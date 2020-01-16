Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B950913F9EE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgAPTvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:51:07 -0500
Received: from correo.us.es ([193.147.175.20]:56034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgAPTu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:50:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D4EB807F0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8483FDA71A
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 799C1DA714; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F4D4DA701;
        Thu, 16 Jan 2020 20:50:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:50:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4D1BE42EF9E1;
        Thu, 16 Jan 2020 20:50:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 8/9] netfilter: nf_tables: fix flowtable list del corruption
Date:   Thu, 16 Jan 2020 20:50:43 +0100
Message-Id: <20200116195044.326614-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200116195044.326614-1-pablo@netfilter.org>
References: <20200116195044.326614-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reported following crash:

  list_del corruption, ffff88808c9bb000->prev is LIST_POISON2 (dead000000000122)
  [..]
  Call Trace:
   __list_del_entry include/linux/list.h:131 [inline]
   list_del_rcu include/linux/rculist.h:148 [inline]
   nf_tables_commit+0x1068/0x3b30 net/netfilter/nf_tables_api.c:7183
   [..]

The commit transaction list has:

NFT_MSG_NEWTABLE
NFT_MSG_NEWFLOWTABLE
NFT_MSG_DELFLOWTABLE
NFT_MSG_DELTABLE

A missing generation check during DELTABLE processing causes it to queue
the DELFLOWTABLE operation a second time, so we corrupt the list here:

  case NFT_MSG_DELFLOWTABLE:
     list_del_rcu(&nft_trans_flowtable(trans)->list);
     nf_tables_flowtable_notify(&trans->ctx,

because we have two different DELFLOWTABLE transactions for the same
flowtable.  We then call list_del_rcu() twice for the same flowtable->list.

The object handling seems to suffer from the same bug so add a generation
check too and only queue delete transactions for flowtables/objects that
are still active in the next generation.

Reported-by: syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com
Fixes: 3b49e2e94e6eb ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 896a6e8aff91..65f51a2e9c2a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1048,12 +1048,18 @@ static int nft_flush_table(struct nft_ctx *ctx)
 	}
 
 	list_for_each_entry_safe(flowtable, nft, &ctx->table->flowtables, list) {
+		if (!nft_is_active_next(ctx->net, flowtable))
+			continue;
+
 		err = nft_delflowtable(ctx, flowtable);
 		if (err < 0)
 			goto out;
 	}
 
 	list_for_each_entry_safe(obj, ne, &ctx->table->objects, list) {
+		if (!nft_is_active_next(ctx->net, obj))
+			continue;
+
 		err = nft_delobj(ctx, obj);
 		if (err < 0)
 			goto out;
-- 
2.11.0


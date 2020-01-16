Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF413D880
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 12:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgAPLDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 06:03:09 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33928 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbgAPLDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 06:03:08 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1is2va-0004LU-In; Thu, 16 Jan 2020 12:03:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: fix flowtable list del corruption
Date:   Thu, 16 Jan 2020 12:03:01 +0100
Message-Id: <20200116110301.4875-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <000000000000b3599c059c36db0d@google.com>
References: <000000000000b3599c059c36db0d@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5a1a6632e3a6..9ba1747686ed 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1047,12 +1047,18 @@ static int nft_flush_table(struct nft_ctx *ctx)
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
2.24.1


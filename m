Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312D2148907
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392685AbgAXOcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404411AbgAXOUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A67E21569;
        Fri, 24 Jan 2020 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875607;
        bh=LomHC6BIaZehvuifzRWoiiOm8DVSs0Au8YgTYp3b71M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEE2DJcZ1of0SBq49KLyvzqNHVJrh4lVxLfhWrIdX+8wBEts4TqAPWLXSfk1AvWYT
         2eIjOE4+sLTnQXKcnlSEtmoUuY5NOB0k4RdzoRJNAmRc2t6UsfPfQMAwiY9Mo38wj+
         RxDNs97eBAhg8WhpOmqmqWOI2c3uEeKajtdu5cDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 094/107] netfilter: nf_tables: fix flowtable list del corruption
Date:   Fri, 24 Jan 2020 09:18:04 -0500
Message-Id: <20200124141817.28793-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 335178d5429c4cee61b58f4ac80688f556630818 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6fa315b73a66a..9fefd01500918 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -981,12 +981,18 @@ static int nft_flush_table(struct nft_ctx *ctx)
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
2.20.1


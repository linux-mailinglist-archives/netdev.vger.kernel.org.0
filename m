Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35C4148854
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390766AbgAXO2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405247AbgAXOVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210C121556;
        Fri, 24 Jan 2020 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875674;
        bh=FLm3Uz2e1NgLQ98EN0hfrjWR9RO3k06VTrjpsPvRQ4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SR67Q6gCy1Vg/NMJyryjJzdZZPUZ/A0wgc/w+U+9ZAEZ0d4CTvpJHIeJa+ZiFFSUj
         RSnYf2+mr5ebe739PpRdqpvR/5ET6YK3YdjPb7mSwtZ3mt83AzpcpMIkSkLxBbKFJX
         hPhjLF/HZH1f8z+feIRmre3t9KCtfn6+WlB3NOhU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 52/56] netfilter: nf_tables: fix flowtable list del corruption
Date:   Fri, 24 Jan 2020 09:20:08 -0500
Message-Id: <20200124142012.29752-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
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
index 79b88467606db..7f0d3ffd54697 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -936,12 +936,18 @@ static int nft_flush_table(struct nft_ctx *ctx)
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


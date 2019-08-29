Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7C0A2602
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfH2SNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbfH2SNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB62C2189D;
        Thu, 29 Aug 2019 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102415;
        bh=XEdqqfd9og2uIEwSR1A5gHDmhSmbXxDigKCRw9lrbaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqER7l2k3BjD2BV/4nLW8b7VKBlQdOAxhbzP4TMCoI5cjFJfAQ4IPlqkY9QFVvHVB
         GkoAQYqO0gwGd9bHRBDCs8XINV1tuXp2ODmrqWkJ4osp6MR6L0JWNJg7DHzOxrCZaK
         x47AC1WIJBo6bkkXZPjK353XQyGJjTOaFt37IDQw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 10/76] netfilter: nf_tables: use-after-free in failing rule with bound set
Date:   Thu, 29 Aug 2019 14:12:05 -0400
Message-Id: <20190829181311.7562-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6a0a8d10a3661a036b55af695542a714c429ab7c ]

If a rule that has already a bound anonymous set fails to be added, the
preparation phase releases the rule and the bound set. However, the
transaction object from the abort path still has a reference to the set
object that is stale, leading to a use-after-free when checking for the
set->bound field. Add a new field to the transaction that specifies if
the set is bound, so the abort path can skip releasing it since the rule
command owns it and it takes care of releasing it. After this update,
the set->bound field is removed.

[   24.649883] Unable to handle kernel paging request at virtual address 0000000000040434
[   24.657858] Mem abort info:
[   24.660686]   ESR = 0x96000004
[   24.663769]   Exception class = DABT (current EL), IL = 32 bits
[   24.669725]   SET = 0, FnV = 0
[   24.672804]   EA = 0, S1PTW = 0
[   24.675975] Data abort info:
[   24.678880]   ISV = 0, ISS = 0x00000004
[   24.682743]   CM = 0, WnR = 0
[   24.685723] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000428952000
[   24.692207] [0000000000040434] pgd=0000000000000000
[   24.697119] Internal error: Oops: 96000004 [#1] SMP
[...]
[   24.889414] Call trace:
[   24.891870]  __nf_tables_abort+0x3f0/0x7a0
[   24.895984]  nf_tables_abort+0x20/0x40
[   24.899750]  nfnetlink_rcv_batch+0x17c/0x588
[   24.904037]  nfnetlink_rcv+0x13c/0x190
[   24.907803]  netlink_unicast+0x18c/0x208
[   24.911742]  netlink_sendmsg+0x1b0/0x350
[   24.915682]  sock_sendmsg+0x4c/0x68
[   24.919185]  ___sys_sendmsg+0x288/0x2c8
[   24.923037]  __sys_sendmsg+0x7c/0xd0
[   24.926628]  __arm64_sys_sendmsg+0x2c/0x38
[   24.930744]  el0_svc_common.constprop.0+0x94/0x158
[   24.935556]  el0_svc_handler+0x34/0x90
[   24.939322]  el0_svc+0x8/0xc
[   24.942216] Code: 37280300 f9404023 91014262 aa1703e0 (f9401863)
[   24.948336] ---[ end trace cebbb9dcbed3b56f ]---

Fixes: f6ac85858976 ("netfilter: nf_tables: unbind set in rule from commit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  9 +++++++--
 net/netfilter/nf_tables_api.c     | 15 ++++++++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5b8624ae4a27f..930d062940b7d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -419,8 +419,7 @@ struct nft_set {
 	unsigned char			*udata;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
-	u16				flags:13,
-					bound:1,
+	u16				flags:14,
 					genmask:2;
 	u8				klen;
 	u8				dlen;
@@ -1333,12 +1332,15 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
+	bool				bound;
 };
 
 #define nft_trans_set(trans)	\
 	(((struct nft_trans_set *)trans->data)->set)
 #define nft_trans_set_id(trans)	\
 	(((struct nft_trans_set *)trans->data)->set_id)
+#define nft_trans_set_bound(trans)	\
+	(((struct nft_trans_set *)trans->data)->bound)
 
 struct nft_trans_chain {
 	bool				update;
@@ -1369,12 +1371,15 @@ struct nft_trans_table {
 struct nft_trans_elem {
 	struct nft_set			*set;
 	struct nft_set_elem		elem;
+	bool				bound;
 };
 
 #define nft_trans_elem_set(trans)	\
 	(((struct nft_trans_elem *)trans->data)->set)
 #define nft_trans_elem(trans)	\
 	(((struct nft_trans_elem *)trans->data)->elem)
+#define nft_trans_elem_set_bound(trans)	\
+	(((struct nft_trans_elem *)trans->data)->bound)
 
 struct nft_trans_obj {
 	struct nft_object		*obj;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bcf17fb46d965..8e4cdae2c4f14 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -136,9 +136,14 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 		return;
 
 	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
-		if (trans->msg_type == NFT_MSG_NEWSET &&
-		    nft_trans_set(trans) == set) {
-			set->bound = true;
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWSET:
+			if (nft_trans_set(trans) == set)
+				nft_trans_set_bound(trans) = true;
+			break;
+		case NFT_MSG_NEWSETELEM:
+			if (nft_trans_elem_set(trans) == set)
+				nft_trans_elem_set_bound(trans) = true;
 			break;
 		}
 	}
@@ -6849,7 +6854,7 @@ static int __nf_tables_abort(struct net *net)
 			break;
 		case NFT_MSG_NEWSET:
 			trans->ctx.table->use--;
-			if (nft_trans_set(trans)->bound) {
+			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
 			}
@@ -6861,7 +6866,7 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			if (nft_trans_elem_set(trans)->bound) {
+			if (nft_trans_elem_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
 			}
-- 
2.20.1


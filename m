Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD223989EA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFBMqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:46:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41568 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFBMqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:46:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2051D641D0;
        Wed,  2 Jun 2021 14:43:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/2] netfilter: nft_ct: skip expectations for confirmed conntrack
Date:   Wed,  2 Jun 2021 14:44:29 +0200
Message-Id: <20210602124430.10863-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602124430.10863-1-pablo@netfilter.org>
References: <20210602124430.10863-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_ct_expect_obj_eval() calls nf_ct_ext_add() for a confirmed
conntrack entry. However, nf_ct_ext_add() can only be called for
!nf_ct_is_confirmed().

[ 1825.349056] WARNING: CPU: 0 PID: 1279 at net/netfilter/nf_conntrack_extend.c:48 nf_ct_xt_add+0x18e/0x1a0 [nf_conntrack]
[ 1825.351391] RIP: 0010:nf_ct_ext_add+0x18e/0x1a0 [nf_conntrack]
[ 1825.351493] Code: 41 5c 41 5d 41 5e 41 5f c3 41 bc 0a 00 00 00 e9 15 ff ff ff ba 09 00 00 00 31 f6 4c 89 ff e8 69 6c 3d e9 eb 96 45 31 ed eb cd <0f> 0b e9 b1 fe ff ff e8 86 79 14 e9 eb bf 0f 1f 40 00 0f 1f 44 00
[ 1825.351721] RSP: 0018:ffffc90002e1f1e8 EFLAGS: 00010202
[ 1825.351790] RAX: 000000000000000e RBX: ffff88814f5783c0 RCX: ffffffffc0e4f887
[ 1825.351881] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff88814f578440
[ 1825.351971] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88814f578447
[ 1825.352060] R10: ffffed1029eaf088 R11: 0000000000000001 R12: ffff88814f578440
[ 1825.352150] R13: ffff8882053f3a00 R14: 0000000000000000 R15: 0000000000000a20
[ 1825.352240] FS:  00007f992261c900(0000) GS:ffff889faec00000(0000) knlGS:0000000000000000
[ 1825.352343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1825.352417] CR2: 000056070a4d1158 CR3: 000000015efe0000 CR4: 0000000000350ee0
[ 1825.352508] Call Trace:
[ 1825.352544]  nf_ct_helper_ext_add+0x10/0x60 [nf_conntrack]
[ 1825.352641]  nft_ct_expect_obj_eval+0x1b8/0x1e0 [nft_ct]
[ 1825.352716]  nft_do_chain+0x232/0x850 [nf_tables]

Add the ct helper extension only for unconfirmed conntrack. Skip rule
evaluation if the ct helper extension does not exist. Thus, you can
only create expectations from the first packet.

It should be possible to remove this limitation by adding a new action
to attach a generic ct helper to the first packet. Then, use this ct
helper extension from follow up packets to create the ct expectation.

While at it, add a missing check to skip the template conntrack too
and remove check for IPCT_UNTRACK which is implicit to !ct.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 0592a9456084..337e22d8b40b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1217,7 +1217,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_UNTRACKED) {
+	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.20.1


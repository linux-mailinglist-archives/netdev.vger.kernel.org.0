Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34D1FF30F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgFRN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbgFRN3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 09:29:38 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B88D207D8;
        Thu, 18 Jun 2020 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592486978;
        bh=mhKkC93IxTE6r/z8FPCV/N5OA7kRLNqPARji3a1ASFI=;
        h=Date:From:To:Cc:Subject:From;
        b=tDylvdmd6vXysvSLfn+nbl7nUuQQjXMDDoHlDiNTLuZro9VKkF6pYD5ciD/5wjciz
         FxU0eIlLDksKfYQwz5Mlv3TQse9+XEpp9BzEWKIppxnqn2hUSeReNvEPxh9PNLnpaN
         yTo6OBx/KCx5DDMbQaKWKLjA8z6bATnumBsPdkek=
Date:   Thu, 18 Jun 2020 08:35:00 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] tipc: Use struct_size() helper
Message-ID: <20200618133459.GA8169@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/tipc/link.c | 8 ++++----
 net/tipc/msg.h  | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index ee3b8d0576b8..9a33752f0263 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1385,12 +1385,12 @@ u16 tipc_get_gap_ack_blks(struct tipc_gap_ack_blks **ga, struct tipc_link *l,
 		p = (struct tipc_gap_ack_blks *)msg_data(hdr);
 		sz = ntohs(p->len);
 		/* Sanity check */
-		if (sz == tipc_gap_ack_blks_sz(p->ugack_cnt + p->bgack_cnt)) {
+		if (sz == struct_size(p, gacks, p->ugack_cnt + p->bgack_cnt)) {
 			/* Good, check if the desired type exists */
 			if ((uc && p->ugack_cnt) || (!uc && p->bgack_cnt))
 				goto ok;
 		/* Backward compatible: peer might not support bc, but uc? */
-		} else if (uc && sz == tipc_gap_ack_blks_sz(p->ugack_cnt)) {
+		} else if (uc && sz == struct_size(p, gacks, p->ugack_cnt)) {
 			if (p->ugack_cnt) {
 				p->bgack_cnt = 0;
 				goto ok;
@@ -1472,7 +1472,7 @@ static u16 tipc_build_gap_ack_blks(struct tipc_link *l, struct tipc_msg *hdr)
 			__tipc_build_gap_ack_blks(ga, l, ga->bgack_cnt) : 0;
 
 	/* Total len */
-	len = tipc_gap_ack_blks_sz(ga->bgack_cnt + ga->ugack_cnt);
+	len = struct_size(ga, gacks, ga->bgack_cnt + ga->ugack_cnt);
 	ga->len = htons(len);
 	return len;
 }
@@ -1521,7 +1521,7 @@ static int tipc_link_advance_transmq(struct tipc_link *l, struct tipc_link *r,
 		gacks = &ga->gacks[ga->bgack_cnt];
 	} else if (ga) {
 		/* Copy the Gap ACKs, bc part, for later renewal if needed */
-		this_ga = kmemdup(ga, tipc_gap_ack_blks_sz(ga->bgack_cnt),
+		this_ga = kmemdup(ga, struct_size(ga, gacks, ga->bgack_cnt),
 				  GFP_ATOMIC);
 		if (likely(this_ga)) {
 			this_ga->start_index = 0;
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 58660d56bc83..c0d161bc7a50 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -189,11 +189,9 @@ struct tipc_gap_ack_blks {
 	struct tipc_gap_ack gacks[];
 };
 
-#define tipc_gap_ack_blks_sz(n) (sizeof(struct tipc_gap_ack_blks) + \
-				 sizeof(struct tipc_gap_ack) * (n))
-
 #define MAX_GAP_ACK_BLKS	128
-#define MAX_GAP_ACK_BLKS_SZ	tipc_gap_ack_blks_sz(MAX_GAP_ACK_BLKS)
+#define MAX_GAP_ACK_BLKS_SZ	(sizeof(struct tipc_gap_ack_blks) + \
+				 sizeof(struct tipc_gap_ack) * MAX_GAP_ACK_BLKS)
 
 static inline struct tipc_msg *buf_msg(struct sk_buff *skb)
 {
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54D8132A52
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgAGPp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:45:56 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51607 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728385AbgAGPpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:45:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DE68A221FD;
        Tue,  7 Jan 2020 10:45:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=7OfLUv9hBSonwlhHma/KiOB/6UQOFKtDC6rHSoEkTL8=; b=YoHuyz7d
        Crh77RfMa2YhZCGpVvIh+6DAJV+b67BsIgyFaqM9HnZjAnBsBwk2J1IU7QZRX4rl
        PugFNI6iKF8HIs03Syu+gxyFQnxUU1Abcj634Vj8/z5PcYLimdnIdnRZdbyfKuZU
        jF6yrZMHusBIxLTvBtHW45+dhizLupjPVUnSswT8Bd2pjOZ21FoUYhCk784Wm+gR
        G9PAPOo65tnJl9Edguea0/wObFBvwjrfdTv6RzHq13T7xLXL/7YZRJj+wBS1M5y3
        F78HxPYQox8MabK43ZwjGPSafBWoaEqeP+lelKuf+sbRrFLHDZ6iosN1xtQGy2om
        FoZ0QpcTK6FWmg==
X-ME-Sender: <xms:sacUXg4fkKCyExmet0Vpy7PcPZtJMURrqWwKMUtBgb_1wvsfuJ3XWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:sacUXv0UZfRK4RktPYLLyax74L5ICW6nnd8JWz8Z99c795d7JnGjoQ>
    <xmx:sacUXhx_kpZh1rB-PJ7tHzAgR5zyaqT8d3x2IbDClyM5e2puRQEEyg>
    <xmx:sacUXpuhJnn9gGhrVAVF_gMC0jq-cYoZw7aMZrDW0TRMExUWi_V-_w>
    <xmx:sacUXgGJDlg7cKyF4H-_Gw5QP727JLR74NxvtDeBF8lweJ02EIoQvQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F8A28005B;
        Tue,  7 Jan 2020 10:45:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/10] ipv6: Add "offload" and "trap" indications to routes
Date:   Tue,  7 Jan 2020 17:45:11 +0200
Message-Id: <20200107154517.239665-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to previous patch, add "offload" and "trap"
indication to IPv6 routes.

This is done by using two unused bits in 'struct fib6_info' to hold
these indications. Capable drivers are expected to set these when
processing the various in-kernel route notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/ip6_fib.h | 11 ++++++++++-
 net/ipv6/route.c      |  7 +++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index b579faea41e9..fd60a8ac02ee 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -192,7 +192,9 @@ struct fib6_info {
 					dst_nopolicy:1,
 					dst_host:1,
 					fib6_destroying:1,
-					unused:3;
+					offload:1,
+					trap:1,
+					unused:1;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
@@ -329,6 +331,13 @@ static inline void fib6_info_release(struct fib6_info *f6i)
 		call_rcu(&f6i->rcu, fib6_info_destroy_rcu);
 }
 
+static inline void fib6_info_hw_flags_set(struct fib6_info *f6i, bool offload,
+					  bool trap)
+{
+	f6i->offload = offload;
+	f6i->trap = trap;
+}
+
 enum fib6_walk_state {
 #ifdef CONFIG_IPV6_SUBTREES
 	FWS_S,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0253b702afb7..4fbdc60b4e07 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5576,6 +5576,13 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		expires -= jiffies;
 	}
 
+	if (!dst) {
+		if (rt->offload)
+			rtm->rtm_flags |= RTM_F_OFFLOAD;
+		if (rt->trap)
+			rtm->rtm_flags |= RTM_F_TRAP;
+	}
+
 	if (rtnl_put_cacheinfo(skb, dst, 0, expires, dst ? dst->error : 0) < 0)
 		goto nla_put_failure;
 
-- 
2.24.1


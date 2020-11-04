Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B412A6535
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgKDNbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:51 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37649 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730015AbgKDNbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5601D5C0056;
        Wed,  4 Nov 2020 08:31:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WYV9lTX1ZX+e6R7IibGzHPoTovOLqWIJvS0FW1py4us=; b=V4/cbvqC
        lGL99XrQ/ZVSzHh39Q4qO2oUTviNgylHVhepxzgP9kX8jx4bUIKdO/Jciw7yzX3q
        vONVekfWxYa3fGBUbTNlKnRZQn4B5Hz5K8bFtQOe7ZwOVi9aZPPkK4GvrukUmspw
        xT9/kZaaSysbugnibXUU5EDyKaXGFztb2IVTh/QLTCmQrx6vosroLM+KCYS9igvU
        oVgRf8izj53P/ZS+6PTkXqT6JfvoTJdPu848qp2s07MI8QILthN15+2sVxNsCdPo
        Mid+SkuD5lPnJRjj/yyBfNi1c33A+UJ/80nyC6GKyWzURlzbOvnt6x/yjO2k+Pmb
        +VXE+XwtJcbdtg==
X-ME-Sender: <xms:Q62iX58bnIJKpbEbtfvSNz_Q8ho6cYyyWroR4Oy_qtaIcTxpJanwlQ>
    <xme:Q62iX9u40n1f4osR8jPUVoVfVMNtosw951t17BsDAuaN2BOy-ltiF6kMhZn0arWpX
    NW1aL4MMCrUKGk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Q62iX3DPETByQGctOFPUKRy5z_NyPGrtkyb7QhJ7sRPCngxde5AEMQ>
    <xmx:Q62iX9deFxhkJeHEm3e0gagWLvsCsXKekSllPZzighJQ1JaJ213c6w>
    <xmx:Q62iX-NPoF3A_NioJK3iTmnphZ1esuCGoJ10PaPfnl18HkmvEjegWA>
    <xmx:Q62iX7rd05l9MzOMsfouA0DFm70mR1zSauWz19Bj43EeuwinMqDvbg>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id E39AD3064610;
        Wed,  4 Nov 2020 08:31:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/18] rtnetlink: Add RTNH_F_TRAP flag
Date:   Wed,  4 Nov 2020 15:30:27 +0200
Message-Id: <20201104133040.1125369-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The flag indicates to user space that the nexthop is not programmed to
forward packets in hardware, but rather to trap them to the CPU. This is
needed, for example, when the MAC of the nexthop neighbour is not
resolved and packets should reach the CPU to trigger neighbour
resolution.

The flag will be used in subsequent patches by netdevsim to test nexthop
objects programming to device drivers and in the future by mlxsw as
well.

Changes since RFC:
* Reword commit message

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/uapi/linux/rtnetlink.h | 6 ++++--
 net/ipv4/fib_semantics.c       | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index fdd408f6a5d2..a0d3363c6bd3 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -396,11 +396,13 @@ struct rtnexthop {
 #define RTNH_F_DEAD		1	/* Nexthop is dead (used by multipath)	*/
 #define RTNH_F_PERVASIVE	2	/* Do recursive gateway lookup	*/
 #define RTNH_F_ONLINK		4	/* Gateway is forced on link	*/
-#define RTNH_F_OFFLOAD		8	/* offloaded route */
+#define RTNH_F_OFFLOAD		8	/* Nexthop is offloaded */
 #define RTNH_F_LINKDOWN		16	/* carrier-down on nexthop */
 #define RTNH_F_UNRESOLVED	32	/* The entry is unresolved (ipmr) */
+#define RTNH_F_TRAP		64	/* Nexthop is trapping packets */
 
-#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | RTNH_F_OFFLOAD)
+#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
+				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
 
 /* Macros to handle hexthops */
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 1f75dc686b6b..f70b9a0c4957 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1644,6 +1644,8 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 	*flags |= (nhc->nhc_flags & RTNH_F_ONLINK);
 	if (nhc->nhc_flags & RTNH_F_OFFLOAD)
 		*flags |= RTNH_F_OFFLOAD;
+	if (nhc->nhc_flags & RTNH_F_TRAP)
+		*flags |= RTNH_F_TRAP;
 
 	if (!skip_oif && nhc->nhc_dev &&
 	    nla_put_u32(skb, RTA_OIF, nhc->nhc_dev->ifindex))
-- 
2.26.2


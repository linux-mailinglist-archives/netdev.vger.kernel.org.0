Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1CD253561
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHZQtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57483 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726929AbgHZQtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A6A205C00CE;
        Wed, 26 Aug 2020 12:49:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=lj6H+mDuCQceq/KxuwKkf2oL6L05xx1vRf5rfcSCdM4=; b=nkErL/4T
        OsjTB69kx/omrOjgity3Ndh/mGiuQR5cXFuXF6svH2Plix6rhtJriQVFj4WJuPKC
        uo1q1Qa31RUHD+LU9JFAu/JJr16kJG2XwAerJqJY+7AfR7S2GDYbICc2Jz4qSTF0
        tfae+aVPP7R73w4QMX8krVyuJnBGl8h9/Nx6VHX7+MtVmdbV3pSN/XAx4mfclkgx
        WiACXLtbUcaOHQ0ivLSkM2tEbyw1YVpkR+6CjuhEsM0rYmzeKiqe9AseTV/z5ig9
        wrxKbdY89rOMkSxDVcLUKcrWdMBptNHUHDNIWG2bizeHZqhZRzRluMU2VQb9qoTq
        4ttfuBu9aQzgWg==
X-ME-Sender: <xms:kZJGX3Z2p_Lxfy8AUnChPxJtxcb0_MVjHH1-fFkVFPB7aoHw5_aInA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:kZJGX2aQeZblzHLhTvjy6IownP1QcUd_r-MRpltrOXKqq_Jo4KpFsg>
    <xmx:kZJGX5935tIVGj23hs8NBNjx5Ft3geDPk1IPR0ONUj8H6xuu2TvBlg>
    <xmx:kZJGX9o0EUk5F-n7XTc_zCT-c5tR55uvmcGYVCqVhVNVT17xBkP4LA>
    <xmx:kZJGX3BB5D9sLq7nrW0hnN-mO81fPMbDZky2yK79iCLFRoWLif1cLg>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00341328005D;
        Wed, 26 Aug 2020 12:49:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/7] ipv4: nexthop: Reduce allocation size of 'struct nh_group'
Date:   Wed, 26 Aug 2020 19:48:51 +0300
Message-Id: <20200826164857.1029764-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200826164857.1029764-1-idosch@idosch.org>
References: <20200826164857.1029764-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The struct looks as follows:

struct nh_group {
	struct nh_group		*spare; /* spare group for removals */
	u16			num_nh;
	bool			mpath;
	bool			fdb_nh;
	bool			has_v4;
	struct nh_grp_entry	nh_entries[];
};

But its offset within 'struct nexthop' is also taken into account to
determine the allocation size.

Instead, use struct_size() to allocate only the required number of
bytes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 134e92382275..d13730ff9aeb 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -133,12 +133,9 @@ static struct nexthop *nexthop_alloc(void)
 
 static struct nh_group *nexthop_grp_alloc(u16 num_nh)
 {
-	size_t sz = offsetof(struct nexthop, nh_grp)
-		    + sizeof(struct nh_group)
-		    + sizeof(struct nh_grp_entry) * num_nh;
 	struct nh_group *nhg;
 
-	nhg = kzalloc(sz, GFP_KERNEL);
+	nhg = kzalloc(struct_size(nhg, nh_entries, num_nh), GFP_KERNEL);
 	if (nhg)
 		nhg->num_nh = num_nh;
 
-- 
2.26.2


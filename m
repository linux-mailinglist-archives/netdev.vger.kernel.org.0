Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE17344A14
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhCVQAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:37 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36231 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231328AbhCVQAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:00:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F28895C01A0;
        Mon, 22 Mar 2021 12:00:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 22 Mar 2021 12:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+vyo3yykrqRfYDPnmfxAwfKZeGHxyuXhJXksm44xlXw=; b=XQktnaDe
        w6/3AWPWimHo2QxtQwoGw/cH1phUiGnZO+ZKIu8IoXIDLjkGxmmVnzIGBL6ojXLC
        58BkXrCY1EhaypJorNEFc17vXhG2JYbmGYZMW/0ctgLRYCt83KzLNWkSBFavEciS
        uU5h1zqgo4ObZ3N4xYRZCyxdzv2p5YjwdWalyAlxhbH3FoTqOsRwc23psNtydbvP
        4ia5QYcAqxsf/F0Je0Fshuw2h70Q+Q4kD0bEKiZYcoNtguZWlGeMaS+AdKXeggDn
        ycMeCK4uQutLGEToFYdVZp+vQCVPKUyAjD/m1rceHLE8bXwvB4QuqLxBH/Jww1xl
        No8p0jzipSMiPg==
X-ME-Sender: <xms:Ar9YYMMVPpt74EJEYkHVmLHNvHrNei-JJbHtpgJB7LPDaHUvwK2k9A>
    <xme:Ar9YYAyE4ONqkDXh36Vi5C45gNR4kwJYFgFGbL_cfBTkDgtQJjMy5A45PVgAOauJr
    eE07_c4i53ioIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ar9YYNs2jI0I6R3PlH9uET8h_ESlZkkCtjBBUYN7D_zVUHDgYFy9Rg>
    <xmx:Ar9YYB5rdghRBXn1u-5ZTHHkUAADWQMNPfhVVOVS6padlOITUCgcHg>
    <xmx:Ar9YYESjO0oJWqdYj_-DkF28c-FQEuOQpxF74cWK5RHExNFZBVRMaA>
    <xmx:Ar9YYNHvgpORflvoV1zhZMdFyaH98rCbA7fpfVyNHhcz4rXmHi894A>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 210821080057;
        Mon, 22 Mar 2021 11:59:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/14] mlxsw: spectrum_router: Avoid unnecessary neighbour updates
Date:   Mon, 22 Mar 2021 17:58:52 +0200
Message-Id: <20210322155855.3164151-12-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Avoid updating neighbour and adjacency entries in hardware when the
neighbour is already connected and its MAC address did not change. This
can happen, for example, when neighbour transitions between valid states
such as 'NUD_REACHABLE' and 'NUD_DELAY'.

This is especially important for resilient hashing as these updates will
result in adjacency entries being marked as active.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index fa190e27323e..4114f3b7d3cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2662,6 +2662,10 @@ static void mlxsw_sp_router_neigh_event_work(struct work_struct *work)
 			goto out;
 	}
 
+	if (neigh_entry->connected && entry_connected &&
+	    !memcmp(neigh_entry->ha, ha, ETH_ALEN))
+		goto out;
+
 	memcpy(neigh_entry->ha, ha, ETH_ALEN);
 	mlxsw_sp_neigh_entry_update(mlxsw_sp, neigh_entry, entry_connected);
 	mlxsw_sp_nexthop_neigh_update(mlxsw_sp, neigh_entry, !entry_connected,
-- 
2.29.2


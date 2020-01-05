Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B91130902
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgAEQWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52975 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgAEQWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:22:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4EEC22106A;
        Sun,  5 Jan 2020 11:22:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:22:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=H78F2VKOEvkdOv0b4/zgbOt0bpuOKiMbyNCs0AY5zK4=; b=qVOciTJO
        SuR3bseAeLJtMrzEMVDLW4n+96jsBdZiGvQSABekID2yS/Hn781kBNNj0nWIfzxk
        kwAFFrdURtpe9LGwsAL1BD4RzpOR4N9WJdqzqQnpsH4pAPwj3qu1HeBfY3PV3335
        7ahnh9oFGLHMuISzK9XVESRALiKvz9x8D9kccvzaK8+Uf8lof9RtyACMSVk4WY6f
        66I1xGaOk4PM1X1yDDFe3iUjrQIY+L/pcK15wsdKwIwyVSwafyyLzpcWjks8SAQv
        sUbaKSbZtNCse/5okRQJczj9g6izPF+IrLsvrVIyseXbbOT7HNBmKHOAUA2H6US8
        /SXKMHSxZm28cg==
X-ME-Sender: <xms:Lg0SXvencSzVDHaEk8JZRf-yTJqBBdDDRxQkKPjMD_jsLBjRxNoYDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:Lg0SXoVwJOanYD4drOaCE1cQjuP9jq39yU4v4WbU02Ak-veSpD-eKA>
    <xmx:Lg0SXl_4d-961D8LN1yimesRxEJwmSd3dPrs-8QyMB2ClKP8VsOQyA>
    <xmx:Lg0SXliZ8Cfg3hJCdjDgBZXsfQ46VpPaMnJLGF3eSqHbNZ06NJ4XSA>
    <xmx:Lg0SXrrmafsid8pTitkD0Ll7ju1nRVCnUDihbkZVeCaOCR6KEeqZjw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 174418005A;
        Sun,  5 Jan 2020 11:22:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/8] mlxsw: spectrum: Disable DIP_LINK_LOCAL check in hardware pipeline
Date:   Sun,  5 Jan 2020 18:20:56 +0200
Message-Id: <20200105162057.182547-8-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105162057.182547-1-idosch@idosch.org>
References: <20200105162057.182547-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

The check drops packets if they need to be routed and their destination
IP is link-local, i.e., belongs to 169.254.0.0/16 address range.

Disable the check since the kernel forwards such packets and does not
drop them.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/trap.h     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 74a08eb45ec8..845201c344ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4551,6 +4551,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_DIP, FORWARD,
 			     ROUTER_EXP, false),
+	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_DIP_LINK_LOCAL, FORWARD,
+			     ROUTER_EXP, false),
 	/* PKT Sample trap */
 	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
 		  false, SP_IP2ME, DISCARD),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 02c68820eae5..3d2331be05d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -87,6 +87,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_DIP = 0x169,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_DIP_LINK_LOCAL = 0x16C,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM6 = 0x17C,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_RESERVED_SCOPE = 0x1B0,
-- 
2.24.1


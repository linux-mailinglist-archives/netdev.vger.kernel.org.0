Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9939D1308FC
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgAEQV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:21:59 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46491 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgAEQV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:21:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BEB121111;
        Sun,  5 Jan 2020 11:21:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=MVlV1aW7UZsmX5oIo7QByiXQfhgrCJIe+ssqBsUWuUQ=; b=wg6xvQgk
        zWbmepX9U2gZs4UAtzHBmXVAP9UopESzsckBuLX6DFEjOeB2J05r906tGdajVzyG
        TDVmoTd8VpAzbadtvlVCyzKYYZITdCnIzfUvumYYF8+W485PMJwMrmdoM9WxCi/C
        Xup7Z8GMk1X+qX0n7SGPeYV6HuyCSb/+eCsbDfuZQpqwQl6V2Q0eWAMDNvGHAims
        BbYHjnYHsYduHYSzI0aXMBY+QBY0uamLvz7iPtZuYs+gKv1HtNf/xdGUorbItL8u
        UIZJm0hwk/kDYSt7uXXPYDW0R0+wMqu8dSHztntj1mHi1480OOBUeN7fI977/U4i
        AvLRi1KNa1K8Uw==
X-ME-Sender: <xms:Jg0SXsO1ySNu21ERfAxm3tGyCaOhr5uV87BsP_PI1R6P86pgKDlAww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:Jg0SXtPO5LuP6G89nvwlAUf2bNiDq3eHoGcNsF74eoUFoqcNZfWZoQ>
    <xmx:Jg0SXiNOBjTDmnMZN_o76YZYP8S4g2AP4LEsNG8K4EDf2Wgzzan5aQ>
    <xmx:Jg0SXsXVZVGmU9XQ65616CZyZepRwG7BcwOIzpf84BVVhVWXTW8z3A>
    <xmx:Jg0SXvUyf3HwLoVIokv_QY9vG7U80f8Iaox3LD1qh3Qvxck0s_MFoA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 117598005C;
        Sun,  5 Jan 2020 11:21:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum: Disable SIP_CLASS_E check in hardware pipeline
Date:   Sun,  5 Jan 2020 18:20:50 +0200
Message-Id: <20200105162057.182547-2-idosch@idosch.org>
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

The check drops packets if they need to be routed and their source IP is
from class E, i.e., belongs to 240.0.0.0/4 address range, but different
from 255.255.255.255.

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
index 1a509bb8d269..78162dcf2337 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4545,6 +4545,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(DECAP_ECN0, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
+	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_CLASS_E, FORWARD,
+			     ROUTER_EXP, false),
 	/* PKT Sample trap */
 	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
 		  false, SP_IP2ME, DISCARD),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 0c1c142bb6b0..e63cb82050c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -80,6 +80,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_UC_DIP_MC_DMAC = 0x161,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_DIP_LB = 0x162,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_MC = 0x163,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_CLASS_E = 0x164,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_LB = 0x165,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_CORRUPTED_IP_HDR = 0x167,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
-- 
2.24.1


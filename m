Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB151308FE
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgAEQWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:02 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39481 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgAEQWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:22:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0FA9D213BD;
        Sun,  5 Jan 2020 11:22:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=S/CVs+eKlccEPY0//W35lb8OWCtgdUWt8hCo4LsonRc=; b=LUb19Q50
        EOAl/ulIVDbOQh7aHg0eMCw4dnBUXqyV11T0lMS7HdHcIGyA4WvNZP3/++S8HguW
        bjwCVIaKzt4PbFnAEHMSwKRPyWIRyg3TD72cUevxtaQDrz1gubP3sGFmQw3euLm2
        WrMDTqWnjtTrJmzkwKFvOMNaEcFB0eCHlNKWvHF6NsACMrYYDqRiATFqoRE0b3n+
        JuRjyt0e7tAN2g1QVwHxvZA2g3ySWLkQdIPWgp7MW/4vKyVVAvZPwAERncq2zr3E
        c9R92Ec7mF3st0XsyeIyXlkB0CIEitQRRD9Jq8/lqtLmzPr0SiQGzFdnBDAP83Tk
        cf99crEHGol6wg==
X-ME-Sender: <xms:KA0SXia-jE9Yg7AEhE9AFXKBT-D3Dh5yfeUl0HMxVO6f3M-VGqNCjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:KA0SXpFbPIiZybR5ZxuW3fv5XY7eQZ-6DFy2eoTua8VQwQlABulX4g>
    <xmx:KA0SXmydZqyY4NyPYQzH2NjfTkfAHK-KqXDH0dkACsiZsJlL23rQBg>
    <xmx:KA0SXrl-nUQzdMBD1MSJszirxQax0-G4rmYJBYBkeaa1a9WE5Nbvbg>
    <xmx:KQ0SXhjUwSyDgXFbA3Ay0aPt22O9QQoyxii8gYjZa5830wKl6BM95w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B684D8005C;
        Sun,  5 Jan 2020 11:21:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum: Disable MC_DMAC check in hardware pipeline
Date:   Sun,  5 Jan 2020 18:20:52 +0200
Message-Id: <20200105162057.182547-4-idosch@idosch.org>
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

The check drops packets if they need to be routed and their multicast
MAC mismatched to their multicast destination IP.

For IPV4:
DMAC is mismatched if it is different from {01-00-5E-0 (25 bits),
DIP[22:0]}

For IPV6:
DMAC is mismatched if it is different from {33-33-0 (16 bits),
DIP[31:0]}

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
index 78162dcf2337..2134bc7661c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4547,6 +4547,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_CLASS_E, FORWARD,
 			     ROUTER_EXP, false),
+	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_MC_DMAC, FORWARD,
+			     ROUTER_EXP, false),
 	/* PKT Sample trap */
 	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
 		  false, SP_IP2ME, DISCARD),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index e63cb82050c6..7ccec9e28cdd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -83,6 +83,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_CLASS_E = 0x164,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_LB = 0x165,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_CORRUPTED_IP_HDR = 0x167,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_MC_DMAC = 0x168,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
-- 
2.24.1


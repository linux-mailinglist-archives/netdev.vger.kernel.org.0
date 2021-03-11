Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BC7337288
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhCKMZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37575 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230509AbhCKMZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2491F5C008B;
        Thu, 11 Mar 2021 07:25:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 07:25:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SEWGWtwP94090qJTcQx534wWVLByi8473Dvd1Ri+78g=; b=e38eePEE
        /Uy5BXpKi0k/6hoPOIyvI9OCghcT6A+7TLm4qxiHZAdACrogSO5FvXaA3rYEuWSH
        EcaJJMWKVPsEE4SELkh7ZdoGeF4zQLWd1aihLQ283ZYt8IPy3Wx1JlshdLantb2l
        jvPeyejX1c3Vz53yzJOJ1s5DIuTjVz3SfV9neInTR6bdG45iRj82SNhrzApMktog
        Go3UqMUYZ+x5weV+fvElLEqVv0oVD1gOQadBhcdMLy+rRkSk5TJ1lVmFUtsrn1oR
        5pSf0eO9285fTFqy+bLWKFFBmvLIMnAHA2+Xph0LGZ01JF+fGhKxjVzHdX+oe+vb
        pRsJvy9Usw/bmg==
X-ME-Sender: <xms:KQxKYAfDNdJ1cQ_wfD7W2INkJ3Ba6cbG5TQnSFsKyjFsX70sMcK7kw>
    <xme:KQxKYCNwhvJ5GMvZLZpgT5FzocbMEELu1cXzeuvKyN5ITi_dSMBUcX1WdPqbp0czc
    2m8paJ1rMo0h5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KQxKYBiJob0Ef7NpC2XofK-tUHH7gWp3qwx9-4Zz306Da-PVkP4ZSw>
    <xmx:KQxKYF9b9lUS3jrIvKgxIMwAFK9BXPeWafi7aGuKuRajwn45txS4bQ>
    <xmx:KQxKYMsF1Mki84P575NxdvRMC98BXwWDZ6OqEoaHSqTNPlB_NckHnw>
    <xmx:KQxKYF7hD1wZFthL6D6YogMKGLlQQV5lsIhM0Rr2mRMDgFuB1UQWTw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D34B3108005C;
        Thu, 11 Mar 2021 07:25:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: spectrum_trap: Split sampling traps between ASICs
Date:   Thu, 11 Mar 2021 14:24:15 +0200
Message-Id: <20210311122416.2620300-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
References: <20210311122416.2620300-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Sampling of ingress packets is supported using a dedicated sampling
mechanism on all Spectrum ASICs. However, Spectrum-2 and later ASICs
support more sophisticated sampling by mirroring packets to the CPU.

As a preparation for more advanced sampling configurations, split the trap
configuration used for sampled packets between Spectrum-1 and later ASICs.

This is needed since packets that are mirrored to the CPU are trapped
via a different trap identifier compared to packets that are sampled
using the dedicated sampling mechanism.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 39 ++++++++++++-------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 4ef12e3e021a..6ecc77fde095 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -463,11 +463,6 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
 		.priority = 2,
 	},
-	{
-		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_SAMPLE, 0),
-		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
-		.priority = 0,
-	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_TRAP, 18),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
@@ -992,14 +987,6 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 			MLXSW_SP_RXL_NO_MARK(PTP1, PTP1, TRAP_TO_CPU, false),
 		},
 	},
-	{
-		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_SAMPLE, ACL_SAMPLE,
-					      MIRROR),
-		.listeners_arr = {
-			MLXSW_RXL(mlxsw_sp_rx_sample_listener, PKT_SAMPLE,
-				  MIRROR_TO_CPU, false, SP_PKT_SAMPLE, DISCARD),
-		},
-	},
 	{
 		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_TRAP, ACL_TRAP, TRAP),
 		.listeners_arr = {
@@ -1709,10 +1696,23 @@ int mlxsw_sp_trap_group_policer_hw_id_get(struct mlxsw_sp *mlxsw_sp, u16 id,
 
 static const struct mlxsw_sp_trap_group_item
 mlxsw_sp1_trap_group_items_arr[] = {
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_SAMPLE, 0),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
+		.priority = 0,
+	},
 };
 
 static const struct mlxsw_sp_trap_item
 mlxsw_sp1_trap_items_arr[] = {
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_SAMPLE, ACL_SAMPLE,
+					      MIRROR),
+		.listeners_arr = {
+			MLXSW_RXL(mlxsw_sp_rx_sample_listener, PKT_SAMPLE,
+				  MIRROR_TO_CPU, false, SP_PKT_SAMPLE, DISCARD),
+		},
+	},
 };
 
 static int
@@ -1749,6 +1749,11 @@ mlxsw_sp2_trap_group_items_arr[] = {
 		.priority = 0,
 		.fixed_policer = true,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_SAMPLE, 0),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
+		.priority = 0,
+	},
 };
 
 static const struct mlxsw_sp_trap_item
@@ -1760,6 +1765,14 @@ mlxsw_sp2_trap_items_arr[] = {
 		},
 		.is_source = true,
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_SAMPLE, ACL_SAMPLE,
+					      MIRROR),
+		.listeners_arr = {
+			MLXSW_RXL(mlxsw_sp_rx_sample_listener, PKT_SAMPLE,
+				  MIRROR_TO_CPU, false, SP_PKT_SAMPLE, DISCARD),
+		},
+	},
 };
 
 static int
-- 
2.29.2


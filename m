Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFEA34E1A6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhC3G7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:59:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54365 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231192AbhC3G7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:59:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B30F65C00D2;
        Tue, 30 Mar 2021 02:59:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 30 Mar 2021 02:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QHgZFdr/K+CVKXxaZ
        WlKgaV8RHvCU8oUcXj7aBKMRPg=; b=hmtOFaGqU96bSsP5+TPNLAnIr2KubL2VS
        MdfYdHg9qUtruAhi9uGnZsxOr9/miPvFgBWmboLfVRokoz+owX/rIpCpM1RH1CYH
        uMxaV4NgOHtEyf+so91be50SEJRXmFVNy2oytGUHZq8gF+6eoUs5H887YGSvsb+c
        QZECJQmFg2qgIjocmb/wnxTGaa+rBKHifMMPA2kUgWFUtW6tOcJYpzqsDI5jQGAT
        /juyoqkR5Pzr3y5HG1GrcNCJS0+19UF+EcW6gFZcaRd1fSRPa7KLsCD2wHEl3410
        eiXjogKj8Z7AQBgyfcS7VU/Ol+jkMMRbgYoNCxEGsdjfceHO2TxAw==
X-ME-Sender: <xms:SMxiYHPCNDZ2jR7uC_eSohnxEhxHzQ_ZeyhWWB3Wrc6ObwG7UTafrQ>
    <xme:SMxiYB85JL-5hpHiQaQMNMvJfb5oIvr4NncDmBAThkF2acvAOzaHez4S51TzA5NZQ
    pTSJcTKGVY0TaE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehledgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SMxiYGSEsm9iDLZhgGDy4YXufJKE_BTfHIeZZ4szMWuBBn66o-uWGQ>
    <xmx:SMxiYLuiB_tqgcykzmJVt_3m9lEHHe16E_loX7_3fZ9Md_Q3NQGHYA>
    <xmx:SMxiYPcPHCm2kb11llQOUQXvOQkJxuN7l6Y7JZFLO0Hm1p1ETEIYbA>
    <xmx:SMxiYG4GnxrUGAbINsIwpDzBdp-Y-dH1JqX5lDOCUAr0HIkHaOoyJw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21FA91080067;
        Tue, 30 Mar 2021 02:59:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, colin.king@canonical.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] mlxsw: spectrum_router: Only perform atomic nexthop bucket replacement when requested
Date:   Tue, 30 Mar 2021 09:58:41 +0300
Message-Id: <20210330065841.429433-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When cleared, the 'force' parameter in nexthop bucket replacement
notifications indicates that a driver should try to perform an atomic
replacement. Meaning, only update the contents of the bucket if it is
inactive.

Since mlxsw only queries buckets' activity once every second, there is
no point in trying an atomic replacement if the idle timer interval is
smaller than 1 second.

Currently, mlxsw ignores the original value of 'force' and will always
try an atomic replacement if the idle timer is not smaller than 1
second.

Fix this by taking the original value of 'force' into account and never
promoting a non-atomic replacement to an atomic one.

Fixes: 617a77f044ed ("mlxsw: spectrum_router: Add nexthop bucket replacement support")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6ccaa194733b..41259c0004d1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5068,8 +5068,9 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
 	/* No point in trying an atomic replacement if the idle timer interval
 	 * is smaller than the interval in which we query and clear activity.
 	 */
-	force = info->nh_res_bucket->idle_timer_ms <
-		MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL;
+	if (!force && info->nh_res_bucket->idle_timer_ms <
+	    MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL)
+		force = true;
 
 	adj_index = nh->nhgi->adj_index + bucket_index;
 	err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh, force, ratr_pl);
-- 
2.30.2


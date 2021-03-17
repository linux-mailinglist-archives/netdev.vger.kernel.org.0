Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD5D33E2B2
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCQAbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhCQAat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:30:49 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7866EC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:30:49 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id a11so246136qto.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qRbccARXlRCPUWaG1KfN16iDlT6bnnDQLr5CqzaWN7I=;
        b=WoSU1I/j05n7eOqyUaZUaAICOnBF2X+kn0LyTpoUoLQOIP2eaWud8JWT+234KE1UXQ
         Pi1MJqtc4SwzWL8LyZ3HCEae0kPhmsbWBLuY5PKx9RavNq60Qi8BY4oGSrNOWSaLm2bF
         r5Wbyp6TfV+wGLFygxiu2HkpBjUj9aLEfHxs/R2CcSHHE0Y98HNBlqXyW/xRyp1ljAMK
         iBbiwGDVN1Vd19ZA0d5JtK5B2t2dPt59xUm8WXoLhFzP4dt1QhWRgQZ0WBN1QiM3Wi2q
         EmXFemVyt/WeDN23jJ1hvVK/4Z5rQr6IKk/Ws6L9+ZOhQJRY91aRRnwmF/udxf5/IKOU
         uUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qRbccARXlRCPUWaG1KfN16iDlT6bnnDQLr5CqzaWN7I=;
        b=nlbCijoiJkvNie9/iwnMO025mLGDrC8W08xBHS8qlZwLTLJJYgBbnofPEM9vLk+FoZ
         1fw6nBnnY8H1bb+lI2LlLA/2zcyz98UVHXuOOujZr6kChqu53IIbuYmiA/HseslNj1oy
         5OIRp4MYHM57lFZNwMbD5foUp4lKAajUyidbk79v5WVcVyMXZopLtJEpO8+S4tTSUHeV
         +zXREkoQo90e6yFzDyAJKVXmeVEgMIGTAtcUVVqRM/zTdlWOHfV7dI9EiyD+h9+AGlPm
         cPQx9ZnMXMI3qS2Ve4XYelhBwGoVTngnt/tgic+7GRjAc/isLcQidgWVH2R9qb+wxyEF
         UYNA==
X-Gm-Message-State: AOAM5325ORQkGnI15sziDt7d7jEkwtWlNbFykQyUqN5aQJp2srUiSyAF
        sws2QZBAPKPRJwFDIz1aH4s=
X-Google-Smtp-Source: ABdhPJwXmZpOfKOLlhP0gqnWdMVCSMZXq5IqOYXpitHahZP63zKtdXnLxHhKoIcCBPydo8Hk4PhtUA==
X-Received: by 2002:ac8:5510:: with SMTP id j16mr1416262qtq.339.1615941048608;
        Tue, 16 Mar 2021 17:30:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h16sm14258475qto.45.2021.03.16.17.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:30:48 -0700 (PDT)
Subject: [net-next PATCH v2 02/10] intel: Update drivers to use
 ethtool_sprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Tue, 16 Mar 2021 17:30:44 -0700
Message-ID: <161594104491.5644.18446437902161792108.stgit@localhost.localdomain>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the Intel drivers to make use of ethtool_sprintf. The general idea
is to reduce code size and overhead by replacing the repeated pattern of
string printf statements and ETH_STRING_LEN counter increments.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |   16 ++----
 drivers/net/ethernet/intel/ice/ice_ethtool.c     |   55 +++++++---------------
 drivers/net/ethernet/intel/igb/igb_ethtool.c     |   40 ++++++----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |   40 ++++++----------
 4 files changed, 50 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index c70dec65a572..3c9054e13aa5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2368,21 +2368,15 @@ static void i40e_get_priv_flag_strings(struct net_device *netdev, u8 *data)
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
-	char *p = (char *)data;
 	unsigned int i;
+	u8 *p = data;
 
-	for (i = 0; i < I40E_PRIV_FLAGS_STR_LEN; i++) {
-		snprintf(p, ETH_GSTRING_LEN, "%s",
-			 i40e_gstrings_priv_flags[i].flag_string);
-		p += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < I40E_PRIV_FLAGS_STR_LEN; i++)
+		ethtool_sprintf(&p, i40e_gstrings_priv_flags[i].flag_string);
 	if (pf->hw.pf_id != 0)
 		return;
-	for (i = 0; i < I40E_GL_PRIV_FLAGS_STR_LEN; i++) {
-		snprintf(p, ETH_GSTRING_LEN, "%s",
-			 i40e_gl_gstrings_priv_flags[i].flag_string);
-		p += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < I40E_GL_PRIV_FLAGS_STR_LEN; i++)
+		ethtool_sprintf(&p, i40e_gl_gstrings_priv_flags[i].flag_string);
 }
 
 static void i40e_get_strings(struct net_device *netdev, u32 stringset,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 2dcfa685b763..4f738425fb44 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -871,68 +871,47 @@ static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
-	char *p = (char *)data;
 	unsigned int i;
+	u8 *p = data;
 
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < ICE_VSI_STATS_LEN; i++) {
-			snprintf(p, ETH_GSTRING_LEN, "%s",
-				 ice_gstrings_vsi_stats[i].stat_string);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < ICE_VSI_STATS_LEN; i++)
+			ethtool_sprintf(&p,
+					ice_gstrings_vsi_stats[i].stat_string);
 
 		ice_for_each_alloc_txq(vsi, i) {
-			snprintf(p, ETH_GSTRING_LEN,
-				 "tx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
 		}
 
 		ice_for_each_alloc_rxq(vsi, i) {
-			snprintf(p, ETH_GSTRING_LEN,
-				 "rx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "rx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "rx_queue_%u_bytes", i);
 		}
 
 		if (vsi->type != ICE_VSI_PF)
 			return;
 
-		for (i = 0; i < ICE_PF_STATS_LEN; i++) {
-			snprintf(p, ETH_GSTRING_LEN, "%s",
-				 ice_gstrings_pf_stats[i].stat_string);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < ICE_PF_STATS_LEN; i++)
+			ethtool_sprintf(&p,
+					ice_gstrings_pf_stats[i].stat_string);
 
 		for (i = 0; i < ICE_MAX_USER_PRIORITY; i++) {
-			snprintf(p, ETH_GSTRING_LEN,
-				 "tx_priority_%u_xon.nic", i);
-			p += ETH_GSTRING_LEN;
-			snprintf(p, ETH_GSTRING_LEN,
-				 "tx_priority_%u_xoff.nic", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_priority_%u_xon.nic", i);
+			ethtool_sprintf(&p, "tx_priority_%u_xoff.nic", i);
 		}
 		for (i = 0; i < ICE_MAX_USER_PRIORITY; i++) {
-			snprintf(p, ETH_GSTRING_LEN,
-				 "rx_priority_%u_xon.nic", i);
-			p += ETH_GSTRING_LEN;
-			snprintf(p, ETH_GSTRING_LEN,
-				 "rx_priority_%u_xoff.nic", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "rx_priority_%u_xon.nic", i);
+			ethtool_sprintf(&p, "rx_priority_%u_xoff.nic", i);
 		}
 		break;
 	case ETH_SS_TEST:
 		memcpy(data, ice_gstrings_test, ICE_TEST_LEN * ETH_GSTRING_LEN);
 		break;
 	case ETH_SS_PRIV_FLAGS:
-		for (i = 0; i < ICE_PRIV_FLAG_ARRAY_SIZE; i++) {
-			snprintf(p, ETH_GSTRING_LEN, "%s",
-				 ice_gstrings_priv_flags[i].name);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < ICE_PRIV_FLAG_ARRAY_SIZE; i++)
+			ethtool_sprintf(&p, ice_gstrings_priv_flags[i].name);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 28baf203459a..4ab9f468f08e 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2347,35 +2347,23 @@ static void igb_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 			IGB_TEST_LEN*ETH_GSTRING_LEN);
 		break;
 	case ETH_SS_STATS:
-		for (i = 0; i < IGB_GLOBAL_STATS_LEN; i++) {
-			memcpy(p, igb_gstrings_stats[i].stat_string,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-		for (i = 0; i < IGB_NETDEV_STATS_LEN; i++) {
-			memcpy(p, igb_gstrings_net_stats[i].stat_string,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < IGB_GLOBAL_STATS_LEN; i++)
+			ethtool_sprintf(&p,
+					igb_gstrings_stats[i].stat_string);
+		for (i = 0; i < IGB_NETDEV_STATS_LEN; i++)
+			ethtool_sprintf(&p,
+					igb_gstrings_net_stats[i].stat_string);
 		for (i = 0; i < adapter->num_tx_queues; i++) {
-			sprintf(p, "tx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_queue_%u_restart", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "tx_queue_%u_restart", i);
 		}
 		for (i = 0; i < adapter->num_rx_queues; i++) {
-			sprintf(p, "rx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_drops", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_csum_err", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_alloc_failed", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "rx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "rx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "rx_queue_%u_drops", i);
+			ethtool_sprintf(&p, "rx_queue_%u_csum_err", i);
+			ethtool_sprintf(&p, "rx_queue_%u_alloc_failed", i);
 		}
 		/* BUG_ON(p - data != IGB_STATS_LEN * ETH_GSTRING_LEN); */
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index a280aa34ca1d..4ceaca0f6ce3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1368,45 +1368,33 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 static void ixgbe_get_strings(struct net_device *netdev, u32 stringset,
 			      u8 *data)
 {
-	char *p = (char *)data;
 	unsigned int i;
+	u8 *p = data;
 
 	switch (stringset) {
 	case ETH_SS_TEST:
-		for (i = 0; i < IXGBE_TEST_LEN; i++) {
-			memcpy(data, ixgbe_gstrings_test[i], ETH_GSTRING_LEN);
-			data += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < IXGBE_TEST_LEN; i++)
+			ethtool_sprintf(&p, ixgbe_gstrings_test[i]);
 		break;
 	case ETH_SS_STATS:
-		for (i = 0; i < IXGBE_GLOBAL_STATS_LEN; i++) {
-			memcpy(p, ixgbe_gstrings_stats[i].stat_string,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < IXGBE_GLOBAL_STATS_LEN; i++)
+			ethtool_sprintf(&p,
+					ixgbe_gstrings_stats[i].stat_string);
 		for (i = 0; i < netdev->num_tx_queues; i++) {
-			sprintf(p, "tx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
 		}
 		for (i = 0; i < IXGBE_NUM_RX_QUEUES; i++) {
-			sprintf(p, "rx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "rx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "rx_queue_%u_bytes", i);
 		}
 		for (i = 0; i < IXGBE_MAX_PACKET_BUFFERS; i++) {
-			sprintf(p, "tx_pb_%u_pxon", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_pb_%u_pxoff", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_pb_%u_pxon", i);
+			ethtool_sprintf(&p, "tx_pb_%u_pxoff", i);
 		}
 		for (i = 0; i < IXGBE_MAX_PACKET_BUFFERS; i++) {
-			sprintf(p, "rx_pb_%u_pxon", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_pb_%u_pxoff", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "rx_pb_%u_pxon", i);
+			ethtool_sprintf(&p, "rx_pb_%u_pxoff", i);
 		}
 		/* BUG_ON(p - data != IXGBE_STATS_LEN * ETH_GSTRING_LEN); */
 		break;



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46F34EEA8F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344658AbiDAJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344646AbiDAJip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:38:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CCB70076;
        Fri,  1 Apr 2022 02:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648805816; x=1680341816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0NIW/cc+RvUknlP+iPskMpoZNNVhTBKJHfCKTw/YlhQ=;
  b=GP/iA4E6rXVZ7H3H9QNTfc4lXvk4Iqlac1YqxKkQXeJ3jV953QuQPAwd
   sjeU3wKeSMdAvDblr4wPYfOgV0Ttph34vlnFUoEg59WMicOY4SnlzzpfX
   ZiyVIbiWIHtdJWvha6f5AKMOCUP/rg2xLrcrAQNrQQNI4bj6svnlZ4Aap
   V3Hi5lNmfbic748AGWF6Bkgt2AEcfzmb8iJhYg7NUQsrvmP6zSsk1JhkF
   Q6vAW1YVbJXTunxJx7pBBnayz88chtAWQadLL1s0yrV1Is17j+D9eDPf4
   08sf2hYLTn80x5qB+UWu0emF2EHwy/4IwK6ICJBkSr+pHClSgerpfcY2o
   A==;
X-IronPort-AV: E=Sophos;i="5.90,226,1643698800"; 
   d="scan'208";a="151165605"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 02:36:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 02:36:55 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 02:36:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 1/2] ethtool: Extend to allow to set PHY latencies
Date:   Fri, 1 Apr 2022 11:39:08 +0200
Message-ID: <20220401093909.3341836-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
References: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend ethtool uapi to allow to configure the latencies for the PHY.
Allow to configure the latency per speed and per direction.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/ethtool.h |  6 ++++++
 net/ethtool/common.c         |  6 ++++++
 net/ethtool/ioctl.c          | 10 ++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 7bc4b8def12c..f120904a4e43 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -296,6 +296,12 @@ enum phy_tunable_id {
 	ETHTOOL_PHY_DOWNSHIFT,
 	ETHTOOL_PHY_FAST_LINK_DOWN,
 	ETHTOOL_PHY_EDPD,
+	ETHTOOL_PHY_LATENCY_RX_10MBIT,
+	ETHTOOL_PHY_LATENCY_TX_10MBIT,
+	ETHTOOL_PHY_LATENCY_RX_100MBIT,
+	ETHTOOL_PHY_LATENCY_TX_100MBIT,
+	ETHTOOL_PHY_LATENCY_RX_1000MBIT,
+	ETHTOOL_PHY_LATENCY_TX_1000MBIT,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
 	 * phy_tunable_strings[] in net/ethtool/common.c
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 0c5210015911..e0fec9eec047 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -98,6 +98,12 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
 	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
 	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
+	[ETHTOOL_PHY_LATENCY_RX_10MBIT] = "phy-latency-rx-10mbit",
+	[ETHTOOL_PHY_LATENCY_TX_10MBIT] = "phy-latency-tx-10mbit",
+	[ETHTOOL_PHY_LATENCY_RX_100MBIT] = "phy-latency-rx-100mbit",
+	[ETHTOOL_PHY_LATENCY_TX_100MBIT] = "phy-lantecy-tx-100mbit",
+	[ETHTOOL_PHY_LATENCY_RX_1000MBIT] = "phy-latency-rx-1000mbit",
+	[ETHTOOL_PHY_LATENCY_TX_1000MBIT] = "phy-latency-tx-1000mbit",
 };
 
 #define __LINK_MODE_NAME(speed, type, duplex) \
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 326e14ee05db..a1caee4ef5b9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2605,6 +2605,16 @@ static int ethtool_phy_tunable_valid(const struct ethtool_tunable *tuna)
 		    tuna->type_id != ETHTOOL_TUNABLE_U16)
 			return -EINVAL;
 		break;
+	case ETHTOOL_PHY_LATENCY_RX_10MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_10MBIT:
+	case ETHTOOL_PHY_LATENCY_RX_100MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_100MBIT:
+	case ETHTOOL_PHY_LATENCY_RX_1000MBIT:
+	case ETHTOOL_PHY_LATENCY_TX_1000MBIT:
+		if (tuna->len != sizeof(s32) ||
+		    tuna->type_id != ETHTOOL_TUNABLE_S32)
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.33.0


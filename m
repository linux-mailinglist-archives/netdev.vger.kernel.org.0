Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816CE195F58
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgC0Tz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:55:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38182 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0Tz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:55:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id f6so7195555wmj.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=evl7BRZpDrNHmuixs2dkSIeH08KdOdXhz0EIi7BGZ4k=;
        b=F/WJV4hq7yUy3NYW0cQDfjpADHgxsmdoM01JzphHt3wWzd4q1j9Iy3+YBsh0HJEBZg
         d+G7K/6G2BnoPxlMxVMtQyu1I8PCy5h7n38o0Aly1hq3bsJZBI5N14UKHoQT4pcwgiMN
         ZvERHwq7gbF3ZTcTzV2jBUmEOv2La9+OuW0uI09XirnlheZsWnPX0KX+71RZn1sAm2Dl
         Vm3z2asS1E+jItuy5cCyUExb1RRn60zH33QuB1y1ARUmIpfs7n7Epk4cl3RCKY/FP6mB
         WDOcmMf7RfA4zX010oTDwiY+/9KEkN7aivXVkQ8Akttxt+vz9ysW1TS/g62vnBNzOpU2
         +T1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=evl7BRZpDrNHmuixs2dkSIeH08KdOdXhz0EIi7BGZ4k=;
        b=o2tpUt4uwHYnK7eWZteEmZn6PA732T+EJ4R3pY2WJv5R2eLuaHZvpUGNT6TfPTCGNs
         so5J4psvQV9qq7z7lsZZcn8ULIqe16CPwbC4PCL5W1k3O36em4NjffOpsGsKb6kfJnIA
         vXwNLGFlUZYiJOvRud+uxFrFWwBG1tFKsEZiY6sVNZHf7nnfX30K9oMzk9Ew/nzSnJRk
         lL8nsbnBsnxky1XTy0ndLdwF/iQlHJZ38CGXQCbALn/ujZZt34gnlpSTAGH7HkSEbB9+
         /su+kY6I3PvYRbKN9KcZzsmCJVLSwIFr10X7HOzky4UNAJkTmPMaP3VDJld3VgLtABKs
         hgcA==
X-Gm-Message-State: ANhLgQ35kIB8jvtZYFG9dxbB/ELuIfcZEQI8QzHlrmvmdgDVkFOF855o
        UzYyHtCMQDWl6J5xaAKMOxQ=
X-Google-Smtp-Source: ADFU+vuRhJSWZn56bWIlMgjTNhAvRQ4Cl7nHB91bw6klqZGiPeu7NGZVu2N4LSu041Do0RL0F6MbmA==
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr305883wmi.13.1585338955468;
        Fri, 27 Mar 2020 12:55:55 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:55:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 2/8] bgmac: configure MTU and add support for frames beyond 8192 byte size
Date:   Fri, 27 Mar 2020 21:55:41 +0200
Message-Id: <20200327195547.11583-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

Change DMA descriptor length to handle jumbo frames beyond 8192 bytes.
Also update jumbo frame max size to include FCS, the DMA packet length
received includes FCS.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Reviewed-by: Arun Parameswaran <arun.parameswaran@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
Squashed the entire bgmac implementation in one patch.

Changes in v2:
Patch is new.

 drivers/net/ethernet/broadcom/bgmac.c | 12 ++++++++++++
 drivers/net/ethernet/broadcom/bgmac.h |  5 +++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 1bb07a5d82c9..98ec1b8a7d8e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1248,6 +1248,14 @@ static int bgmac_set_mac_address(struct net_device *net_dev, void *addr)
 	return 0;
 }
 
+static int bgmac_change_mtu(struct net_device *net_dev, int mtu)
+{
+	struct bgmac *bgmac = netdev_priv(net_dev);
+
+	bgmac_write(bgmac, BGMAC_RXMAX_LENGTH, 32 + mtu);
+	return 0;
+}
+
 static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_open		= bgmac_open,
 	.ndo_stop		= bgmac_stop,
@@ -1256,6 +1264,7 @@ static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_set_mac_address	= bgmac_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl           = phy_do_ioctl_running,
+	.ndo_change_mtu		= bgmac_change_mtu,
 };
 
 /**************************************************
@@ -1530,6 +1539,9 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
 
+	/* Omit FCS from max MTU size */
+	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
+
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
 		dev_err(bgmac->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 40d02fec2747..351c598a3ec6 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -351,7 +351,7 @@
 #define BGMAC_DESC_CTL0_IOC			0x20000000	/* IRQ on complete */
 #define BGMAC_DESC_CTL0_EOF			0x40000000	/* End of frame */
 #define BGMAC_DESC_CTL0_SOF			0x80000000	/* Start of frame */
-#define BGMAC_DESC_CTL1_LEN			0x00001FFF
+#define BGMAC_DESC_CTL1_LEN			0x00003FFF
 
 #define BGMAC_PHY_NOREGS			BRCM_PSEUDO_PHY_ADDR
 #define BGMAC_PHY_MASK				0x1F
@@ -366,7 +366,8 @@
 #define BGMAC_RX_FRAME_OFFSET			30		/* There are 2 unused bytes between header and real data */
 #define BGMAC_RX_BUF_OFFSET			(NET_SKB_PAD + NET_IP_ALIGN - \
 						 BGMAC_RX_FRAME_OFFSET)
-#define BGMAC_RX_MAX_FRAME_SIZE			1536		/* Copied from b44/tg3 */
+/* Jumbo frame size with FCS */
+#define BGMAC_RX_MAX_FRAME_SIZE			9724
 #define BGMAC_RX_BUF_SIZE			(BGMAC_RX_FRAME_OFFSET + BGMAC_RX_MAX_FRAME_SIZE)
 #define BGMAC_RX_ALLOC_SIZE			(SKB_DATA_ALIGN(BGMAC_RX_BUF_SIZE + BGMAC_RX_BUF_OFFSET) + \
 						 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
-- 
2.17.1


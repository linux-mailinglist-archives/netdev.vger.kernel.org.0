Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F49194BA8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgCZWlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:41:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37496 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZWlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:41:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id d1so10027924wmb.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eoc/anp9hI4hmzoROmqXY5/InuJ0Eh4KwcgSSqkOB/8=;
        b=Aw7nbTJeQV0hvE+8Z+7LO51RetG0Ins3YlmpaNTH6ymaEWBZi7xJFzwXT+DrZYUBYF
         7+hBGteklVt2I4dwm0ENcM47WEw8iF1WXPj9WOWUpRoDekEjFHWIBdFdjPF+tUC5tLsn
         Bm0rtAqy52k2fhCmvO985E8FZRNXY7KKhKJPq6cE1waC/zQPD3qB5ug7ZbugOyYmjevs
         vUBgD4NsuCJjcJ54wtUmkYgySQVDZPi06i3eK6qXf/YbHAY2UePIfRKkuov02pvRBTdR
         ASDqYnJ5K4Cwc/7/aTT+fXde4XtamkdCARMBznzEwRvRbb7Iy3OqQn+Ra2VM9CZ2SgD3
         SVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eoc/anp9hI4hmzoROmqXY5/InuJ0Eh4KwcgSSqkOB/8=;
        b=qAnrCXu3BCeRMRYVAv20QeQLffkZySFhc6QvvDt2/1fIBmeq2DWo+onxr7GXqA8khv
         y1I5F8pat9P9oWmgGtGnhEgGCjO6Kv/OVQHQn50xzdfDv2wHTfhqG6/S/yXBkaPIs37t
         k/xx/MgmHU6PmTYMWtR3S6Q9bxjtvmjkl8JBw+cTloPXPH2vXTBhqKWO16S9PWV1pifb
         z+nQ0AJqbuMrVbHwLY1FPmRzib5LqFghN/dfxYl5pc+R8XU+XTOn7dGuKxTLarGFXK3m
         x1S1r+s2oBxJjIrU+MVA/onb7aflMfr+Et7DLZ2uU//8BUVsbJeR6ax1hHMj18ARngRf
         hDXw==
X-Gm-Message-State: ANhLgQ3klCuRysk3q52VKtbHSe3GkUf8yORbCkRdrHl4PNBhEXsxDzuu
        TpeiPp21eRxLtv5BO6mJcF4=
X-Google-Smtp-Source: ADFU+vun8dUkWEVSSRXFgfNGZIVrwXSJUF5hoVUEO0sUKVSaYGI2va2we2yDq5zzgfYOULK3c59qBg==
X-Received: by 2002:a05:6000:48:: with SMTP id k8mr11619847wrx.91.1585262464600;
        Thu, 26 Mar 2020 15:41:04 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t81sm5522783wmb.15.2020.03.26.15.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 15:41:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 2/8] bgmac: configure MTU and add support for frames beyond 8192 byte size
Date:   Fri, 27 Mar 2020 00:40:34 +0200
Message-Id: <20200326224040.32014-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326224040.32014-1-olteanv@gmail.com>
References: <20200326224040.32014-1-olteanv@gmail.com>
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


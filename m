Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945B8192C2A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCYPWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33515 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgCYPWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so3687546wrd.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3wL1B/wBmmIryhoIyvG5CwEVuoVqoi8PMnXTD9WV78c=;
        b=B0whHngrM6GZ+twNvWO/G8XfoRenHt04yZvhW/rQR/OFgsHnHrcZtXD6+WpCZ8XVnr
         nU9o7bTNfZHpj5hXnYoBUlHsAB9UepLbxNiGnu2IClxeaDQaWDghxl8BPWNitBem5Ksf
         dfZ1y1qJ1JQE0Ke7tbqUCWQU2aCSVk6jwkNBemKMEIajRYErg3Lj8hU+aHTwhsZXuzAz
         lmdsKtlvVg7nyk4gGaikAzYlXvYErGmFjlQ1aE1YFUUREpSDczhCryrKBGkEKABfcSw8
         NYJ+QEL+V7B3ct0IPCO/+CvB5esqUMHDNAiozymv5JIrZI5APXg8AnsjGOaj3h0pTr30
         Y+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3wL1B/wBmmIryhoIyvG5CwEVuoVqoi8PMnXTD9WV78c=;
        b=DOAQqql4oAiGzLQ8wMdnHjHja8QNQwTjnxXjGbZDlChfg8OKRF8cgh1u3t17Jq6wME
         d1Dg6ntrN3duMrZeaLJKFsMdwv+PJMJZzxChCqGGCa37mpf+5urhP6ypKZPejwsBf/sJ
         diU8paS50rAEFkS0ILrPSehU4Ru454B7lS6jsuQwzf4MAZtRxRT+cjIsjOkCVqoLYNJQ
         IcLqFarBRuPXfDomt2/CRPkTlfe8Ts8msJqv7UkDTtX2qThhvhzNRFEhJoLxFyPum3Af
         OB6hcUG6qfM/k6q+qhFw2nmVm9rYK2YFQ1NDxSmaxjeIcf6oZx4zPefA4ATX0JTbmFoR
         ymfA==
X-Gm-Message-State: ANhLgQ0stRBkPrROm6VJyN+mgTcQgA0pBz9CybSIMqmGucr/utFP79Gg
        oiXDA6S+RmpRWUGolh5j4Es=
X-Google-Smtp-Source: ADFU+vuwijqsqeE1MstjN/bYoHvuwnscuHPRkro+NJ/nd5ZzODMQe7aEwYDZM2Bekmg9c0YUGDjuAw==
X-Received: by 2002:adf:9322:: with SMTP id 31mr3994720wro.297.1585149741188;
        Wed, 25 Mar 2020 08:22:21 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 05/10] bgmac: Add DMA support to handle frames beyond 8192 bytes
Date:   Wed, 25 Mar 2020 17:22:04 +0200
Message-Id: <20200325152209.3428-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

Add DMA support in driver to handle jumbo frames beyond 8192 bytes.
Also update jumbo frame max size to include FCS, the DMA packet length
received includes FCS.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Reviewed-by: Arun Parameswaran <arun.parameswaran@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/broadcom/bgmac.c | 4 +++-
 drivers/net/ethernet/broadcom/bgmac.h | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index c530dff0353b..98ec1b8a7d8e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1538,7 +1538,9 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	net_dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
-	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE;
+
+	/* Omit FCS from max MTU size */
+	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
 
 	err = register_netdev(bgmac->net_dev);
 	if (err) {
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 041ad069b5c8..351c598a3ec6 100644
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
@@ -366,8 +366,8 @@
 #define BGMAC_RX_FRAME_OFFSET			30		/* There are 2 unused bytes between header and real data */
 #define BGMAC_RX_BUF_OFFSET			(NET_SKB_PAD + NET_IP_ALIGN - \
 						 BGMAC_RX_FRAME_OFFSET)
-/* Jumbo frame size */
-#define BGMAC_RX_MAX_FRAME_SIZE			9720
+/* Jumbo frame size with FCS */
+#define BGMAC_RX_MAX_FRAME_SIZE			9724
 #define BGMAC_RX_BUF_SIZE			(BGMAC_RX_FRAME_OFFSET + BGMAC_RX_MAX_FRAME_SIZE)
 #define BGMAC_RX_ALLOC_SIZE			(SKB_DATA_ALIGN(BGMAC_RX_BUF_SIZE + BGMAC_RX_BUF_OFFSET) + \
 						 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
-- 
2.17.1


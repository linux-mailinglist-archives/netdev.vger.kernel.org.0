Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759FB36785A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhDVELF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbhDVEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A3C06138C;
        Wed, 21 Apr 2021 21:09:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id p12so31918090pgj.10;
        Wed, 21 Apr 2021 21:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z+GoIGK0ASypWzKq72OR9x8SOdqUZq5a0/koCWBmuF4=;
        b=AprUGNkG4iniX7gYV9sc0nkIUpaw4DobJ3++iTN7JS1NrwMyOKGGVaf1e30tNIa2fS
         9Y6nYK+mNrT+XNGmGy7DRF+fGYtEm14LyCfV0Fx9FEO8gBU4ik38GOv1jcJuLGLXaD5F
         iBwjY25Oxbsp2K6ujWm3YM8eXHcTWlk2AuujaGh48a6d3DqDr5fTUpnwUTMpGHo9JZUk
         Ecc2BqqOrxpsAH4/ufHOPDgaeab6jBSNFcEBFh0epEuGDlNV2C6mkO5s871Ebdi9aq4V
         rekaU3kfYEudV5imStEtUGcGERNtIqjWQfL3JfUvfrGz/1x7gJWp2voSN6PItH0wgTEA
         wYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+GoIGK0ASypWzKq72OR9x8SOdqUZq5a0/koCWBmuF4=;
        b=e3LiU4sq4jFcWEXd5a4UaXh3lTM5InMNE7gEq/KOUJ/Gxb2tpQCDuVJxvx8xnmfeCU
         TqUoe8GtxBmO2c8QgJGSYdjwpIqBqW0QUxl2L+dC8dwweWpJEkLkp6thfK8GIWRnDf7n
         YvqR3fowdz7vi3W6DUwHXe7zmKbp3LHAmDgV41f0rG+gP7tkD8zwMVUad+hNPeg4D5nL
         yIORKMzMwRIaCrJ2lEIchgsK8QY9onpV6KwaHzU8fOWvXjNdC3GADBclFiT0afHCbgBQ
         nF/VTB+0E2DeEVRpZhinbVtaxdCKFdlHkz56qITW98ZcXtbWepQ7yI6qAy5d80freMiS
         pt7A==
X-Gm-Message-State: AOAM530i2je5MPimEjQQnZSNRbnrr6mW1zI9RZuTdUIGjf9DhSGpi+pK
        j/+cat+LS2ebWvQ5GUq0AdY=
X-Google-Smtp-Source: ABdhPJwdXfftitSkQgijuSk3gh09yZ8hWXEU9IIUiEfUBuPEVMliIZMb7ZvHXRb3o8qf6vA4R76wXw==
X-Received: by 2002:a63:4866:: with SMTP id x38mr1518318pgk.135.1619064588652;
        Wed, 21 Apr 2021 21:09:48 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:48 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 13/14] net: ethernet: mtk_eth_soc: set PPE flow hash as skb hash if present
Date:   Wed, 21 Apr 2021 21:09:13 -0700
Message-Id: <20210422040914.47788-14-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

This improves GRO performance

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: Use MTK_RXD4_FOE_ENTRY instead of GENMASK(13, 0)]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 88a437f478fd..8c863322587e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/pinctrl/devinfo.h>
 #include <linux/phylink.h>
+#include <linux/jhash.h>
 #include <net/dsa.h>
 
 #include "mtk_eth_soc.h"
@@ -1248,6 +1249,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		struct net_device *netdev;
 		unsigned int pktlen;
 		dma_addr_t dma_addr;
+		u32 hash;
 		int mac;
 
 		ring = mtk_get_rx_ring(eth);
@@ -1317,6 +1319,12 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->protocol = eth_type_trans(skb, netdev);
 		bytes += pktlen;
 
+		hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
+		if (hash != MTK_RXD4_FOE_ENTRY) {
+			hash = jhash_1word(hash, 0);
+			skb_set_hash(skb, hash, PKT_HASH_TYPE_L4);
+		}
+
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
 		    (trxd.rxd2 & RX_DMA_VTAG))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-- 
2.31.1


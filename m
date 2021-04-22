Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03ED367842
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhDVEKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhDVEKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F360C06138B;
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s20so7004082plr.13;
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M+UkxRcksnApyVs6XRntELHRkRUhOfWnYDnO1ZqRoWc=;
        b=Krf+iJf9arTXsWfbO65KruQYlFPyL1W/a7QWL02To8JtHLLrm20hPSip5Kw2GYq1hg
         3JDjnW6092g1/mOdXD/KN06D96oRcuH52oVcY57hYBD66+TCVJrR7xfG7phe8ZmD4OEo
         BZ1wV6M9t6HSDZZqJdH2dm99RTbOTKaqDGU9Ro0oeEtmAh+tOV2EdGnEpHw0u+B/EVlH
         f3ZD4Syu54p1lxdzbPr6nLnvpktbP7H6quaEgdtYftzfwitW+x5WwHFBUMQM6RfQ4ZRb
         ouh4k1jXB7rDkA0uo7zRPHS+iPSLvlcucPcW5e0rK6rzK62duM4YriwkoBYfEF25oBiJ
         GvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+UkxRcksnApyVs6XRntELHRkRUhOfWnYDnO1ZqRoWc=;
        b=tsiOMJxRXSgQs9OmNSpgRA1LH6FAc4B2btpi40yg/zxnV/uQ8k7lSkCrEHYrv88KWq
         s6yjM9zZ9mWbGGHED5cni6dOTC6jPwkNYXpdP0suvOwGTxnEHwsdqPl9A0rTEJo5PEha
         x2SM6SBXbb2BXummvqFiuaD3HKi9TuvQ5xO50Yq04FHnSU4P6i7ZFrNyCOqzwTAN3QSW
         PAZM18n8prJttzQ+MbIN3braeeI2/Mg882k/EvFXXH8DyDZaDTItiSg0V/JZKN7+0v3N
         CfVh4J8omuQwu+ERliXFgJr+f2tHo9m/LAHIiNsGPhutdqV4LAg4mjgmHNPCiFMeeeiE
         RCuQ==
X-Gm-Message-State: AOAM530DjlHrmfxAsjRORCaa/d/YkkjAmWUFf+szEsPGb70LwY/XdCm5
        grKAB7dOzDcix5BhZVH2XFo=
X-Google-Smtp-Source: ABdhPJyTYQJ83qyCIAcrBlJUUq7yf3pUtZkYMy14r3Ds24vk5PH8rQcWHhpel40s381fjFRfb8hXbw==
X-Received: by 2002:a17:902:109:b029:ec:9f64:c53d with SMTP id 9-20020a1709020109b02900ec9f64c53dmr1408533plb.83.1619064578591;
        Wed, 21 Apr 2021 21:09:38 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:38 -0700 (PDT)
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
Subject: [PATCH net-next 01/14] net: ethernet: mtk_eth_soc: fix RX VLAN offload
Date:   Wed, 21 Apr 2021 21:09:01 -0700
Message-Id: <20210422040914.47788-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The VLAN ID in the rx descriptor is only valid if the RX_DMA_VTAG bit is
set. Fixes frames wrongly marked with VLAN tags.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: fix commit message]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6b00c12c6c43..b2175ec451ab 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1319,7 +1319,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->protocol = eth_type_trans(skb, netdev);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
-		    RX_DMA_VID(trxd.rxd3))
+		    (trxd.rxd2 & RX_DMA_VTAG))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       RX_DMA_VID(trxd.rxd3));
 		skb_record_rx_queue(skb, 0);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1a6750c08bb9..875e67b41561 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -301,6 +301,7 @@
 #define RX_DMA_LSO		BIT(30)
 #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
 #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
+#define RX_DMA_VTAG		BIT(15)
 
 /* QDMA descriptor rxd3 */
 #define RX_DMA_VID(_x)		((_x) & 0xfff)
-- 
2.31.1


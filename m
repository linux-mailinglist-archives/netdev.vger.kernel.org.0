Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB48368C79
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbhDWFWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbhDWFVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:21:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7765FC061574;
        Thu, 22 Apr 2021 22:21:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cu16so20506743pjb.4;
        Thu, 22 Apr 2021 22:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M+UkxRcksnApyVs6XRntELHRkRUhOfWnYDnO1ZqRoWc=;
        b=YqR5wBCEG4LdcLo0lZg6cH+tcklWyskvWaWbqu3+m41OjiOI0vJfgBt8WaINceHnHp
         FyU+z+yV8z6xoqI++d8hQxrn2BQRnF0Y/1jqkBP9miOh28YC9KpipS3bkSPuce6xDvYg
         /Lyf+fM6U9AE0wjboQyGDvrSAgRqgL8PfTA3DCD/JPO3wLZwurni51LBzh3/SFygeGPB
         2Y8/q/NVfGeScdqCN7s+CpIYqaYw+/RP3YawQueSHLhJt+j//ecPbtNd4+27FX6tTvHg
         bBqiKmamHW3XgihuVB4P0t4EqDgrOkMjoMS0Ayb+Of0uKKHYIYb5lYJDhurCt1TBjlx3
         aTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+UkxRcksnApyVs6XRntELHRkRUhOfWnYDnO1ZqRoWc=;
        b=pyH5u5aAmilnp4QGpaeb8sxq5fED9eA1FvXwnSkoCeYwXFTfn1VD5Nps8Hu4eHPRSN
         PrquivD1HK3ytK2lTxttl2TEv2QIroZzIfUSW7pcCoXtpKb3sfcNZErYhFsqWEfN9vjs
         9zjpvjp+kWdG6WNwF5mWiviEZJ1KmuhUY5w0QosUbfbiEzYdk4O/h98XdhkUY8gn2odZ
         P1grs20IBD2WEJ8dESM+I0XD8SXhohmwucaqzsoRxez+SpFGEa3dJONb/pSVrlMOVN0n
         vY0K611v6v4sNwJ2kI6OtYld9x1jFMKh5llg1K0Dpl4GpX/+df+OLEQBT5IE3aFaIFvn
         /Wbg==
X-Gm-Message-State: AOAM530v+ACXvtD54AYmixvfsJM546GfqkmDJdgQWQ9WzSMSB99cj+HK
        kHtVbALIik9cWwjPCIlTsrQ=
X-Google-Smtp-Source: ABdhPJwQ6kWQAIGJ3oAZPqiZa98jRvYL+nHMV0pr0QOfpb87dPhNaXXKFCC4UGF13r43UlsVmHXS3Q==
X-Received: by 2002:a17:902:dac9:b029:eb:732:d914 with SMTP id q9-20020a170902dac9b02900eb0732d914mr2058741plx.85.1619155277945;
        Thu, 22 Apr 2021 22:21:17 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:17 -0700 (PDT)
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
Subject: [PATCH net-next v2 01/15] net: ethernet: mtk_eth_soc: fix RX VLAN offload
Date:   Thu, 22 Apr 2021 22:20:54 -0700
Message-Id: <20210423052108.423853-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
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


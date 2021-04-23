Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E55E368C8D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbhDWFWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240552AbhDWFWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:07 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D85C06174A;
        Thu, 22 Apr 2021 22:21:30 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id p2so18982865pgh.4;
        Thu, 22 Apr 2021 22:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1zBsYlQcq61seY0imZReAqd25ZKjbgbucT8yzndF0G8=;
        b=mXObVk0IL/7DFMTpyCRPZqGetBuk3drJ5M/Obl1C6xlK7NDyhWWCkl+KNYiQutboxo
         kW6NaspOYeE4qWwHpjbIUz5ErGST9GY4/eGwtQc2odt1wMZD2IcUhPqD7dBy4NkNPGp6
         tLrU2REcLNeOdDmQFXDupVzyomCI8NOfpFEHRpNz4ig38eg/mrkEcIXxjnR0osGV2q0+
         xDwo2ZK2B8OGp7uC4aJhP7+Udx313yhxFi88+DxnbG/lTvoUAMI1y+IIfQ540dy3P3I3
         h2xF0CqSDfBDDUk1QwMwVSTt5nZm7ixz/P7ca/S9n6Ac0i6+Ji+RlmRQgNyh98fCyjxt
         /fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zBsYlQcq61seY0imZReAqd25ZKjbgbucT8yzndF0G8=;
        b=CcybcUWyC0HoCOZIElIdpJ7xMp4hnCZLn0OaJeEKtu6eaV96NzgU3RAeH13QLdDniE
         Pxz12kriK57YMkyckSoSL6dpAJ8kvDg+GiNGvtCkZVvUcXhJgLICbxbMNIegC+FoP2Li
         pS0hz2X+oQUZKBbFp88tvSHDqM+pAimpDk9abgWXL256rfM2kQUwVCaRVi05cv8FX5Eb
         Y/7PPUIsSO5wsoJ60sJuPbqp4pSnF1UCjQ4wrq6BK+BjsqVs27aDIRclUu9IoiPTvjEF
         aKV6dE1haOEeisM8spKdYOW+rv3+ThhVtXh//1Eyr17ZYrBEB54F0Xl4dcVuCyDkgt4q
         JwKg==
X-Gm-Message-State: AOAM533wKyN+bx9u3Xk24gtn5aR1+Kv1AoCAY+GH9lsVm2yFUyE39NLC
        orLEdFdKufpXiw02A/WyJpk=
X-Google-Smtp-Source: ABdhPJzYTtLTrv/HN8NBYaCqVRueYZcK2ZzzlX8xhlJjUZfD3Gdzp3iB1pwBdX68Cwy/NGXiEfx9FQ==
X-Received: by 2002:a62:1b50:0:b029:257:da1e:837f with SMTP id b77-20020a621b500000b0290257da1e837fmr2066529pfb.57.1619155290331;
        Thu, 22 Apr 2021 22:21:30 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
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
Subject: [PATCH net-next v2 14/15] net: ethernet: mtk_eth_soc: set PPE flow hash as skb hash if present
Date:   Thu, 22 Apr 2021 22:21:07 -0700
Message-Id: <20210423052108.423853-15-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
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
index 8faf8fb1c83a..37e50a2e7d0e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/pinctrl/devinfo.h>
 #include <linux/phylink.h>
+#include <linux/jhash.h>
 #include <net/dsa.h>
 
 #include "mtk_eth_soc.h"
@@ -1250,6 +1251,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		struct net_device *netdev;
 		unsigned int pktlen;
 		dma_addr_t dma_addr;
+		u32 hash;
 		int mac;
 
 		ring = mtk_get_rx_ring(eth);
@@ -1319,6 +1321,12 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
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


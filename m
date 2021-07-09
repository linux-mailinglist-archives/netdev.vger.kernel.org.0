Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33973C1D36
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 03:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhGIB6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 21:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhGIB63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 21:58:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AECC061574;
        Thu,  8 Jul 2021 18:55:45 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j9so1634466pfc.5;
        Thu, 08 Jul 2021 18:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nn1wSgCcZgcwpI1qK0JAAC1fT9Tjqy/uXaXsglsp5RM=;
        b=i/s4z4IVsWKS3nyUBDvXz4eFVldzWy51+mktPw1TUrjN8CXWW+D91zcDp8p1OnQBm2
         B3l3S7NeVPqDveXbTsjGXz/ktMaOoBL7rZ3iCmHqdIPlhi77pno6IRsLTf8WF64Bu2y/
         3E9QkQAXbKOFz362FaKluY38hXQgwsFFJpSWGG+JMj1DuFgcqQEZmVRVQ7V6YjX+Il4n
         Q77tHvat9/+If2jKXxbXhg7mYRJzIWzc4ertiXq+LWlMGDOjlGnwhXSVHkuh0n0OAqrj
         B6Vig2RhPcEIijUx31zSFgjyMyFvRAQFKBT3pR1VaMDaHnk0+Ex4rS+S20us5vH11bFk
         TBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nn1wSgCcZgcwpI1qK0JAAC1fT9Tjqy/uXaXsglsp5RM=;
        b=X/8uv9WqRZBzIAgldjDz8nvozWmBW8W1jjjxOFrJOaQ9setlENHQItyM8DqpCvp56z
         ePPeYbyDS8zzpYM/xuxvRyWeVoui50yb4OMtQpdvYY0SFl+tZz7/f8gWRNLtuWv59OXT
         d5w112g9oMW7ZrtEUVdImQyIbY3C0ppENM/7Nvo81jJPfKnQac/5NGdItR68o2eG4I5q
         mdxQSgOq++/oMc4Xn70wDkKwhPHanwXdCxfZIMJ8Ph3R5QL+dWCl/GnmqXvxma3FqgoS
         eGsqbIedLlEXMDU4Yf1FqDhQgvu6aN036lLpg/SG2tmSYGhw/kd7tH7iz6/ORiFQBWx9
         T20A==
X-Gm-Message-State: AOAM5320VeXoSGGXKnoGUlJcCCrATrbxLI/XAHA44GBq98qmJiX16gzi
        c0ud2b+cSJK8f5FmVSjudV7cL1wtK2A=
X-Google-Smtp-Source: ABdhPJy+hANOy4Cvpb++vC/TjCi/mm5x3T8XqooM4KeQU0Pb3nI6Jw3Mk+65iRlbpve43YqmJZI9Ag==
X-Received: by 2002:aa7:8003:0:b029:2eb:2f8f:a320 with SMTP id j3-20020aa780030000b02902eb2f8fa320mr34939624pfi.70.1625795745012;
        Thu, 08 Jul 2021 18:55:45 -0700 (PDT)
Received: from 7YHHR73.igp.broadcom.net (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id e2sm4161122pfj.212.2021.07.08.18.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 18:55:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Ensure all TX/RX queues DMAs are disabled
Date:   Thu,  8 Jul 2021 18:55:32 -0700
Message-Id: <20210709015532.10590-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that we disable each of the TX and RX queues in the TDMA and
RDMA control registers. This is a correctness change to be symmetrical
with the code that enables the TX and RX queues.

Tested-by: Maxime Ripard <maxime@cerno.tech>
Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 35e9956e930c..db74241935ab 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3238,15 +3238,21 @@ static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
 /* Returns a reusable dma control register value */
 static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 {
+	unsigned int i;
 	u32 reg;
 	u32 dma_ctrl;
 
 	/* disable DMA */
 	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->tx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
 	reg &= ~dma_ctrl;
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 
+	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->rx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
 	reg &= ~dma_ctrl;
 	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
-- 
2.25.1


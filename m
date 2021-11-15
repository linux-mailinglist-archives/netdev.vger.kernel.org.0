Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B930450E01
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhKOSJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 13:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239836AbhKOSEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895CD619E3;
        Mon, 15 Nov 2021 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997964;
        bh=ke48mqdZH2OA4qy1tg07rSC3Or8ooyAKw/9VaUN0brU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2e9JS74CHIzmdPc4IsLwTXhxP0ISdfdS+DPtBlXzrhnkoezsja056l2YjOmBWeq0
         sSFJPFxp4a9qzpITlwoSfS6GVAkVHPlf9KxsowbGHM5CC/NaRgiwiMbFAVdquOtGlP
         /9UPjBiKl6ISPRaURaQEnzLfmwrerCWlkf6+0gpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Tim Gardner <tim.gardner@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/575] net: enetc: unmap DMA in enetc_send_cmd()
Date:   Mon, 15 Nov 2021 18:01:04 +0100
Message-Id: <20211115165355.524327484@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

[ Upstream commit cd4bc63de774eee95e9bac26a565cd80e0fca421 ]

Coverity complains of a possible dereference of a null return value.

   	5. returned_null: kzalloc returns NULL. [show details]
   	6. var_assigned: Assigning: si_data = NULL return value from kzalloc.
488        si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
489        cbd.length = cpu_to_le16(data_size);
490
491        dma = dma_map_single(&priv->si->pdev->dev, si_data,
492                             data_size, DMA_FROM_DEVICE);

While this kzalloc() is unlikely to fail, I did notice that the function
returned without unmapping si_data.

Fix this by refactoring the error paths and checking for kzalloc()
failure.

Fixes: 888ae5a3952ba ("net: enetc: add tc flower psfp offload driver")
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c   | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index dbceb99c4441a..9e6988fd3787a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -486,14 +486,16 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	data_size = sizeof(struct streamid_data);
 	si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
+	if (!si_data)
+		return -ENOMEM;
 	cbd.length = cpu_to_le16(data_size);
 
 	dma = dma_map_single(&priv->si->pdev->dev, si_data,
 			     data_size, DMA_FROM_DEVICE);
 	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
 		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		kfree(si_data);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out;
 	}
 
 	cbd.addr[0] = lower_32_bits(dma);
@@ -513,12 +515,10 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		return -EINVAL;
+		goto out;
 
-	if (!enable) {
-		kfree(si_data);
-		return 0;
-	}
+	if (!enable)
+		goto out;
 
 	/* Enable the entry overwrite again incase space flushed by hardware */
 	memset(&cbd, 0, sizeof(cbd));
@@ -563,6 +563,10 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	}
 
 	err = enetc_send_cmd(priv->si, &cbd);
+out:
+	if (!dma_mapping_error(&priv->si->pdev->dev, dma))
+		dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_FROM_DEVICE);
+
 	kfree(si_data);
 
 	return err;
-- 
2.33.0




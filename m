Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118934B373
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 09:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfFSH5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 03:57:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46027 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfFSH5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 03:57:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so2189937wre.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 00:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bokJRGcKnRg+lYalbUGR/zo7jSchbb9EpVxMeRfuJ+8=;
        b=G5fWNCRWNQVLQQBBasOMOCRIYXNe9mzu+YNFWyVwekahl/pQY7vkvSCJNHB0ItWPE8
         J+HGhdTdp7I0rhWks5uk2bEYvBAIMKHNf5AC9Ahf+GnUX2EQ1P6ihKbAtx86p5jG8O9U
         NLd3kIelXNASuZnE0HZ1cgfnReAXL0hJQKY2wpn74bP0fOrf0LKrHSsYa2zpzKMKeCpS
         oI0ErGkALcdNuHzvIZtAk4I2rBUT6GzN/35yNcc06vnFo5LbmUO9aiWyptN4sqvH9j5M
         y2bUvIbH8xgbbcMPwpAH38GYx4HKdH1DvhlWsx6Q/xJMi8h6WVMsW6VuCsQTPQ13driU
         bDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bokJRGcKnRg+lYalbUGR/zo7jSchbb9EpVxMeRfuJ+8=;
        b=l0Oy4sA12lrCfYubyEGl2FahCGzcJVQM7sC4R82HMNrdJlp9GpQFx38HcCQx7VbNL3
         kfpcmhX9F59pQ5vmHMU1BdhmncCIyat5PW9hXmTpPmBR7mEQRMiXR/W4Z1nI8F5VFVb1
         nzq8AUpKnH2kNB+4+4Mx9TLg1V8B5M8zxduAZDNcAslS15zWQnWT4uy67C0qSMUJN2/E
         R1tBKskUf+szC/jPrAJxhrymMU0mV3jjB/cv5r0AIthhVTjN4HCZN6/eLaKXLw2W6Prn
         b2R2ehJ0x8/FYb+AH8aCHTcnS3g8rLnZtqOcrn16/c+ZTXPX1EIkVsm3ldLGcZv6FBdv
         /Euw==
X-Gm-Message-State: APjAAAWX+W3UNVBzRkO3i+Fyi32HPExluAE1lifpCIVpZmiLInKk6ElQ
        N/rNZTLLR94EfuYpd0/Gz7rfIw==
X-Google-Smtp-Source: APXvYqy+AUKf0noxBF3WuIgqgBrSPz8Xauheg6Eo76TspViLXEpHlPHvuuxLDHIkiSOcT81i5nuQ6w==
X-Received: by 2002:adf:e446:: with SMTP id t6mr73214471wrm.115.1560931038107;
        Wed, 19 Jun 2019 00:57:18 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id y133sm842572wmg.5.2019.06.19.00.57.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Jun 2019 00:57:17 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     jaswinder.singh@linaro.org
Cc:     netdev@vger.kernel.org, ard.biesheuvel@linaro.org,
        masahisa.kojima@linaro.org, davem@davemloft.net,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH 1/2] net: netsec: initialize tx ring on ndo_open
Date:   Wed, 19 Jun 2019 10:57:13 +0300
Message-Id: <1560931034-6810-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we changed the Tx ring handling and now depend not bit31 to figure
out the owner of the descriptor, we should initialize this every time
the device goes down-up instead of doing it once on driver init. If the
value is not correctly initialized the device won't have any available
descriptors

Fixes: 35e07d23473972b8876f98bcfc631ebcf779e870 ("net: socionext: remove mmio reads on Tx")

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 32 ++++++++++++++-----------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index cba5881b2746..a10ef700f16d 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1029,7 +1029,6 @@ static void netsec_free_dring(struct netsec_priv *priv, int id)
 static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[id];
-	int i;
 
 	dring->vaddr = dma_alloc_coherent(priv->dev, DESC_SZ * DESC_NUM,
 					  &dring->desc_dma, GFP_KERNEL);
@@ -1040,19 +1039,6 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 	if (!dring->desc)
 		goto err;
 
-	if (id == NETSEC_RING_TX) {
-		for (i = 0; i < DESC_NUM; i++) {
-			struct netsec_de *de;
-
-			de = dring->vaddr + (DESC_SZ * i);
-			/* de->attr is not going to be accessed by the NIC
-			 * until netsec_set_tx_de() is called.
-			 * No need for a dma_wmb() here
-			 */
-			de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
-		}
-	}
-
 	return 0;
 err:
 	netsec_free_dring(priv, id);
@@ -1060,6 +1046,23 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 	return -ENOMEM;
 }
 
+static void netsec_setup_tx_dring(struct netsec_priv *priv)
+{
+	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
+	int i;
+
+	for (i = 0; i < DESC_NUM; i++) {
+		struct netsec_de *de;
+
+		de = dring->vaddr + (DESC_SZ * i);
+		/* de->attr is not going to be accessed by the NIC
+		 * until netsec_set_tx_de() is called.
+		 * No need for a dma_wmb() here
+		 */
+		de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
+	}
+}
+
 static int netsec_setup_rx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
@@ -1361,6 +1364,7 @@ static int netsec_netdev_open(struct net_device *ndev)
 
 	pm_runtime_get_sync(priv->dev);
 
+	netsec_setup_tx_dring(priv);
 	ret = netsec_setup_rx_dring(priv);
 	if (ret) {
 		netif_err(priv, probe, priv->ndev,
-- 
2.20.1


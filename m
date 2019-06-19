Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8CD4B5D7
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 12:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfFSKEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 06:04:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45174 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfFSKEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 06:04:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so2647814wre.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 03:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=+U8s5zjt+68t+3zrCJ60IzWHDPnf4eGmiq3HaOOcocs=;
        b=O4di6ByusizFJY+7WsmOchdwPMJatZzJZ/jaARxHWoSFDxSZMN0Ja6Ay0hxion8TTU
         MyLlnHVkOpW+6IjrAaivprSFe8h4NW07NUmpiLNS7qO9vVQVYh9LMw4FcUKe1wVflhjJ
         akWSXc/DvfWbfiX1firsXTTXuYft4AlwQoYv2YuZD4P7ZEZ4mUdJTu9bfVphcc1FZppj
         v/XvVm+JYY/PvePpy7YIMD3/5+BoXd+VIfhm42xGAUczBQujiAOBDZ48IM4Qa7ei35dn
         uc89YjbQj8KgMbMZRrSpRY3TSV+ock9xHDj3RyZoP/S5CWSz8y79jv/h7HlmI7ObaSIC
         mQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+U8s5zjt+68t+3zrCJ60IzWHDPnf4eGmiq3HaOOcocs=;
        b=iqLYzVBFvcbfjw1ylF81twd8hbIwtaMkTv/WaDJT60CFfqf+OIjYxkRwFAoF5vt8tz
         1ww/PvN/b8wvkkHfoyw1bwxKtyiT6DmZgEnRHG8RZ2ZlWY0A6uiz0K5kDcx89QbQjza8
         /Fc5+RV433S3SMx+ZVgEx7HKZ3Fn6LxZ0fuwpl1pNrPjng9fS/MAr5WlMhKesbkzkSb2
         3v1lbi3RSVSnHMGMj0J3d1rAoQbYzYE5DAzGyOBvAkEdVMsa0MNGxAPmlsyqUXgLfVUE
         9CoEVISi5vN3sviRwFN2cu7DrNc5itwKdGNOEzUJRT3Rf58UzfMK0u63KKDrQz9jzVbJ
         ++NA==
X-Gm-Message-State: APjAAAWtOKyA2803NVZgvjIqi/53KccErSXRl0OHqZdTaOvsPnAvACk6
        Y8m6qElDzQzxQ4slyt1mGs7jRA==
X-Google-Smtp-Source: APXvYqxgTZHgMoM5sNNB9xneA68OjGf8xNd9nZyfkFgoXvtRSxV54wvhd5fjWW65DVd4/o1QDwA/eA==
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr23299018wrk.121.1560938644712;
        Wed, 19 Jun 2019 03:04:04 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id y184sm1197729wmg.14.2019.06.19.03.04.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Jun 2019 03:04:03 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     jaswinder.singh@linaro.org
Cc:     netdev@vger.kernel.org, ard.biesheuvel@linaro.org,
        masahisa.kojima@linaro.org, davem@davemloft.net,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH 1/2, v2] net: netsec: initialize tx ring on ndo_open
Date:   Wed, 19 Jun 2019 13:04:00 +0300
Message-Id: <1560938641-16778-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we changed the Tx ring handling and now depends on bit31 to figure
out the owner of the descriptor, we should initialize this every time
the device goes down-up instead of doing it once on driver init. If the
value is not correctly initialized the device won't have any available
descriptors

Changes since v1:
- Typo fixes

Fixes: 35e07d234739 ("net: socionext: remove mmio reads on Tx")

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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


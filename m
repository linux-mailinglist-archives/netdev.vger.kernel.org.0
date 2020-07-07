Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9138F216D94
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 15:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGGNTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 09:19:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35571 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGNTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 09:19:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so44996334wmf.0;
        Tue, 07 Jul 2020 06:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5u45MFZ0AunWhEh+z5x9xG0AnMJE7Wt+xXaTtLLZ//c=;
        b=riZFf+BJT/6uzNNjdrTK68fBoGBnSOC4xLp73XfQvabTrvZic1Tft4w8qcfAp3VFfJ
         jSGPjIAQWSNuymaObynZcjRpjL7Op8NQrHVjhW59xCyRMla3RBU5WqHBiDYbfsZZH5hs
         Pex26R844VzLLIzhOPk6AIUFBsk+/dS0jb7+J3I0Atfug3+04m81xI937P40aRuGAXtG
         2o366CvjUrM4G/njirQ8uOFR7b4AMj6YXybDiAnfW5SEnBPQ88zmoP2z/ySJrBuzLl6m
         kT4T06mwfzdaeJptV1qbdyFCKAaeVZFP8URKSerUPkwxEdb7xIYgu4SNJ6EN4ZN3gh8a
         SZfA==
X-Gm-Message-State: AOAM532RG3qM/a9o2SzKckoK8Te9jLD8nNpZ66/5f/iI7G8YbFn+VH4R
        jGbDdhZMRjFnNML0fVLpgk0TNl6SBbQ=
X-Google-Smtp-Source: ABdhPJwkkybRoMT8mNHguvJgI3WP5sr2m/kWHkwpImvFTVNrdz45GXI6h0sCr9GC3XqtFNl3+/Widw==
X-Received: by 2002:a1c:19c5:: with SMTP id 188mr4077694wmz.124.1594127961410;
        Tue, 07 Jul 2020 06:19:21 -0700 (PDT)
Received: from msft-t490s.lan (93-38-127-70.ip70.fastwebnet.it. [93.38.127.70])
        by smtp.gmail.com with ESMTPSA id o21sm1067067wmh.18.2020.07.07.06.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:19:20 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>,
        linux-kernel@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] mvpp2: fix pointer check
Date:   Tue,  7 Jul 2020 15:19:13 +0200
Message-Id: <20200707131913.25534-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

priv->page_pool is an array, so comparing against it will always return true.
Do a meaningful check by checking priv->page_pool[0] instead.
While at it, clear the page_pool pointers on deallocation, or when an
allocation error happens during init.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: c2d6fe6163de ("mvpp2: XDP TX support")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d8e238ed533e..6a3f356640a0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -548,8 +548,10 @@ static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 	val |= MVPP2_BM_STOP_MASK;
 	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
 
-	if (priv->percpu_pools)
+	if (priv->percpu_pools) {
 		page_pool_destroy(priv->page_pool[bm_pool->id]);
+		priv->page_pool[bm_pool->id] = NULL;
+	}
 
 	dma_free_coherent(dev, bm_pool->size_bytes,
 			  bm_pool->virt_addr,
@@ -609,8 +611,15 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 						       mvpp2_pools[pn].buf_num,
 						       mvpp2_pools[pn].pkt_size,
 						       dma_dir);
-			if (IS_ERR(priv->page_pool[i]))
+			if (IS_ERR(priv->page_pool[i])) {
+				int j;
+
+				for (j = 0; j < i; j++) {
+					page_pool_destroy(priv->page_pool[j]);
+					priv->page_pool[j] = NULL;
+				}
 				return PTR_ERR(priv->page_pool[i]);
+			}
 		}
 	}
 
@@ -4486,7 +4495,7 @@ static int mvpp2_check_pagepool_dma(struct mvpp2_port *port)
 	if (!priv->percpu_pools)
 		return err;
 
-	if (!priv->page_pool)
+	if (!priv->page_pool[0])
 		return -ENOMEM;
 
 	for (i = 0; i < priv->port_count; i++) {
-- 
2.26.2


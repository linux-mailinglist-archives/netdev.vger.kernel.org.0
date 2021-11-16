Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5745357E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbhKPPUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237778AbhKPPUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:20:15 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4618DC061570;
        Tue, 16 Nov 2021 07:17:18 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id z34so54111073lfu.8;
        Tue, 16 Nov 2021 07:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WcoJy80pB25ieScn7Lo5XNT/vxhf72hZpDaOFdShM24=;
        b=cehjgrQ04ABWjjl09/yx2ATVh91dBPRAHe6rqkzWa4CSlIQPQDwFx7PMoZNxUcdj5U
         Manxn0EpdBMVxP4jDietXGoDplKe7847slUL9jQHlreSYdjN/yEHGDx83VuAmP4pxnd9
         HK+v6uNkYj4XIGvhfkJPvZqgEbsoh4xR04JsxThuJbwXw2wV7mI7vTEtq4xaEWtISfCs
         IyDitnfeXGUbX5m7ITAbiYEGHT+CQbxxlBCcCiXzjAj+E3LwDzI0i1YgnRBiV8nlJA8c
         9cDrw6YuFfQhJihxjdqKR1GxybwXgwX8D53EQEUt4Alfv+ZTmmCRVfLGxh2T2/iDPN8d
         J5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WcoJy80pB25ieScn7Lo5XNT/vxhf72hZpDaOFdShM24=;
        b=eHU2ireD7lv9XXgUJGK/xyDL3aKAdoTjuRuE5dy8RWWHAzzL5UbaIE7uOfLzuVmNwj
         lK6LTG6eVSCSjD3wCUZGJl3psiIsX8zVmp7fsQf+O78ktf1LcO3DibaMsI9z+SZQ20h1
         cL4OMoHqrCUj3AwKNy2o9Uub2Fg/5n4MwekiWblben4DkpXQJh0BuhCVIzob7MXB0/RY
         P7XM2wZpB6GXNab5mAJ/3u7mLMW5zvC9iS+BxFNu1PwQIze9gAvtucUW+2D6feFRdrgD
         njo1HjVC7vjCQnhQZIMvHJQlaivRjUJir9mYMfX2cC5cVv9i9lV2ZC7uYR/FEECWdJOq
         +XYw==
X-Gm-Message-State: AOAM530w/BhbWMJLxzLeJiBIFzdShKQwE7Wd9opCAGgGExOOIwm+oFgI
        G/F42M/5mYw8OwPBg7xTPZw=
X-Google-Smtp-Source: ABdhPJxy0ozf+KtbGX++iM5WsPR27dld7nSBAWctEockkzGZMFb08QHpePq8XQjA3e87LCQEi045Rg==
X-Received: by 2002:ac2:53ad:: with SMTP id j13mr7049306lfh.225.1637075836596;
        Tue, 16 Nov 2021 07:17:16 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id w15sm1789484lfe.245.2021.11.16.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:17:16 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
Date:   Tue, 16 Nov 2021 18:17:12 +0300
Message-Id: <20211116151712.14338-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115080817.GE27562@kadam>
References: <20211115080817.GE27562@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Access to netdev after free_netdev() will cause use-after-free bug.
Move debug log before free_netdev() call to avoid it.

Fixes: 7472dd9f6499 ("staging: fsl-dpaa2/eth: Move print message")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	replaced Cc: stable with Fixes: tag

---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 714e961e7a77..6451c8383639 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4550,10 +4550,10 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	fsl_mc_portal_free(priv->mc_io);
 
-	free_netdev(net_dev);
-
 	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
 
+	free_netdev(net_dev);
+
 	return 0;
 }
 
-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A6D2FE3B2
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbhAUHR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbhAUHRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:17:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32344C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 23:17:01 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id j12so1031486pjy.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 23:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y/dz5Et4ByJct+mpQOK2piJi9Q0ePShfeuwSsga0D8s=;
        b=szb/zdbH+iKPWtls97uMYVSL6fDoEl7dgESJOrYTgDhFgyQv3bN3JZKoV4jAWbqOK7
         c1FJwW2vpZwitDb44QHLj1cMnqEhiWxoj4qF9harZjjnNeD1YUSUCfgHR+ckzmSsKudw
         GYSck9kcKuUHSNZNqEz2NzJzj6OKlTzfDydoHs4oSs3J0ankF9yDMIoNH/fc60wDQEoG
         aISf1t8PrMUWuDtV7HgUlAJrYCGWRMYW/P9/GNQ9rsAQbHz4JBDodZMKEf+0zJYldnaj
         oWDnJ1IljYTCq+rlBCJqDaCCHlobMniroqvr1pBcHbFcBO+rEz+MIJ5yVwe6JS7dcwRH
         L3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y/dz5Et4ByJct+mpQOK2piJi9Q0ePShfeuwSsga0D8s=;
        b=p9k4FmgtnCupdDQZV4ZxQyEWxondeI9LzWXsDDV33iPqpUpstmKIQRZTWAsHWieufN
         wq8+biWSgd3R6OBHe/z1qC/H2tV8swQrkVq8zUJjpbbuek84nl2H2HzbxZLR93YrWoQt
         eeB/Pg2Y5xGoDW6M/KdEXl2zg+GFPa7vQAUDCBYSqk5jToQ06UVMT0wfDCobxPH3LhZG
         5d5G6fACYjkyyJ7t8K/kFFIENXpteK+ygdgSB+pi554i1wyS15BTb9qetmp9eN5r4wVk
         3OJiyqSqqwxFCCJ1WdSYOPMzfkbpQreDJIyTuLlwfc4nG2Ku5cKYMOQhrxZeJfUl6QWF
         8nUg==
X-Gm-Message-State: AOAM531m5f5RAjmbYG6W3/Q+QR1jArV1wJQfNTvIQ9GisZGuFT+RQRac
        eP5fo+IS/0ia1kDeFNZixo0=
X-Google-Smtp-Source: ABdhPJz9hdRs/GtkLzYOdTU/t84Hs3e/4lv19nfS7Vzuhemu31MNkaWjjBQ3EFu2Lw0PqO3U+3Idmg==
X-Received: by 2002:a17:90a:9309:: with SMTP id p9mr10209090pjo.154.1611213420721;
        Wed, 20 Jan 2021 23:17:00 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id u12sm4170865pgi.91.2021.01.20.23.16.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Jan 2021 23:17:00 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>
Subject: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
Date:   Thu, 21 Jan 2021 15:09:06 +0800
Message-Id: <20210121070906.25380-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The octeontx2 hardware needs the buffer to be 128 byte aligned.
But in the current implementation of napi_alloc_frag(), it can't
guarantee the return address is 128 byte aligned even the request size
is a multiple of 128 bytes, so we have to request an extra 128 bytes and
use the PTR_ALIGN() to make sure that the buffer is aligned correctly.

Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers")
Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index bdfa2e293531..5ddedc3b754d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -488,10 +488,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
 	dma_addr_t iova;
 	u8 *buf;
 
-	buf = napi_alloc_frag(pool->rbsize);
+	buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
+	buf = PTR_ALIGN(buf, OTX2_ALIGN);
 	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D630F19A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhBDLHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbhBDLHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:07:37 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5EAC061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:06:57 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so1830506pgl.10
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 03:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzBEGVs7ShXuDuudJL55FJtZbtZ13P6PAznQ6B819Zs=;
        b=NvrYJt4cYzVPmvdcY65Wqd7/gTCtQGKApwC66eoftgcffwPOoLMYfKlsMt/UmCFzk1
         imya2h91ptbuWQeFh299/jSt+Sl7YlwFvw+0e0ZoQEQGz0vfeasUJCvVK2LY4Xj9LXm2
         h69Xb7cm997Q8qnZA7yZgDbH1wg+8eymMQ6ceuhUs3bdNtHC9cKUw64bGO8JVIn+xdIp
         TnfjcLX0Fe04JDQRu8oEhKs5NH8m7MrEzYbfOnx/yl1KmdbOOlNBpVHnBv77jBTJDKwr
         4qzkdyHQ5dkiRwvAFINZ0T5CxuhW78ZjXVp/EKJK11EQQHoEBq+dKzitR97swWlBIWl9
         S+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzBEGVs7ShXuDuudJL55FJtZbtZ13P6PAznQ6B819Zs=;
        b=CZ9aWjWQxtp/1x3r2HExXH3AWFCwnXWSAQ+8I1AVej/apWUEI55MzttosxW6cfovlq
         eXWAbAJakBaVD6QP2ePoEml1LUBeNAv+6p8r5AB2IA/wO7dZ3fo1bx5j8QUiSadNmbfx
         W2zXko9MU4HF7d3GU7hYChafWHENXok+X83czWV37zIhUDXMhMhyDasYYKkjLgkvcamG
         XL90+qHcs8jOvgcDVVNB0+z/byXdu+HWRI12Vs2oOVaSHrFtmYaDgQAIQunDEdKIO2xo
         e/rLrk6rzCdaool1m1YLF0S/4uK4LIOoditPzZ6eVEiDQrmWLB6FNw67jbvazTmQ9GjL
         HP+w==
X-Gm-Message-State: AOAM531H+TMLUmOH8Lt5Gld4CY2ayT70+2sRrpgqsYVfJBIORL70Msi+
        JudGQNJIQXruw/8SKsCA6W4=
X-Google-Smtp-Source: ABdhPJx6ie01JeK5jWxGkYMlNH5zUqdQO8xPZvsK3KFfwTKw+dh7B63pLQn0mLSzhxGc08O8Nfnn2g==
X-Received: by 2002:a62:800d:0:b029:1bc:9cd1:8ee1 with SMTP id j13-20020a62800d0000b02901bc9cd18ee1mr7673873pfd.69.1612436816640;
        Thu, 04 Feb 2021 03:06:56 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id y15sm5283351pju.20.2021.02.04.03.06.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 03:06:56 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [PATCH net-next v3 4/4] net: dpaa2: Use napi_alloc_frag_align() to avoid the memory waste
Date:   Thu,  4 Feb 2021 18:56:38 +0800
Message-Id: <20210204105638.1584-5-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210204105638.1584-1-haokexin@gmail.com>
References: <20210204105638.1584-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_alloc_frag_align() will guarantee that a correctly align
buffer address is returned. So use this function to simplify the buffer
alloc and avoid the unnecessary memory waste.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
v3: Add Reviewed-by from Ioana.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 41e225baf571..882b32a04f5e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -764,12 +764,11 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	/* Prepare the HW SGT structure */
 	sgt_buf_size = priv->tx_data_offset +
 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
-	sgt_buf = napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
+	sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
 	if (unlikely(!sgt_buf)) {
 		err = -ENOMEM;
 		goto sgt_buf_alloc_failed;
 	}
-	sgt_buf = PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
 	memset(sgt_buf, 0, sgt_buf_size);
 
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B213A30F199
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhBDLHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbhBDLH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:07:29 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D1AC06178A
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:06:48 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x23so397031pfn.6
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 03:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MpxBx7CFidjEvv2qNlKhDCm20O5t175GcwGcP4QIJDY=;
        b=krLkjUlMsjgJPggCxPNXbj6yWEVNtfwDGkfWvaGIqn9cPMtKQLqhb6CHl69LjCgfAd
         oZd0JerLfFLPzmcakW7/WZ0D6xrFGHDW8A/3nZlOmyjkre/uiNwsr7RItiPzQGWsiASp
         tJzEEGUaH/5TcKu32mHhE6Ne0LKCvUd9JXSt3tb1KSn/M1LAMiKaSTG020IVloGOg3JC
         aRIe/PAoK37yQO949gZi9h31kN6dq7XRIDnZWF/BradEQztHdaB+z0vmZQWxLRD39Zie
         MIvBHqFXpGziOzS/jCVhQjfWkZcanOPBzRMwtmQWF8VasSD2HIrF/r2neCi5iFewe1pC
         VGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MpxBx7CFidjEvv2qNlKhDCm20O5t175GcwGcP4QIJDY=;
        b=BDnMxq8VqazC8GRB1PdarLtsg8/yF9BRLXr1H/b9hS1lUAGcWObLZnonqUSc1+aFRa
         fR91v48Agvc4FUKDlZYvB7/UOqSXXXWBfeVg6ijzf+PsgvPHkEj7cvs2Hc1uFoRXzLk5
         E0FIahEnTepvdZN2khbkm3RtmEOndkrl2NzmvzyGdCkeYO/0iYeCu71dIR+CQVBQL5a8
         /QD6N9vl1RD86eq+unZ4i+PVVYN9l+MuZzgxRiWEQ1N+iIkEuvQQC9txXJouuI+Gp+V1
         /YULuwRqlDXtcnw1sLFucoHmzAvUkO2tvYd+XEAJ2WA4nZwQOinezEa4pYkIfi7hEtTS
         m04Q==
X-Gm-Message-State: AOAM531L6d6F4ni9lKDBzSAmDJXVtXdH8a6awhDApl7QzPJ8Q8mv+MOj
        kkbCyt7X1w9yoKMePCzbC3A=
X-Google-Smtp-Source: ABdhPJyWNxEw23YnZjMMzMzNbWoakj/41AQpCmR06mLqQ46q+dIDmZoAwydwG7AGkPjLxZGNcYxsRw==
X-Received: by 2002:a63:884a:: with SMTP id l71mr6529590pgd.75.1612436808390;
        Thu, 04 Feb 2021 03:06:48 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id y15sm5283351pju.20.2021.02.04.03.06.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 03:06:47 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>
Subject: [PATCH net-next v3 3/4] net: octeontx2: Use napi_alloc_frag_align() to avoid the memory waste
Date:   Thu,  4 Feb 2021 18:56:37 +0800
Message-Id: <20210204105638.1584-4-haokexin@gmail.com>
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
Tested-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
v3: Add Tested-by from Subbaraya.

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 5ddedc3b754d..cbd68fa9f1d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -488,11 +488,10 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
 	dma_addr_t iova;
 	u8 *buf;
 
-	buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
+	buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	buf = PTR_ALIGN(buf, OTX2_ALIGN);
 	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
-- 
2.29.2


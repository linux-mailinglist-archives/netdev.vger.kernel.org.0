Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3AC309B0C
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhAaH7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhAaHz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:55:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88656C0613D6
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:55:12 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id md11so8496379pjb.0
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s8BZjK3yyKd70r8rMjExXPdv17zezvJcgaVaU9wbfEs=;
        b=jsXPb6nzV+mCgEeEKCe1zY7l7PnTSQfJ/9DIpbLoOns7+tr5uQN0P8Vnj7162vwsnL
         VMfAM8p7nu+8byKGt98jxB0rrsi9bKvku3WRtVcpfscDg6Pr6++K+xdnCC5yY0X72j/x
         JYLNWIhk25ZlnZkX2ruYW7KBE54y+G2/Mrp5BsR0emuCaitd8UOHAWouhwJZJUhJtWNI
         ig7WE5VWzGYc4SaQoabbg9erCi/DxW2BhXkedGaVlZwGdQvYKM8qZ/bSsBjLNgjahrgo
         UDBYaFD7eoAQMQkK9PH/OQMHvkE8GixQ/pEYL9jqwNTLbSV8icjON5r7gnKbD1n6l/81
         Hvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s8BZjK3yyKd70r8rMjExXPdv17zezvJcgaVaU9wbfEs=;
        b=Z5Gh7qv0d0oZZuoKayXpyMVLBff3trKO+cTN+eiA5klAWrJQzz4N84qWDDv8ZwnFUp
         5IicHPlLjNvO8ldUOBap7O1O+Csqvs/41hwI7OJi38PEf5bovm6OFixYxx7h4E1oux6v
         7GPngqopHWp9WG+ds7TzPU0wTsk9fD1n6usqYf9vM+rJY2FWymyqbOJSDs1VZ5xLjQl2
         baD+trghhXVtB2cmd+DJHnbaXJWd34qmoXN94h5ytdUQC4eOM+51azF36B2Ar0q+qZvS
         ULGXcdZpn+ArDj1dEn9B3LLZPe6SEdiW509Wog1f3hmwp5PT7Kxae9U9tUVEETM9qDCS
         aVTw==
X-Gm-Message-State: AOAM532wYGzOCRgdEuIfQuxZh/RqgCkbrN2p27UjutR7RAdvrwyY+nX6
        /1e/qvUcwl99lYefZM3a6oY=
X-Google-Smtp-Source: ABdhPJzsER2j3ut5nyKv8clJ7ZChhAVNALxWHV70uV2V/iXGaStkHHMpcqUtmXREpq2ld2X819HLfw==
X-Received: by 2002:a17:90a:5403:: with SMTP id z3mr12096249pjh.198.1612079712116;
        Sat, 30 Jan 2021 23:55:12 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id h23sm13931290pgh.64.2021.01.30.23.55.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 23:55:11 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>
Subject: [PATCH net-next v2 3/4] net: octeontx2: Use napi_alloc_frag_align() to avoid the memory waste
Date:   Sun, 31 Jan 2021 15:44:25 +0800
Message-Id: <20210131074426.44154-4-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210131074426.44154-1-haokexin@gmail.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_alloc_frag_align() will guarantee that a correctly align
buffer address is returned. So use this function to simplify the buffer
alloc and avoid the unnecessary memory waste.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
v2: No change.

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


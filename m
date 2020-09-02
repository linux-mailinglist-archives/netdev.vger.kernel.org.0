Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A54A25B1C1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgIBQd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBQd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:33:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81355C061244;
        Wed,  2 Sep 2020 09:33:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so38892wmi.1;
        Wed, 02 Sep 2020 09:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2qvkwmqjjGM0RfjIplcORNd0dXrXenfHRoPeccCbQs=;
        b=KXdH0tcsr9jfN4LME7Eb84NGipaYEBMx/4+RmQdbyAVwvyGz/ShRyowlf6Rdyr4QnY
         vVfKBHD5FL98h2XvAsSRJUV5OGLUwMPORVwHuHnKVTMs3X92tIzDMTgILqiZU2thOles
         4k5n3Dnt08XLYzpEM8UPqnEKMBIKnsAfg5iws8ljUgmu4uW3gMxRXSAEuWnJQeDm4zL/
         9wYGwdrz1I2yOYuL5wDnhzjEbz4krFN6h7T1mRDD3raE33VIoMDm06b9btfnbDWhMFPu
         YwqeB0Dmb87GNBAoe5Of5Tt3/IVlz9W7dN943AgfxXxc5J0eyOHvutxymLEGcO1C3I0Y
         +2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2qvkwmqjjGM0RfjIplcORNd0dXrXenfHRoPeccCbQs=;
        b=eE6LzxVexLIXlCadXkkTuuZoaDT3wxup/ia9XGdmMAnw2jGK48cFlFCFhz8WZOmnbJ
         Mc6wquYN2Ae0+3TcXgC14LfY6bKjInHP9DPdxcoLCWaXrlkuEkEd1ZdH/pFo5mqxhbQm
         NylwZqG1PmVBB8x7CooRb8PCSpxMH466L1XgZWEtxOkiU0R36FgzpCA0HlH9AT4ArRnE
         zhs7NhknBDLfMV3QSzYDjAmAMZfYcia1rd5o3oOxhZpd3oBgJZdR9QLZJkUJqH0DPq/K
         oS8L43AdusOAnA3e8ik4F+nBqUKW82OJWmrR//WBxVgEAH/CSni/A1Mz+y3IvjChhZID
         ViiA==
X-Gm-Message-State: AOAM530l0qGXSDbiGUSpg1YX+Ab7qysIhIpx+CFwEt/TBbACwQAG1nvu
        S8662ymfokQtyV05Spr+wZaQMZ5g4v79wcVt
X-Google-Smtp-Source: ABdhPJyZP2b3PC6lr0p1xYM3weE5VehC7kVZPjSkxTsr3W781y4DnPLrA2RkZfLDCBDllx+SgK7vwA==
X-Received: by 2002:a1c:1f42:: with SMTP id f63mr1424093wmf.1.1599064404161;
        Wed, 02 Sep 2020 09:33:24 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id y6sm237545wrt.80.2020.09.02.09.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 09:33:23 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xsk: Free variable on error path
Date:   Wed,  2 Sep 2020 17:33:19 +0100
Message-Id: <20200902163319.345284-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xp_create_dma_map(), memory is allocated to dma_map->dma_pages, but
then dma_map is erroneously compared to NULL, rather than the member.
Fix this.

Addresses-Coverity: ("Dead code")
Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 net/xdp/xsk_buff_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 795d7c81c0ca..5b00bc5707f2 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -287,7 +287,7 @@ static struct xsk_dma_map *xp_create_dma_map(struct device *dev, struct net_devi
 		return NULL;
 
 	dma_map->dma_pages = kvcalloc(nr_pages, sizeof(*dma_map->dma_pages), GFP_KERNEL);
-	if (!dma_map) {
+	if (!dma_map->dma_pages) {
 		kfree(dma_map);
 		return NULL;
 	}
-- 
2.28.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC92FDC92
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbhATWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732565AbhATWFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:05:52 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E5BC061796
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:11 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n2so70843iom.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GEkZShmIoWIOHRSj/dMYdcTQJIFBlR5LmZuBGxQqt0o=;
        b=KGqxBRhWG0wQED0/oG28azKJHeU2ExraE2jLPSU6GHG05vMtlgk4Gmn2w8JmfNqATL
         gvmiDftAv2x5Si3uR/G9iHV7tXuEfPzG5EJEg8T9S5Iu4MJlUk0VfXCcmt4/V+bSMeGI
         NG3IAmA67S5jo3tKSp43Hf5+hsp4uyZ42jLQSR4x7wSECOXHqE78ZwOVUydn/BT/g0YS
         QJplMcQrQjW4Q1r1+A2r5D3KLeqZlpUriBZGJE3jAZbm0g3OQwR1HMg6ZTl32cjIpuwn
         28sdghpNDr1JpHHybKBPBwgm2ka36SPFxXA5xA0dYfSpA5snWcaY0yOPIvV7XvX92p/7
         6YtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GEkZShmIoWIOHRSj/dMYdcTQJIFBlR5LmZuBGxQqt0o=;
        b=RRJudVeBjfKf+zBfA+uAENAQeGc0Z7bqL0Ngj79zXQyOYAMZ9ywPg7OaoKUupiF1b3
         ocfwmejVR5lpT9vGeR9vxWn348zu+nllFcwelfPi9anFVIYqkgnnWYTkxInoqQ/dwilV
         2EVcpCGX4t5+IKHfewoOc1+/V8YForAyVuOuA3gMeOF7+JKww2v1v2CLxOqLl7K/ULCw
         nNFnxsnRPiiswSmqq/wmS4xLsxLFyLmTEjWyhVoarjGixDoWvz9BCs5Ruf0EIM3FefCS
         qjDP9b7swSZFgXxRGNInYaR80mucRe8JDMPA2Nh9DlLaOoemk6X76cpYnvhzXNMeO4bz
         PEKg==
X-Gm-Message-State: AOAM531bGc+acK9aGr9bZoYxfd2BqQfI9oPNBMF4+egtQDQOAXI81l9Z
        4B/czRg873rlhTfI6xmriN9Vcg==
X-Google-Smtp-Source: ABdhPJz2u+wj/uWyrtTZvNr4EsCAVe4GjHDztu5zONdati2xLCvfuJvsMzikKq8P6MFM2wNiFuQSmw==
X-Received: by 2002:a05:6638:164c:: with SMTP id a12mr9475468jat.128.1611180250424;
        Wed, 20 Jan 2021 14:04:10 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e5sm1651712ilu.27.2021.01.20.14.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:04:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: disable IEOB interrupts before clearing
Date:   Wed, 20 Jan 2021 16:04:01 -0600
Message-Id: <20210120220401.10713-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120220401.10713-1-elder@linaro.org>
References: <20210120220401.10713-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in gsi_isr_ieob(), event ring IEOB interrupts are disabled
one at a time.  The loop disables the IEOB interrupt for all event
rings represented in the event mask.  Instead, just disable them all
at once.

Disable them all *before* clearing the interrupt condition.  This
guarantees we'll schedule NAPI for each event once, before another
IEOB interrupt could be signaled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 59fc22347a257..8498326c43f40 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1205,6 +1205,7 @@ static void gsi_isr_ieob(struct gsi *gsi)
 	u32 event_mask;
 
 	event_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_OFFSET);
+	gsi_irq_ieob_disable(gsi, event_mask);
 	iowrite32(event_mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
 
 	while (event_mask) {
@@ -1212,7 +1213,6 @@ static void gsi_isr_ieob(struct gsi *gsi)
 
 		event_mask ^= BIT(evt_ring_id);
 
-		gsi_irq_ieob_disable_one(gsi, evt_ring_id);
 		napi_schedule(&gsi->evt_ring[evt_ring_id].channel->napi);
 	}
 }
-- 
2.20.1


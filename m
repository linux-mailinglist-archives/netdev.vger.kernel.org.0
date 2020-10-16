Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C1129016C
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 11:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405485AbgJPJOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 05:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394928AbgJPJOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 05:14:06 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EE1C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 02:14:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g12so1863704wrp.10
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zPgdfxITgs8gt0mAU1h7JDrovjf7QLszONGP3uJ2eg4=;
        b=R5cklrATR9NwvY6hFmZRvJAC2SbXGXbw8Ke7+uBrVCxuVvi9wn24cD620heKv3UQtN
         v5YD8saxTTZEasSCCtcdXCVkFEQltFaPq2XH0TR+6P9sH+upBCxr39WP4BUsZOONrRIG
         HoyCOiAXVuv6shH/NnZVkNiTEA8f/MDE+YWu0UzCy4aQavL8hwtfagb6qN2LSq6HBuq1
         axWJEOzMzGo3babQ8RB8Be9zvkNIeA3ZPTwhqKUK3HfTvbNkzC+B1iH6kTZTQOtsCnOZ
         EKYF6SkYbBdNhjPIn42Ji3jzKuu7iwGh258DhKXmhUTZwCTGtnQK5KNkc3mIXjXBBAh3
         Vgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zPgdfxITgs8gt0mAU1h7JDrovjf7QLszONGP3uJ2eg4=;
        b=XX8rboPcbb+9kTp1eTx2+ouBuXmW6hCHQlkFx8pdPZy4L8Iisd29PWkEDk4ppAD/7u
         +0qwU2/PR+H30FT2rhLfsuQeqI8pTpmPV4AWJmh+h+STfgkHAP1w0TqtHC8sGJR97otA
         GXRd5QFj7lcYY0dt4eLV+q+i0xzlwD9/D5FFRpFvBO3cdVorboD8+uCwNaQTH41q1HPf
         7eyA1shLRYQKtSFIdMtTUc/ML/xL+jW7vkQhB673w267z8ypBznF4cStCJjVRy1FVEx4
         WVFsXT8MhcLb7w/n1w/uMWO/iyhFssEsjBpr2jEy2Bn3nNF/S5AnCq6oD/CWAX564Ite
         kUWw==
X-Gm-Message-State: AOAM533Y+HFFZ8wYpWVvb85dt/Zy3mdBEooYDkrA6LMSKPZIr1FlKdXp
        eBLmq+zf9Nk2LNqAuK1Aq8LhFA==
X-Google-Smtp-Source: ABdhPJzXmMb80f4tr3J9Af6ZXwvKNaw5Niv1o89nrUvBcI3VNZQz0TtVQtToWNw3NQ1BtGRJxHK9og==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr2796657wrq.155.1602839644642;
        Fri, 16 Oct 2020 02:14:04 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id x4sm2751811wrt.93.2020.10.16.02.14.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2020 02:14:04 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, hemantk@codeaurora.org,
        manivannan.sadhasivam@linaro.org, eric.dumazet@gmail.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v6 1/2] bus: mhi: Add mhi_queue_is_full function
Date:   Fri, 16 Oct 2020 11:20:06 +0200
Message-Id: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function can be used by client driver to determine whether it's
possible to queue new elements in a channel ring.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v1->v5: This change is not part of the series
 v6: add this patch to the series

 drivers/bus/mhi/core/main.c | 15 +++++++++++++--
 include/linux/mhi.h         |  7 +++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index a588eac..44aa11f 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -943,8 +943,8 @@ void mhi_ctrl_ev_task(unsigned long data)
 	}
 }
 
-static bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
-			     struct mhi_ring *ring)
+static inline bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
+				    struct mhi_ring *ring)
 {
 	void *tmp = ring->wp + ring->el_size;
 
@@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
 }
 EXPORT_SYMBOL_GPL(mhi_queue_buf);
 
+bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
+					mhi_dev->ul_chan : mhi_dev->dl_chan;
+	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+
+	return mhi_is_ring_full(mhi_cntrl, tre_ring);
+}
+EXPORT_SYMBOL_GPL(mhi_queue_is_full);
+
 int mhi_send_cmd(struct mhi_controller *mhi_cntrl,
 		 struct mhi_chan *mhi_chan,
 		 enum mhi_cmd_type cmd)
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 9d67e75..f72c3a4 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -745,4 +745,11 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
 int mhi_queue_skb(struct mhi_device *mhi_dev, enum dma_data_direction dir,
 		  struct sk_buff *skb, size_t len, enum mhi_flags mflags);
 
+/**
+ * mhi_queue_is_full - Determine whether queueing new elements is possible
+ * @mhi_dev: Device associated with the channels
+ * @dir: DMA direction for the channel
+ */
+bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir);
+
 #endif /* _MHI_H_ */
-- 
2.7.4


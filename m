Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8172734619B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhCWOhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhCWOgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:36:36 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C918C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:36:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d191so11175686wmd.2
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6eJZQTDI0Y84I/lOWy3mMS42uiB5oEH6WMZ3z5nS0d0=;
        b=pHzR/7Z6eHA78L1BvgGTQiQAhJnvTDdjMWpPrwY555vA3/mWm4yfaRMlr8bNgsGM7m
         ak0EF5URxm+I/b+6ygzCzo72Zm1yKUO2JaXtLrAFS8ulshGks79KiUseLyorblp9TMUe
         v/ZJN/MHhgqx5Tz2Z2T94XkebPXOA81X338zhTplN2YidosZ2CUBJWw+UYiER84C7r5I
         cOIUQjhTgj77kWaqc4F6eS/A+I5kHNmQsKQV9og5lvWZpIlDvl4AQlOB3/jS0c4egayd
         4hORD7/JEj0GVRjYORTpN5fLWB5qYvRA1Q7Xsyyp53ramYBJkp4UifpEOB+uvCkahO5p
         P6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6eJZQTDI0Y84I/lOWy3mMS42uiB5oEH6WMZ3z5nS0d0=;
        b=MkLWXIAi7Qu2J9r4cB0nz12KmOGnuTv+/w4lUy9fBv5IUsg4blwXSsSJGYwrccFkNw
         U7SI7uJ7W3zrxe/XPmKZrUvfgruIwr8X6NFUAp+e+8xKmj+p1C7SD0cjJFFYS8JFuyGw
         VKadJTRQBUWg6g5K2Whq/LPFo/hi1vFnkErRK4UHeiHLFPLJL4tcmejG+YKnQBxzxTfy
         +ixV+1f3J0nCHJHiCN5W2JOGgsQ2bX6/Um4tUuFLYnCWIS3yIEooXm2G4NHHEZImk0AY
         vkVSkKE/q87kLuh4whpYsLmzPGiARQ2ZcVtO2epUNtlXm5MhZwijLHLPGUnplG5QK8s1
         PSNw==
X-Gm-Message-State: AOAM5311nQQ0OTHlZFBgKIuCAmHsH8xtxvWpnHlZnBOk16I0qJ9DZZnZ
        DgcjSK4eRkZf+NBZLelC03j8TeoICagEhh5c
X-Google-Smtp-Source: ABdhPJzNoG3ICgEl+qy/NAOtSyA43MMulRHArdsSZSew9OSOkFSE6cHs/90U97lyTvz51qACvI2hHA==
X-Received: by 2002:a05:600c:4f8e:: with SMTP id n14mr3761882wmq.34.1616510192858;
        Tue, 23 Mar 2021 07:36:32 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f09e:975c:f695:2be8])
        by smtp.gmail.com with ESMTPSA id f2sm23995886wrq.34.2021.03.23.07.36.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 07:36:32 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [RESEND PATCH net-next 1/2] net: mhi: Allow decoupled MTU/MRU
Date:   Tue, 23 Mar 2021 15:45:06 +0100
Message-Id: <1616510707-27210-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a maximum receive unit (MRU) size is specified, use it for RX
buffers allocation instead of the MTU.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi/mhi.h | 1 +
 drivers/net/mhi/net.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
index 12e7407..1d0c499 100644
--- a/drivers/net/mhi/mhi.h
+++ b/drivers/net/mhi/mhi.h
@@ -29,6 +29,7 @@ struct mhi_net_dev {
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 	int msg_enable;
+	unsigned int mru;
 };
 
 struct mhi_net_proto {
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index f599608..5ec7a29 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -265,10 +265,12 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 						      rx_refill.work);
 	struct net_device *ndev = mhi_netdev->ndev;
 	struct mhi_device *mdev = mhi_netdev->mdev;
-	int size = READ_ONCE(ndev->mtu);
 	struct sk_buff *skb;
+	unsigned int size;
 	int err;
 
+	size = mhi_netdev->mru ? mhi_netdev->mru : READ_ONCE(ndev->mtu);
+
 	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
 		skb = netdev_alloc_skb(ndev, size);
 		if (unlikely(!skb))
-- 
2.7.4


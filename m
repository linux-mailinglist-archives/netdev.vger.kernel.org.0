Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941D534D35B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhC2PKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhC2PJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:09:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAED5C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:09:52 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id d8-20020a1c1d080000b029010f15546281so8706793wmd.4
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+X/hKTZh40f/grnF7BdEW6HAu8wuo4fpxyd9sGXZx8Q=;
        b=QZ++iBuHwzRhONRzeQg8IMTGg8a14AW0TeGqUrA7MszWwzDoJ57k6eb7R4fuWfQFSi
         bbAdveCnnrh2RG76mVRgSCHHu2phUoqqLoxsuk3XZb2WGFA9f+40k15OajiNugSBg0YO
         NT/n+PaN3EXInGC12S1nYX2SSJuG2UzT830BV8msUV8LcI/zQOeIgM4B5WpAKYpgoVwn
         H8x4FFxzpcCyL9OUh/nbRqHU9GtHPdNz8KHGtGO/tLwMc6R9OLYOd4iKMOE6u3A6fAUL
         sSy5KttzX+zunsw2V0/917Md66Ej0rjnb90YmCBY14+2ykSc0ooc9Cb6z1F+GWS426xd
         1bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+X/hKTZh40f/grnF7BdEW6HAu8wuo4fpxyd9sGXZx8Q=;
        b=ihPGcTf7hJJlacfCOkFbjyc393fuvbKMk+CJkBKXpRTyqjd1nDqTbIbfKFmPEmksRL
         kjWsiTbQO6WRpfX7y4t64xF+znEJ9O35mDuVlaCPaoA7MIN0S8gdV0ZUmSVKd9FQb2M4
         Qe/oCUTssoZNFjflLwNVFkCcy3wwhcRiAXYsPt2KKi6FwUeO350YyIZZn8+SeiTf5XgI
         H+TJs63shFCDKemOchS0yW7iTP9m6a45NqqRBCiZNh2QWbKjkI3eS0dQinAwqAAQyAdN
         OL/pN7LY8uOtAxUeYYkE26nfAsuhJ24Yb9NrEeH4Tw1VjOMBj9dHeepD3+stvdXVeimF
         Khsw==
X-Gm-Message-State: AOAM532L6Ro9CfqSKmnkhvsdSmVb6FC9LhmL9LIgQg/pokql16XpBKx6
        5pK1Gz8So9MM3LViphDKE08Uqg==
X-Google-Smtp-Source: ABdhPJy0T6XDnznAN2UjgXNfvCBKvWgt1vbllvlB0/Y865atfoQUUnc5VnowkMsaerZIVHWt7ku3gw==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr25412470wmj.26.1617030591610;
        Mon, 29 Mar 2021 08:09:51 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:e89:f257:8111:afb6])
        by smtp.gmail.com with ESMTPSA id x11sm24963636wmi.3.2021.03.29.08.09.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 08:09:51 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 2/2] net: mhi: Allow decoupled MTU/MRU
Date:   Mon, 29 Mar 2021 17:18:25 +0200
Message-Id: <1617031105-3147-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617031105-3147-1-git-send-email-loic.poulain@linaro.org>
References: <1617031105-3147-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MBIM protocol makes the mhi network interface asymmetric, ingress data
received from MHI is MBIM protocol, possibly containing multiple
aggregated IP packets, while egress data received from network stack is
IP protocol.

This changes allows a 'protocol' to specify its own MRU, that when
specified is used to allocate MHI RX buffers (skb).

For MBIM, Set the default MTU to 1500, which is the usual network MTU
for WWAN IP packets, and MRU to 3.5K (for allocation efficiency),
allowing skb to fit in an usual 4K page (including padding,
skb_shared_info, ...).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: squashed 1/2 and 1/2 (decoupled mtu/mru + mbim mru)
     Reduced MRU from 32k to 3.5K

 drivers/net/mhi/mhi.h        |  1 +
 drivers/net/mhi/net.c        |  4 +++-
 drivers/net/mhi/proto_mbim.c | 11 +++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

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
index b1769fb..4bef7fe 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -270,10 +270,12 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
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
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index 10ffb97..a1df2f6 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -26,6 +26,15 @@
 
 #define MBIM_NDP16_SIGN_MASK 0x00ffffff
 
+/* Usual WWAN MTU */
+#define MHI_MBIM_DEFAULT_MTU 1500
+
+/* 3500 allows to optimize skb allocation, the skbs will basically fit in
+ * one 4K page. Large MBIM packets will simply be split over several MHI
+ * transfers and chained by the MHI net layer (zerocopy).
+ */
+#define MHI_MBIM_DEFAULT_MRU 3500
+
 struct mbim_context {
 	u16 rx_seq;
 	u16 tx_seq;
@@ -280,6 +289,8 @@ static int mbim_init(struct mhi_net_dev *mhi_netdev)
 		return -ENOMEM;
 
 	ndev->needed_headroom = sizeof(struct mbim_tx_hdr);
+	ndev->mtu = MHI_MBIM_DEFAULT_MTU;
+	mhi_netdev->mru = MHI_MBIM_DEFAULT_MRU;
 
 	return 0;
 }
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04A538F9C8
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 07:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhEYFFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 01:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhEYFFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 01:05:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA07C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 22:04:18 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d78so21784331pfd.10
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 22:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oIvpbLH3vlj7yRsFcULWrZNj7K6Hj3PQocr5h8sVMDc=;
        b=Oj87Uk/hlyWk+t72Bz10S8K7FSnks3icvU0+fn08+fGWS4h7ll82TotwGbZilHECd9
         It1jJabIz8GRRO7jmGtF2K4ajDiIAS4qx3UNbwoTCDDmixLg8x9xWLjsJZpXEjuzFRjw
         yd4/siRgf5jjqq7lPASL15Y3PVidXL/Iild2cn5ASht615+IOuL85hmZHfjRUtn+zgMs
         17Jv7dYx1iBdYK+YCtyxtGexufTlotuK2BzK7oIA0NcnVsCIwi+Sdx4AWmYn7V9qBfdl
         3yNpAVk5jjAc4t57Nl7xsqyHslllGPfBdo8ji5R7dYkIA0s0ZDRtK8vOxi8t915RQU6D
         3RPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oIvpbLH3vlj7yRsFcULWrZNj7K6Hj3PQocr5h8sVMDc=;
        b=ebDRGQceSVijO5WTx92xgPePvWYCeT8Vbr+VNH47z+CsvA+9yU2mfUgFos4ICNJZcT
         JTMSvI7fokHTvWdcjp5jyhHNFmQvFYj+V9Ew4Sum045XhdXXpu7Gjg6C/Dqg+Cejq0Fj
         eUFHaSf8yuo5jl+swmdb5TAXKCIwH61n1uq6jy4xm6ZEqTUZ0KSmnMxw6vXDyxsy2vuR
         W0c8K+zUskxd5J+l2TBlzMKj9o6No3ufuN0ax2qiN5lIjq6a3VzV1dTFOambYcNLHo2g
         vZO706Y6D0Cobelvca7siL1RyDDvO0cUL8io/nTxzqnVDjyxWcd3MUwEWqlufMSYcZXr
         /ruQ==
X-Gm-Message-State: AOAM530XXT55ZOggn/zJUxZlW1D10odf09qbqZ8v5Y6Qo6PuqLoT0wus
        bSFxgyF/GLNHvVbXXX3k4zPA
X-Google-Smtp-Source: ABdhPJzQH57ajIZiCS/nCe6OvrQluojFIylTt7cYgwqJsj0J3RkEEzWDxQqfdjWyIX2utqr0Re7JQA==
X-Received: by 2002:a62:7d82:0:b029:2de:2c39:c6a4 with SMTP id y124-20020a627d820000b02902de2c39c6a4mr28766004pfc.75.1621919058291;
        Mon, 24 May 2021 22:04:18 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id t23sm6160579pjt.45.2021.05.24.22.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 22:04:17 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-net: Add validation for used length
Date:   Tue, 25 May 2021 12:58:38 +0800
Message-Id: <20210525045838.1137-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds validation for used length (might come
from an untrusted device) to avoid data corruption
or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c4711e23af88..2dcdc1a3c7e8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -668,6 +668,13 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		void *orig_data;
 		u32 act;
 
+		if (unlikely(len > GOOD_PACKET_LEN)) {
+			pr_debug("%s: rx error: len %u exceeds max size %lu\n",
+				 dev->name, len, GOOD_PACKET_LEN);
+			dev->stats.rx_length_errors++;
+			goto err_xdp;
+		}
+
 		if (unlikely(hdr->hdr.gso_type))
 			goto err_xdp;
 
@@ -739,6 +746,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %lu\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		put_page(page);
+		return NULL;
+	}
+
 	skb = build_skb(buf, buflen);
 	if (!skb) {
 		put_page(page);
@@ -822,6 +837,13 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		void *data;
 		u32 act;
 
+		if (unlikely(len > truesize)) {
+			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+				 dev->name, len, (unsigned long)ctx);
+			dev->stats.rx_length_errors++;
+			goto err_xdp;
+		}
+
 		/* Transient failure which in theory could occur if
 		 * in-flight packets from before XDP was enabled reach
 		 * the receive path after XDP is loaded.
-- 
2.11.0


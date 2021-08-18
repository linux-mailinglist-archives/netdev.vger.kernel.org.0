Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E413F0A9B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhHRRzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhHRRzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:55:41 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75561C061796
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 10:55:05 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id t25so801322ljc.12
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDZPSj82vJSIqNRbjRn5ddf373T0TpM4lEOoyZlVBZQ=;
        b=gmyLLI7JXpGj/OVBAN+uSzWOdMfP5YgfaXsgxzkz64Wd+OYKX0wQXGC4jGag2WE7uY
         E8hA6Bemu37meaMUVtI6ps1/8pzZlwoGMjjoQ1HwzZPKh4p+YRSTqKhC2JWXFtYN2pZ/
         3tT5kqRRQdkRabE9aLIDVQ0njaXIiaSuvtBwo830lK9kZf0ZXWJGMYK3WgOS0A6NisxV
         AoDISwFNEovUT4P+kNpxPKbcunxMTHOUq/oo+R28Cyp2kIBycmoQ+/kyP6+ujRCMp9z2
         HWZrecThca/8NfhVX5ktgC+IyuNH20vloG9nP/IkJlW/COuF1n9z4/OeZare6qDrIWR2
         xVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDZPSj82vJSIqNRbjRn5ddf373T0TpM4lEOoyZlVBZQ=;
        b=Kgkpe021rJTT3TdhVih0c1kRjDuRrmu/zBOElthAaP/ALP5rnlXpJlFrr0euqwE/Qc
         EqvZ0H0tyVXuuZzyy7iwhiI5IgOxkQiIsTtRDxn4n2M2+1zqyvEg2NJLyftF1J7cU865
         3GYOQDGt+ZmuzrwbjkmOZ5f4bOeuXxYgly/9/VifRIQMePNK0wRN6uzAk2b9oJ2cDzl1
         qPsUx13AdchbBtkST6FtCJfuexBzsmPW2XGlZxVYJEOJN3et0ogQcu4yAn42cdUnzI6Q
         qWWRml5hodThC6gmQTlar1NXZ+Ef1MTLIenIyTjb0JiI5Xvnae7GeK3Fg/ybU9mTOlyO
         4GLA==
X-Gm-Message-State: AOAM532RJyFWMBuMciq0q84AdoOUNhmxgAS3+69rKkMmWCAUxmKTqRgv
        YGNaS7kz4+1e7nHYt56l5qL/UA==
X-Google-Smtp-Source: ABdhPJzgju0iGClDUhJIg1bfxppQKWWT8UaYgKfcmAPRfVZg8FN3K6bHCLVQKa9pnbW8D41Y9+GRVw==
X-Received: by 2002:a2e:a606:: with SMTP id v6mr8840863ljp.366.1629309303836;
        Wed, 18 Aug 2021 10:55:03 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id c5sm55820lji.67.2021.08.18.10.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:55:03 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] drivers/net/virtio_net: Fixed vheader to use v1.
Date:   Wed, 18 Aug 2021 20:54:38 +0300
Message-Id: <20210818175440.128691-2-andrew@daynix.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818175440.128691-1-andrew@daynix.com>
References: <20210818175440.128691-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header v1 provides additional info about RSS.
Added changes to computing proper header length.
In the next patches, the header may contain RSS hash info
for the hash population.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 56c3f8519093..85427b4f51bc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -240,13 +240,13 @@ struct virtnet_info {
 };
 
 struct padded_vnet_hdr {
-	struct virtio_net_hdr_mrg_rxbuf hdr;
+	struct virtio_net_hdr_v1_hash hdr;
 	/*
 	 * hdr is in a separate sg buffer, and data sg buffer shares same page
 	 * with this header sg. This padding makes next sg 16 byte aligned
 	 * after the header.
 	 */
-	char padding[4];
+	char padding[12];
 };
 
 static bool is_xdp_frame(void *ptr)
@@ -1258,7 +1258,7 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
 					  struct ewma_pkt_len *avg_pkt_len,
 					  unsigned int room)
 {
-	const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	const size_t hdr_len = ((struct virtnet_info *)(rq->vq->vdev->priv))->hdr_len;
 	unsigned int len;
 
 	if (room)
@@ -1642,7 +1642,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	int num_sg;
-	unsigned hdr_len = vi->hdr_len;
+	unsigned int hdr_len = vi->hdr_len;
 	bool can_push;
 
 	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
@@ -2819,7 +2819,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
  */
 static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
 {
-	const unsigned int hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	const unsigned int hdr_len = vi->hdr_len;
 	unsigned int rq_size = virtqueue_get_vring_size(vq);
 	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
 	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;
-- 
2.31.1


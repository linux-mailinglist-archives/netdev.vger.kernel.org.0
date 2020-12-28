Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BB62E6751
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633317AbgL1QX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441017AbgL1QXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:23:21 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2906C061798
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:40 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id h4so9222957qkk.4
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uPsSfUcgHKgBzIXc3fN7YUqB8K9nJMunTZsde3ErHn4=;
        b=Xf0U70enwHW9IE8UGZVUnVIVEA0/1QMa+Unw2Hvs5voiItNagr8wOqb3rTN6qtLyyM
         2ADTZISRtDDTotVM/uwXgEPL23oP1/cusS33uE6wGl8QeZwRQ+3+JYlWuZb/zWAesI3m
         7JfTQsiGGjhJIAqky4jzDVjlH1LoiEPLMvBLOGDiA2GWIV73XXw1pMnkufdYO6/wdk8Y
         qTPP9EorAaSNWuEhFKTcqkzidcQjWghsBc+WxyVA9O7ZUwvCJ1EIxyMSnJT5AJB+lARJ
         4fq4yhWzH4y55tOWWNCjYFb6e0WCSqMHlb4GrIIbfgcqGBKfuYkK1kjW8BmsElawttUB
         k7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uPsSfUcgHKgBzIXc3fN7YUqB8K9nJMunTZsde3ErHn4=;
        b=hq97Z0YfWlH0rcxw1l2sG+JYuLW3LFq813j/9+NRa56ltg4QyilFbdtHI4jIdDzRIi
         ufDDcXMoo33mZeEoc9Ch1026z8xOuTQsXSTNFs9i4FEplKNvQowyZjrgRjGGCpiYYlY3
         acNydisOl4D++O+RKdQ9jOrtBWeHK3cxJVK0U3s9sy1PJqmBpuryF6khBz6VavLcHmiK
         hj1jY121sFy46T7JWPxtizz6iUa3ac5FFiGrGqZjAqjr8t+hCdMXlg/Qaz8eMWM4r25v
         jFfyFkgxPnUMcshGvN9N7xkOAmNVswuYlXS8j2GO26f4TV6TmjtrwJGNcRYRMf/GceKQ
         YXXA==
X-Gm-Message-State: AOAM531Dbj20R3fPVBCxSzHxs+OXSfzdnqAt/vi0h+dw/dap3Z3av391
        mnEohQlhMnp7gnXgAKZmXTQ=
X-Google-Smtp-Source: ABdhPJxplx0oHVIyDzXmxBVOqgqLZvlzZAjkoslvEhIVjuqNIZ1evoBz2Od6TWBfCKaXMkzVsnsl/g==
X-Received: by 2002:a37:8204:: with SMTP id e4mr40690939qkd.351.1609172560145;
        Mon, 28 Dec 2020 08:22:40 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id u65sm24005556qkb.58.2020.12.28.08.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 08:22:39 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH rfc 3/3] virtio-net: support transmit timestamp
Date:   Mon, 28 Dec 2020 11:22:33 -0500
Message-Id: <20201228162233.2032571-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Add optional delivery time (SO_TXTIME) offload for virtio-net.

The Linux TCP/IP stack tries to avoid bursty transmission and network
congestion through pacing: computing an skb delivery time based on
congestion information. Userspace protocol implementations can achieve
the same with SO_TXTIME. This may also reduce scheduling jitter and
improve RTT estimation.

Pacing can be implemented in ETF or FQ qdiscs or offloaded to NIC
hardware. Allow guests to offload for the same reasons.

The timestamp straddles (virtual) hardware domains. Like PTP, use
international atomic time (CLOCK_TAI) as global clock base. It is
guest responsibility to sync with host, e.g., through kvm-clock.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c        | 24 +++++++++++++++++-------
 include/uapi/linux/virtio_net.h |  1 +
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 57744bb6a141..d40be688aed0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -207,6 +207,9 @@ struct virtnet_info {
 	/* Host will pass CLOCK_TAI receive time to the guest */
 	bool has_rx_tstamp;
 
+	/* Guest will pass CLOCK_TAI delivery time to the host */
+	bool has_tx_tstamp;
+
 	/* Has control virtqueue */
 	bool has_cvq;
 
@@ -1550,7 +1553,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
-	struct virtio_net_hdr_v1_hash *ht;
+	struct virtio_net_hdr_v12 *h12;
 	int num_sg;
 	unsigned hdr_len = vi->hdr_len;
 	bool can_push;
@@ -1575,13 +1578,15 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
 
-	ht = (void *)hdr;
+	h12 = (void *)hdr;
 	if (vi->has_tx_hash) {
-		ht->hash_value = cpu_to_virtio32(vi->vdev, skb->hash);
-		ht->hash_report = skb->l4_hash ? VIRTIO_NET_HASH_REPORT_L4 :
-						 VIRTIO_NET_HASH_REPORT_OTHER;
-		ht->hash_state = VIRTIO_NET_HASH_STATE_DEFAULT;
+		h12->hash.value = cpu_to_virtio32(vi->vdev, skb->hash);
+		h12->hash.report = skb->l4_hash ? VIRTIO_NET_HASH_REPORT_L4 :
+						  VIRTIO_NET_HASH_REPORT_OTHER;
+		h12->hash.flow_state = VIRTIO_NET_HASH_STATE_DEFAULT;
 	}
+	if (vi->has_tx_tstamp)
+		h12->tstamp = cpu_to_virtio64(vi->vdev, skb->tstamp);
 
 	sg_init_table(sq->sg, skb_shinfo(skb)->nr_frags + (can_push ? 1 : 2));
 	if (can_push) {
@@ -3089,6 +3094,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 		vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
 	}
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_TX_TSTAMP)) {
+		vi->has_tx_tstamp = true;
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
 	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->any_header_sg = true;
@@ -3279,7 +3289,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
+	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP, VIRTIO_NET_F_TX_TSTAMP
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 0ffe2eeebd4a..da017a47791d 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,7 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_TX_TSTAMP	  54	/* Guest sets TAI delivery time */
 #define VIRTIO_NET_F_RX_TSTAMP	  55	/* Host sends TAI receive time */
 #define VIRTIO_NET_F_TX_HASH	  56	/* Guest sends hash report */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
-- 
2.29.2.729.g45daf8777d-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56188313E45
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhBHS6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbhBHS5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:57:19 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208CBC061793
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:56:03 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id r77so15475271qka.12
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 10:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3J632UJbPXnW5jI7wLWLk7WvFrwdIcMwbkqpeY3vEL0=;
        b=Hoeu2zQdI95fmHYt1Fbz/whuJT9ICgJQ4y2smIelFESDm8DEs611ZSYNwf07OvRVEX
         q4iGtBQ6lEoS177Lu/di72pvOwyjmg62sTw9yC08S9HI5XIUmNPTLlnvo1P6SF2oI5To
         HfDmNI9Twgyv+v+vi8HrWiGqf4mV8sp6LP1ekPArBPefX//UduLN9wZCd8HBKJqrkH74
         8MONE6165vfthDl/SpTP9D8FOuh24U5HtlrcUbFItepW9EOPnVbPBU5/tEMvWLRmmNvk
         zVtBjKDMg1ocZ7Mv98jOqMHMS6lUGOeSf04a4N8S3aYPwuGlMqxrqFr+Hq8nJfVKbJGL
         6+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3J632UJbPXnW5jI7wLWLk7WvFrwdIcMwbkqpeY3vEL0=;
        b=IuWlJIaofsn+y13yx/2/ANs90O7GJmmRvvlvPQPx3xKp5DyRcMxrWHvfwWKUmOi8Dd
         IjSmheXE3UZAwGxZOrPHyqnWG/Y2VnydgGIGsD5yoA7rqs54Sx4ga2L2Z2JjnGcWXFEr
         tL/6VdJhl+EpTH+rDcLF6MCUu8kCGzjTCI6P8/SceTVqdQ4x/vyxAoBMANiRQucOyglJ
         X4fQv1K3m4NcukHMvhaDxC9M0/fmaNrK9Zf5Xi49++dB5EG1hifiDdEZZdEsEUBp/mFK
         q9ovst1P+h8TDe76CdyP8l8B5zr33+b/BEPnHob1owKWiHRP9wNe077gr+WTSZ8W9chM
         oqBA==
X-Gm-Message-State: AOAM5313e+0gLcKemM9uBhqh7rMh0Ua0kgouQLIfkwURE+oqa8BnTuwK
        hMi2+X6d9Jmn0WItpuxiU6A=
X-Google-Smtp-Source: ABdhPJxtmh1c+353FOHWeHvBtBodf+fk30pSohJV/0pPlUJ59vA/v8TDJKFt/PU9z5CWg8UXQ9WDIQ==
X-Received: by 2002:a37:434c:: with SMTP id q73mr18683570qka.170.1612810562384;
        Mon, 08 Feb 2021 10:56:02 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f109:45d3:805f:3b83])
        by smtp.gmail.com with ESMTPSA id q25sm17370744qkq.32.2021.02.08.10.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 10:56:01 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        richardcochran@gmail.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC v2 1/4] virtio-net: support transmit hash report
Date:   Mon,  8 Feb 2021 13:55:55 -0500
Message-Id: <20210208185558.995292-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
In-Reply-To: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Virtio-net supports sharing the flow hash from device to driver on rx.
Do the same in the other direction for robust routing and telemetry.

Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
and updates this field on error with sk_rethink_txhash. Allow the host
stack to do the same.

Concrete examples of error conditions that are resolved are
mentioned in the commits that add sk_rethink_txhash calls. Such as
commit 7788174e8726 ("tcp: change IPv6 flow-label upon receiving
spurious retransmission").

Experimental results mirror what the theory suggests: where IPv6
FlowLabel is included in path selection (e.g., LAG/ECMP), flowlabel
rotation on TCP timeout avoids the vast majority of TCP disconnects
that would otherwise have occurred during link failures in long-haul
backbones, when an alternative path is available.

Rotation can be applied to various bad connection signals, such as
timeouts and spurious retransmissions. In aggregate, such flow level
signals can help locate network issues. Reserve field hash_state to
share this info. For now, always set VIRTIO_NET_HASH_STATE_DEFAULT.
Passing information between TCP stack and driver is future work.

Changes RFC->RFCv2
  - drop unused VIRTIO_NET_HASH_STATE_TIMEOUT_BIT
  - convert from cpu_to_virtioXX to cpu_to_leXX

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c        | 26 +++++++++++++++++++++++---
 include/uapi/linux/virtio_net.h |  9 ++++++++-
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e63792549..7f822b2a5205 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -201,6 +201,9 @@ struct virtnet_info {
 	/* Host will merge rx buffers for big packets (shake it! shake it!) */
 	bool mergeable_rx_bufs;
 
+	/* Driver will pass tx path info to the device */
+	bool has_tx_hash;
+
 	/* Has control virtqueue */
 	bool has_cvq;
 
@@ -394,9 +397,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 	hdr_len = vi->hdr_len;
 	if (vi->mergeable_rx_bufs)
-		hdr_padded_len = sizeof(*hdr);
+		hdr_padded_len = max_t(unsigned int, hdr_len, sizeof(*hdr));
 	else
-		hdr_padded_len = sizeof(struct padded_vnet_hdr);
+		hdr_padded_len = ALIGN(hdr_len, 16);
 
 	/* hdr_valid means no XDP, so we can copy the vnet header */
 	if (hdr_valid)
@@ -1528,6 +1531,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct virtio_net_hdr_v1_hash *ht;
 	int num_sg;
 	unsigned hdr_len = vi->hdr_len;
 	bool can_push;
@@ -1552,6 +1556,16 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
 
+	ht = (void *)hdr;
+	if (vi->has_tx_hash) {
+		u16 report = skb->l4_hash ? VIRTIO_NET_HASH_REPORT_L4 :
+					    VIRTIO_NET_HASH_REPORT_OTHER;
+
+		ht->hash_value = cpu_to_le32(skb->hash);
+		ht->hash_report = cpu_to_le16(report);
+		ht->hash_state = cpu_to_le16(VIRTIO_NET_HASH_STATE_DEFAULT);
+	}
+
 	sg_init_table(sq->sg, skb_shinfo(skb)->nr_frags + (can_push ? 1 : 2));
 	if (can_push) {
 		__skb_push(skb, hdr_len);
@@ -3050,6 +3064,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 	else
 		vi->hdr_len = sizeof(struct virtio_net_hdr);
 
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_TX_HASH)) {
+		vi->has_tx_hash = true;
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
 	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->any_header_sg = true;
@@ -3240,7 +3259,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
-	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
+	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
+	VIRTIO_NET_F_TX_HASH
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f11..273d43c35f59 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,7 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_TX_HASH	  56	/* Driver sends hash report */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -170,8 +171,14 @@ struct virtio_net_hdr_v1_hash {
 #define VIRTIO_NET_HASH_REPORT_IPv6_EX         7
 #define VIRTIO_NET_HASH_REPORT_TCPv6_EX        8
 #define VIRTIO_NET_HASH_REPORT_UDPv6_EX        9
+#define VIRTIO_NET_HASH_REPORT_L4              10
+#define VIRTIO_NET_HASH_REPORT_OTHER           11
 	__le16 hash_report;
-	__le16 padding;
+	union {
+		__le16 padding;
+#define VIRTIO_NET_HASH_STATE_DEFAULT          0
+		__le16 hash_state;
+	};
 };
 
 #ifndef VIRTIO_NET_NO_LEGACY
-- 
2.30.0.478.g8a0d178c01-goog


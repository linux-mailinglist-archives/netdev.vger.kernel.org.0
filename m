Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F22E674F
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441026AbgL1QXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441018AbgL1QXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:23:19 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E4EC061793
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:39 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id bd6so5130330qvb.9
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E+P5deBgMfEMNVf0vB1e6Pyaa3lRUXorz/FFexYbRww=;
        b=p+sxNA67eY0qGzrr2ZW6sQAHd9YD0jBivT9ziHSrGJMTY4UrjK4ppFohD1CVbPCzxZ
         WI/Ex9/QF5cywFlBBJ5ZPgKp58cgSI9ffH5PbjMk7oHXQMoN2sJf5IB5eAjUSsdAwDDo
         u3KQTI2/2KRBWvhoP5wVuJk9Np8K0XSbe1H2kBEKYScpCUsfuJgusA+9dX9oOuYNbaIj
         Nuxnf9A/oCB3j61hFK7ONtm78MzDSFseEGs2GkUOuRiHAE8whBocmAoezYr7C/ln+ObI
         d3fySF12MrE0fO3LrJfOY8sxx2RM+u18qN/5D1mMcWdrgxccRHvpFFlp5VU3EKApVs4w
         CBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E+P5deBgMfEMNVf0vB1e6Pyaa3lRUXorz/FFexYbRww=;
        b=O3NcwfJcmLc8rmWwLNv80u4YtGU8qck0DPeP6jSKwWT4JA8Ytk3IA2o1DasaXF+MZS
         2ZNBA4Hl213VRB6qThKZu7AWPk4N2M9ek60QMgEp8l4BHv/rqZcqwHObbAElys+2Ld1D
         6I4UIDijZEa7yA4MXfBW8xnSS7fXPas+RZy8woYmr2Boj1yS3ykjTnebvCkd23+GqOp+
         dPIiY/QEBsBxEMzoRO8NbqWtyahu1zNdGWPZrRXBI8QkLeZTqSzQ28Oje7MufKxJ5Afa
         HQtRr/pzaMIaay1F7ryCxro3865EyizoKVDc7Wr+zVInJJpoMjtAJ5SENpYJ29/AYd7R
         WzRg==
X-Gm-Message-State: AOAM532kZQUtNGNPfxx+S/WHQoB5D75Tm6u4DOAPUBBJTBZpatBoGQ09
        QgblWXHDDvgv/FJ6OXpuSo0=
X-Google-Smtp-Source: ABdhPJyzCEi17L8Bqx+W7irotxFVqlBZ0ufvsoQmL1pqrzYK2d80AdgiRcapqv28GPFkJFMeEo0uMA==
X-Received: by 2002:a0c:fe90:: with SMTP id d16mr48310260qvs.13.1609172558271;
        Mon, 28 Dec 2020 08:22:38 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id u65sm24005556qkb.58.2020.12.28.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 08:22:37 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH rfc 1/3] virtio-net: support transmit hash report
Date:   Mon, 28 Dec 2020 11:22:31 -0500
Message-Id: <20201228162233.2032571-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Virtio-net supports sharing the flow hash from host to guest on rx.
Do the same on transmit, to allow the host to infer connection state
for more robust routing and telemetry.

Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
and updates these fields on error with sk_rethink_txhash. This feature
allows the host to make similar decisions.

Besides the raw hash, optionally also convey connection state for
this hash. Specifically, the hash rotates on transmit timeout. To
avoid having to keep a stateful table in the host to detect flow
changes, explicitly notify when a hash changed due to timeout.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c        | 24 +++++++++++++++++++++---
 include/uapi/linux/virtio_net.h | 10 +++++++++-
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..b917b7333928 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -201,6 +201,9 @@ struct virtnet_info {
 	/* Host will merge rx buffers for big packets (shake it! shake it!) */
 	bool mergeable_rx_bufs;
 
+	/* Guest will pass tx path info to the host */
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
@@ -1534,6 +1537,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct virtio_net_hdr_v1_hash *ht;
 	int num_sg;
 	unsigned hdr_len = vi->hdr_len;
 	bool can_push;
@@ -1558,6 +1562,14 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
 
+	ht = (void *)hdr;
+	if (vi->has_tx_hash) {
+		ht->hash_value = cpu_to_virtio32(vi->vdev, skb->hash);
+		ht->hash_report = skb->l4_hash ? VIRTIO_NET_HASH_REPORT_L4 :
+						 VIRTIO_NET_HASH_REPORT_OTHER;
+		ht->hash_state = VIRTIO_NET_HASH_STATE_DEFAULT;
+	}
+
 	sg_init_table(sq->sg, skb_shinfo(skb)->nr_frags + (can_push ? 1 : 2));
 	if (can_push) {
 		__skb_push(skb, hdr_len);
@@ -3054,6 +3066,11 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -3243,7 +3260,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
-	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
+	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
+	VIRTIO_NET_F_TX_HASH
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f11..f6881b5b77ee 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,7 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_TX_HASH	  56	/* Guest sends hash report */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -170,8 +171,15 @@ struct virtio_net_hdr_v1_hash {
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
+#define VIRTIO_NET_HASH_STATE_TIMEOUT_BIT      0x1
+		__le16 hash_state;
+	};
 };
 
 #ifndef VIRTIO_NET_NO_LEGACY
-- 
2.29.2.729.g45daf8777d-goog


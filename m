Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5302E6750
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633290AbgL1QXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440986AbgL1QXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:23:20 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D7AC061796
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:39 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id p5so5146192qvs.7
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vQsWqZSCnMr1x/EzF/kzhHSUUJGM29HYm08xu/2fjmE=;
        b=a7r3Z2CBMpz7h38KBUNrKg/8UT6W3Yw49Otjw8kRDRqEKPPT2nizEk67WHBHJwVcE6
         57nPbkaGZbWsPM0WCmfWG4zFe11Dh5BdAhO5sKi7rASiHegTjP47BBQ1Y83GlhqQbs/3
         lvRqNBJf1UK9H5ycT8FxGQAoX4uqT6qzXXvPL6UTcD4sgXm1XjT8FlcsHidRqBbx7F86
         PPCDWa8bnXz1GUqNrRN+m1nh43xoqE8MdOqkloYFkR7Tpy3KBI55xSk6HUEDFbcymYvi
         UvMDDR3eem5RXpPiw8Lf6JQxDEmgJ/mco0chJSsU6ZoHXCRNjqcIart4OKSJyveMho3k
         w49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vQsWqZSCnMr1x/EzF/kzhHSUUJGM29HYm08xu/2fjmE=;
        b=fsoUqR/BhN/p4+kBtExKfahiNFfi7JUc9UtCHJAGaMweMMtE4w10kCrmQRQigiKUOD
         5cqb1DmTlBAVuy7XW4oz7ZaZSiAkcCzgS3DVaBO1WILy2MWwNBvSryR9Xcv3xVll8w/m
         01ymXYNBvbCJhny0Cz3FnKcnfIVg0BfhzRzS4E7lUJW+BnKiW3bSZWgOe/qvpPZP6oYb
         ShDnljsGYyH2kWQvpZyQbHB1LlPqiKAS7z9R88pOTiELxFub9a8IqFsxmjn0txje0Fkj
         t4ghuTj6gVUvNRELlPm75vy3FJkgxLKbQ9CdlAcQoMufFQ79+3IQsiJ61Lm+eyUCPY6N
         33mQ==
X-Gm-Message-State: AOAM531W1LQ6GBWuxnUqI58GoXKc3pAYVX3QBZ2BJEi7Q3AvuX6uwUM0
        Q7GVylZ2rHwuylk4psAo/5Y=
X-Google-Smtp-Source: ABdhPJx3TAGUQMPRKMmT3Y9uUkxQtN1ZuRA6AKf8I+fo2yanHcrz4Nm9p6V5c4DvbopY8iekLMzsgw==
X-Received: by 2002:ad4:4108:: with SMTP id i8mr47649560qvp.49.1609172559222;
        Mon, 28 Dec 2020 08:22:39 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id u65sm24005556qkb.58.2020.12.28.08.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 08:22:38 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH rfc 2/3] virtio-net: support receive timestamp
Date:   Mon, 28 Dec 2020 11:22:32 -0500
Message-Id: <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Add optional PTP hardware timestamp offload for virtio-net.

Accurate RTT measurement requires timestamps close to the wire.
Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
virtio-net header is expanded with room for a timestamp. A host may
pass receive timestamps for all or some packets. A timestamp is valid
if non-zero.

The timestamp straddles (virtual) hardware domains. Like PTP, use
international atomic time (CLOCK_TAI) as global clock base. It is
guest responsibility to sync with host, e.g., through kvm-clock.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c        | 20 +++++++++++++++++++-
 include/uapi/linux/virtio_net.h | 12 ++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b917b7333928..57744bb6a141 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -204,6 +204,9 @@ struct virtnet_info {
 	/* Guest will pass tx path info to the host */
 	bool has_tx_hash;
 
+	/* Host will pass CLOCK_TAI receive time to the guest */
+	bool has_rx_tstamp;
+
 	/* Has control virtqueue */
 	bool has_cvq;
 
@@ -292,6 +295,13 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
 	return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
 }
 
+static inline struct virtio_net_hdr_v12 *skb_vnet_hdr_12(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct virtio_net_hdr_v12) > sizeof(skb->cb));
+
+	return (void *)skb->cb;
+}
+
 /*
  * private is used to chain pages for big packets, put the whole
  * most recent used list in the beginning for reuse
@@ -1082,6 +1092,9 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		goto frame_err;
 	}
 
+	if (vi->has_rx_tstamp)
+		skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(skb_vnet_hdr_12(skb)->tstamp);
+
 	skb_record_rx_queue(skb, vq2rxq(rq->vq));
 	skb->protocol = eth_type_trans(skb, dev);
 	pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
@@ -3071,6 +3084,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
 	}
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
+		vi->has_rx_tstamp = true;
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
 	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->any_header_sg = true;
@@ -3261,7 +3279,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_TX_HASH
+	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index f6881b5b77ee..0ffe2eeebd4a 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,7 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_RX_TSTAMP	  55	/* Host sends TAI receive time */
 #define VIRTIO_NET_F_TX_HASH	  56	/* Guest sends hash report */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
@@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
 	};
 };
 
+struct virtio_net_hdr_v12 {
+	struct virtio_net_hdr_v1 hdr;
+	struct {
+		__le32 value;
+		__le16 report;
+		__le16 flow_state;
+	} hash;
+	__virtio32 reserved;
+	__virtio64 tstamp;
+};
+
 #ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
  * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
-- 
2.29.2.729.g45daf8777d-goog


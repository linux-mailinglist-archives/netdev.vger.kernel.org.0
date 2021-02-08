Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65A313E4C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhBHS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbhBHS5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:57:21 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E06DC0617A7
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:56:07 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id l27so15474420qki.9
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 10:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V5SXxqRn9iChNkelA4Lz5t2Lq5FsheIFJl6lMmqNafs=;
        b=k1RlK0+rIiwKwfG+r9ciIyMYKAWET+IcMxexNzwQ+6z4uvYmVm0UL9tmzMKzLCn0r5
         MENfN1EXiEQTscopjRumoVdOW1lKWWj4fEVTwe2Hqrf9FD08Cp6diJio+rxvIxngxUCC
         m6pes9Awe+fNvUqENRRffwYQHGecfMZ4Qmn46xJvm+oFVCGJrZlnfHj9RLogA5D0ZQEz
         onLIh5gMZg5ENRcaSB5EcFMY0OIoMLlmgFhBl8NWczXYnHyCNPfiARsRf1wlTIXDs1rt
         CYuyUQgOa2xHtTfCgnCzjNDo1hiiLpBXscWeJQV5KOrUgPLho2xqhVhXRizC9D+VJMma
         cJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V5SXxqRn9iChNkelA4Lz5t2Lq5FsheIFJl6lMmqNafs=;
        b=Vo4Sph7PmKvsqJdN8O3HT37XEDm/B9giDTUrHMqc0ZAiK65Jee3dzhkkedCCBi2Pwb
         sXJL2XuZP/kIlZF0wfv7rW/v0AM/xFYjcfI3kJgBCrHn1wqlMG+dtCQuSahV9Ll/IX+X
         Puy1iY48P4YmOs5wC72fOGy8v8IaUFUZTp6dd60RkIKLyP2lUMbfmaey7552y9Pb2u7A
         12RQ9zLruwI+iYXvD96ftxap4S/px2z0YPnBRkdx3TkxlgFmssL8iIgGFECGlK2fxeOg
         HL27YM+BbOchebqJoKVtkt+88TzBJFoI6iS+WA3P0nRX7eWrqc5ysouFfkAXjgTTlFmd
         cgDg==
X-Gm-Message-State: AOAM533SJZ9UrRrEWG+8cHxzafu2FFpub6KyxZMN2Rx0Pn9UXbSgldkH
        bqp6yL7CeQVoxrb9GuTvh0+VN6dFVBQ=
X-Google-Smtp-Source: ABdhPJx2Vzz3BN3fufrvFs0gfLszLO304XiNcsw2UEPhzqYAxQtPHMyuALjvbbug6pZAp9GoEaItqw==
X-Received: by 2002:a05:620a:8dc:: with SMTP id z28mr1023748qkz.404.1612810566558;
        Mon, 08 Feb 2021 10:56:06 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f109:45d3:805f:3b83])
        by smtp.gmail.com with ESMTPSA id q25sm17370744qkq.32.2021.02.08.10.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 10:56:05 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        richardcochran@gmail.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC v2 4/4] virtio-net: support future packet transmit time
Date:   Mon,  8 Feb 2021 13:55:58 -0500
Message-Id: <20210208185558.995292-5-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
In-Reply-To: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Add optional transmit time (SO_TXTIME) offload for virtio-net.

The Linux TCP/IP stack tries to avoid bursty transmission and network
congestion through pacing: computing an skb delivery time based on
congestion information. Userspace protocol implementations can achieve
the same with SO_TXTIME. This may also reduce scheduling jitter and
improve RTT estimation.

Pacing can be implemented in ETF or FQ qdiscs or offloaded to NIC
hardware. Allow virtio-net driver to offload for the same reasons.

The timestamp straddles (virtual) hardware domains. Like PTP, use
international atomic time (CLOCK_TAI) as global clock base. The driver
must sync with the device, e.g., through kvm-clock.

Changes RFC - RFCv2
  - rename from transmit timestamp to future packet transmit time
  - convert cpu_to_virtioXX to cpu_to_leXX

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c        | 13 ++++++++++++-
 include/uapi/linux/virtio_net.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fc8ecd3a333a..c09d19b97f42 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -216,6 +216,9 @@ struct virtnet_info {
 	/* Device will pass tx timestamp. Requires has_tx_tstamp */
 	bool enable_tx_tstamp;
 
+	/* Driver will pass CLOCK_TAI delivery time to the device */
+	bool has_tx_time;
+
 	/* Has control virtqueue */
 	bool has_cvq;
 
@@ -1616,6 +1619,8 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	}
 	if (vi->enable_tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
 		ht->hdr.flags |= VIRTIO_NET_HDR_F_TSTAMP;
+	if (vi->has_tx_time && skb->tstamp)
+		ht->tstamp = cpu_to_le64(skb->tstamp);
 
 	sg_init_table(sq->sg, skb_shinfo(skb)->nr_frags + (can_push ? 1 : 2));
 	if (can_push) {
@@ -3221,6 +3226,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 		vi->hdr_len = sizeof(struct virtio_net_hdr_hash_ts);
 	}
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_TX_TIME)) {
+		vi->has_tx_time = true;
+		vi->hdr_len = sizeof(struct virtio_net_hdr_hash_ts);
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
 	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->any_header_sg = true;
@@ -3412,7 +3422,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP, VIRTIO_NET_F_TX_TSTAMP
+	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP, VIRTIO_NET_F_TX_TSTAMP, \
+	VIRTIO_NET_F_TX_TIME
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index b5d6f0c6cead..7ca99a2ee1a3 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,7 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_TX_TIME	  53	/* Driver sets TAI delivery time */
 #define VIRTIO_NET_F_TX_TSTAMP	  54	/* Device sends TAI transmit time */
 #define VIRTIO_NET_F_RX_TSTAMP	  55	/* Device sends TAI receive time */
 #define VIRTIO_NET_F_TX_HASH	  56	/* Driver sends hash report */
-- 
2.30.0.478.g8a0d178c01-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E87488C76
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbiAIVHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbiAIVHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:07:21 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E50C061757
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:07:20 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id s30so9674235lfo.7
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 13:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gPMwCL078ECJkrlQTrRDDMNXwBo1Y+lA8nTpGMji1Wg=;
        b=jxWccFhpO5rk3jHyiLzmvF/kyhq/XU78LlunysVItkpbWP+nNSO2rgRGekjjqsuWpv
         9BEcOCD0MdXnHrglMH+zDrU9LTjpcTvYCYhg3LBhRZgZxpgQE1/oRgkdjzXwFYXCyqRS
         fdsAKd59ou0LUqZNzK1+7hdpgbZmuOADY6Xziy7yWtdtcBKsiME4F3f6NdyEmjznmOIB
         jELoyra4mxTsQk69kfLiEUI0hpxImfazWWTWQugLqLoXHlLhQ6DFqe7OMjvUmwU+Zs35
         FKHTmf7sGZigM73fDkyzukEeGaGndMscOyP7Vrhyc0+Y20+Wt7+tIkpbCtm08dFz4S1V
         yleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gPMwCL078ECJkrlQTrRDDMNXwBo1Y+lA8nTpGMji1Wg=;
        b=QBPBFnb3J/U/BLonu7Wcvr7ZxRWJxFah3fglZhmtvo2fXGegjUvXARRJ+Dp4qIR6Cy
         uAWb3DxlEeFNY6t5F80GGEFZ3FJcfMdNmRZl6JDN9fjpIIJ/XEzLc3r6jPNBOKvE5nOq
         Ed5FNCI37U4u6Somha8cXjdrDZJmrpQPjZnm6DmcbZ5FXY/iLo4wcf4WEhGaJsfx82tN
         VklXg0YN+wNalQzGkd7gZX3ykKvEsYDjXVF6zuKlvvyHvhbiQyF4wdyEBYhGJgE15PX3
         X6PsZjcJDKT0CY1i/4JwRfGtjfkSlQvDVGZt6ehdeFBeT7KyO6u8P7JVDlFIheCD5ebU
         1tpg==
X-Gm-Message-State: AOAM531H68ww9U749zT6Rxxksw3RqUxggmZDaCsIOCmC021N+9UVBdtZ
        FYWpHDlvgUPBjNOKfE17i++7OyJIh3PtwKlo
X-Google-Smtp-Source: ABdhPJzkLZ3kLE4tJ7kFEzPFPXa4NfnIE1rfj++1VSELHsF9723jYLQDF2/21JeeE3d2RoZJNYR1yQ==
X-Received: by 2002:a2e:5d1:: with SMTP id 200mr56438738ljf.272.1641762438526;
        Sun, 09 Jan 2022 13:07:18 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p17sm766129lfu.233.2022.01.09.13.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 13:07:17 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH 3/4] drivers/net/virtio_net: Added RSS hash report.
Date:   Sun,  9 Jan 2022 23:06:58 +0200
Message-Id: <20220109210659.2866740-4-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220109210659.2866740-1-andrew@daynix.com>
References: <20220109210659.2866740-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added features for RSS hash report.
If hash is provided - it sets to skb.
Added checks if rss and/or hash are enabled together.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 56 ++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21794731fc75..6e7461b01f87 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -231,6 +231,7 @@ struct virtnet_info {
 
 	/* Host supports rss and/or hash report */
 	bool has_rss;
+	bool has_rss_hash_report;
 	u8 rss_key_size;
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
@@ -424,7 +425,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	hdr_p = p;
 
 	hdr_len = vi->hdr_len;
-	if (vi->mergeable_rx_bufs)
+	if (vi->has_rss_hash_report)
+		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
+	else if (vi->mergeable_rx_bufs)
 		hdr_padded_len = sizeof(*hdr);
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
@@ -1160,6 +1163,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	struct net_device *dev = vi->dev;
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct virtio_net_hdr_v1_hash *hdr_hash;
+	enum pkt_hash_types rss_hash_type;
 
 	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
@@ -1186,6 +1191,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 
 	hdr = skb_vnet_hdr(skb);
+	if (dev->features & NETIF_F_RXHASH) {
+		hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
+
+		switch (hdr_hash->hash_report) {
+		case VIRTIO_NET_HASH_REPORT_TCPv4:
+		case VIRTIO_NET_HASH_REPORT_UDPv4:
+		case VIRTIO_NET_HASH_REPORT_TCPv6:
+		case VIRTIO_NET_HASH_REPORT_UDPv6:
+		case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
+		case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
+			rss_hash_type = PKT_HASH_TYPE_L4;
+			break;
+		case VIRTIO_NET_HASH_REPORT_IPv4:
+		case VIRTIO_NET_HASH_REPORT_IPv6:
+		case VIRTIO_NET_HASH_REPORT_IPv6_EX:
+			rss_hash_type = PKT_HASH_TYPE_L3;
+			break;
+		case VIRTIO_NET_HASH_REPORT_NONE:
+		default:
+			rss_hash_type = PKT_HASH_TYPE_NONE;
+		}
+		skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
+	}
 
 	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2233,7 +2261,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
-				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
+				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
+				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
 		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
 		return false;
 	}
@@ -3220,7 +3249,9 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
 			     "VIRTIO_NET_F_CTRL_VQ") ||
-	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS"))) {
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
+			     "VIRTIO_NET_F_HASH_REPORT"))) {
 		return false;
 	}
 
@@ -3355,6 +3386,12 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT)) {
+		vi->has_rss_hash_report = true;
+		vi->rss_indir_table_size = 1;
+		vi->rss_key_size = VIRTIO_NET_RSS_MAX_KEY_SIZE;
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
 		vi->has_rss = true;
 		vi->rss_indir_table_size =
@@ -3364,7 +3401,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
 	}
 
-	if (vi->has_rss) {
+	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_hash_types_supported =
 		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
 		vi->rss_hash_types_supported &=
@@ -3374,8 +3411,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 		dev->hw_features |= NETIF_F_RXHASH;
 	}
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
-	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
+
+	if (vi->has_rss_hash_report)
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
+	else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
+		 virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
 	else
 		vi->hdr_len = sizeof(struct virtio_net_hdr);
@@ -3442,7 +3482,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
-	if (vi->has_rss) {
+	if (vi->has_rss || vi->has_rss_hash_report) {
 		rtnl_lock();
 		virtnet_init_default_rss(vi);
 		rtnl_unlock();
@@ -3580,7 +3620,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
-- 
2.34.1


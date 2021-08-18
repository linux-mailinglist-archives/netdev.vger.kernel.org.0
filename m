Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977293F0AA2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhHRRzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhHRRzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:55:43 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B356C0617AD
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 10:55:07 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h9so6585558ljq.8
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 10:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FaxHlGthirATxFhjaA6+LodZEweSNS8npuY55w+kwqI=;
        b=ueRgO9rsDH8h9Dl0VwHX2lFZDbo6wJ/hp2dx513bA7Vjy8ckwys5RknhabUcbciaUz
         njaAo6cj1gI6O24fDdfYNL4oTe+iiEvj+AJIfeYmaWltf2ww9jhHMtHmtO6yTOU9TjqJ
         zWTozWykUKnVLhAak+OuFdw9Qpk7lIsh/VmNLNg8JoBWoPjBYpD7/3lBRD5ry9gjxkYL
         2SeZ2ASJ98Y1WHG0cxVmLntEe1GzRtzgwfuiu/w0yW1mAp2j0zbKj9OhChvBysi3Vj4l
         0KWzwY3PGzXCXr55XUL5321t8iGPT6btF6a0hCsFNWeTn/AXPK3CVHLaCBIS8kgreTb3
         D64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FaxHlGthirATxFhjaA6+LodZEweSNS8npuY55w+kwqI=;
        b=igBF3oitbCY/4k5uxyEPa+jmvlkAKxpzl5dUVVTwc/LAKH7qKs5rYSQ1VOtrj5BTo9
         MyONtM6fYhYoEA8lJIAJca2iKWHsz1dZAM/2T5RMEAZpVWITb3rnuQevprdDVBL9Lzy1
         W+MdEJWLC9quoB5hyPN2ZkK4KBmAkYMSiLbx7JPk5tXAykCEzSxs8VTw9kZmEzsV2gq3
         3bfHzuUtkeEO11Cino9eKxZeJ15khtF5aNVOXxDKL8KaV9eFb5LGFrcRwD1IO2o1LLY0
         SGPHiFkhIMIoa6kvL38Aum/uqZLQHlPj6bbNA+d3npWfc7tOAL+p8xYfmESXfBiJ4fmv
         yFnw==
X-Gm-Message-State: AOAM532gwJZNOZn0Z9B/ALL0dWmvRJ4qGomPTc96fDH2+skFw+rb+Bcw
        KJ3SV68E7auo55/dbWlyz30h8w==
X-Google-Smtp-Source: ABdhPJy5ThR5uwyZiMpJBsOcvGSZdjgDAXV+IUj3zSolVN+xfllaNSK4wygdy5FFjijVKRaCYS++bA==
X-Received: by 2002:a2e:a549:: with SMTP id e9mr8906892ljn.500.1629309305717;
        Wed, 18 Aug 2021 10:55:05 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id c5sm55820lji.67.2021.08.18.10.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:55:05 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] drivers/net/virtio_net: Added RSS hash report.
Date:   Wed, 18 Aug 2021 20:54:40 +0300
Message-Id: <20210818175440.128691-4-andrew@daynix.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818175440.128691-1-andrew@daynix.com>
References: <20210818175440.128691-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added set_hash for skb.
Also added hashflow set/get callbacks.
Virtio RSS "IPv6 extensions" hashes disabled.
Also, disabling RXH_IP_SRC/DST for TCP would disable them for UDP.
TCP and UDP supports only:
ethtool -U eth0 rx-flow-hash tcp4 sd
    RXH_IP_SRC + RXH_IP_DST
ethtool -U eth0 rx-flow-hash tcp4 sdfn
    RXH_IP_SRC + RXH_IP_DST + RXH_L4_B_0_1 + RXH_L4_B_2_3

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 177 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 177 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d87bde246305..6a52eeaf9292 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1151,6 +1151,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	struct net_device *dev = vi->dev;
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct virtio_net_hdr_v1_hash *hdr_hash;
+	enum pkt_hash_types rss_hash_type;
 
 	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
@@ -1177,6 +1179,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 
 	hdr = skb_vnet_hdr(skb);
+	if (vi->has_rss_hash_report && (dev->features & NETIF_F_RXHASH)) {
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
@@ -2250,6 +2275,132 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
 	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
 }
 
+void virtnet_get_hashflow(const struct virtnet_info *vi, struct ethtool_rxnfc *info)
+{
+	info->data = 0;
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case TCP_V6_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case UDP_V4_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case UDP_V6_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST |
+						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+		}
+		break;
+	case IPV4_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+
+		break;
+	case IPV6_FLOW:
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
+			info->data = RXH_IP_SRC | RXH_IP_DST;
+
+		break;
+	default:
+		info->data = 0;
+		break;
+	}
+}
+
+bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *info)
+{
+	u64 is_iphash = info->data & (RXH_IP_SRC | RXH_IP_DST);
+	u64 is_porthash = info->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3);
+	u32 new_hashtypes = vi->rss_hash_types_saved;
+
+	if ((is_iphash && (is_iphash != (RXH_IP_SRC | RXH_IP_DST))) ||
+	    (is_porthash && (is_porthash != (RXH_L4_B_0_1 | RXH_L4_B_2_3)))) {
+		return false;
+	}
+
+	if (!is_iphash && is_porthash)
+		return false;
+
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case IPV4_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
+		if (is_iphash)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4;
+
+		break;
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+	case IPV6_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
+		if (is_iphash)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6;
+
+		break;
+	default:
+		break;
+	}
+
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_TCPv4;
+		if (is_porthash)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_TCPv4;
+
+		break;
+	case UDP_V4_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_UDPv4;
+		if (is_porthash)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_UDPv4;
+
+		break;
+	case TCP_V6_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_TCPv6;
+		if (is_porthash)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_TCPv6;
+
+		break;
+	case UDP_V6_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_UDPv6;
+		if (is_porthash)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_UDPv6;
+
+		break;
+	default:
+		break;
+	}
+
+	if (new_hashtypes != vi->rss_hash_types_saved) {
+		vi->rss_hash_types_saved = new_hashtypes;
+		vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_saved;
+		if (vi->dev->features & NETIF_F_RXHASH)
+			return virtnet_commit_rss_command(vi);
+	}
+
+	return true;
+}
+
 static void virtnet_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
@@ -2530,8 +2681,28 @@ int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *r
 	switch (info->cmd) {
 	case ETHTOOL_GRXRINGS:
 		info->data = vi->curr_queue_pairs;
+		break;
+	case ETHTOOL_GRXFH:
+		virtnet_get_hashflow(vi, info);
+		break;
+	default:
 		rc = -EOPNOTSUPP;
 	}
+
+	return rc;
+}
+
+static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int rc = 0;
+
+	switch (info->cmd) {
+	case ETHTOOL_SRXFH:
+		if (!virtnet_set_hashflow(vi, info))
+			rc = -EINVAL;
+
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
@@ -2559,6 +2730,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_rxfh = virtnet_get_rxfh,
 	.set_rxfh = virtnet_set_rxfh,
 	.get_rxnfc = virtnet_get_rxnfc,
+	.set_rxnfc = virtnet_set_rxnfc,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
@@ -3351,8 +3523,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_hash_types_supported =
 		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
+		vi->rss_hash_types_supported &=
+				~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
+				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
+				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
 
 		dev->hw_features |= NETIF_F_RXHASH;
+		dev->features |= NETIF_F_NTUPLE;
 	}
 
 	if (vi->has_cvq && vi->has_rss_hash_report)
-- 
2.31.1


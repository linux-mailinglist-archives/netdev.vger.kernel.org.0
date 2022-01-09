Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1C3488C77
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbiAIVHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbiAIVHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:07:21 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69664C061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:07:21 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id x6so37468090lfa.5
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 13:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FP2HV+KB9S2snMgVXESVBDFeX2fn1V4rp/jz+fcXOVc=;
        b=dLABM+LnIWptARKU4HIg3R4viKD91mq4dzwmMwGvXrbqA3OmUjU7Mbd4GhxPS7Akq4
         T0NblkNwn0poZnnDQ1wGZA5+dWq/KUs89JMpvrn1FvsV23FTZUyC2GILxp9dicG2tPz0
         LcAIp53ZTj1kSmuDqrJ6lwci7XPaOoEOOY6mqT7hxdvPiigh7O5c6zrQfn3PQE8hrUGj
         o76LrrofZxhlVe5+F7MJbqmYO9zpKDKn+/YjSKvjzMJkG0WbF/+HZSG6xygfkQWcKWhY
         7XxTbmdzbH461TYvKjrY5qAo+/B85Mc2GmlHZbL0OiSm2nCRWNdiA8k7X88JnobcuTyi
         3+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FP2HV+KB9S2snMgVXESVBDFeX2fn1V4rp/jz+fcXOVc=;
        b=u9Mla6sRR9lpcYutCUXetfOD5EsdVCXeEeP6ysw/sGrHqbNZSWCY34WExg2LJ5j3W/
         DNSteR87Jc5ZoK9gibGPjWtGSRYZ5g035nfYxGpRrBDUaaqq5j7bp4VWuvmqj6BpyyLL
         q5yVM7hIgz72AxwFDAxt+Kz5WmLQAtg7i7CfZpZWqihrkKyl27Ul5TIrMrv/AACUdTkI
         QBTLXdUK1uHXi8Y4IlZh403Bw0mvceRoYL/c8t6uk6ZUYnTkJEnTFeU/kKWX8m+cPlP3
         2XjT/BsioGXaR3wYTY7goDMLkGiUzFe5C012vrr/UjLT1JuoOYzBHwffICvq5xDTgOcq
         h7HA==
X-Gm-Message-State: AOAM530KHwIKMUthyDoDGLU5JtoWKkh6tLwEFL7uuRUGZrcqRG9SHY/c
        WEaeIMYUJ4wk+MA45CvWl+Pw0DXWiaprRpbc
X-Google-Smtp-Source: ABdhPJxFZAP8N5kCFdbxXfhRLVT0qaqLJZf7SKzRTUkgwUUByj41Xjj78polbwvu1TkMIH49DWPtvw==
X-Received: by 2002:a2e:a230:: with SMTP id i16mr49431274ljm.494.1641762439527;
        Sun, 09 Jan 2022 13:07:19 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p17sm766129lfu.233.2022.01.09.13.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 13:07:19 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH 4/4] drivers/net/virtio_net: Added RSS hash report control.
Date:   Sun,  9 Jan 2022 23:06:59 +0200
Message-Id: <20220109210659.2866740-5-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220109210659.2866740-1-andrew@daynix.com>
References: <20220109210659.2866740-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now it's possible to control supported hashflows.
Also added hashflow set/get callbacks.
Also, disabling RXH_IP_SRC/DST for TCP would disable then for UDP.
TCP and UDP supports only:
ethtool -U eth0 rx-flow-hash tcp4 sd
    RXH_IP_SRC + RXH_IP_DST
ethtool -U eth0 rx-flow-hash tcp4 sdfn
    RXH_IP_SRC + RXH_IP_DST + RXH_L4_B_0_1 + RXH_L4_B_2_3

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 159 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 159 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6e7461b01f87..1b8dd384483c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -235,6 +235,7 @@ struct virtnet_info {
 	u8 rss_key_size;
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
+	u32 rss_hash_types_saved;
 
 	/* Has control virtqueue */
 	bool has_cvq;
@@ -2275,6 +2276,7 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
 	int i = 0;
 
 	vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_supported;
+	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
 	vi->ctrl->rss.table_info.indirection_table_mask = vi->rss_indir_table_size - 1;
 	vi->ctrl->rss.table_info.unclassified_queue = 0;
 
@@ -2289,6 +2291,131 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
 	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
 }
 
+static void virtnet_get_hashflow(const struct virtnet_info *vi, struct ethtool_rxnfc *info)
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
+static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *info)
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
 
 static void virtnet_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
@@ -2574,6 +2701,27 @@ static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 	switch (info->cmd) {
 	case ETHTOOL_GRXRINGS:
 		info->data = vi->curr_queue_pairs;
+		break;
+	case ETHTOOL_GRXFH:
+		virtnet_get_hashflow(vi, info);
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+	}
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
 		break;
 	default:
 		rc = -EOPNOTSUPP;
@@ -2602,6 +2750,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_rxfh = virtnet_get_rxfh,
 	.set_rxfh = virtnet_set_rxfh,
 	.get_rxnfc = virtnet_get_rxnfc,
+	.set_rxnfc = virtnet_set_rxnfc,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
@@ -2854,6 +3003,16 @@ static int virtnet_set_features(struct net_device *dev,
 		vi->guest_offloads = offloads;
 	}
 
+	if ((dev->features ^ features) & NETIF_F_RXHASH) {
+		if (features & NETIF_F_RXHASH)
+			vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_saved;
+		else
+			vi->ctrl->rss.table_info.hash_types = 0;
+
+		if (!virtnet_commit_rss_command(vi))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.34.1


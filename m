Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48F54AE07C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384807AbiBHSQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384725AbiBHSPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:15:50 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AEAC061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:15:49 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id e17so86801ljk.5
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 10:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+37NPEyVD8WMNDuKr+VUpr12blnHBAWksfV9NWdACbw=;
        b=zwnHJGSXcjyPdbLznzXmWvMRa3UWKL5LIZ5Hgobr6ylhWMO+pojrCi+9nahhBazm7b
         CHoqYDO5Nn7LxS9eTBQOyfaCRNDzgOEOePJOFMsh/qWI/hLz736UCQw1LO//91wQoWq+
         4wQ+7jZJWFFZvyJz6a/2pu9MJcBmuoXpdu8Y2KMpuz/IThti9omsfsMlR3INKZmKwr5X
         xcS1BhLqtfXCzrSE2y83j3awjh33Rxm2yOUu9hWzkW9WKy4AhugE/W8yyQAWGGEkCYwu
         o0vMGodNEtf87qq6mvKgzkQaRnihng8EU7H6BQhPJEebfLWlOgKuQB4aHrbmAAD7vLQP
         fhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+37NPEyVD8WMNDuKr+VUpr12blnHBAWksfV9NWdACbw=;
        b=JLxww5g+re2nFp3cgHEYxR3yt+MQaqI5U4EdX28uHtAqY5ZViVRkVazxDepDiPqn2W
         LV9TrLw8H5jKCgT4lVAUgoeVh6hXgJudmqG/JsywvHp6ZJ85YqVK2CvB1k3KCP01EbNG
         c6DNG937DxnHWlHFp3Y0PxtAZY+n9EdO6xaVJq7rcZrTru5tqs7/4WVGaz2r0qMiv3Ix
         ZZnfwh8BjB9AgbXmk31zvb3kwAlr/KMkrqKaVp192o02coccBqxLq7cHsUR1CkVBW5D/
         HBohgVgBRCHkh9YLkz+h/m96mfvjGP3+KWG0+LkgUfdZHRuanwP9b10Dqn40sYDx9b1T
         1p6w==
X-Gm-Message-State: AOAM530rxq/Fm8pSuNPhnAjlhEClc7yToqJlxU1VyV9c4krb2Xw6G3oB
        axU+sa2jyfBHJ6CUWZWYbTInlMVueIopjrYw
X-Google-Smtp-Source: ABdhPJzyvVblRx20Nb0+M4lqiiWcQd4FDHTeMZG0p9O+KGIhqGeTVjXci+jjWxMcGrDkXaytMx+gUw==
X-Received: by 2002:a2e:a41a:: with SMTP id p26mr3602861ljn.176.1644344147317;
        Tue, 08 Feb 2022 10:15:47 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p16sm2125082ljc.86.2022.02.08.10.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 10:15:46 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v3 4/4] drivers/net/virtio_net: Added RSS hash report control.
Date:   Tue,  8 Feb 2022 20:15:10 +0200
Message-Id: <20220208181510.787069-5-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208181510.787069-1-andrew@daynix.com>
References: <20220208181510.787069-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now it's possible to control supported hashflows.
Added hashflow set/get callbacks.
Also, disabling RXH_IP_SRC/DST for TCP would disable then for UDP.
TCP and UDP supports only:
ethtool -U eth0 rx-flow-hash tcp4 sd
    RXH_IP_SRC + RXH_IP_DST
ethtool -U eth0 rx-flow-hash tcp4 sdfn
    RXH_IP_SRC + RXH_IP_DST + RXH_L4_B_0_1 + RXH_L4_B_2_3

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 141 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 543da2fbdd2d..88759d5e693c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -231,6 +231,7 @@ struct virtnet_info {
 	u8 rss_key_size;
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
+	u32 rss_hash_types_saved;
 
 	/* Has control virtqueue */
 	bool has_cvq;
@@ -2272,6 +2273,7 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
 	int i = 0;
 
 	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
 	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size - 1;
 	vi->ctrl->rss.unclassified_queue = 0;
 
@@ -2286,6 +2288,121 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
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
+		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6)
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
+	u32 new_hashtypes = vi->rss_hash_types_saved;
+	bool is_disable = info->data & RXH_DISCARD;
+	bool is_l4 = info->data == (RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3);
+
+	/* supports only 'sd', 'sdfn' and 'r' */
+	if (!((info->data == (RXH_IP_SRC | RXH_IP_DST)) | is_l4 | is_disable))
+		return false;
+
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_TCPv4);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv4 : 0);
+		break;
+	case UDP_V4_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_UDPv4);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv4 : 0);
+		break;
+	case IPV4_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
+		if (!is_disable)
+			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv4;
+		break;
+	case TCP_V6_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_TCPv6);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv6 : 0);
+		break;
+	case UDP_V6_FLOW:
+		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_UDPv6);
+		if (!is_disable)
+			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
+				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv6 : 0);
+		break;
+	case IPV6_FLOW:
+		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
+		if (!is_disable)
+			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv6;
+		break;
+	default:
+		/* unsupported flow */
+		return false;
+	}
+
+	/* if unsupported hashtype was set */
+	if (new_hashtypes != (new_hashtypes & vi->rss_hash_types_supported))
+		return false;
+
+	if (new_hashtypes != vi->rss_hash_types_saved) {
+		vi->rss_hash_types_saved = new_hashtypes;
+		vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
+		if (vi->dev->features & NETIF_F_RXHASH)
+			return virtnet_commit_rss_command(vi);
+	}
+
+	return true;
+}
 
 static void virtnet_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
@@ -2571,6 +2688,27 @@ static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
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
@@ -2599,6 +2737,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_rxfh = virtnet_get_rxfh,
 	.set_rxfh = virtnet_set_rxfh,
 	.get_rxnfc = virtnet_get_rxnfc,
+	.set_rxnfc = virtnet_set_rxnfc,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
@@ -2853,7 +2992,7 @@ static int virtnet_set_features(struct net_device *dev,
 
 	if ((dev->features ^ features) & NETIF_F_RXHASH) {
 		if (features & NETIF_F_RXHASH)
-			vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
 		else
 			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
 
-- 
2.34.1


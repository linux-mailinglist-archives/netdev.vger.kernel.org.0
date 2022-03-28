Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE5C4E9EA7
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbiC1SEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245196AbiC1SDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:03:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1618747380
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:50 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p15so26142466lfk.8
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XwrXFEA6ufe8dhxsMfcGXWPDSgo5Wl5hFQl5/q/s41A=;
        b=gHyv2qs2Yjq/ET7dkvz7OTcH8gpSmULP7P//kx11mu9/+xqOAQehRE51mGJ5/niBSX
         0pVi8VNCBoiCZQbxtDiA2CchVULw9xHJglAV/fYsbDWm50j52Usq40j8ewNFccLZhlGo
         qoSq1PBxybT9st8xoOU0NMLqSk2uIg37bHY9L8SzZCyy2ASEhp9QVpvT2NnZFTCP/S7P
         G5kA9qUe+kNGWBybNNA2edLumDyI5l3BS0iGVGp8c/eNO+PsPe54aPyMUW01Dq2G3oic
         Mhc2dB4UWmkJ99/BOrRbrUHQjzycZs+exBjI8CGivRz2a5inPStD3soSHXV5Z9j6La7z
         y3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XwrXFEA6ufe8dhxsMfcGXWPDSgo5Wl5hFQl5/q/s41A=;
        b=3qfJv/X1ksVER0JhnckYLOTdEOPd8yqm5UmhwFDaTWfFricBULKaLgJe98IVk2uA5M
         MH5u8aCt+PEHHT6VDKseaYSCM4Pc6X7iIuXH8lJd+oZpAcqi19ZKVYCvlRbtlmP6fRee
         8xfWz1IGKTkfmZY+eKol9kh15ud4PdeMyrhgcFBk76XRVOPB2yHxwNVCWkW+s3KqLY1t
         NWM4aw5RbrAPcK5RBCVIpG9lvGtCS/nCsRDtpr4XvO35q+K9l/2VQ2dDX4GTQSo553FM
         pKo6KRdllGabZ2Rg/An4Xp6T1/8+F5XGOiTdmgeJvtwQlgUyMZ25HVyaDQlc8KmlU79Z
         gwkw==
X-Gm-Message-State: AOAM531WeQYj+ApuR84AIu6BfTLAhddE1zwNwZXgE7dSjtrMT7PAHTiK
        5XZZTMl9/hv5MqQQWmMpu8RWr8kL5qCO9mS2
X-Google-Smtp-Source: ABdhPJzqoqh0sgKnKs5HEqi6D3G6NXiCSBODvFvDqYTbViPzi7+Xk2QY1waFok8NORsCAwWNGH3rqQ==
X-Received: by 2002:a05:6512:130c:b0:44a:2dd3:91d0 with SMTP id x12-20020a056512130c00b0044a2dd391d0mr21741491lfu.234.1648490505338;
        Mon, 28 Mar 2022 11:01:45 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id a4-20020a2eb164000000b0024988e1cfb6sm1801559ljm.94.2022.03.28.11.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:01:44 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, jasowang@redhat.com,
        mst@redhat.com, yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 4/4] drivers/net/virtio_net: Added RSS hash report control.
Date:   Mon, 28 Mar 2022 20:53:36 +0300
Message-Id: <20220328175336.10802-5-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328175336.10802-1-andrew@daynix.com>
References: <20220328175336.10802-1-andrew@daynix.com>
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
Disabling happens because VirtioNET hashtype for IP doesn't check L4 proto,
it works for all IP packets(TCP, UDP, ICMP, etc.).
For TCP and UDP, it's possible to set IP+PORT hashes.
But disabling IP hashes will disable them for TCP and UDP simultaneously.
It's possible to set IP+PORT for TCP/UDP and disable/enable IP
for everything else(UDP, ICMP, etc.).

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 141 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c9472c30e8a2..17eeb4f807e3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -231,6 +231,7 @@ struct virtnet_info {
 	u8 rss_key_size;
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
+	u32 rss_hash_types_saved;
 
 	/* Has control virtqueue */
 	bool has_cvq;
@@ -2278,6 +2279,7 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
 	int i = 0;
 
 	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
 	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size
 						? vi->rss_indir_table_size - 1 : 0;
 	vi->ctrl->rss.unclassified_queue = 0;
@@ -2293,6 +2295,121 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
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
@@ -2578,6 +2695,27 @@ static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
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
@@ -2606,6 +2744,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_rxfh = virtnet_get_rxfh,
 	.set_rxfh = virtnet_set_rxfh,
 	.get_rxnfc = virtnet_get_rxnfc,
+	.set_rxnfc = virtnet_set_rxnfc,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
@@ -2860,7 +2999,7 @@ static int virtnet_set_features(struct net_device *dev,
 
 	if ((dev->features ^ features) & NETIF_F_RXHASH) {
 		if (features & NETIF_F_RXHASH)
-			vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
 		else
 			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
 
-- 
2.35.1


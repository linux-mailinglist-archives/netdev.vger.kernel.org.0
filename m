Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B038488C75
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbiAIVH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbiAIVHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:07:20 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CF7C061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:07:19 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id d3so11145508lfv.13
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 13:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uAmtBE5XTkwhwH0nRAkkE7dKv+jBT+3UHOOWIsORAMY=;
        b=OxWA02gRFOFB3TGiUmLwcaE1xEqmyH8nRxC8sUHGIkic5Fb5K0eIumfMDUMgz4hFSC
         CvXYdT/VAyWR2KGs9td6eGoPpSwPeYaVJcEujuswUIobuPn8cCaVisvbOmgL0sqi8STK
         JFHtq2xPVi6LraZApmTJK7G+OLMf96StZXDYoRkrpebo89yH7nZ6kUHfgl5saSp1EsYb
         ICW64Z4N66Hkb2pOxKwWGVc2YkX/gcvpHrnOrX/H+dayKj7Smv23utFuVbbjeJstqlvI
         Cf0VpCd/3VYv72/3vwWItAAhuTqL5w5y2bxaDJsyvoK2YwqCmCaKG40k0J/xRLusywlO
         zipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uAmtBE5XTkwhwH0nRAkkE7dKv+jBT+3UHOOWIsORAMY=;
        b=480V57FsVSDw+sbQqwCowdI1vTTE6ovESxwmt/pE3FIB4pEJDh/tlvNoB5EjteV0if
         HcIRRr+wJj0haLvuh62hKa5x/uoyozB4ESiA/tI5HDdDFOQckiWKA9lM0kkvVRcsQmjN
         f/MnPXzJFNnujwoIqP3zTqRg8m52Vx8f+aXsmvi2NHOyrrR+mqulfi0BtxmpjZaTNkRo
         yIIl9v1JjPpy3pW39wLoQp5BClKhn4GRgcv+xpJbJetBIl7BfnXnyJpjSnLiK+73aMV3
         dj503fsi/TikvCONiWcoaWRfIhvaI0j1Il8HBx5+A/qGVNJjhxKenwvQ/9Va5315MAdT
         qJcQ==
X-Gm-Message-State: AOAM5302FFa3QuOc8d0tWqdD2nDStOOn7aUBjZAv8qN4YesQlpPjm4PU
        gisYSI/Ws9i00i2zqVEG/Kg9WzYHuh3zv869
X-Google-Smtp-Source: ABdhPJxMkf0xv6fF90sKVT6rqo5utLKX7sTrqC/lrxCYbV2BGiftTekRjltY8WztGMAbOKK94JThBg==
X-Received: by 2002:a2e:8543:: with SMTP id u3mr52946847ljj.307.1641762437311;
        Sun, 09 Jan 2022 13:07:17 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p17sm766129lfu.233.2022.01.09.13.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 13:07:16 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH 2/4] drivers/net/virtio_net: Added basic RSS support.
Date:   Sun,  9 Jan 2022 23:06:57 +0200
Message-Id: <20220109210659.2866740-3-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220109210659.2866740-1-andrew@daynix.com>
References: <20220109210659.2866740-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added features for RSS.
Added initialization, RXHASH feature and ethtool ops.
By default RSS/RXHASH is disabled.
Virtio RSS "IPv6 extensions" hashes disabled.
Added ethtools ops to set key and indirection table.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 194 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 184 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 66439ca488f4..21794731fc75 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -169,6 +169,28 @@ struct receive_queue {
 	struct xdp_rxq_info xdp_rxq;
 };
 
+/* This structure can contain rss message with maximum settings for indirection table and keysize
+ * Note, that default structure that describes RSS configuration virtio_net_rss_config
+ * contains same info but can't handle table values.
+ * In any case, structure would be passed to virtio hw through sg_buf split by parts
+ * because table sizes may be differ according to the device configuration.
+ */
+#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
+#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
+struct virtio_net_ctrl_rss {
+	struct {
+		__le32 hash_types;
+		__le16 indirection_table_mask;
+		__le16 unclassified_queue;
+	} __packed table_info;
+	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
+	struct {
+		u16 max_tx_vq; /* queues */
+		u8 hash_key_length;
+	} __packed key_info;
+	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+};
+
 /* Control VQ buffers: protected by the rtnl lock */
 struct control_buf {
 	struct virtio_net_ctrl_hdr hdr;
@@ -178,6 +200,7 @@ struct control_buf {
 	u8 allmulti;
 	__virtio16 vid;
 	__virtio64 offloads;
+	struct virtio_net_ctrl_rss rss;
 };
 
 struct virtnet_info {
@@ -206,6 +229,12 @@ struct virtnet_info {
 	/* Host will merge rx buffers for big packets (shake it! shake it!) */
 	bool mergeable_rx_bufs;
 
+	/* Host supports rss and/or hash report */
+	bool has_rss;
+	u8 rss_key_size;
+	u16 rss_indir_table_size;
+	u32 rss_hash_types_supported;
+
 	/* Has control virtqueue */
 	bool has_cvq;
 
@@ -395,9 +424,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	hdr_p = p;
 
 	hdr_len = vi->hdr_len;
-	if (vi->has_rss_hash_report)
-		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
-	else if (vi->mergeable_rx_bufs)
+	if (vi->mergeable_rx_bufs)
 		hdr_padded_len = sizeof(*hdr);
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
@@ -2184,6 +2211,55 @@ static void virtnet_get_ringparam(struct net_device *dev,
 	ring->tx_pending = ring->tx_max_pending;
 }
 
+static bool virtnet_commit_rss_command(struct virtnet_info *vi)
+{
+	struct net_device *dev = vi->dev;
+	struct scatterlist sgs[4];
+	unsigned int sg_buf_size;
+
+	/* prepare sgs */
+	sg_init_table(sgs, 4);
+
+	sg_buf_size = sizeof(vi->ctrl->rss.table_info);
+	sg_set_buf(&sgs[0], &vi->ctrl->rss.table_info, sg_buf_size);
+
+	sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
+	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
+
+	sg_buf_size = sizeof(vi->ctrl->rss.key_info);
+	sg_set_buf(&sgs[2], &vi->ctrl->rss.key_info, sg_buf_size);
+
+	sg_buf_size = vi->rss_key_size;
+	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
+
+	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
+				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
+		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
+		return false;
+	}
+	return true;
+}
+
+static void virtnet_init_default_rss(struct virtnet_info *vi)
+{
+	u32 indir_val = 0;
+	int i = 0;
+
+	vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_supported;
+	vi->ctrl->rss.table_info.indirection_table_mask = vi->rss_indir_table_size - 1;
+	vi->ctrl->rss.table_info.unclassified_queue = 0;
+
+	for (; i < vi->rss_indir_table_size; ++i) {
+		indir_val = ethtool_rxfh_indir_default(i, vi->max_queue_pairs);
+		vi->ctrl->rss.indirection_table[i] = indir_val;
+	}
+
+	vi->ctrl->rss.key_info.max_tx_vq = vi->curr_queue_pairs;
+	vi->ctrl->rss.key_info.hash_key_length = vi->rss_key_size;
+
+	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
+}
+
 
 static void virtnet_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
@@ -2412,6 +2488,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
 		vi->duplex = duplex;
 }
 
+static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
+{
+	return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
+}
+
+static u32 virtnet_get_rxfh_indir_size(struct net_device *dev)
+{
+	return ((struct virtnet_info *)netdev_priv(dev))->rss_indir_table_size;
+}
+
+static int virtnet_get_rxfh(struct net_device *dev, u32 *indir, u8 *key, u8 *hfunc)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int i;
+
+	if (indir) {
+		for (i = 0; i < vi->rss_indir_table_size; ++i)
+			indir[i] = vi->ctrl->rss.indirection_table[i];
+	}
+
+	if (key)
+		memcpy(key, vi->ctrl->rss.key, vi->rss_key_size);
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	return 0;
+}
+
+static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int i;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (indir) {
+		for (i = 0; i < vi->rss_indir_table_size; ++i)
+			vi->ctrl->rss.indirection_table[i] = indir[i];
+	}
+	if (key)
+		memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
+
+	virtnet_commit_rss_command(vi);
+
+	return 0;
+}
+
+static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	int rc = 0;
+
+	switch (info->cmd) {
+	case ETHTOOL_GRXRINGS:
+		info->data = vi->curr_queue_pairs;
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
 static const struct ethtool_ops virtnet_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo = virtnet_get_drvinfo,
@@ -2427,6 +2568,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.set_link_ksettings = virtnet_set_link_ksettings,
 	.set_coalesce = virtnet_set_coalesce,
 	.get_coalesce = virtnet_get_coalesce,
+	.get_rxfh_key_size = virtnet_get_rxfh_key_size,
+	.get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
+	.get_rxfh = virtnet_get_rxfh,
+	.set_rxfh = virtnet_set_rxfh,
+	.get_rxnfc = virtnet_get_rxnfc,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
@@ -3073,7 +3219,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
-			     "VIRTIO_NET_F_CTRL_VQ"))) {
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS"))) {
 		return false;
 	}
 
@@ -3113,13 +3260,14 @@ static int virtnet_probe(struct virtio_device *vdev)
 	u16 max_queue_pairs;
 	int mtu;
 
-	/* Find if host supports multiqueue virtio_net device */
-	err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
-				   struct virtio_net_config,
-				   max_virtqueue_pairs, &max_queue_pairs);
+	/* Find if host supports multiqueue/rss virtio_net device */
+	max_queue_pairs = 0;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
+		max_queue_pairs =
+		     virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
 
 	/* We need at least 2 queue's */
-	if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
+	if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
 	    max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
 	    !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
 		max_queue_pairs = 1;
@@ -3207,6 +3355,25 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
+		vi->has_rss = true;
+		vi->rss_indir_table_size =
+			virtio_cread16(vdev, offsetof(struct virtio_net_config,
+						      rss_max_indirection_table_length));
+		vi->rss_key_size =
+			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
+	}
+
+	if (vi->has_rss) {
+		vi->rss_hash_types_supported =
+		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
+		vi->rss_hash_types_supported &=
+				~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
+				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
+				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
+
+		dev->hw_features |= NETIF_F_RXHASH;
+	}
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
 	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
@@ -3275,6 +3442,12 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
+	if (vi->has_rss) {
+		rtnl_lock();
+		virtnet_init_default_rss(vi);
+		rtnl_unlock();
+	}
+
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
@@ -3406,7 +3579,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
-	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
+	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
+	VIRTIO_NET_F_RSS
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
-- 
2.34.1


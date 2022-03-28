Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023904E9E94
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbiC1SEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245177AbiC1SD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:03:27 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A110047380
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:45 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q5so20302141ljb.11
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vpBON0TsJ9kCQgywxiFvAL7kx2glxEzhPvm1Ujx6csw=;
        b=h4Ql6Y4er3Wop84w1CW/1XxSCeqKBzR4R1kMSPSleJ9t4Zz9W3z8EUjfdJA+Uu8rRU
         X6zisfQ4gluF0BkAmxZ1cbonsKVGP+SXZa+9lsS8lP6wkGiCyz5nv0nSxVEJZEBDbYNA
         21gHiyxtHD3VRbCf1iJQYrIt7DrUQ5K8y+RigyK7u2Ax9Px40F4vvo6Jfe20XJHX3wex
         B5SOL7CBBMCJOJZDwPFUrP7MyJXGFzaKVPfaN4aYsnilAO5pPiV6Sg9a/eOUbAaZQPk5
         9X9M1pvsPj3fv8EypFJr5YW5LmyTNPq1yz1RBFapn3pVLyoDJ0llXfOe+aGHVkv4yAwZ
         xuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vpBON0TsJ9kCQgywxiFvAL7kx2glxEzhPvm1Ujx6csw=;
        b=AvyRj3djDbt/qFf7yM3TwPqhmEyiGg6OAnDR8wUSGMBcJNGrQ1bV9m3uL4LwTo6xQg
         e+dCrG2slezhmjpObLerIWGbsIkzI8tTRHXWNobpOHFkf2UaYyAYvS06ZDM83vbOVi8C
         yFtETKzeLi9o77i+bdRXPJ+lRJfTFI+bevilYoebPpV0EsbYALbFxKynjL2nPPEWf/td
         GBZga6iZtHWilY+rkMkki6qc5n+rRIJYAVX4JnWBdoN+S6W3NWFDQ5mLhqtJ7FUH6iPC
         lAb83VprP2A7loRoetuOXCqnRGKU1U7ZYpPHFXH7w5tv+2KZq0aHfrPSPzZ5FrwRaLDV
         nWWw==
X-Gm-Message-State: AOAM5303EbNW+pJYuPTxx8mSk2eWlUoFi13WwEQFRagDPqhghXdCLPea
        D1h3ZRR6SsaqGar1RsHRgE33y1lKqcT/28dK
X-Google-Smtp-Source: ABdhPJwo1FWpGqci9ApryQNZgzCcQt4CCr7r9u3V5z/XR2cke92sEJRhXJqbd2CsxW+SVcJ5RXx4zw==
X-Received: by 2002:a2e:a907:0:b0:249:6747:d8ca with SMTP id j7-20020a2ea907000000b002496747d8camr21415025ljq.452.1648490502769;
        Mon, 28 Mar 2022 11:01:42 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id a4-20020a2eb164000000b0024988e1cfb6sm1801559ljm.94.2022.03.28.11.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:01:42 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, jasowang@redhat.com,
        mst@redhat.com, yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 2/4] drivers/net/virtio_net: Added basic RSS support.
Date:   Mon, 28 Mar 2022 20:53:34 +0300
Message-Id: <20220328175336.10802-3-andrew@daynix.com>
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

Added features for RSS.
Added initialization, RXHASH feature and ethtool ops.
By default RSS/RXHASH is disabled.
Virtio RSS "IPv6 extensions" hashes disabled.
Added ethtools ops to set key and indirection table.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 192 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 186 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b9ed7c55d9a0..b5f2bb426a7b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -169,6 +169,24 @@ struct receive_queue {
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
+	u32 hash_types;
+	u16 indirection_table_mask;
+	u16 unclassified_queue;
+	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
+	u16 max_tx_vq;
+	u8 hash_key_length;
+	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+};
+
 /* Control VQ buffers: protected by the rtnl lock */
 struct control_buf {
 	struct virtio_net_ctrl_hdr hdr;
@@ -178,6 +196,7 @@ struct control_buf {
 	u8 allmulti;
 	__virtio16 vid;
 	__virtio64 offloads;
+	struct virtio_net_ctrl_rss rss;
 };
 
 struct virtnet_info {
@@ -206,6 +225,12 @@ struct virtnet_info {
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
 
@@ -2184,6 +2209,57 @@ static void virtnet_get_ringparam(struct net_device *dev,
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
+	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
+	sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
+
+	sg_buf_size = sizeof(uint16_t) * (vi->ctrl->rss.indirection_table_mask + 1);
+	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
+
+	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
+			- offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
+	sg_set_buf(&sgs[2], &vi->ctrl->rss.max_tx_vq, sg_buf_size);
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
+	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size
+						? vi->rss_indir_table_size - 1 : 0;
+	vi->ctrl->rss.unclassified_queue = 0;
+
+	for (; i < vi->rss_indir_table_size; ++i) {
+		indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
+		vi->ctrl->rss.indirection_table[i] = indir_val;
+	}
+
+	vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
+	vi->ctrl->rss.hash_key_length = vi->rss_key_size;
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
@@ -2679,6 +2825,16 @@ static int virtnet_set_features(struct net_device *dev,
 		vi->guest_offloads = offloads;
 	}
 
+	if ((dev->features ^ features) & NETIF_F_RXHASH) {
+		if (features & NETIF_F_RXHASH)
+			vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
+		else
+			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
+
+		if (!virtnet_commit_rss_command(vi))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -3073,6 +3229,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
 			     "VIRTIO_NET_F_CTRL_VQ"))) {
 		return false;
 	}
@@ -3113,13 +3271,14 @@ static int virtnet_probe(struct virtio_device *vdev)
 	u16 max_queue_pairs;
 	int mtu;
 
-	/* Find if host supports multiqueue virtio_net device */
-	err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
-				   struct virtio_net_config,
-				   max_virtqueue_pairs, &max_queue_pairs);
+	/* Find if host supports multiqueue/rss virtio_net device */
+	max_queue_pairs = 1;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
+		max_queue_pairs =
+		     virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
 
 	/* We need at least 2 queue's */
-	if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
+	if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
 	    max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
 	    !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
 		max_queue_pairs = 1;
@@ -3207,6 +3366,23 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
+		vi->has_rss = true;
+		vi->rss_indir_table_size =
+			virtio_cread16(vdev, offsetof(struct virtio_net_config,
+				rss_max_indirection_table_length));
+		vi->rss_key_size =
+			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
+
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
@@ -3275,6 +3451,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
+	if (vi->has_rss)
+		virtnet_init_default_rss(vi);
+
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
@@ -3406,7 +3585,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
-	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
+	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
+	VIRTIO_NET_F_RSS
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
-- 
2.35.1


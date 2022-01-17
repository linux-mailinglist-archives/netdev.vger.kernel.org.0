Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371A749035B
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 09:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiAQIAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 03:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbiAQIAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 03:00:36 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A79C061746
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 00:00:35 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m3so40398687lfu.0
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 00:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R1cCJbepPDyM0CLWOcZl19Ml7ugID4kuXQjq583AIRg=;
        b=b5h4dDWr5c4eQpt/l/PcE92naBY/e7zcYoBpndsOmxmruCuE7fejaMG/9xwKAga7zH
         Yh34XHocsgns18USWmM7NYJuGFxZwcQu4CqKFqWhx596R2kXexitObd182toeCuAP59N
         aZOmof36fIXkmtZ5Vd1PWHOyQGF64bwG0Wd1JYt4J882ny26w4l/ZY7R9rsDf1ygEVGh
         k5pLGuM+zQ+HQCk+OhA86C0nG5PqenAiLpEjB3PtW0eLOipmVYI3iXX2I5oL1+d0BuVr
         YDnz9je/km1+k371ZCBnXZ4P0rXP/h4kgSqJQfEiNMasil0RJhDR7yClEK9ilqQVFNrj
         q8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R1cCJbepPDyM0CLWOcZl19Ml7ugID4kuXQjq583AIRg=;
        b=HcpB5cD8FeN3qYFdJ/2jMqRa8/lfifjzzp8CUvp7FTmDfisqHBzDyV+z8XJjgwqBZp
         jmTrkGp8PK1UzCVSHja/OIVCqA+HmeQ4exgWQlfMpSr3ankHYIusdAfCNV1k1dzbSL8D
         L1B+xAPzuwdqbqzu54ilij06orw7zH5s8FkbPgOnZklYTHY/EZyuoj8sd/jBZc8Z1MDV
         qiLXN/7zfQL0FZ+Bv8yTcvi7a872AcQT4edZ5p1Sigeec7U95lsKtvBKTONPP3UmOiCC
         KTzkag8lSzs/tbUn/43Fi5usdIWQgMp2dRtLr2NtCJST4M/Wset3FdNqUb7dJI0RJ0R3
         0Xow==
X-Gm-Message-State: AOAM533RSflneRLaIpTTEok1Am5gJQrWJ+5BMX4Oi+JOTUY/RkvlyfZG
        K6ablGP4bRhhWtm6QiANo6mlNR++PUpkvR5RDVY=
X-Google-Smtp-Source: ABdhPJwLipLdiI0ZSapdPWRN2THYFsk76L7WH0KFo7vu0oh7xcoQ/rnPLhntvCp01oscehVANZoiOQ==
X-Received: by 2002:a05:651c:170c:: with SMTP id be12mr2566016ljb.522.1642406433192;
        Mon, 17 Jan 2022 00:00:33 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id x18sm1279423ljd.105.2022.01.17.00.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:00:32 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v2 2/4] drivers/net/virtio_net: Added basic RSS support.
Date:   Mon, 17 Jan 2022 10:00:07 +0200
Message-Id: <20220117080009.3055012-3-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117080009.3055012-1-andrew@daynix.com>
References: <20220117080009.3055012-1-andrew@daynix.com>
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
 drivers/net/virtio_net.c | 193 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 187 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 05fe5ba32187..9aae11cb568e 100644
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
 
@@ -2184,6 +2209,56 @@ static void virtnet_get_ringparam(struct net_device *dev,
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
+	sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
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
+	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size - 1;
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
@@ -2412,6 +2487,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
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
@@ -2427,6 +2567,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
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
@@ -2679,6 +2824,16 @@ static int virtnet_set_features(struct net_device *dev,
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
 
@@ -3073,6 +3228,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
 			     "VIRTIO_NET_F_CTRL_VQ"))) {
 		return false;
 	}
@@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -3207,6 +3365,25 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -3275,6 +3452,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
+	if (vi->has_rss)
+		virtnet_init_default_rss(vi);
+
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
@@ -3406,7 +3586,8 @@ static struct virtio_device_id id_table[] = {
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


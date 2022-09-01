Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2161C5A948B
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiIAKZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiIAKZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:25:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003DCDEF6;
        Thu,  1 Sep 2022 03:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662027898; x=1693563898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IP+YY7Vlyu3Y2ILLuj9EI+J4/4vQcHrQeC3vNdfstEk=;
  b=ISpZ6M35BSuFwukjAOn9I6RGwNw1ISc7Gt3/H39T8X0cIzyhsM3X/Ndq
   ebk/F1l660cN2cqMqsMPRH0d5+WKYgcjpZDC8Z1elzC+ih/B6FDrrG/UF
   FU6WCOMvlB41tNtGB42PuBsZ7Vvj80BFobSpUQRjR2I/x7/7oMcaQLH4/
   KGIp6cUbfzjL9DbWJzzaG3hBEgJ/ABURwgwNEXgq95/X4fK73gxx7telX
   oVYg4s1KSjR1GQAN4Ku+w0DKMeAc2X4knPN0LHxK6cnUHCg+mDEMG6sMU
   Vdspk0/eMglbdZJ8c6k2urcADvkzGGfnzwRO0uWln0PnCiRBWJqudZ9B+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321825560"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321825560"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642276444"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:56 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 3/4] vDPA: detect device endian in _net_config_fill() and _fill_stats_rec()
Date:   Thu,  1 Sep 2022 18:16:00 +0800
Message-Id: <20220901101601.61420-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901101601.61420-1-lingshan.zhu@intel.com>
References: <20220901101601.61420-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit detect endian-ness of the device by
vdpa_config_ops.get_vq_endian(), so that functions
vdpa_dev_net_config_fill() and vdpa_fill_stats_rec()
can convert the endian-ness correctly by __virtio16_to_cpu().

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c06c02704461..8a08caf573d1 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/vdpa.h>
 #include <uapi/linux/vdpa.h>
+#include <uapi/linux/vhost.h>
 #include <net/genetlink.h>
 #include <linux/mod_devicetable.h>
 #include <linux/virtio_ids.h>
@@ -814,21 +815,31 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
+	const struct vdpa_config_ops *ops = vdev->config;
 	struct virtio_net_config config = {};
 	u64 features;
 	u16 val_u16;
+	u8 le;
 
-	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
+	ops->get_config(vdev, 0, &config, sizeof(config));
+
+	/* endian-ness is a device wide attr, so reading the endian-ness of vq0
+	 * can get the endian-ness of the device config space.
+	 */
+	if (ops->get_vq_endian(vdev, 0) == VHOST_VRING_LITTLE_ENDIAN)
+		le = true;
+	else
+		le = false;
 
 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
 		    config.mac))
 		return -EMSGSIZE;
 
-	val_u16 = __virtio16_to_cpu(true, config.status);
+	val_u16 = __virtio16_to_cpu(le, config.status);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
 		return -EMSGSIZE;
 
-	val_u16 = __virtio16_to_cpu(true, config.mtu);
+	val_u16 = __virtio16_to_cpu(le, config.mtu);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
@@ -897,6 +908,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
 	u16 max_vqp;
 	u8 status;
 	int err;
+	u8 le;
 
 	status = vdev->config->get_status(vdev);
 	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
@@ -905,7 +917,15 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
 	}
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
 
-	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
+	/* endian-ness is a device wide attr, so reading the endian-ness of vq0
+	 * can get the endian-ness of the device config space.
+	 */
+	if (vdev->config->get_vq_endian(vdev, 0) == VHOST_VRING_LITTLE_ENDIAN)
+		le = true;
+	else
+		le = false;
+
+	max_vqp = __virtio16_to_cpu(le, config.max_virtqueue_pairs);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
 		return -EMSGSIZE;
 
-- 
2.31.1


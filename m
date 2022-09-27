Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78B55EB865
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiI0DM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiI0DMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:12:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755891C93F;
        Mon, 26 Sep 2022 20:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664248188; x=1695784188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COzcN3Qbisu/0MjCDWrAxFQOe27JKz2nAsFAG8KBs8s=;
  b=envEKnHPJTvQ83A3njiIr3Vu/0xykJQStFImlmDq/DKoUytSzeJj93UW
   +E1nHDY5CRry4wPXoyKOh3KAh5glCD6VRFHb8GQ67th+0F0dZujqF95kF
   KXy0WWMjOHubTobPzpV/f5n/O7jZRKKa7KNZVJtvb0IPDrPd3FoH9aoVA
   /SY+SYVlcpwgwUQxOLUbMNqqtlwclbkWn3go/CiYiA8YQTufQGSZZhpEQ
   iedinGoUY/67PxKeyPJcVor4S8l/kulFwc4UkRRcNqea/Q8WVYkZSW7fk
   s5BtUnVljETCxafyfFduiFgHbuujD3isRIhqoxYyRoBA9pOSP2AzoHMIa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="299922328"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="299922328"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:41 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="710387786"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="710387786"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:39 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 RESEND 6/6] vDPA: conditionally read MTU and MAC in dev cfg space
Date:   Tue, 27 Sep 2022 11:01:17 +0800
Message-Id: <20220927030117.5635-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927030117.5635-1-lingshan.zhu@intel.com>
References: <20220927030117.5635-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The spec says:
mtu only exists if VIRTIO_NET_F_MTU is set
The mac address field always exists (though
is only valid if VIRTIO_NET_F_MAC is set)

So vdpa_dev_net_config_fill() should read MTU and MAC
conditionally on the feature bits.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index fa7f65279f79..3d2cf8caff7c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -814,6 +814,29 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
+static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, u64 features,
+					const struct virtio_net_config *config)
+{
+	u16 val_u16;
+
+	if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
+		return 0;
+
+	val_u16 = __virtio16_to_cpu(true, config->mtu);
+
+	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
+}
+
+static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 features,
+					const struct virtio_net_config *config)
+{
+	if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
+		return 0;
+
+	return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
+			sizeof(config->mac), config->mac);
+}
+
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
@@ -822,24 +845,22 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 
 	vdev->config->get_config(vdev, 0, &config, sizeof(config));
 
-	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
-		    config.mac))
-		return -EMSGSIZE;
-
 	val_u16 = __virtio16_to_cpu(true, config.status);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
 		return -EMSGSIZE;
 
-	val_u16 = __virtio16_to_cpu(true, config.mtu);
-	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
-		return -EMSGSIZE;
-
 	features_device = vdev->config->get_device_features(vdev);
 
 	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
+	if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
+		return -EMSGSIZE;
+
+	if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
+		return -EMSGSIZE;
+
 	return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
 }
 
-- 
2.31.1


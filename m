Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB785EB85A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiI0DMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiI0DL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:11:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC50310;
        Mon, 26 Sep 2022 20:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664248171; x=1695784171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=seVF5/jELUBPIdInogzKyMqz5go1Mgay8X224linJj0=;
  b=lirwWfGxytaJAlJaz2sGceHpRSYdGQjk/6cwUz90z3xRKtZURs1CAEgq
   Opfz3eUSi6ENVjFDsi/jCemIp/YKSjot5RJNmrfsSNchPZ86C2T+lm8AZ
   2uCvhLp/LvWfDnwUhlPRXVoaiMPimVKlozjJv7YykrOyWsBGbHkOOS+/4
   aR+ux6i1KGSDm3scvrPCfX+AbImDuN8cg+Xo2yyY910SvjrfTwaSAP1Ts
   AvmOnTV4llW5Uhxw/M9vmqW6DI0MUIzjA95QlGmAjtMCgSzEPVl9rrqUy
   2SM/MXx54px0yeVIxyjlacVFe3O+kAL2Xog4F9d7AZvChSKOQi6e3ARcZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327558437"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="327558437"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:31 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="710387752"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="710387752"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 20:09:29 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 RESEND 1/6] vDPA: allow userspace to query features of a vDPA device
Date:   Tue, 27 Sep 2022 11:01:12 +0800
Message-Id: <20220927030117.5635-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927030117.5635-1-lingshan.zhu@intel.com>
References: <20220927030117.5635-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new vDPA netlink attribution
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
features of vDPA devices through this new attr.

This commit invokes vdpa_config_ops.get_config()
rather than vdpa_get_config_unlocked() to read
the device config spcae, so no races in
vdpa_set_features_unlocked()

Userspace tool iproute2 example:
$ vdpa dev config show vdpa0
vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
  negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
  dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c       | 17 ++++++++++++-----
 include/uapi/linux/vdpa.h |  4 ++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c06c02704461..2035700d6fc8 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -491,6 +491,7 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
 		err = -EMSGSIZE;
 		goto msg_err;
 	}
+
 	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
 			      mdev->supported_features, VDPA_ATTR_PAD)) {
 		err = -EMSGSIZE;
@@ -815,10 +816,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
 {
 	struct virtio_net_config config = {};
-	u64 features;
+	u64 features_device, features_driver;
 	u16 val_u16;
 
-	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
+	vdev->config->get_config(vdev, 0, &config, sizeof(config));
 
 	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
 		    config.mac))
@@ -832,12 +833,18 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-	features = vdev->config->get_driver_features(vdev);
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
+	features_driver = vdev->config->get_driver_features(vdev);
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
+			      VDPA_ATTR_PAD))
+		return -EMSGSIZE;
+
+	features_device = vdev->config->get_device_features(vdev);
+
+	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
+	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
 }
 
 static int
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 25c55cab3d7c..07474183fdb3 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -46,12 +46,16 @@ enum vdpa_attr {
 
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
 	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
+	/* virtio features that are supported by the vDPA management device */
 	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
 
 	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
 	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
 	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
 
+	/* virtio features that are supported by the vDPA device */
+	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AF55B32E1
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiIIJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiIIJFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:05:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C61D12EDBA;
        Fri,  9 Sep 2022 02:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714332; x=1694250332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2d+ps/g4TWdMsszBDkTswdlQFaJPehalTwu3sMOcUBY=;
  b=bcj1dOXObRmDh93LlTVfucREK2fM+qxTSApPIio24kZzwhmzyP/IqvAs
   /dU4QiWWK75ufFVE4q51KhnVcsHwthg4plTwQA4+PIyRxiFTfcHG1GV8Q
   MVse5FTwTe823v9Ztx66zfOeGAvKkvD7ric78YNt5tOxkRE6OGoImUX9S
   uYNZS/LQeXHgjxjtTfNVGUnXpgwrZ0kt+4QGKA5vkZRVlCNjtK326Urd5
   bxYX3528sGHtJzT2RgkcrFcisgMfTwVbOCU8AzRPzp75qyGGKrXk1OuFg
   KevkgOzfCufioqvSpnZ7pKqBfnq2z9fXACQYtGY0NUhj4gcKu6z0ji+w2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277165810"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277165810"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="592540387"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:29 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 4/4] vDPA: Conditionally read MTU and MAC in dev cfg space
Date:   Fri,  9 Sep 2022 16:57:12 +0800
Message-Id: <20220909085712.46006-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220909085712.46006-1-lingshan.zhu@intel.com>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/vdpa/vdpa.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index f8ff61232421..b332388d3375 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -815,6 +815,29 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
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
@@ -824,18 +847,10 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 
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
 	/* only read driver features after the feature negotiation is done */
 	status = vdev->config->get_status(vdev);
 	if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
@@ -852,6 +867,12 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
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


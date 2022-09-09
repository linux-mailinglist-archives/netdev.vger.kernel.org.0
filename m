Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494295B32D3
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiIIJGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiIIJFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:05:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99401238CE;
        Fri,  9 Sep 2022 02:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714327; x=1694250327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHvN2ZiZojVn/CzRTD5zuK0xhqk56k8vx5k5+vTx4O4=;
  b=Olb4ziZfiz4c/09UoXuE4idkL3+pgpv4ZHtnEl7mS8VC22D2eUmcwhxY
   L84v4XN3a8hUQbZTFQEq9ADCyLXTiXRzpZtXZ3vl8IsIzM4/n8f6xZ9El
   3ma8xeBLyG6X8QBBngQA2X2cfPBgYBC97Jr3trMy7F/RsuT/JwKnD7dxU
   w7+7q90ovqLdGuxXPcSk9fxiPR7PamPJInUFY/TxKYMzMs59UCtMYhAcl
   eeWsgk1PNki0Z5IR8YFRBjmpjlJ+xPG1xZOcUJPR6SwGmDNOnTwWfDWe7
   QK73bBbmuic2aZYV1LuVWpJrv89YgDy7pT5VXuMsYnAS/biMkwfxYZC6L
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277165799"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277165799"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="592540357"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:25 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/4] vDPA: only report driver features if  FEATURES_OK is set
Date:   Fri,  9 Sep 2022 16:57:10 +0800
Message-Id: <20220909085712.46006-3-lingshan.zhu@intel.com>
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

vdpa_dev_net_config_fill() should only report driver features
to userspace after features negotiation is done.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 798a02c7aa94..29d7e8858e6f 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	struct virtio_net_config config = {};
 	u64 features_device, features_driver;
 	u16 val_u16;
+	u8 status;
 
 	vdev->config->get_config(vdev, 0, &config, sizeof(config));
 
@@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-	features_driver = vdev->config->get_driver_features(vdev);
-	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
-			      VDPA_ATTR_PAD))
-		return -EMSGSIZE;
+	/* only read driver features after the feature negotiation is done */
+	status = vdev->config->get_status(vdev);
+	if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
+		features_driver = vdev->config->get_driver_features(vdev);
+		if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
+				      VDPA_ATTR_PAD))
+			return -EMSGSIZE;
+	}
 
 	features_device = vdev->config->get_device_features(vdev);
 
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4DD5B32C8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiIIJGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiIIJFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:05:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CF112ED88;
        Fri,  9 Sep 2022 02:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714330; x=1694250330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7uhTu4XFJxBaCJgQtMXGUFVSm1I/3xH5+hRRbO84cNM=;
  b=mUyYQUHH4Ttrip43VtBrve4hK0oFTapHNYqjuvs4iASfZszyjfezd3Fv
   6k72+wAspgDTRyxd2IH5jdPtJBpgDHauz9xD+tKufXR6ZpjBCPyfYaMH+
   iLV5Q7EgLzm2UTNs3bSY9wsxUXS+63in1YxuhDLQEmoJkiTAAwrUzLmtr
   3NVnLRJBcv7W40n5KICBD+4+ZyNmVMhalY6UE8W5m/qQkkQyEc/P/QJHd
   yo0HzuLO+d1Z4k3Un1F/0Nz7hI2mlq1VyxdEQiQ79oYwANA2xQ9DFVNXM
   C/oHJyK7HGpgAG8R0zaH+ntRoiPMBsLvrEInnOM+26/QPv6KAcmW6zHJD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277165804"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277165804"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="592540372"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:27 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/4] vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
Date:   Fri,  9 Sep 2022 16:57:11 +0800
Message-Id: <20220909085712.46006-4-lingshan.zhu@intel.com>
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

virtio 1.2 spec says:
max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
VIRTIO_NET_F_RSS is set.

So when reporint MQ to userspace, it should check both
VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.

This commit also fixes:
1) a spase warning by replacing le16_to_cpu with __virtio16_to_cpu.
2) vdpa_dev_net_mq_config_fill() should checks device features
for MQ than driver features.
3) struct vdpa_device *vdev is not needed for
vdpa_dev_net_mq_config_fill(), unused.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 29d7e8858e6f..f8ff61232421 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -801,16 +801,17 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
 	return msg->len;
 }
 
-static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
-				       struct sk_buff *msg, u64 features,
+static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
 				       const struct virtio_net_config *config)
 {
 	u16 val_u16;
 
-	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
+	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
+	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
 		return 0;
 
-	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
+	val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
+
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
@@ -851,7 +852,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
-	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
+	return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
 }
 
 static int
-- 
2.31.1


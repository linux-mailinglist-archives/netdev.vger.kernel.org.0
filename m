Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA3F590FC0
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbiHLKxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbiHLKxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:53:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767B1AB1A3;
        Fri, 12 Aug 2022 03:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660301597; x=1691837597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jWNofX+dOPQkXy8PRqgVzBaCSEUE/3juZjqg4ALYZT0=;
  b=bRSfc8Zj9rC/j9QGseOw/oo+skLZi/wBIxE2AEa5fjtGLyPZNcJhR2Gz
   p6ayu0bEqCfF58m/7DQhiILBj9WA+gM8W71Yoafh854ZrIMPDlcw9qVQp
   KiKkJkMqwj6L0HKaHsDojgQQ5gm2KHZVghu8I4UlnWk/U1R/w2jL311u4
   CM7bd5HdO4gwqfIV3MSNfQmRKMSPbnNmVYIi1tEspenvjmgheYnUNbi41
   pTVvrOE0JNKPg6w1IQW5Kh/xVecMhVWWSZbe3osDQzZeZOWChtr5LAawh
   wF+9I3jCwqNLK9CJMk6Stj7+3yAFWvSXt0+/70OXblyxfPETuSy7PH6gk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271956322"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271956322"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665780627"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:14 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 6/6] fix 'cast to restricted le16' warnings in vdpa.c
Date:   Fri, 12 Aug 2022 18:45:00 +0800
Message-Id: <20220812104500.163625-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220812104500.163625-1-lingshan.zhu@intel.com>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_config_fill() and
vdpa_fill_stats_rec()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
 drivers/vdpa/vdpa.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index f6172c8dd262..0e5fa97dfcc3 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -847,7 +847,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
 
-	val_u16 = le16_to_cpu(config.status);
+	/*
+	 * Assume little endian for now, userspace can tweak this for
+	 * legacy guest support.
+	 */
+	val_u16 = __virtio16_to_cpu(true, config.status);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
 		return -EMSGSIZE;
 
@@ -937,7 +941,11 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
 	}
 	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
 
-	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
+	/*
+	 * Assume little endian for now, userspace can tweak this for
+	 * legacy guest support.
+	 */
+	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
 		return -EMSGSIZE;
 
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DAD5FEC0E
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJNJuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 05:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiJNJuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 05:50:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F87A2F651
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 02:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665741012; x=1697277012;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y9y3OjO/luNlBmQ8H9i99QPF0QmPgUDjDbeRaFF1nsE=;
  b=iFbySXigRn5grXTN/rdevmFZBLixhDynAcrxdsOeSk9Wof7Yit/cMfeU
   PPMr21KuuNyOHpqEd3YMqYxtpIn6gVKSqbeHvhABvq1dHDFOAwuYqboTr
   hJbLX4ktFWv3d5VmSVhFRax8LBsSO2aCgqCedVII3sOl47b0inmcv7kAM
   UjQpthTFVHew/qQ9VxzCupsjo0qidzL+Ox7a6GHHIKTy0yEgYAPl4t7EQ
   tHhyLNoY1d+Xa3BDPm8cgvt125TU1F0JpU92QLnVE+IMW57GW95C/nawu
   NRycDtQ9AHrf392vExE/nwrnhxI1NH+bRHC/5k4wgzj2ZQZZ43m8BTbDv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="302952693"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="302952693"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 02:50:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="627518953"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="627518953"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 02:50:08 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, stephen@networkplumber.org,
        dsahern@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] iproute2/vdpa: Add support for reading device features
Date:   Fri, 14 Oct 2022 17:41:52 +0800
Message-Id: <20221014094152.5570-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements support for reading vdpa device
features in iproute2.

Example:
$ vdpa dev config show vdpa0
vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
  negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
  dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 vdpa/vdpa.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index b73e40b4..89844e92 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
+	[VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
+	[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
 
 #define NUM_FEATURE_BITS 64
 
-static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
+static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
 			   uint16_t dev_id)
 {
 	const char * const *feature_strs = NULL;
@@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
 	if (dev_id < ARRAY_SIZE(dev_to_feature_str))
 		feature_strs = dev_to_feature_str[dev_id];
 
-	if (mgmtdevf)
+	if (devf)
 		pr_out_array_start(vdpa, "dev_features");
 	else
 		pr_out_array_start(vdpa, "negotiated_features");
@@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
 		print_features(vdpa, val_u64, false, dev_id);
 	}
+	if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
+		uint16_t dev_id = 0;
+
+		if (tb[VDPA_ATTR_DEV_ID])
+			dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
+
+		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
+		print_features(vdpa, val_u64, true, dev_id);
+	}
 }
 
 static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5583E5EEB42
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiI2ByQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbiI2ByP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:54:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF29822BDA;
        Wed, 28 Sep 2022 18:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664416452; x=1695952452;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=whH5AC8kMAxW+DvvWFDRKDdPE+thuIPFy2NSLFOY2uc=;
  b=LVGlmxXgsDPCirbKnRtZoHaPCd5K8MVuZpbFO0FA0Il47TKy+TZGnQEl
   CjablpxmezpNNly6H9fl9hLiB+7r6q1QtJFQaDfIHrpnkJpPN6N1eGdr7
   vQtC5Vog6lPs1tuIoK+i454SUl2KxVmk+5U6f4FqKV5mGw1xniI7t9Mum
   wEIP4wg2VftPJzrtwmCqXG8LWmXOxJ00ENyOCrCsAgoLH5GKMe/UNWevK
   jV95yBANqSjjJTqhdcBSNjzJkbp1lNG9L+byZ/yYZNTo2j0vI0zI/2mfs
   mzUmZZ1by+Z0t5UNLjwqONTcGB8myTC+B1CQFDGbU5Wi1HeNseDARfSC0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365813983"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="365813983"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="950931614"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="950931614"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:12 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/6] Conditionally read fields in dev cfg space 
Date:   Thu, 29 Sep 2022 09:45:49 +0800
Message-Id: <20220929014555.112323-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
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

This series intends to read the fields in virtio-net device
configuration space conditionally on the feature bits,
this means:

MTU exists if VIRTIO_NET_F_MTU is set
MAC exists if VIRTIO_NET_F_NET is set
MQ exists if VIRTIO_NET_F_MQ or VIRTIO_NET_F_RSS is set.

This series report device features to userspace and invokes
vdpa_config_ops.get_config() rather than
vdpa_get_config_unlocked() to read the device config spcae,
so no races in vdpa_set_features_unlocked()

Thanks!

Changes form V2:
remove unnacessary checking for vdev->config->get_status (Jason)

Changes from V1:
1)Better comments for VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
only in the header file(Jason)
2)Split original 3/4 into separate patches(Jason)
3)Check FEATURES_OK for reporting driver features
in vdpa_dev_config_fill (Jason)
4) Add iproute2 example for reporting device features

Zhu Lingshan (6):
  vDPA: allow userspace to query features of a vDPA device
  vDPA: only report driver features if FEATURES_OK is set
  vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
  vDPA: check virtio device features to detect MQ
  vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
  vDPA: conditionally read MTU and MAC in dev cfg space

 drivers/vdpa/vdpa.c       | 68 ++++++++++++++++++++++++++++++---------
 include/uapi/linux/vdpa.h |  4 +++
 2 files changed, 56 insertions(+), 16 deletions(-)

-- 
2.31.1


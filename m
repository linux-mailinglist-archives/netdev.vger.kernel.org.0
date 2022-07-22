Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4218857E12F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiGVMBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiGVMBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:01:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94429BB21B
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658491272; x=1690027272;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xMov5voTZZCQEXkDT5G0fnTQ8nIixYdsjLY4N77bGf8=;
  b=MQQCkXfkt15/4ONW0OtVIlf1umfTE9XLZgEOY1DK3Bn95SUL5C6epjeY
   1dhY59GK1kZtO5+FLR0eJfRfmNmVJrVrhssVAvu2um0DMN8TP6ieHORtp
   OMgEExhmMZvtxcE8u9+LyLBhv6yhM2t+Ism7GsTUp8s1rS2a7ErA2hZVt
   WIIndlJYvqz25rIDO+qC1j5I0xFXreerDcAdsQJRSzxy5Kyec/zQ2YkX2
   SYuQlkmKHAFoRGX9rD2ZCURW3JurYafzXM7erpSWvJ3KMGJOqdVHM8oBm
   JSKqdLncqXgHAXTXHrsbYjYgFnkSfT1NwusgQx2fABXu+X6hm8h6iOZ1Z
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="284850172"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="284850172"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="657189800"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 05:01:10 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 0/6] ifcvf/vDPA: support query device config space through netlink
Date:   Fri, 22 Jul 2022 19:53:03 +0800
Message-Id: <20220722115309.82746-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows userspace to query device config space of vDPA
devices and the management devices through netlink,
to get multi-queue, feature bits and etc.

This series has introduced a new netlink attr
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
features of vDPA  devices than the management device.

Please help review.

Thanks!
Zhu Lingshan

Changes from V3:
(1)drop the fixes tags(Parva)
(2)better commit log for patch 1/6(Michael)
(3)assign num_queues to max_supported_vqs than max_vq_pairs(Jason)
(4)initialize virtio pci capabilities in the probe() function.

Changes from V2:
Add fixes tags(Parva)

Changes from V1:
(1) Use __virito16_to_cpu(true, xxx) for the le16 casting(Jason)
(2) Add a comment in ifcvf_get_config_size(), to explain
why we should return the minimum value of
sizeof(struct virtio_net_config) and the onboard
cap size(Jason)
(3) Introduced a new attr VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES
(4) Show the changes of iproute2 output before and after 5/6 patch(Jason)
(5) Fix cast warning in vdpa_fill_stats_rec() 

Zhu Lingshan (6):
  vDPA/ifcvf: get_config_size should return a value no greater than dev
    implementation
  vDPA/ifcvf: support userspace to query features and MQ of a management
    device
  vDPA: allow userspace to query features of a vDPA device
  vDPA: !FEATURES_OK should not block querying device config space
  vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ
    == 0
  vDPA: fix 'cast to restricted le16' warnings in vdpa.c

 drivers/vdpa/ifcvf/ifcvf_base.c |  13 ++-
 drivers/vdpa/ifcvf/ifcvf_base.h |   2 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 142 +++++++++++++++++---------------
 drivers/vdpa/vdpa.c             |  32 ++++---
 include/uapi/linux/vdpa.h       |   1 +
 5 files changed, 105 insertions(+), 85 deletions(-)

-- 
2.31.1


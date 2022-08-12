Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5972590FB3
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiHLKxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHLKxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:53:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502F39BB4C;
        Fri, 12 Aug 2022 03:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660301582; x=1691837582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bStvOSpsXVApWkDcCtm3uX/ugByyXgBgVEJUj06LIyE=;
  b=f+15gZTX6lcJZrIrboxIHDr6j4NagCsR/++oZSPWDfR4gcgevhZqNEcS
   ABNEMlrGtpabQgsqpd2b6cr0vOktDxqxjJ3HfZhPIRoOrEW9OyenN8+S+
   CEqk23aX4SQcHmVNI8/HgW6BqOP4nt3mlJBdMqsxUSQ1Mbc6jpG0iuEID
   MET6o1TfnlONxF2F611fjfXqVk6Jv30xiNCqldzd2DY3gSreLxifA/9YE
   HCvda+855kjovWlEYamZXrmyvRv1d/SZZMxe+kN1TjcRf/pwZao+xydTK
   8I6SN0uO3CibEWtczjx9jLpmpmixE7q4WOo0wjjTG9fX0pBCOHIn6cvTo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271956259"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271956259"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:53:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665780567"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 03:52:59 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 0/6] ifcvf/vDPA: support query device config space through netlink
Date:   Fri, 12 Aug 2022 18:44:54 +0800
Message-Id: <20220812104500.163625-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This series allows userspace to query device config space of vDPA
devices and the management devices through netlink,
to get multi-queue, feature bits and etc.

This series has introduced a new netlink attr
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
features of vDPA  devices than the management device.

Please help review.

Thanks!
Zhu Lingshan

Changes rom V4:
(1) Read MAC, MTU, MQ conditionally (Michael)
(2) If VIRTIO_NET_F_MAC not set, don't report MAC to userspace
(3) If VIRTIO_NET_F_MTU not set, report 1500 to userspace
(4) Add comments to the new attr
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES(Michael)
(5) Add comments for reporting the device status as LE(Michael)

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
  vDPA: Conditionally read fields in virtio-net dev config space
  fix 'cast to restricted le16' warnings in vdpa.c

 drivers/vdpa/ifcvf/ifcvf_base.c |  13 ++-
 drivers/vdpa/ifcvf/ifcvf_base.h |   2 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 142 +++++++++++++++++---------------
 drivers/vdpa/vdpa.c             |  82 ++++++++++++------
 include/uapi/linux/vdpa.h       |   3 +
 5 files changed, 149 insertions(+), 93 deletions(-)

-- 
2.31.1


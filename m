Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF526563470
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiGANgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiGANgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:36:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5EE167F6
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682572; x=1688218572;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6M2sA4npi1sIDwroPfK9FVMXkK6RXhu2tDfJY4yxkIA=;
  b=lTTGhKg4AuWVszZHm0MaDv6E3a8DWT36AaPvC18ualouK/LUTgQxDrnJ
   EJZnZjoy7dDRz8Y/OBe4lvpTPEFOohgOnhI3qznfLka4CsFIrRb2OVfD8
   yAc80TD1jcHPNTTgozp3j1oaVF3wZRswBUmoGrmzAkZ7Z1SSclB+lBE5G
   Z/aCmhmuk9K0cvJfK0lNT/O3ikysLH8OyqIXMpO2z/b5GkFtahgHaIKnc
   7aIs04zMW3J4UMXKhn5/34yKsIN7AjiAnseDOin/RC6hgM5RzQh278Jpp
   41LPgGugB6miP81TvQ5rXXD3rr5+mcU4YBZozUQ79uwC7v0+DgS9NSMjl
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282682884"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282682884"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648349599"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:36:10 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/6] ifcvf/vDPA: support query device config space through netlink
Date:   Fri,  1 Jul 2022 21:28:20 +0800
Message-Id: <20220701132826.8132-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows userspace to query device config space of vDPA
devices and the management devices through netlink,
to get multi-queue, feature bits

This series has introduced a new netlink attr
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
features of vDPA  devices than the management device.

Please help review.

Thanks!
Zhu Lingshan

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

 drivers/vdpa/ifcvf/ifcvf_base.c | 25 +++++++++++++++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
 drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
 drivers/vdpa/vdpa.c             | 32 +++++++++++++++-----------------
 include/uapi/linux/vdpa.h       |  1 +
 5 files changed, 45 insertions(+), 19 deletions(-)

-- 
2.31.1


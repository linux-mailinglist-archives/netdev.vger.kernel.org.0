Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A712525E7D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378146AbiEMIsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348408AbiEMIsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:48:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831056A044
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652431695; x=1683967695;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Lou9ai1G8RCG+/9EbrGJJrnQJuX9AW1A7s8wYecMBwY=;
  b=c783X3LBhF5U/FjHM2vyJJazEYQTKoUztMq+DLFvf0CW8uRImWoxS9oA
   k8wi6Gl321Qflqlw5PtPDKhv4ITkxKRz7rPSWmK7j5n2I6OFhuzdoR3+c
   OKHjKqnpczucXN0AGLpDcx4TeMtMD09p5RBvEmKj25nanBCyg89LbaRWe
   O4lG6wOc1Qd1iEg8AbZXXuxrP5Pk95PdbVfVHYdiuXDkSCUIs64TmrXIV
   sSL1YflcBlYkQDHSFv6u8L1R28Eef91haVgBC6uZAoKbV9H1v1SyPhD1V
   2wG6CFOWowALaxEIFCU29tRGxHWiBHeyQafIiqGXgBl68E1X8OMGex0eP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356682841"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="356682841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:03 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595122593"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:01 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 0/6] ifcvf/vDPA: support query device config space through
Date:   Fri, 13 May 2022 16:39:29 +0800
Message-Id: <20220513083935.1253031-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
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

This series allows userspace to query device config space through
netlink, to get multi-queue, feature bits, device features and
driver features.

This series also has fixed some issues of misusing
VDPA_ATTR_DEV_SUPPORTED_FEATURES, this should be used for virtio devices
than the management device.

Please help review.

Thanks!
Zhu Lingshan

Zhu Lingshan (6):
  vDPA/ifcvf: get_config_size should return a value no greater than dev
    implementation
  vDPA/ifcvf: support userspace to query features and MQ of a management
    device
  vDPA/ifcvf: support userspace to query device feature bits
  vDPA: !FEATURES_OK should not block querying device config space
  vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ
    == 0
  vDPA: fix 'cast to restricted le16' warnings in
    vdpa_dev_net_config_fill()

 drivers/vdpa/ifcvf/ifcvf_base.c | 20 ++++++++++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
 drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
 drivers/vdpa/vdpa.c             | 32 +++++++++++++++-----------------
 include/uapi/linux/vdpa.h       |  1 +
 5 files changed, 40 insertions(+), 19 deletions(-)

-- 
2.31.1


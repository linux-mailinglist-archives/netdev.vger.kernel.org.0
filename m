Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F026A53B1C9
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiFBCsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiFBCsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:48:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B940A1CC5EE
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654138098; x=1685674098;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Lou9ai1G8RCG+/9EbrGJJrnQJuX9AW1A7s8wYecMBwY=;
  b=cGwp+elUzAbxFOeRUZmeAgaltdzrFx/P8vtlD4el4gcrIDL1tiYOghco
   tc52V6S6mPPh3o59kGYUDqVQHb8KSFAdPdPRknkCsultS5+LamthftOc4
   M0CgT0NB14rzST0bIP7d4gAaK95RcpJohki4M2HnTvCnZ7uuTJ6CLFKmn
   b11LVrPKuJF8/mG9O7i2iwYT95KENpGOvNzopvlXtIf3xl90hJCd2a4JB
   BzrEgBN0rJI+WoVB4WNPKdYMQw56gPJ08rGkLT/xS71zPw+M6XAIPrLm4
   hWVirmjsfsKGTNAREqgvl0HX1/lFWV5BQubfGV0iO3vExGkmDfUXJZ2bK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275874614"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="275874614"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="612608858"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:15 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/6] ifcvf/vDPA: support query device config space through netlink
Date:   Thu,  2 Jun 2022 10:38:39 +0800
Message-Id: <20220602023845.2596397-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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


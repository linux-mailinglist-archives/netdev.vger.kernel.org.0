Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED685EB835
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiI0DB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiI0DAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:00:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CF4C3D;
        Mon, 26 Sep 2022 19:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247529; x=1695783529;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+Pxhx9WdJvTQwrgbXVM7E/FumYYrkJKpzjAGhpHVRA0=;
  b=R3EpmRL9bwBCnyjnf+csf99mP20zqtIPAKY5CRxQhWFmE52DTuDGeqXP
   hZERtTqOuZZafTF3PcGCsy3ODWKahg+9jXP63X9NoTeX71li9J6muYCpR
   rkC7/v0yEblDB9mqIsQrq39aVAr/xMWVTG2Y2xUY3Lp/HdxEjMrncoCTe
   JbqOFeB1ckVaxGfFvQQf71vl+HQgwdqXxL9Wrf7GIOD0j5/hrJQhe9hpU
   EyCaWayyvDMKZB17sEm4qq5ABudo/OamDZSkOiMY7RWZnvfT2u5cDzG5a
   hcvwYkC5yQNaSuRjQOdkXUd40gqTgjbp2mfp34q1V1lmNse3l7TrI3dzi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="387490737"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="387490737"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652105629"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652105629"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:46 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/6] Conditionally read fields in dev cfg space
Date:   Tue, 27 Sep 2022 10:50:29 +0800
Message-Id: <20220927025035.4972-1-lingshan.zhu@intel.com>
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
so no raeces in vdpa_set_features_unlocked()

Thanks!

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

 drivers/vdpa/vdpa.c       | 71 ++++++++++++++++++++++++++++++---------
 include/uapi/linux/vdpa.h |  4 +++
 2 files changed, 59 insertions(+), 16 deletions(-)

-- 
2.31.1


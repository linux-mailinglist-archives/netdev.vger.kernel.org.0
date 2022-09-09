Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0255B5B32E0
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiIIJGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiIIJFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:05:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC77117785;
        Fri,  9 Sep 2022 02:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714324; x=1694250324;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TwPMDxAGGAqZ5FfgDavetyiGItPmgud7a5UYrPnIpz8=;
  b=FWco7WZP9AeU9hAHOlbD6KDISz0NxPGbmMXtndONQiCKSw0ZlumwvtZH
   OxgYj3CSNK8NHHDkbz3rYSOzfW0b6XEaLUxtbwXb/umaHA5Z40Egn7WJy
   q5pyzKVGnf/q1V2dVZlFXYFzR8aPYf6PBHTVbcs7XCWnYkn5O3Zogxr9K
   kI4faUTIV7yxQi7FU9DdI3ywlZY3U+TGldocWa48bYKpScL1DxTRsXGu7
   mZgFSZEDFkRpDHd9aO3AkMGQRvyIfHMo/WVbzrOmVDN1JTsgibk+T9BCx
   rbQnfGr/3uPEPK4XBlCPti1lwaO/szBAxl2AFIgigNFFYCFBQ7PDW2NCd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277165792"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277165792"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="592540330"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:05:21 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/4] Conditionally read fields in dev cfg space
Date:   Fri,  9 Sep 2022 16:57:08 +0800
Message-Id: <20220909085712.46006-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
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

This series intends to read the fields in virtio-net device
configuration space conditionally on the feature bits,
this means:

MTU exists if VIRTIO_NET_F_MTU is set
MAC exists if VIRTIO_NET_F_NET is set
MQ exists if VIRTIO_NET_F_MQ or VIRTIO_NET_F_RSS is set.

This series report device features to userspace and invokes
vdpa_config_ops.get_config() than vdpa_get_config_unlocked()
to read the device config spcae, so no raeces in
vdpa_set_features_unlocked()

Thanks!

Zhu Lingshan (4):
  vDPA: allow userspace to query features of a vDPA device
  vDPA: only report driver features if  FEATURES_OK is set
  vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
  vDPA: Conditionally read MTU and MAC in dev cfg space

 drivers/vdpa/vdpa.c       | 68 ++++++++++++++++++++++++++++++---------
 include/uapi/linux/vdpa.h |  4 +++
 2 files changed, 56 insertions(+), 16 deletions(-)

-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB19B67F174
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjA0Wxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjA0Wxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:53:46 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAA479216
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674860017; x=1706396017;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kCLuuV9b2y3goZOAgi7vmz4g+h+oHX3J7cKCnwVztvY=;
  b=Okv7lyqRp18GlL16CkDT25d1zszRA5XznjvSpFsCTYFCi/Sj9EPgyI4j
   mBWG8lJGRgan0ZYMewGIaURiXaFeHd79q8qsPUyjCG2DjZsFkb3Io5Mls
   TyfZ9egkHZNr1fwj86ZfN1fqO1uvNKYJR72c4vB5KtjTwuCv+rqm8HG+J
   URcDXLuIsF6Nwp1EKJbQPR+7jE9rJZJsez2QRGT140emcZs++Hd+DGu8U
   gxK33RLyXNZcWLVrLIh0jYZyE2H4p3EmZnc/+M/GkMSo1mVKQocOr5wrc
   i242aIvvlbmwWIZU3T/X1ZpZ1/I3CiTWtYMbXLGWxHI2wXAgih8Loyyp9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="327229812"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="327229812"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 14:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="805976398"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="805976398"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2023 14:53:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        leonro@nvidia.com
Subject: [PATCH net v4 0/2][pull request] Intel Wired LAN Driver Updates 2023-01-27 (ice)
Date:   Fri, 27 Jan 2023 14:53:31 -0800
Message-Id: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dave prevents modifying channels when RDMA is active as this will break
RDMA traffic.

Michal fixes a broken URL.
---
v4:
- Protect driver with device_lock; send variable down the call chain to
  avoid double lock
- Change returned error from -EINVAL to -EBUSY

v3: https://lore.kernel.org/netdev/20230120211231.431147-1-anthony.l.nguyen@intel.com/
- Reduced scope of lock in patch 1 to avoid double lock
- Dropped, previous, patch 2

v2: https://lore.kernel.org/netdev/20230103230738.1102585-1-anthony.l.nguyen@intel.com/
- Dropped, previous, patch 1.
- Replace RDMA patch to disallow change instead of replugging aux device

v1: https://lore.kernel.org/netdev/20221207211040.1099708-1-anthony.l.nguyen@intel.com/

The following are changes since commit 7083df59abbc2b7500db312cac706493be0273ff:
  net: mdio-mux-meson-g12a: force internal PHY off on mux switch
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Dave Ertman (1):
  ice: Prevent set_channel from changing queues while RDMA active

Michal Wilczynski (1):
  ice: Fix broken link in ice NAPI doc

 .../device_drivers/ethernet/intel/ice.rst     |  2 +-
 drivers/net/ethernet/intel/ice/ice.h          |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 23 ++++++++-------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  4 +--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 28 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  5 ++--
 6 files changed, 44 insertions(+), 20 deletions(-)

-- 
2.38.1


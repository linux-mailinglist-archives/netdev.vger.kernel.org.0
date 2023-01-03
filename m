Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77765CA2E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbjACXG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbjACXGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:06:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747C3BF76
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787213; x=1704323213;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VJuav1nzh1CXGGiAZ22fYjm7ia2zAsVELcSElEZQchI=;
  b=RTqZIAcqrH2soh3OQdeGLofetuMQvPbSCXLxHWT/qDjWzlyNgbFwg+0s
   wdVeCfHPTBRvkx9vaNJYId5/Rjr3bs7gjL5PMrdzlidy3XRWXd6yIZ+uX
   hJyfmLmDvUrBnbF1J/B84C0x5+8Gt742CijEEmFBtEM6kFwGJRP7Irn/0
   bHe/4SC04n9xKhEHQZKWTchxiypKfE/4DZeJjsoQ4G5ZFKvljpxZmdOB4
   XUPvGJRTzGtUiuCTvK6qUBm5DV93g705eGytnwffyhtrWDWWSGptCaMD6
   ijSzTcrtJL3Nm0nVYRkdmNKDPIXYfXpthIfVPS+eVh5Fbt/teQ46NwLBG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="319487130"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="319487130"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:06:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="828982736"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="828982736"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 03 Jan 2023 15:06:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates 2023-01-03 (ice)
Date:   Tue,  3 Jan 2023 15:07:35 -0800
Message-Id: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
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

Mateusz replaces unregister_netdev() call with call to clear rings as
there can be a deadlock with the former call.

Michal fixes a broken URL.
---
v2:
- Dropped, previous, patch 1.
- Replace RDMA patch to disallow change instead of replugging aux device

v1: https://lore.kernel.org/netdev/20221207211040.1099708-1-anthony.l.nguyen@intel.com/

The following are changes since commit c7dd13805f8b8fc1ce3b6d40f6aff47e66b72ad2:
  usb: rndis_host: Secure rndis_query check against int overflow
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Dave Ertman (1):
  ice: Prevent set_channel from changing queues while RDMA active

Mateusz Palczewski (1):
  ice: Fix deadlock on the rtnl_mutex

Michal Wilczynski (1):
  ice: Fix broken link in ice NAPI doc

 .../device_drivers/ethernet/intel/ice.rst      |  2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c   | 18 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_lib.c       | 10 ++++------
 3 files changed, 20 insertions(+), 10 deletions(-)

-- 
2.38.1


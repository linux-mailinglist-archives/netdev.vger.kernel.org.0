Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B1751AEFE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244476AbiEDU3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiEDU3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:29:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3A74BFD0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651695953; x=1683231953;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=crJ6JqkDQ/hgsgU0ZCY+gNBaklwXkwaRPCEQlKQ5z4E=;
  b=MQDgri/CaVhHlQGMq8ihum414tCC4nTLsqMRD3GrXyB7Ak2mNpOUhvHi
   +9bvm2qc+gE61heSRiFVnSzaCF8H/cCV8mTMAeu5FpKBu1q1HSfMk8PDA
   r/PiI0Swb3jDTfRFeG1U2gpDsbcy1hayIO2Yc5fOghvOsWlJZyWsmAt3e
   5zL/8t9pmdcOu6AvVjifYUBt2zpBB6P2cnHRUwuTFQ1GZh3Dj8Px2lu7N
   bnd7nAc6IblXlW5YyoBeSt3Vi/EIuByK2Q4OIsuJqtcUGMb+aGct/B14P
   feHxMgYuKvvth3p4CHOZk/l4yJocWcB4IODKWr/1KY7RhYSj808OXn46B
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267774821"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="267774821"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 13:25:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="620968689"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 May 2022 13:25:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-05-04
Date:   Wed,  4 May 2022 13:22:48 -0700
Message-Id: <20220504202252.2001471-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
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

This series contains updates to ice driver only.

Ivan Vecera fixes a race with aux plug/unplug by delaying setting adev
until initialization is complete and adding locking.

Anatolii ensures VF queues are completely disabled before attempting to
reconfigure them.

Michal ensures stale Tx timestamps are cleared from hardware.

Arkadiusz prevents writing of timestamps when rings are being
configured.

The following are changes since commit ad0724b90a2d637c4279fba0a56d4c0b8efc7401:
  Merge tag 'mlx5-fixes-2022-05-03' of git://git.kernel.org/pub/scm/linux/kernel/g it/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anatolii Gerasymenko (1):
  ice: clear stale Tx queue settings before configuring

Arkadiusz Kubalewski (1):
  ice: fix crash when writing timestamp on RX rings

Ivan Vecera (1):
  ice: Fix race during aux device (un)plugging

Michal Michalik (1):
  ice: fix PTP stale Tx timestamps cleanup

 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 25 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 29 ++++++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 68 ++++++++++++++-----
 5 files changed, 93 insertions(+), 32 deletions(-)

-- 
2.35.1


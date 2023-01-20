Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953F8675F6D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjATVKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjATVK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:10:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CBA891F5
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674249027; x=1705785027;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KjMIN15tC6o4IJWIs9nz1wdhjKJ19InvtPp1tTkVKD4=;
  b=WyCBru3kROuueANP2rKKOET2aWill7ZWBM7AYSVg4kkVsXHOq4papOM0
   IQ2bQUhQv3iuOaFgvgujR2634ZJTlc0VSCJdsQ2qNlMpTvTgxiy/UVjiS
   rmC4DDDdVdf46z/cjoHn8yiiElPH2IldLP5o0mRA8LFm/OxLxnYqRf2G1
   7a/x7P0jFejZ67rWjP4GidwUNjHFEqZN140K9K/37GDmuzVnYJT/64FXG
   y/N/f7tsTZQGJqzKbkq3cEtx5tm8V6fJEa86nfkcB+VtAHrrqv0jfOrIg
   6Jcpo/3Idh3tRqcEZwiXFSM3qMknVFvBLYPl8JG2+WbYD8GyXYVyoezfR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="352949171"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="352949171"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 13:10:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="784667622"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="784667622"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 20 Jan 2023 13:10:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-01-20 (iavf)
Date:   Fri, 20 Jan 2023 13:10:33 -0800
Message-Id: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Michal Schmidt converts single iavf workqueue to per adapter to avoid
deadlock issues.

Marcin moves setting of VLAN related netdev features to watchdog task to
avoid RTNL deadlock.

Stefan Assmann schedules immediate watchdog task execution on changing
primary MAC to avoid excessive delay.

The following are changes since commit 45a919bbb21c642e0c34dac483d1e003560159dc:
  Revert "Merge branch 'octeontx2-af-CPT'"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Marcin Szycik (1):
  iavf: Move netdev_update_features() into watchdog task

Michal Schmidt (1):
  iavf: fix temporary deadlock and failure to set MAC address

Stefan Assmann (1):
  iavf: schedule watchdog immediately when changing primary MAC

 drivers/net/ethernet/intel/iavf/iavf.h        |   2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 113 ++++++++----------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  10 +-
 4 files changed, 66 insertions(+), 69 deletions(-)

-- 
2.38.1


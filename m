Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143736436C3
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiLEVY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiLEVYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6EE2BB29
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275470; x=1701811470;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dIvDcTvCBfdBJhOb4QsURqbgmYrJyhZjMA6IwKCdzDA=;
  b=DVZOkpsB4IewuQp9eVS1WI9wHZa6MbQJZyU3bKnxp1jQRItrAACHLKGz
   FX3YanRETKqjJu4orvzB5dwgDTkYeN3QdFlqmxF/eFR27/XrRMGj6jNwM
   Jclp/PSjE4MNNNezg9kuaUBVq7zYaxE+2G6qap6jJiSQWUhi9J1+ubgkg
   d7/pNZC2en73um0Os68X8LYRojNNBXOf23mU0u2Dfw/IaYloNPgB+VeeR
   wBOz0i3psKwC89rE6DTrpk2KehHbFDJMkJ/pbux8Igv+wFoA8RkqMR7O2
   y6Xq0iheAy6QNBMsvwzxW9ku63x7f07GW23x5F39WV4999ufiPVUhffiU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157787"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157787"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744930"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744930"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, muhammad.husaini.zulkifli@intel.com
Subject: [PATCH net-next 0/8][pull request] Intel Wired LAN Driver Updates 2022-12-05 (igc)
Date:   Mon,  5 Dec 2022 13:24:06 -0800
Message-Id: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Muhammad Husaini Zulkifli says:

This patch series improves the Time-Sensitive Networking(TSN) Qbv Scheduling
features. I225 stepping had some hardware restrictions; I226 enables us to
further enhance the driver code and offer more Qbv capabilities.

An overview of each patch is given below:

Patch 1: Allow configuring the basetime with a value of zero.
Patch 2: To enable basetime scheduling in the future, remove the existing
restriction for i226 stepping while maintain the restriction for i225.
Patch 3: Ensure basetime values are not negative
Patch 4: Handle the Qbv end time correctly if cycle time parameter is
configured during the Gate Control List. Applicable for both i225 and i226.
Patch 5: Remove the restriction which require a controller reset when
setting the basetime register for new i226 steps and enable the second
GCL configuration.
Patch 6: Setting the Qbv start time and end time properly if the particular
gate is close in the Gate Control List due to hardware bug.
Patch 7: Configure strict cycle for better behaved transmissions
Patch 8: Allow scheduling packet to next cycle for i225

Test Procedure:
Talker: udp_tai application is being used to generate the Qbv packet.
Receiver: Capture using tcpdump to analyze the packet using wireshark.

The following are changes since commit 343a5d358e4ab5597e90e1eafa7eba55eb42e96b:
  net: phy: mxl-gpy: rename MMD_VEND1 macros to match datasheet
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Muhammad Husaini Zulkifli (2):
  igc: remove I226 Qbv BaseTime restriction
  igc: Add checking for basetime less than zero

Tan Tee Min (4):
  igc: allow BaseTime 0 enrollment for Qbv
  igc: recalculate Qbv end_time by considering cycle time
  igc: enable Qbv configuration for 2nd GCL
  igc: Set Qbv start_time and end_time to end_time if not being
    configured in GCL

Vinicius Costa Gomes (2):
  igc: Use strict cycles for Qbv scheduling
  igc: Enhance Qbv scheduling by using first flag bit

 drivers/net/ethernet/intel/igc/igc.h         |   3 +
 drivers/net/ethernet/intel/igc/igc_base.c    |  29 +++
 drivers/net/ethernet/intel/igc/igc_base.h    |   2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |   3 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 224 ++++++++++++++++---
 drivers/net/ethernet/intel/igc/igc_tsn.c     |  66 +++---
 drivers/net/ethernet/intel/igc/igc_tsn.h     |   2 +-
 7 files changed, 266 insertions(+), 63 deletions(-)

-- 
2.35.1


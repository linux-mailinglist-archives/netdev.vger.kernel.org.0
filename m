Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDD559610A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiHPRYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiHPRX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:23:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63B74E847
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660670638; x=1692206638;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mbDbR79agWSIGix84RLMTgYgQrNABc1gC5yMwOUH138=;
  b=aPKgxizsL+6WJ1Khe0/8MdFwNBbXCp+Dp+WBwKm67BJP4jrrambvbC2H
   feAySLT4S7gJeFtILT16kBMgAXmy8TznGDLynMH1Np31yDBzl6qXf2ho7
   6kvDaL9AN4z6s9zPPbw593ZW/Jp5pPw4QJcBzXbwLfX3jo3Fyjfkst7W6
   1OeC1qC5vAzFjSNHP8XVyfZEo+HJs0t+6gqS3lBsIagYDHDZiv0+fjLMa
   UFTYobmf12Ulxc2wQDrZUuD2HMXFrokF1Npihu54oKx/FV5BZKeLB1L/E
   VDJREiyiTAE8IypScE2votOuwcr+nJXGxaQFFNrDQHkM3bDMNOI7Maqyt
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="318281029"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="318281029"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:23:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="610340344"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2022 10:23:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com
Subject: [PATCH net-next 0/6][pull request] ice: detect and report PTP timestamp issues
Date:   Tue, 16 Aug 2022 10:23:46 -0700
Message-Id: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

This series fixes a few small issues with the cached PTP Hardware Clock
timestamp used for timestamp extension. It also introduces extra checks to
help detect issues with this logic, such as if the cached timestamp is not
updated within the 2 second window.

This introduces a few statistics similar to the ones already available in
other Intel drivers, including tx_hwtstamp_skipped and tx_hwtstamp_timeouts.

It is intended to aid in debugging issues we're seeing with some setups
which might be related to incorrect cached timestamp values.

The following are changes since commit 7ebfc85e2cd7b08f518b526173e9a33b56b3913b:
  Merge tag 'net-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (6):
  ice: set tx_tstamps when creating new Tx rings via ethtool
  ice: initialize cached_phctime when creating Rx rings
  ice: track Tx timestamp stats similar to other Intel drivers
  ice: track and warn when PHC update is late
  ice: re-arrange some static functions in ice_ptp.c
  ice: introduce ice_ptp_reset_cached_phctime function

 drivers/net/ethernet/intel/ice/ice_ethtool.c |   7 +
 drivers/net/ethernet/intel/ice/ice_lib.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 854 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_ptp.h     |  13 +
 drivers/net/ethernet/intel/ice/ice_txrx.c    |   4 +-
 5 files changed, 491 insertions(+), 388 deletions(-)

-- 
2.35.1


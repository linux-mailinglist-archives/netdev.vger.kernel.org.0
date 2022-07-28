Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB81584597
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiG1SVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiG1SVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8641C10C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032503; x=1690568503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NjS7/84P9n8JvysDrWYDxWAG9GnGIhWOY98Y0EOFGC4=;
  b=fz55PMVPrN0MPnfI5CukWHEsNmWu+BdZe4UA7WOM90EZC+/SCk3VSt9v
   pm5tqS2dXLhl2zBMraDl9fk/YDnCkQEga8NwXHI1V6ipiNNMmap0QbJ/9
   Wf2O3qrCsNGs8MMAz4/++G6SlKWo5PwlPtj/vZ88DhgjXO2ZWRC0Ah38o
   ke1ZhA0MZjqeedgkFn8aoAp5+pxo6nL6yNyQ6cj0CjJX1SPykHZjwKBwi
   M3T3S0vfu/JKN4eqAbar/L/nxDbgum1rmF2Yq4A9Yl8NQm1+L/z9c3Ya4
   gZJlp9uLEdruavWgRBpsdR8NOKkRvcIXc3fzIbgdYT0uf/QIhvAXlezLf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348902"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348902"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456611"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com, jacob.e.keller@intel.com
Subject: [PATCH net-next 0/7][pull request] 1GbE Intel Wired LAN Driver Updates 2022-07-28
Date:   Thu, 28 Jul 2022 11:18:29 -0700
Message-Id: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller says:

Convert all of the Intel drivers with PTP support to the newer .adjfine
implementation which uses scaled parts per million.

This improves the precision of the frequency adjustments by taking advantage
of the full scaled parts per million input coming from user space.

In addition, all implementations are converted to using the
mul_u64_u64_div_u64 function which better handles the intermediate value.
This function supports architecture specific instructions where possible to
avoid loss of precision if the normal 64-bit multiplication would overflow.

Of note, the i40e implementation is now able to avoid loss of precision on
slower link speeds by taking advantage of this to multiply by the link speed
factor first. This results in a significantly more precise adjustment by
allowing the calculation to impact the lower bits.

This also gets us a step closer to being able to remove the .adjfreq
entirely by removing its use from many drivers.

I plan to follow this up with a series to update the drivers from other
vendors and drop the .adjfreq implementation entirely.

The following are changes since commit 623cd87006983935de6c2ad8e2d50e68f1b7d6e7:
  net: cdns,macb: use correct xlnx prefix for Xilinx
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Jacob Keller (7):
  ice: implement adjfine with mul_u64_u64_div_u64
  e1000e: remove unnecessary range check in e1000e_phc_adjfreq
  e1000e: convert .adjfreq to .adjfine
  i40e: use mul_u64_u64_div_u64 for PTP frequency calculation
  i40e: convert .adjfreq to .adjfine
  ixgbe: convert .adjfreq to .adjfine
  igb: convert .adjfreq to .adjfine

 drivers/net/ethernet/intel/e1000e/e1000.h    |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c   |  4 +-
 drivers/net/ethernet/intel/e1000e/ptp.c      | 18 +++--
 drivers/net/ethernet/intel/i40e/i40e_ptp.c   | 35 ++++------
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 16 +----
 drivers/net/ethernet/intel/igb/igb_ptp.c     | 15 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 73 +++++++++++---------
 7 files changed, 75 insertions(+), 88 deletions(-)

-- 
2.35.1


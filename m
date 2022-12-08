Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCBE64664A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiLHBLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiLHBLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:37 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88878BD14
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461895; x=1701997895;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1LXWw3r9SHxGnQ5pp44T4TmCV4HN4B+aW6rgGx1fsq8=;
  b=jIgsq2XkEsoekZT6IcznAhrbh6JhoZZv88SmsiymxWhGWEpEV2fa1Afe
   UfYAp8HcMW8J7alzVFDKxcBDp5lSwvim1KHcVTuT8JtqCFNcZPRHaHsMt
   s3xoeRxLUgzcdKNtgtKWJdsHWzdMFrwmH+dQSai5ScrW1NoIrOgGCK8sz
   QfcC+vn6Ogtd81TY+vqlAFA5hkGDG+qvxRpbOWBQdpAUThsi585CyUVhZ
   yrz73LTMGlXDDAZeg4uqbRQrgwgF2y3KrlKtYrqc/S0i+e/392znfNrjL
   R0A6adVM6drJ66a8szkQeKUCOz7Nt/i8ttgfWldC8b9Z3VfmrwsElsWgs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672875"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672875"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445326"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445326"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 00/13] ethtool: clean up and fix
Date:   Wed,  7 Dec 2022 17:11:09 -0800
Message-Id: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
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

This series is an update to the ethtool application code, and was
triggered by running some static analysis tools and doing some general
refactor on the ethtool code to make it clearer.

The tools run were:
$ scan-build make
$ cppcheck
$ make CFLAGS+='-fsanitize=address,undefined' LDFLAGS+='-lubsan -lasan'

The big change in this series is a refactor of all the various bit
shifts from (1 << foo) to BIT(foo).  The goal was to make the code more
readable and maintainable, while fixing a few small bugs and hopefully
preventing more in the future from people forgetting to add 1UL to a 1
being used in a bitshift.

It includes a uapi sync/update to match a patch that was sent to the kernel
separately in the following link:
Link: https://lore.kernel.org/netdev/20221207231728.2331166-1-jesse.brandeburg@intel.com/

v2: first external version, updated commit message for 7/13
v1: internal version

Jesse Brandeburg (13):
  ethtool: convert boilerplate licenses to SPDX
  ethtool: fix trivial issue in allocation
  ethtool: disallow passing null to find_option
  ethtool: commonize power related strings
  ethtool: fix extra warnings
  ethtool: fix uninitialized local variable use
  ethtool: avoid null pointer dereference
  ethtool: fix runtime errors found by sanitizers
  ethtool: merge uapi changes to implement BIT and friends
  ethtool: refactor bit shifts to use BIT and BIT_ULL
  ethtool: fix missing free of memory after failure
  ethtool: fix leak of memory after realloc
  ethtool: fix bug and use standard string parsing

 amd8111e.c                   | 198 ++++++++---------
 cmis.c                       |  10 +-
 de2104x.c                    | 410 +++++++++++++++++------------------
 ethtool.c                    |  38 ++--
 fsl_enetc.c                  |   2 -
 internal.h                   |  26 +--
 json_print.c                 |   6 +-
 json_print.h                 |   6 +-
 natsemi.c                    | 358 +++++++++++++++---------------
 netlink/bitset.c             |   6 +-
 netlink/features.c           |   4 +-
 netlink/monitor.c            |   4 +-
 netlink/msgbuff.c            |  39 ++--
 netlink/parser.c             |  13 +-
 netlink/permaddr.c           |   2 +-
 netlink/settings.c           |  10 +-
 netlink/stats.c              |   2 +-
 qsfp.c                       |  21 +-
 qsfp.h                       | 353 +++++++++++++++---------------
 realtek.c                    |  48 ++--
 rxclass.c                    |   4 +-
 sfc.c                        |   7 +-
 sff-common.c                 |   6 +-
 sff-common.h                 |   9 +-
 sfpdiag.c                    |  67 +++---
 sfpid.c                      | 151 +++++++------
 stmmac.c                     |   5 +-
 test-cmdline.c               |   5 +-
 test-common.c                |  14 +-
 test-features.c              |   5 +-
 tse.c                        |   7 +-
 uapi/linux/ethtool.h         | 112 ++++++----
 uapi/linux/ethtool_netlink.h |   6 +-
 33 files changed, 961 insertions(+), 993 deletions(-)


base-commit: 3acf7eee7ade666289f98311befe334bb57d3765
-- 
2.31.1


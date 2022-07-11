Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F4B570A7C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiGKTQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGKTQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:16:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43F2167E7
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 12:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657566998; x=1689102998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t9wX0QlDLudHj5GUjPvRfRHzgwKh9jkuWBj8FrotkrE=;
  b=N50/mqowFPumysILQQ4Gu0QI0IoY0Xoh9UPrP+mTPs3MXi6tMFPtY8p4
   NHk9Wrd4BNFrijGAu847G4H4nW2joKUqlwuLuwKch4v6B1NgO86WkYIQ6
   LhAvVC7ZkEA2TTNsAcWzsugsdp21ui2adEGrqyU84be56yBQ1yZMfsfGF
   MLFMAJ6aWzCqaDR+3lFl+qnS7E+pmNrCB+TKsXbAok/VvXBWfIBHjvLsS
   S8yh9j5/5VCZWVa6KfSTjcrPkdeJFF9rvoDRErIChtL3Jx29MxUZwA4f2
   9imU8GoXVIbd9kVlkDWfxD2yzQREBpKvr1+4ige+OwOOeMFnjBntGwawQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="282300977"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="282300977"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="697742708"
Received: from eedeets-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.2.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:37 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/5] mptcp: Support changes to initial subflow priority
Date:   Mon, 11 Jul 2022 12:16:28 -0700
Message-Id: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates the in-kernel MPTCP path manager to allow changes to
subflow priority for the first subflow created for each MPTCP connection
(the one created with the MP_CAPABLE handshake).

Patches 1 and 2 do some refactoring to simplify the new functionality.

Patch 3 introduces the new feature to change the initial subflow
priority and send the MP_PRIO header on that subflow.

Patch 4 cleans up code related to tracking endpoint ids on the initial
subflow.

Patch 5 adds a selftest to confirm that subflow priorities are updated
as expected.


Paolo Abeni (5):
  mptcp: introduce and use mptcp_pm_send_ack()
  mptcp: address lookup improvements
  mptcp: allow the in kernel PM to set MPC subflow priority
  mptcp: more accurate MPC endpoint tracking
  selftests: mptcp: add MPC backup tests

 net/mptcp/pm_netlink.c                        | 129 ++++++++++--------
 net/mptcp/protocol.c                          |   2 +-
 net/mptcp/protocol.h                          |   2 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh |  30 ++++
 4 files changed, 105 insertions(+), 58 deletions(-)


base-commit: edb2c3476db9898a63fb5d0011ecaa43ebf46c9b
-- 
2.37.0


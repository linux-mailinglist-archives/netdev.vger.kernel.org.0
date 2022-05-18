Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C9D52C5F6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiERWGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiERWG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:06:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5091D865C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652911495; x=1684447495;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AaYAfdtSFmamX2nqp1xAEEDOlvserQ8afZnPYHX55DI=;
  b=d95pthpO1kI873tQbVFxKbpSnK6l56BT+T6qSsjoSYrKmykajWkLvqG/
   DZ16EATOujrZWubg6bBIzZiXX6YDMr8uiKC2NvDwVTI8S128ci/0n3FoG
   tb6yqyUivS4nI3UMzlvvm/VPpCozhAUJwEVux5WLB4FJ2T0iLOr1NY9pL
   FdposRs6RTxs2IiJ1v0RMX7brKqoW4T8AnfqFhyzkFJmDlNwQiuQ6W7qa
   aNvL4XZvSxrVpSAoVg2xBqz5/BA30gOUQJFM6EeRboYIwfTFebLX4Krld
   ea6hoFRjpqS3CRDmdy6RVG4FgNpP9m/fIi7ACIRPg5Ig4Lqu1pOteDGhD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270734204"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="270734204"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="598075431"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.18])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 15:04:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] mptcp: Miscellaneous fixes and a new test case
Date:   Wed, 18 May 2022 15:04:42 -0700
Message-Id: <20220518220446.209750-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1 and 3 remove helpers that were iterating over the subflow
connection list without proper locking. Iteration was not needed in
either case.

Patch 2 fixes handling of MP_FAIL timeout, checking for orphaned
subflows instead of using the MPTCP socket data lock and connection
state.

Patch 4 adds a test for MP_FAIL timeout using tc pedit to induce checksum
failures.

Geliang Tang (1):
  selftests: mptcp: add MP_FAIL reset testcase

Mat Martineau (2):
  mptcp: Check for orphaned subflow before handling MP_FAIL timer
  mptcp: Do not traverse the subflow connection list without lock

Paolo Abeni (1):
  mptcp: stop using the mptcp_has_another_subflow() helper

 net/mptcp/pm.c                                  |  9 +++------
 net/mptcp/protocol.c                            | 16 +---------------
 net/mptcp/protocol.h                            | 14 --------------
 net/mptcp/subflow.c                             | 15 +++++----------
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 10 ++++++++++
 5 files changed, 19 insertions(+), 45 deletions(-)


base-commit: a3641ca416a3da7cbeae5bcf1fc26ba9797a1438
-- 
2.36.1


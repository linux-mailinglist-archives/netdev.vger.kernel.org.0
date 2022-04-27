Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26C51258A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiD0WxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiD0WxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB0E2A262
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099810; x=1682635810;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PLYufhWqyIwZBwlpC1Chcv6QvN9N+oO+h0YIvk+N97s=;
  b=km9q/cv2aRmjJVRfok/mI5/jPQK9fsLp2IKPsgmlangxaOf8qmYuJk7h
   lpwh0NHZdpzYn8aeQW7a146Pm7jQiPrIGI6HSf0UIgldbuo5c1I8iAa+H
   TzPzM8JdOwOmM3kMcjJxbX1phKDBhVYiUMb5ZXQLmgVrldQHgDFUHSAs6
   +njqZEeYNJJax4sqZoAAnN9iPQZm5BpHMtWmKEJYiACWUTQs5AU1LhAhQ
   uBAmKnE9JC9g6CAnkaAJ9EGLOGClwntpXNodciPZF1Y4Qnl93udKKsuSz
   Hhfuz7vw8G+dE/9II+NzQnBTPfOy2C+IPpclR/c6dnTCadbiZV2ezDL1i
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265907641"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265907641"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="731049114"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.233.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/6] mptcp: Path manager mode selection
Date:   Wed, 27 Apr 2022 15:49:56 -0700
Message-Id: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP already has an in-kernel path manager (PM) to add and remove TCP
subflows associated with a given MPTCP connection. This in-kernel PM has
been designed to handle typical server-side use cases, but is not very
flexible or configurable for client devices that may have more
complicated policies to implement.

This patch series from the MPTCP tree is the first step toward adding a
generic-netlink-based API for MPTCP path management, which a privileged
userspace daemon will be able to use to control subflow
establishment. These patches add a per-namespace sysctl to select the
default PM type (in-kernel or userspace) for new MPTCP sockets. New
self-tests confirm expected behavior when userspace PM is selected but
there is no daemon available to handle existing MPTCP PM events.

Subsequent patch series (already staged in the MPTCP tree) will add the
generic netlink path management API.


Mat Martineau (6):
  mptcp: Remove redundant assignments in path manager init
  mptcp: Add a member to mptcp_pm_data to track kernel vs userspace mode
  mptcp: Bypass kernel PM when userspace PM is enabled
  mptcp: Make kernel path manager check for userspace-managed sockets
  mptcp: Add a per-namespace sysctl to set the default path manager type
  selftests: mptcp: Add tests for userspace PM type

 Documentation/networking/mptcp-sysctl.rst     | 18 +++++
 net/mptcp/ctrl.c                              | 21 ++++++
 net/mptcp/pm.c                                | 50 +++++++++-----
 net/mptcp/pm_netlink.c                        | 30 ++++-----
 net/mptcp/protocol.h                          | 16 ++++-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 66 +++++++++++++++++++
 6 files changed, 167 insertions(+), 34 deletions(-)


base-commit: 03fa8fc93e443e6caa485cc741328a1386c63630
-- 
2.36.0


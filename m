Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE2510B93
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 23:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355588AbiDZWAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355593AbiDZWAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:00:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFE24C7B4
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 14:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651010243; x=1682546243;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UKn5ULvisIai/X6auQ0IUQyugeeIAu6qCezwwW+QMj4=;
  b=eCJDZ3jnUo3lrL0V6yaLcUBNu+HKoiuT0vTHYVeWCXDEthLUQzXAglnV
   2TByF0XdnjLvbPYp4pGIkaRVpedufgl/oOaz85muFsxPbGTMHyIZvDIiT
   z5lYnc4QxprXye+wfTKS60/NBJYQk4VdMmr312U4aN82k28FKCUVRQ0DN
   X9DNJjpb/t/PDb4xb19AJz4/IH/SQ2DJygon7jvnxeLtLpimQw+1MkjC+
   T3BehkI5picvHJVlHGksGC07+OT+NOazIIc1dSBjpBpugMTyUyjVQo7iq
   3njbaDUmz+xbjgUbQ+RorTCxmAr/mGYy9OpHPlAlOb1THOAhqNC7W9KCl
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="352172420"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="352172420"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 14:57:23 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="532878093"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.10.176])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 14:57:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/7] mptcp: Timeout for MP_FAIL response
Date:   Tue, 26 Apr 2022 14:57:10 -0700
Message-Id: <20220426215717.129506-1-mathew.j.martineau@linux.intel.com>
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

When one peer sends an infinite mapping to coordinate fallback from
MPTCP to regular TCP, the other peer is expected to send a packet with
the MPTCP MP_FAIL option to acknowledge the infinite mapping. Rather
than leave the connection in some half-fallback state, this series adds
a timeout after which the infinite mapping sender will reset the
connection.

Patch 1 adds a fallback self test.

Patches 2-5 make use of the MPTCP socket's retransmit timer to reset the
MPTCP connection if no MP_FAIL was received.

Patches 6 and 7 extends the self test to check MP_FAIL-related MIBs.

Geliang Tang (7):
  selftests: mptcp: add infinite map testcase
  mptcp: use mptcp_stop_timer
  mptcp: add data lock for sk timers
  mptcp: add MP_FAIL response support
  mptcp: reset subflow when MP_FAIL doesn't respond
  selftests: mptcp: check MP_FAIL response mibs
  selftests: mptcp: print extra msg in chk_csum_nr

 net/mptcp/pm.c                                |  18 ++-
 net/mptcp/protocol.c                          |  64 +++++++++-
 net/mptcp/protocol.h                          |   2 +
 net/mptcp/subflow.c                           |  13 ++
 tools/testing/selftests/net/mptcp/config      |   8 ++
 .../testing/selftests/net/mptcp/mptcp_join.sh | 119 +++++++++++++++++-
 6 files changed, 216 insertions(+), 8 deletions(-)


base-commit: 561215482cc69d1c758944d4463b3d5d96d37bd1
-- 
2.36.0


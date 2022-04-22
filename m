Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6147A50C3E5
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiDVWb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiDVWav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:30:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2747A23F363
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650664549; x=1682200549;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=21xEP8av6DL8u+JJ2vUv8Ig2n+logWsNBtL3SHSq7eQ=;
  b=jBEtPxdc/1k4PjpbDopdqnpudoqXrS0w8kyeGuTFQts7kgHubuysBZ+i
   0MDk4eBDEb42CoetxajMqGoAykHEya4EjTPtieE6qAtnhIuITHi3F1fm8
   zFAWcmVMg4l6yhSC11/iQ5ckkvMUmWvoPZE9t46qgq9COP891S7cp5jIR
   bP+wdh7NbiKSP3FFxKFNLwq/fMskaeuCfTdotMQz6sKd0cAjlw3HOMxAO
   doJK5rQionh/XRLYY2mYnEWusXB1m8b3WnelLPr06j8CwnfmO7XkhDsHr
   El8DRYP3iTO2MtEOzWzSaKLQQD5YxLJUwLOsnP8zpk9Zfsu5A4JVQeHgF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264285975"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264285975"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578119254"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.99.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/8] mptcp: TCP fallback for established connections
Date:   Fri, 22 Apr 2022 14:55:35 -0700
Message-Id: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684 allows some MPTCP connections to fall back to regular TCP when
the MPTCP DSS checksum detects middlebox interference, there is only a
single subflow, and there is no unacknowledged out-of-sequence
data. When this condition is detected, the stack sends a MPTCP DSS
option with an "infinite mapping" to signal that a fallback is
happening, and the peers will stop sending MPTCP options in their TCP
headers. The Linux MPTCP stack has not yet supported this type of
fallback, instead closing the connection when the MPTCP checksum fails.

This series adds support for fallback to regular TCP in a more limited
scenario, for only MPTCP connections that have never connected
additional subflows or transmitted out-of-sequence data. The selftests
are also updated to check new MIBs that track infinite mappings.


Geliang Tang (8):
  mptcp: don't send RST for single subflow
  mptcp: add the fallback check
  mptcp: track and update contiguous data status
  mptcp: infinite mapping sending
  mptcp: infinite mapping receiving
  mptcp: add mib for infinite map sending
  mptcp: dump infinite_map field in mptcp_dump_mpext
  selftests: mptcp: add infinite map mibs check

 include/net/mptcp.h                           |  3 +-
 include/trace/events/mptcp.h                  |  6 +-
 net/mptcp/mib.c                               |  1 +
 net/mptcp/mib.h                               |  1 +
 net/mptcp/options.c                           |  8 ++-
 net/mptcp/pm.c                                |  6 ++
 net/mptcp/protocol.c                          | 21 +++++++
 net/mptcp/protocol.h                          | 13 +++++
 net/mptcp/subflow.c                           | 57 +++++++++++--------
 .../testing/selftests/net/mptcp/mptcp_join.sh | 36 +++++++++++-
 10 files changed, 121 insertions(+), 31 deletions(-)


base-commit: c78c5a660439d4d341a03b651541fda3ebe76160
-- 
2.36.0


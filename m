Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60855CA4A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbiF1BDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242975AbiF1BCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:51 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0599822B2E
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656378170; x=1687914170;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7F1GksiUh4GGU6rpDDIpWzHMHRJPzh4VbbxMJ3QTtpQ=;
  b=RFbKoC9D8aQhBai29hrebUbh0zzxz99XfUFGqSy29WQwVWeNdZSbxdGm
   HVEcAHcfclLHHTZojW6v61IvsG/CjxXmDmrHz2tIAVdIhR1mou10v5Cs8
   laBAc7FstJI6ov8AkKcdhQE1pKk4dxTK6bP8aaueyA+7XkVU8oeIUsuMP
   bubqtiV/qyByEcTHg7FyJne9cpH9dB3lQw42VmU1uT2yudvs6LxWcchck
   0zC59eERdoLZDmInV3pz0imST0j/l/L/+jj8eqCGW2WXcLAjE4Yl8Rai3
   8ZS65yjMtYzwykBC1oEurYPtn9xCtA0cZhXm72BkqwXUVeE8Kp/BVKpwA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264642442"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264642442"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="692867356"
Received: from cgarner-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.0.217])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net 0/9] mptcp: Fixes for 5.19
Date:   Mon, 27 Jun 2022 18:02:34 -0700
Message-Id: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several categories of fixes from the mptcp tree:

Patches 1-3 are fixes related to MP_FAIL and FASTCLOSE, to make sure
MIBs are accurate, and to handle MP_FAIL transmission and responses at
the correct times. sk_timer conflicts are also resolved.

Patches 4 and 6 handle two separate race conditions, one at socket
shutdown and one with unaccepted subflows.

Patch 5 makes sure read operations are not blocked during fallback to
TCP.

Patch 7 improves the diag selftest, which were incorrectly failing on
slow machines (like the VMs used for CI testing).

Patch 8 avoids possible symbol redefinition errors in the userspace
mptcp.h file.

Patch 9 fixes a selftest build issue with gcc 12.

Geliang Tang (1):
  mptcp: invoke MP_FAIL response when needed

Mat Martineau (1):
  selftests: mptcp: Initialize variables to quiet gcc 12 warnings

Ossama Othman (1):
  mptcp: fix conflict with <netinet/in.h>

Paolo Abeni (6):
  mptcp: fix error mibs accounting
  mptcp: introduce MAPPING_BAD_CSUM
  mptcp: fix shutdown vs fallback race
  mptcp: consistent map handling on failure
  mptcp: fix race on unaccepted mptcp sockets
  selftests: mptcp: more stable diag tests

 include/uapi/linux/mptcp.h                    |   9 +-
 net/mptcp/options.c                           |   7 +-
 net/mptcp/pm.c                                |  10 +-
 net/mptcp/protocol.c                          |  84 +++++++-----
 net/mptcp/protocol.h                          |  24 +++-
 net/mptcp/subflow.c                           | 127 ++++++++++++++----
 tools/testing/selftests/net/mptcp/diag.sh     |  48 +++++--
 .../selftests/net/mptcp/mptcp_connect.c       |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c |   2 +-
 .../selftests/net/mptcp/mptcp_sockopt.c       |   2 +-
 10 files changed, 227 insertions(+), 88 deletions(-)


base-commit: cb8092d70a6f5f01ec1490fce4d35efed3ed996c
-- 
2.37.0


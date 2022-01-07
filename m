Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729C8486EA5
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344036AbiAGAUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:47987 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344032AbiAGAUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514842; x=1673050842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XS9HOJad0xzPcWJfD8W7uMV6wOTUVS5GlNTngup38us=;
  b=jEXNAlzfFP8ZevyVs9uuMB1MOCewvNmY85n61BqJr0Q0Fbv5pKg00V2A
   C2ijKBU32eSZyM/5TDtYVplw/B1LKFcfTFiMlpBkniTsgWIf/bES0ZxS4
   Lbct+qqs9IKZ98iHHtdqAKhp5+G1m8I/id3v2GtRFTr1WZuITDb1LVDZb
   ErGENFuDL/ja5c9o8UjOkHyqcSGu4YNt0noFHujsiMoLJe7FsrKC2x6Ep
   Bgsa327AiSwyUw8L4BHVHg9/zh3qwbIieGX6sJ5qqaZqNyZxbqZWpuGqb
   JOdvzubgdsRCoiBpQQsdZ/ydJ4GQ9O4Ni3ZwBoieEphMt3ZrVBGz3DHjj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721299"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721299"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508489"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 00/13] mptcp: New features and cleanup
Date:   Thu,  6 Jan 2022 16:20:13 -0800
Message-Id: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches have been tested in the MPTCP tree for a longer than usual
time (thanks to holiday schedules), and are ready for the net-next
branch. Changes include feature updates, small fixes, refactoring, and
some selftest changes.

Patch 1 fixes an OUTQ ioctl issue with TCP fallback sockets.

Patches 2, 3, and 6 add support of the MPTCP fastclose option (quick
shutdown of the full MPTCP connection, similar to TCP RST in regular
TCP), and a related self test.

Patch 4 cleans up some accept and poll code that is no longer needed
after the fastclose changes.

Patch 5 add userspace disconnect using AF_UNSPEC, which is used when
testing fastclose and makes the MPTCP socket's handling of AF_UNSPEC in
connect() more TCP-like.

Patches 7-11 refactor subflow creation to make better use of multiple
local endpoints and to better handle individual connection failures when
creating multiple subflows. Includes self test updates.

Patch 12 cleans up the way subflows are added to the MPTCP connection
list, eliminating the need for calls throughout the MPTCP code that had
to check the intermediate "join list" for entries to shift over to the
main "connection list".

Patch 13 refactors the MPTCP release_cb flags to use separate storage
for values only accessed with the socket lock held (no atomic ops
needed), and for values that need atomic operations.


Paolo Abeni (13):
  mptcp: keep snd_una updated for fallback socket
  mptcp: implement fastclose xmit path
  mptcp: full disconnect implementation
  mptcp: cleanup accept and poll
  mptcp: implement support for user-space disconnect
  selftests: mptcp: add disconnect tests
  mptcp: fix per socket endpoint accounting
  mptcp: clean-up MPJ option writing
  mptcp: keep track of local endpoint still available for each msk
  mptcp: do not block subflows creation on errors
  selftests: mptcp: add tests for subflow creation failure
  mptcp: cleanup MPJ subflow list handling
  mptcp: avoid atomic bit manipulation when possible

 net/mptcp/options.c                           | 101 ++++--
 net/mptcp/pm.c                                |  34 +-
 net/mptcp/pm_netlink.c                        | 197 ++++++-----
 net/mptcp/protocol.c                          | 307 ++++++++++--------
 net/mptcp/protocol.h                          |  63 ++--
 net/mptcp/sockopt.c                           |  24 +-
 net/mptcp/subflow.c                           |  10 +-
 net/mptcp/token.c                             |   1 +
 tools/testing/selftests/net/mptcp/config      |   1 +
 .../selftests/net/mptcp/mptcp_connect.c       | 148 +++++++--
 .../selftests/net/mptcp/mptcp_connect.sh      |  39 ++-
 .../testing/selftests/net/mptcp/mptcp_join.sh |  83 ++++-
 12 files changed, 683 insertions(+), 325 deletions(-)


base-commit: 710ad98c363a66a0cd8526465426c5c5f8377ee0
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352A83F5550
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhHXBGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:06:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:62117 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234664AbhHXBGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 21:06:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204346748"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204346748"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:49 -0700
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="515224393"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.11.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, liyonglong@chinatelecom.cn
Subject: [PATCH net-next 0/6] mptcp: Refactor ADD_ADDR/RM_ADDR handling
Date:   Mon, 23 Aug 2021 18:05:38 -0700
Message-Id: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set changes the way MPTCP ADD_ADDR and RM_ADDR options are
handled to improve the reliability of sending and updating address
advertisements. The information used to populate outgoing advertisement
option headers is now stored separately to avoid rare cases where a more
recent request would overwrite something that had not been sent
yet. While the peers would recover from this, it's better to avoid the
problem in the first place.


Patch 1 moves an advertisement option check under a lock so the changes
made in the next several patches will not introduce a race.

Patches 2-4 make sure ADD_ADDR, ADD_ADDR echo, and RM_ADDR options use
separate flags and data.

Patch 5 removes some now-redundant flags.

Patch 6 adds a selftest that confirms the advertisement reliability
improvements.


Yonglong Li (6):
  mptcp: move drop_other_suboptions check under pm lock
  mptcp: make MPTCP_ADD_ADDR_SIGNAL and MPTCP_ADD_ADDR_ECHO separate
  mptcp: fix ADD_ADDR and RM_ADDR maybe flush addr_signal each other
  mptcp: build ADD_ADDR/echo-ADD_ADDR option according pm.add_signal
  mptcp: remove MPTCP_ADD_ADDR_IPV6 and MPTCP_ADD_ADDR_PORT
  selftests: mptcp: add_addr and echo race test

 net/mptcp/options.c                           | 28 ++++-----
 net/mptcp/pm.c                                | 58 +++++++++++++------
 net/mptcp/pm_netlink.c                        | 10 ++--
 net/mptcp/protocol.h                          | 24 ++++----
 .../testing/selftests/net/mptcp/mptcp_join.sh | 15 +++++
 5 files changed, 83 insertions(+), 52 deletions(-)


base-commit: f6a4e0e8a00ff6fadb29f3646ccd33cc85195a38
-- 
2.33.0


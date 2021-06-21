Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224F73AF8D4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhFUW47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:56:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:11255 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhFUW45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:56:57 -0400
IronPort-SDR: EmPCShlIbOA3M6Kvu7AamMKLANM6uHmmTi4GbjRL2wO1j1BTRSJLDtArzq2sIc5ShloaB4PAAz
 mKI8BqOha3rw==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768514"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768514"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
IronPort-SDR: 81HSb9rpE4RxTd+OSN4ywgZoI/EXSn4qGwKmfDnQfD1MjXucKDLpiO7nVi15Ez6UeBY3sDAhyF
 rKb0bfwUiZSg==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673967"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com
Subject: [PATCH net-next 0/6] mptcp: A few optimizations
Date:   Mon, 21 Jun 2021 15:54:32 -0700
Message-Id: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is a set of patches that we've accumulated and tested in the MPTCP
tree.


Patch 1 removes the MPTCP-level tx skb cache that added complexity but
did not provide a meaningful benefit.

Patch 2 uses the fast socket lock in more places.

Patch 3 improves handling of a data-ready flag.

Patch 4 deletes an unnecessary and racy connection state check.

Patch 5 adds a MIB counter for one type of invalid MPTCP header.

Patch 6 improves self test failure output.


Matthieu Baerts (1):
  selftests: mptcp: display proper reason to abort tests

Paolo Abeni (5):
  mptcp: drop tx skb cache
  mptcp: use fast lock for subflows when possible
  mptcp: don't clear MPTCP_DATA_READY in sk_wait_event()
  mptcp: drop redundant test in move_skbs_to_msk()
  mptcp: add MIB counter for invalid mapping

 net/mptcp/mib.c                               |   1 +
 net/mptcp/mib.h                               |   1 +
 net/mptcp/pm_netlink.c                        |  10 +-
 net/mptcp/protocol.c                          | 113 +++---------------
 net/mptcp/protocol.h                          |   2 -
 net/mptcp/subflow.c                           |   4 +-
 .../selftests/net/mptcp/mptcp_connect.sh      |  52 +++++---
 7 files changed, 62 insertions(+), 121 deletions(-)


base-commit: ef2c3ddaa4ed0b1d9de34378d08d3e24a3fec7ac
-- 
2.32.0


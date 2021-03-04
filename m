Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD632DBD9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbhCDVea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:34:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:5219 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237314AbhCDVeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:34:08 -0500
IronPort-SDR: bDUer5CM68Z9MBd6OKThCtRtNSA46suDFgAiTZaN4rEB0VGe2cW0rxkv7Z8fbWa5f5rXjaZuVU
 uGy+x9Fq8Q1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769404"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769404"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:22 -0800
IronPort-SDR: R+KIm55i0bTOcoU+wzGETFZrYYeip4GywHOObzMHusFmO5LUIhEuAP9m6Q98WiaVIVp+c6iCPB
 44wG00sP9hIw==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329475"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.01.org
Subject: [PATCH net 0/9] mptcp: Fixes for v5.12
Date:   Thu,  4 Mar 2021 13:32:07 -0800
Message-Id: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches from the MPTCP tree fix a few multipath TCP issues:


Patches 1 and 5 clear some stale pointers when subflows close.

Patches 2, 4, and 9 plug some memory leaks.

Patch 3 fixes a memory accounting error identified by syzkaller.

Patches 6 and 7 fix a race condition that slowed data transmission.

Patch 8 adds missing wakeups when write buffer space is freed.


Florian Westphal (4):
  mptcp: reset last_snd on subflow close
  mptcp: put subflow sock on connect error
  mptcp: dispose initial struct socket when its subflow is closed
  mptcp: reset 'first' and ack_hint on subflow close

Geliang Tang (1):
  mptcp: free resources when the port number is mismatched

Paolo Abeni (4):
  mptcp: fix memory accounting on allocation error
  mptcp: factor out __mptcp_retrans helper()
  mptcp: fix race in release_cb
  mptcp: fix missing wakeup

 net/mptcp/protocol.c | 165 +++++++++++++++++++++++++++----------------
 net/mptcp/subflow.c  |  14 ++--
 2 files changed, 112 insertions(+), 67 deletions(-)


base-commit: a9ecb0cbf03746b17a7c13bd8e3464e6789f73e8
-- 
2.30.1


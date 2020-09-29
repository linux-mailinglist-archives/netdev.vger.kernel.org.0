Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DDF27DB6F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgI2WI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:08:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:6058 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgI2WI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:08:27 -0400
IronPort-SDR: /rCvvXtiOTECr4+JJI+30l0gfi8NJoXB4RNkbmIPmieFWdbWDgj0M6fFJe84TTPZnLuF+yuy1w
 B2ZajTkqBW3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223900087"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="223900087"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:08:26 -0700
IronPort-SDR: AgCDbInYzArql5Ou/+6zTxHvQ+oCZR7AVukgAhaYNMgoyPtFhGwv+WOEi21Oa6uw/I8uV0cngO
 WEDwHwFz2fcg==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="312368803"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.88.125])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:08:25 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, pabeni@redhat.com
Subject: [PATCH net 0/2] mptcp: Fix for 32-bit DATA_FIN
Date:   Tue, 29 Sep 2020 15:08:18 -0700
Message-Id: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The main fix is contained in patch 2, and that commit message explains
the issue with not properly converting truncated DATA_FIN sequence
numbers sent by the peer.

With patch 2 adding an unlocked read of msk->ack_seq, patch 1 cleans up
access to that data with READ_ONCE/WRITE_ONCE.


This does introduce two merge conflicts with net-next, but both have
straightforward resolution. Patch 1 modifies a line that got removed in
net-next so the modification can be dropped when merging. Patch 2 will
require a trivial conflict resolution for a modified function
declaration.


Mat Martineau (2):
  mptcp: Consistently use READ_ONCE/WRITE_ONCE with msk->ack_seq
  mptcp: Handle incoming 32-bit DATA_FIN values

 net/mptcp/options.c  | 11 ++++++-----
 net/mptcp/protocol.c |  8 ++++----
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  | 16 +++++++++++++---
 4 files changed, 24 insertions(+), 13 deletions(-)


base-commit: c92a79829c7c169139874aa1d4bf6da32d10c38a
-- 
2.28.0


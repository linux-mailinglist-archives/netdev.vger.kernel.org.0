Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455BF23155F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgG1WMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:2588 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgG1WMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:14 -0400
IronPort-SDR: dC8tRpuMbmzlVr2I65FccmfafO8Ql97fvrdZb1ykWmeSirlZtgXnlN1M6AQe6GBb/dEaHnBTjL
 aZ447cVdn01w==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342666"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342666"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:13 -0700
IronPort-SDR: Su7GEUgtuTdyek5OW+A/VOWAWpWjMpA872bCNZwsVR6SWlsrd9soAjNkErRwKWrFH2DnkYhhoW
 l1V8wNjsyu5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468875"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 00/12] Exchange MPTCP DATA_FIN/DATA_ACK before TCP FIN
Date:   Tue, 28 Jul 2020 15:11:58 -0700
Message-Id: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows the MPTCP-level connection to be closed with the
peers exchanging DATA_FIN and DATA_ACK according to the state machine in
appendix D of RFC 8684. The process is very similar to the TCP
disconnect state machine. 

The prior code sends DATA_FIN only when TCP FIN packets are sent, and
does not allow for the MPTCP-level connection to be half-closed.

Patch 8 ("mptcp: Use full MPTCP-level disconnect state machine") is the
core of the series. Earlier patches in the series have some small fixes
and helpers in preparation, and the final four small patches do some
cleanup.


Mat Martineau (12):
  mptcp: Allow DATA_FIN in headers without TCP FIN
  mptcp: Return EPIPE if sending is shut down during a sendmsg
  mptcp: Remove outdated and incorrect comment
  mptcp: Use MPTCP-level flag for sending DATA_FIN
  mptcp: Track received DATA_FIN sequence number and add related helpers
  mptcp: Add mptcp_close_state() helper
  mptcp: Add helper to process acks of DATA_FIN
  mptcp: Use full MPTCP-level disconnect state machine
  mptcp: Only use subflow EOF signaling on fallback connections
  mptcp: Skip unnecessary skb extension allocation for bare acks
  mptcp: Safely read sequence number when lock isn't held
  mptcp: Safely store sequence number when sending data

 net/mptcp/options.c  |  57 +++++++--
 net/mptcp/protocol.c | 295 ++++++++++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h |   6 +-
 net/mptcp/subflow.c  |  14 +-
 4 files changed, 306 insertions(+), 66 deletions(-)


base-commit: 0003041e7a0bf24594e5d66fe217bbbefdac44ab
-- 
2.28.0


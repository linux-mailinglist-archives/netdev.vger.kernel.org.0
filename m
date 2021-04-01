Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE2352354
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhDAXTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:19:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:18940 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234850AbhDAXTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:19:53 -0400
IronPort-SDR: 4IyUqnDE7f40EHpw1iKwgBixkXEwC1RGvMo8PgcvbEbemMszep1d6++24GzUPAmn2dEtwv8Ial
 eX0r8nrY9UtA==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191829881"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="191829881"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:53 -0700
IronPort-SDR: DXN6dwrGaOqhNBgjaIECa0VeQkB1sHgL1L/fA+wkk68G+Dgpbr8gkRinkjkYM9D3joK4jwzxOW
 YlH0KHiY1Hdg==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="446269194"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.128.105])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:53 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/7] mptcp: remove unneeded check on first subflow
Date:   Thu,  1 Apr 2021 16:19:43 -0700
Message-Id: <20210401231947.162836-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
References: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently we explicitly check for the first subflow being
NULL in a couple of places, even if we don't need any
special actions in such scenario.

Just drop the unneeded checks, to avoid confusion.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 2 +-
 net/mptcp/protocol.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 69cafaacc31b..68361d28dc67 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -952,7 +952,7 @@ bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool us
 	 * should match. If they mismatch, the peer is misbehaving and
 	 * we will prefer the most recent information.
 	 */
-	if (READ_ONCE(msk->rcv_data_fin) || !READ_ONCE(msk->first))
+	if (READ_ONCE(msk->rcv_data_fin))
 		return false;
 
 	WRITE_ONCE(msk->rcv_data_fin_seq,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0c916d48cad8..531ee24aa827 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -493,7 +493,7 @@ static bool mptcp_check_data_fin(struct sock *sk)
 	u64 rcv_data_fin_seq;
 	bool ret = false;
 
-	if (__mptcp_check_fallback(msk) || !msk->first)
+	if (__mptcp_check_fallback(msk))
 		return ret;
 
 	/* Need to ack a DATA_FIN received from a peer while this side
-- 
2.31.1


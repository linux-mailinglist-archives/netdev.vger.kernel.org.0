Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C893196B1
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhBKXfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:35:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:55189 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBKXfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:35:17 -0500
IronPort-SDR: 6I8jL51i1reMipNtH/UT53I2cnhBkyuz492uuc1Kp5Ti9Wo8r39EOyjsQejs4lmB6puBw90QZq
 lmGbbJBCUvig==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177944"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177944"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:50 -0800
IronPort-SDR: swVc6EDMBVGlpt7llyEv0zWsTfbD5uW9k+Hozh6JAAN/O58MbWfqfuMlRDQkmXwzLfWLIsdhGX
 pa8myOcPyjNQ==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226391"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:50 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 6/6] mptcp: add a missing retransmission timer scheduling
Date:   Thu, 11 Feb 2021 15:30:42 -0800
Message-Id: <20210211233042.304878-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently we do not schedule the MPTCP retransmission
timer after pushing the data when such action happens
in the subflow context.

This may cause hang-up on active-backup scenarios, or
even when only single subflow msks are involved, if we lost
some peer's ack.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 3 +--
 net/mptcp/protocol.c | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 82a37cc26776..8fec3dabe109 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -880,8 +880,7 @@ static void ack_update_msk(struct mptcp_sock *msk,
 		msk->wnd_end = new_wnd_end;
 
 	/* this assumes mptcp_incoming_options() is invoked after tcp_ack() */
-	if (after64(msk->wnd_end, READ_ONCE(msk->snd_nxt)) &&
-	    sk_stream_memory_free(ssk))
+	if (after64(msk->wnd_end, READ_ONCE(msk->snd_nxt)))
 		__mptcp_check_push(sk, ssk);
 
 	if (after64(new_snd_una, old_snd_una)) {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0dbf5cbd7e56..06da6ad31c87 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1582,6 +1582,9 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 		mptcp_set_timeout(sk, ssk);
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
+		if (!mptcp_timer_pending(sk))
+			mptcp_reset_timer(sk);
+
 		if (msk->snd_data_fin_enable &&
 		    msk->snd_nxt + 1 == msk->write_seq)
 			mptcp_schedule_work(sk);
-- 
2.30.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9673AF8D6
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhFUW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:57:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:11255 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232064AbhFUW5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:57:01 -0400
IronPort-SDR: BkzTuHcDtExoM/fw73//2fp8J9xVWdzJtGQoBxDfBSyC+jZK6xDMQ9ZzPjkOssGfrAkHHY1Wux
 4WEBsEutEzvQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768519"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768519"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
IronPort-SDR: JETIo+o+XHnaU103DvAb4XUSHtFklFsORi+3HR5U9Li7VRDX9P3WRDLS/syn810Pq6Tb0P22ts
 tczt537G6fyg==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673971"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/6] mptcp: don't clear MPTCP_DATA_READY in sk_wait_event()
Date:   Mon, 21 Jun 2021 15:54:35 -0700
Message-Id: <20210621225438.10777-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
References: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If we don't flush entirely the receive queue, we need set
again such bit later. We can simply avoid clearing it.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c47ce074737d..3e088e9d20fd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1715,7 +1715,7 @@ static void mptcp_wait_data(struct sock *sk, long *timeo)
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 
 	sk_wait_event(sk, timeo,
-		      test_and_clear_bit(MPTCP_DATA_READY, &msk->flags), &wait);
+		      test_bit(MPTCP_DATA_READY, &msk->flags), &wait);
 
 	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 	remove_wait_queue(sk_sleep(sk), &wait);
@@ -2039,10 +2039,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		 */
 		if (unlikely(__mptcp_move_skbs(msk)))
 			set_bit(MPTCP_DATA_READY, &msk->flags);
-	} else if (unlikely(!test_bit(MPTCP_DATA_READY, &msk->flags))) {
-		/* data to read but mptcp_wait_data() cleared DATA_READY */
-		set_bit(MPTCP_DATA_READY, &msk->flags);
 	}
+
 out_err:
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD01523156B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgG1WMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:2588 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgG1WMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:15 -0400
IronPort-SDR: c6HQuTTkWBa1U+bizhVIPfgRMsK0UyJw1voNHsfooQeIFabTYs12hkyjDoiztQE1M6vXLftyz5
 3nMKt1PK069g==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342673"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342673"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:13 -0700
IronPort-SDR: qGPSZeptvBctBvkmIru8akZEDyIyMOY2/Sr6s1YNuzGpSFpNVVVUw84L0wUGXOAfcWRbMUoKcK
 jLM/jrO47ohg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468880"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:13 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 02/12] mptcp: Return EPIPE if sending is shut down during a sendmsg
Date:   Tue, 28 Jul 2020 15:12:00 -0700
Message-Id: <20200728221210.92841-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A MPTCP socket where sending has been shut down should not attempt to
send additional data, since DATA_FIN has already been sent.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2891ae8a1028..b3c3dbc89b3f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -748,6 +748,11 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 restart:
 	mptcp_clean_una(sk);
 
+	if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN)) {
+		ret = -EPIPE;
+		goto out;
+	}
+
 wait_for_sndbuf:
 	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
-- 
2.28.0


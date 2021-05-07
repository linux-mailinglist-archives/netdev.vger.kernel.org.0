Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C21D375DD4
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhEGARo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:17:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:5041 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhEGARo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:17:44 -0400
IronPort-SDR: OH3loR979EZROYaYW1MQ9BTEvHTg5II7o/13kgyNX4f9gz1NMbglZaOGkQs5pJMQPSYIExbJKY
 iPXr0sFR8mKA==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="198664145"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="198664145"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 17:16:43 -0700
IronPort-SDR: Cmje+R+0xIyzi/0fLQnmPLZ2EZzjoWZxJLCqI9Z2I6ENWIcSnW5T0H1eQhpAQLPLFMvyqEehwB
 BuTvC90JgwSA==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="434644838"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.15.233])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 17:16:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net] mptcp: fix splat when closing unaccepted socket
Date:   Thu,  6 May 2021 17:16:38 -0700
Message-Id: <20210507001638.225468-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If userspace exits before calling accept() on a listener that had at least
one new connection ready, we get:

   Attempt to release TCP socket in state 8

This happens because the mptcp socket gets cloned when the TCP connection
is ready, but the socket is never exposed to userspace.

The client additionally sends a DATA_FIN, which brings connection into
CLOSE_WAIT state.  This in turn prevents the orphan+state reset fixup
in mptcp_sock_destruct() from doing its job.

Fixes: 3721b9b64676b ("mptcp: Track received DATA_FIN sequence number and add related helpers")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/185
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 82e91b00ad39..a5ede357cfbc 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -546,8 +546,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 	 * ESTABLISHED state and will not have the SOCK_DEAD flag.
 	 * Both result in warnings from inet_sock_destruct.
 	 */
-
-	if (sk->sk_state == TCP_ESTABLISHED) {
+	if ((1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
 		sk->sk_state = TCP_CLOSE;
 		WARN_ON_ONCE(sk->sk_socket);
 		sock_orphan(sk);

base-commit: 8621436671f3a4bba5db57482e1ee604708bf1eb
-- 
2.31.1


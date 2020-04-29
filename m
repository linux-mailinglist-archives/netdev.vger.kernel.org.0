Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07BF1BE67B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgD2Sne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727087AbgD2Snd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:43:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0E7C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:43:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jTrgA-00007C-2C; Wed, 29 Apr 2020 20:43:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] mptcp: replace mptcp_disconnect with a stub
Date:   Wed, 29 Apr 2020 20:43:20 +0200
Message-Id: <20200429184320.30733-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo points out that mptcp_disconnect is bogus:
"lock_sock(sk);
looks suspicious (lock should be already held by the caller)
And call to: tcp_disconnect(sk, flags); too, sk is not a tcp
socket".

->disconnect() gets called from e.g. inet_stream_connect when
one tries to disassociate a connected socket again (to re-connect
without closing the socket first).
MPTCP however uses mptcp_stream_connect, not inet_stream_connect,
for the mptcp-socket connect call.

inet_stream_connect only gets called indirectly, for the tcp socket,
so any ->disconnect() calls end up calling tcp_disconnect for that
tcp subflow sk.

This also explains why syzkaller has not yet reported a problem
here.  So for now replace this with a stub that doesn't do anything.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/14
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b22a63ba2348..6e0188f5d3f3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1316,11 +1316,12 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
-	lock_sock(sk);
-	__mptcp_clear_xmit(sk);
-	release_sock(sk);
-	mptcp_cancel_work(sk);
-	return tcp_disconnect(sk, flags);
+	/* Should never be called.
+	 * inet_stream_connect() calls ->disconnect, but that
+	 * refers to the subflow socket, not the mptcp one.
+	 */
+	WARN_ON_ONCE(1);
+	return 0;
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-- 
2.26.2


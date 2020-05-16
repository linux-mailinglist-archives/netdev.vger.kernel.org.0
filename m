Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2D41D5FC5
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgEPIsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:48:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3429CC061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:48:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsUA-0005uN-Tp; Sat, 16 May 2020 10:47:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 6/7] mptcp: remove inner wait loop from mptcp_sendmsg_frag
Date:   Sat, 16 May 2020 10:46:22 +0200
Message-Id: <20200516084623.28453-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

previous patches made sure we only call into this function
when these prerequisites are met, so no need to wait on the
subflow socket anymore.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/7
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a11e51222e59..bc950cf818f7 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -510,20 +510,6 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 * fooled into a warning if we don't init here
 	 */
 	pfrag = sk_page_frag(sk);
-	while ((!retransmission && !mptcp_page_frag_refill(ssk, pfrag)) ||
-	       !mptcp_ext_cache_refill(msk)) {
-		ret = sk_stream_wait_memory(ssk, timeo);
-		if (ret)
-			return ret;
-
-		/* if sk_stream_wait_memory() sleeps snd_una can change
-		 * significantly, refresh the rtx queue
-		 */
-		mptcp_clean_una(sk);
-
-		if (unlikely(__mptcp_needs_tcp_fallback(msk)))
-			return 0;
-	}
 	if (!retransmission) {
 		write_seq = &msk->write_seq;
 		page = pfrag->page;
-- 
2.26.2


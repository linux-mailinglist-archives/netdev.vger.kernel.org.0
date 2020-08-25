Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E252425242B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHYXbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgHYXbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:31:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A930DC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:31:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAiPF-0006FU-Qq; Wed, 26 Aug 2020 01:31:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net] mptcp: free acked data before waiting for more memory
Date:   Wed, 26 Aug 2020 01:31:05 +0200
Message-Id: <20200825233105.15172-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After subflow lock is dropped, more wmem might have been made available.

This fixes a deadlock in mptcp_connect.sh 'mmap' mode: wmem is exhausted.
But as the mptcp socket holds on to already-acked data (for retransmit)
no wakeup will occur.

Using 'goto restart' calls mptcp_clean_una(sk) which will free pages
that have been acked completely in the mean time.

Fixes: fb529e62d3f3 ("mptcp: break and restart in case mptcp sndbuf is full")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1aad411a0e46..8ccd4a151dcb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -892,7 +892,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto out;
 	}
 
-wait_for_sndbuf:
 	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
 	while (!sk_stream_memory_free(sk) ||
@@ -982,7 +981,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 				 */
 				mptcp_set_timeout(sk, ssk);
 				release_sock(ssk);
-				goto wait_for_sndbuf;
+				goto restart;
 			}
 		}
 	}
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3952C2CCC
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbgKXQZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390358AbgKXQZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:25:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1077C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 08:24:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1khb7f-0003tW-TS; Tue, 24 Nov 2020 17:24:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net-next] mptcp: put reference in mptcp timeout timer
Date:   Tue, 24 Nov 2020 17:24:46 +0100
Message-Id: <20201124162446.11448-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On close this timer might be scheduled. mptcp uses sk_reset_timer for
this, so the a reference on the mptcp socket is taken.

This causes a refcount leak which can for example be reproduced
with 'mp_join_server_v4.pkt' from the mptcp-packetdrill repo.

The leak has nothing to do with join requests, v1_mp_capable_bind_no_cs.pkt
works too when replacing the last ack mpcapable to v1 instead of v0.

unreferenced object 0xffff888109bba040 (size 2744):
  comm "packetdrill", [..]
  backtrace:
    [..] sk_prot_alloc.isra.0+0x2b/0xc0
    [..] sk_clone_lock+0x2f/0x740
    [..] mptcp_sk_clone+0x33/0x1a0
    [..] subflow_syn_recv_sock+0x2b1/0x690 [..]

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4b7794835fea..dc979571f561 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1710,6 +1710,7 @@ static void mptcp_timeout_timer(struct timer_list *t)
 	struct sock *sk = from_timer(sk, t, sk_timer);
 
 	mptcp_schedule_work(sk);
+	sock_put(sk);
 }
 
 /* Find an idle subflow.  Return NULL if there is unacked data at tcp
-- 
2.26.2


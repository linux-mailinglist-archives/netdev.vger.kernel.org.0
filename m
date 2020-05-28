Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B8A1E6E4E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436759AbgE1WCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436830AbgE1WCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:02:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34923C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:02:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jeQbC-0003v7-Mf; Fri, 29 May 2020 00:02:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] tcp: tcp_init_buffer_space can be static
Date:   Fri, 29 May 2020 00:01:52 +0200
Message-Id: <20200528220152.3999-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of commit 98fa6271cfcb
("tcp: refactor setting the initial congestion window") this is called
only from tcp_input.c, so it can be static.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/tcp.h    | 1 -
 net/ipv4/tcp_input.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 66e4b8331850..bca761ffa25f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -662,7 +662,6 @@ void tcp_initialize_rcv_mss(struct sock *sk);
 int tcp_mtu_to_mss(struct sock *sk, int pmtu);
 int tcp_mss_to_mtu(struct sock *sk, int mss);
 void tcp_mtup_init(struct sock *sk);
-void tcp_init_buffer_space(struct sock *sk);
 
 static inline void tcp_bound_rto(const struct sock *sk)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ad90102f5dfb..83330a6cb242 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -437,7 +437,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 /* 3. Try to fixup all. It is made immediately after connection enters
  *    established state.
  */
-void tcp_init_buffer_space(struct sock *sk)
+static void tcp_init_buffer_space(struct sock *sk)
 {
 	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
 	struct tcp_sock *tp = tcp_sk(sk);
-- 
2.26.2


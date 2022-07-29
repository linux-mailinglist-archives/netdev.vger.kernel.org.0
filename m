Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221BB58535C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiG2QTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiG2QTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:19:38 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C512688CE4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:19:37 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t17so8099404lfk.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rd2KLz4QF9UOE1ei+peKZ3w3t4bij/8xG4IQeBcKYB0=;
        b=QXeTxITZlUPY7hB7Hfv3B+MTkd620StE09Rs6hzYCu2SCKiLm+FapAp7HP/uOqaD4h
         +gdKF5DVJbXajm+fUQFGva3i6QsX99NUl1lWG2zO+9kKOIJZCKC7how97ljbI5ctHVR2
         up08Ww6nk4Q5dkEXbBZ7nuJ0Vr6HLUsodUikY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rd2KLz4QF9UOE1ei+peKZ3w3t4bij/8xG4IQeBcKYB0=;
        b=tjnRLA8CJY+DlFTNiGKzObKUFE4VIButBBpdwt0q6NBa9T6LlCHXvkSNkVuLuNFGSk
         eKkMAIoh/eWmRUqXH6aJvaPklXW8FE7hO5Jq21zjZPUzCRKIvjz4sHxCAvfnulhvDBAl
         PAVRZpePX+Itshc4zsaxsMbafsA5R9SSOMjuIS0rSZtl+ECNWYXgDhz7Cm2G60nhQvrE
         LxyA60v/dOqQZw588isZsg8yeq+FIqFtuKHIn+bZPz1blzfp24Ih/Qmi/aHN0o1rC3dI
         PKCJwPgWo3b+1oNK4D4MbENr2PdqmYUivZzYQk9Mlj5PBf/zU5hWa5eTXjKKmkDBsTM3
         PhOw==
X-Gm-Message-State: ACgBeo35Q26QydVBoXqHCYiCuk2xeeo9bYKU+EZf0v+DSRXHzoo+KY1Q
        UZRto4yAJK5kgaMKYtvHJVVk4hPDuqL1Fg==
X-Google-Smtp-Source: AGRyM1vHLdOfJ3vNnsBu3wguKve5gC2HMNOL90NbFvuwQdwxiHwagmZiVK5qiBNmCHdNf/iktVAxow==
X-Received: by 2002:a05:6512:e92:b0:48a:9b4b:87c0 with SMTP id bi18-20020a0565120e9200b0048a9b4b87c0mr1435585lfb.407.1659111575831;
        Fri, 29 Jul 2022 09:19:35 -0700 (PDT)
Received: from localhost.localdomain ([2a01:110f:4304:1700:5f1b:2efc:32e1:140e])
        by smtp.gmail.com with ESMTPSA id y21-20020a05651c021500b0025d6ecbc897sm708069ljn.46.2022.07.29.09.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:19:35 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, pabeni@redhat.com,
        kuba@kernel.org, Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next] When using syscookies initial receive window calculation uses wrong MSS
Date:   Fri, 29 Jul 2022 18:19:32 +0200
Message-Id: <20220729161932.2543584-1-marek@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using syncookies we get the `mss` variable from the two bits
encoded in the ACK number. This MSS though, represents the
client/sender MSS.

When calculating initial receive window with
`tcp_select_initial_window`, we feed it MSS so that the receive
buffer can be MSS aligned. But this MSS is supposed to be our
receiver/server advertised MSS, not MSS from the remote
party. The code got it wrong.

Usually it's not a big deal but could yield weird/wrong
rcv_ssthresh initial values. Consider this:

$ sysctl net.ipv4.tcp_syncookies=2
$ ip route change local 127.0.0.1/32 dev lo initrwnd 1
$ ip -6 route change local ::1 dev lo initrwnd 1

Flags [S], seq #, win 32767, options [mss 65495,nop,nop,sackOK,nop,wscale 10], length 0
Flags [S.], seq #, ack #, win 128, options [mss 128], length 0
Flags [.], ack 1, win 32767, length 0
> client_tcpi_snd_wnd:128  server_tcpi_rcv_ssthresh:128
Flags [P.], seq 1:2, ack 1, win 536, length 1
Flags [.], ack 2, win 32767, length 0
> client_snd_wnd:536  server_rcv_ssthresh:128

After the handshake we see the client reporting send window=128
and this is visible as tcpi_snd_wnd on client and rcv_ssthresh on
server. Then, after 1 byte exchange, to get an ACK from server,
we see the window to surprisingly grow to 536 bytes. This is
surprising, since the server window should not be related to
syncookie-derived MSS from the client. What is even more
surprising, the window is 536 but the rcv_ssthresh on server is
still 128.

Flags [S], seq #, win 32767, options [mss 65476,nop,nop,sackOK,nop,wscale 10], length 0
Flags [S.], seq #, ack #, win 128, options [mss 128], length 0
Flags [.], ack 1, win 32767, length 0
> client_snd_wnd:128  server_rcv_ssthresh:128
Flags [P.], seq 1:2, ack 1, win 1220, length 1
Flags [.], ack 2, win 32767, length 0
> client_tcpi_snd_wnd:1220  server_tcpi_rcv_ssthresh:128

Identical situation for IPv6.

After the patch we get more sensible values, and sender window is
kept in sync with rcv_ssthresh:

Flags [S], seq #, win 65495, options [mss 65495,nop,nop,sackOK,nop,wscale 4], length 0
Flags [S.], seq #, ack #, win 128, options [mss 128], length 0
Flags [.], ack 1, win 65495, length 0
> client_snd_wnd:128  server_rcv_ssthresh:128
Flags [P.], seq 1:2, ack 1, win 128, length 1
Flags [.], ack 2, win 65494, length 0
> client_snd_wnd:128  server_rcv_ssthresh:128

Flags [S], seq #, win 65476, options [mss 65476,nop,nop,sackOK,nop,wscale 4], length 0
Flags [S.], seq #, ack #, win 128, options [mss 128], length 0
Flags [.], ack 1, win 65476, length 0
> client_snd_wnd:128  server_rcv_ssthresh:128
Flags [P.], seq 1:2, ack 1, win 128, length 1
Flags [.], ack 2, win 65475, length 0
> client_snd_wnd:128  server_rcv_ssthresh:128

Signed-off-by: Marek Majkowski <marek@cloudflare.com>
---
 net/ipv4/syncookies.c | 7 ++++++-
 net/ipv6/syncookies.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 942d2dfa1115..c6701c490528 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -338,6 +338,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct rtable *rt;
 	__u8 rcv_wscale;
 	struct flowi4 fl4;
+	u32 adj_mss;
+	u32 advmss;
 	u32 tsoff = 0;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
@@ -430,6 +432,9 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 	}
 
+	advmss = tcp_mss_clamp(tp, dst_metric_advmss(&rt->dst));
+	adj_mss = advmss - (ireq->tstamp_ok ? TCPOLEN_TSTAMP_ALIGNED : 0);
+
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
 	/* limit the window selection if the user enforce a smaller rx buffer */
@@ -438,7 +443,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
 		req->rsk_window_clamp = full_space;
 
-	tcp_select_initial_window(sk, full_space, req->mss,
+	tcp_select_initial_window(sk, full_space, adj_mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(&rt->dst, RTAX_INITRWND));
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 5014aa663452..8175043c0bb9 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -139,6 +139,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	int full_space, mss;
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
+	u32 adj_mss;
+	u32 advmss;
 	u32 tsoff = 0;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
@@ -249,7 +251,10 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	    (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
 		req->rsk_window_clamp = full_space;
 
-	tcp_select_initial_window(sk, full_space, req->mss,
+	advmss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	adj_mss = advmss - (ireq->tstamp_ok ? TCPOLEN_TSTAMP_ALIGNED : 0);
+
+	tcp_select_initial_window(sk, full_space, adj_mss,
 				  &req->rsk_rcv_wnd, &req->rsk_window_clamp,
 				  ireq->wscale_ok, &rcv_wscale,
 				  dst_metric(dst, RTAX_INITRWND));
-- 
2.25.1


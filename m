Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41E2635B6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIISRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgIISQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:16:18 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20B9C061757
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:16:16 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y2so1878269qvs.14
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WpHZA/YEb8AVMH8e/anhUbZurJrmP6ml/9UihqCFb/E=;
        b=onc9VEw88lG1pmegiJlBWBJ1rKtrwLP6Vm62HpLo3b7Eb39nuoZsav/Q9hsU6n7gB1
         eX1FXJ7LecwsU8xVK6YtYjNkWveUZCE68p2GvF6zLcmTd6z2bsXPhYtjftBPCFynH4Cm
         Cr61YrwWuAMJ35ORvMb7j9LGOHOKbdyEu4uBpDCL9lHT9RGh5eP1H5VEF//aHCQk97mS
         mUI9DCGsUuCkODWE1iA582lQ29TKdpW9LSShTmbuE8rkN1vU+6J4yflXRWSz7l1FB7Nc
         swh+zxbPHU+LW3Gigu6devZVw2sRShjPrJmnc8VjhuNHIGIPb8p/2i6pq7I7RhrXvm31
         22Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WpHZA/YEb8AVMH8e/anhUbZurJrmP6ml/9UihqCFb/E=;
        b=KWeb+X+g6rXjvE8EFPtdAKupzdvv56SX54qNneiwi3upoLaAKFziOk8yI3PJN6TuY4
         Qly7kq+lGYTsv1HGcD8Fkohzsgu+NQ22MnicE0/FXyi3tZB1bZnJ+ECUa4nPERP518fD
         M7+WK2f7AOyi90OklpNGM0nH0Bxwl9K2UIDUwE405duRaRpSkp27UZACet03sQ4XPr9G
         5fCmc1XVTD3bHyPweCs0muZKlrSiaB2VRnqGVFwBUNAbofEyjOavYY32bxUPFRbvkrpK
         H/J35vhBR5VfL8x8BhuA1xnEkHPUH9ssbgx/TTP4GflthUigCUxsK2Dh3AvuL7hlaBbj
         oEaQ==
X-Gm-Message-State: AOAM530p32XvkNJhvBPqt6dPdjyuZ4xWVBDxf/BHJKDsVYdfNmwyK2t3
        2f1WrRo/Xd0AI+wUbBqeD4HrW+BqQmWVVf8=
X-Google-Smtp-Source: ABdhPJzS0ym9tVR8I2T1mvWHbdYsdDXSbYFdW0NkipIWrWEC9aGNXY+MS2O1gnWPHns2kmS6d7GkVUzqOdKcCds=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:ec11:: with SMTP id
 y17mr5491406qvo.72.1599675375975; Wed, 09 Sep 2020 11:16:15 -0700 (PDT)
Date:   Wed,  9 Sep 2020 14:15:55 -0400
In-Reply-To: <20200909181556.2945496-1-ncardwell@google.com>
Message-Id: <20200909181556.2945496-4-ncardwell@google.com>
Mime-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next 3/4] tcp: simplify tcp_set_congestion_control():
 always reinitialize
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the previous patches ensure that all call sites for
tcp_set_congestion_control() want to initialize congestion control, we
can simplify tcp_set_congestion_control() by removing the reinit
argument and the code to support it.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
---
 include/net/tcp.h   |  2 +-
 net/core/filter.c   |  3 +--
 net/ipv4/tcp.c      |  2 +-
 net/ipv4/tcp_cong.c | 11 ++---------
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e85d564446c6..f857146c17a5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1104,7 +1104,7 @@ void tcp_get_available_congestion_control(char *buf, size_t len);
 void tcp_get_allowed_congestion_control(char *buf, size_t len);
 int tcp_set_allowed_congestion_control(char *allowed);
 int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
-			       bool reinit, bool cap_net_admin);
+			       bool cap_net_admin);
 u32 tcp_slow_start(struct tcp_sock *tp, u32 acked);
 void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index b26c04924fa3..0bd0a97ee951 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4451,8 +4451,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			strncpy(name, optval, min_t(long, optlen,
 						    TCP_CA_NAME_MAX-1));
 			name[TCP_CA_NAME_MAX-1] = 0;
-			ret = tcp_set_congestion_control(sk, name, false,
-							 true, true);
+			ret = tcp_set_congestion_control(sk, name, false, true);
 		} else {
 			struct inet_connection_sock *icsk = inet_csk(sk);
 			struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7360d3db2b61..e58ab9db73ff 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3050,7 +3050,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		name[val] = 0;
 
 		lock_sock(sk);
-		err = tcp_set_congestion_control(sk, name, true, true,
+		err = tcp_set_congestion_control(sk, name, true,
 						 ns_capable(sock_net(sk)->user_ns,
 							    CAP_NET_ADMIN));
 		release_sock(sk);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index d18d7a1ce4ce..a9b0fb52a1ec 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -341,7 +341,7 @@ int tcp_set_allowed_congestion_control(char *val)
  * already initialized.
  */
 int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
-			       bool reinit, bool cap_net_admin)
+			       bool cap_net_admin)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcp_congestion_ops *ca;
@@ -365,15 +365,8 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 	if (!ca) {
 		err = -ENOENT;
 	} else if (!load) {
-		const struct tcp_congestion_ops *old_ca = icsk->icsk_ca_ops;
-
 		if (bpf_try_module_get(ca, ca->owner)) {
-			if (reinit) {
-				tcp_reinit_congestion_control(sk, ca);
-			} else {
-				icsk->icsk_ca_ops = ca;
-				bpf_module_put(old_ca, old_ca->owner);
-			}
+			tcp_reinit_congestion_control(sk, ca);
 		} else {
 			err = -EBUSY;
 		}
-- 
2.28.0.526.ge36021eeef-goog


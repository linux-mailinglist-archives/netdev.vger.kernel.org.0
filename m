Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E89D264A71
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgIJQ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgIJQzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:55:33 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14508C061388
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:53:20 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id u23so3970598qku.17
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=S6AuheHIRwyrJQTuUfR58Qd8kmBi7CvFbpaQ8Qcutxg=;
        b=YNttQCF+B1/hAzcl2uJhy37rwLZYHlOQYNDWR7L0rIRoNo4K5glk919Fqj886W3LSZ
         3E3jSggf3TItjZqgO5lxnXTe7JAI6ASWuA+vtqWN1ZwYak2iuIwDABkWmxc9z1HHTFpv
         He5gZnY90DhbgiR7qgK06Cotnn4fXxP2EIZjsz69P81rt4R/6SPuqspmh5opXE5yfmuG
         k3X9GqC1ouQ55OdRYHXFmGdFE7X8Y5n51ByIuhjwXTXaPOIT6WMv+jDshS5xPXssKxRw
         J3lgYK4gRVrDeidtxKiQyZarGR0ntT0U+M5TkESpOqw3oJPDUv7GNBpebCh0+acqOG6v
         DHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=S6AuheHIRwyrJQTuUfR58Qd8kmBi7CvFbpaQ8Qcutxg=;
        b=ITJXL8R6g5X9xAPjqSnLyu2DNIqwlQ8RE5P3xynG8Iizzrce2JXCTDnAweyNPLbGEX
         +X0QpP9IaZOjwGnDMsMEUSefeHysQD4zq29Msz+Ykb5P09QNjbLYsayjeWFg2rB2CSVx
         WKnE/FDs8Cvw2GypP/V8JOAhNHcw18zsS2iYQCNpTBQ3P4OYrjC4OT9xyXzN9lNsgODQ
         ayhVoShSwwxacFbqere/Ptj2h98TMDmay1VrAu2qEZZUeOfJN/RJrIbtYeHoLt4PvK92
         MiD4bzNdXEjbrJQ4U1VZKqZ0BTYkB5xuPCxoJIQ4OvPZgznYGUJ8v/d68cTp3HhSl7lo
         /rwQ==
X-Gm-Message-State: AOAM530gIBVk0c0uETz5OL3zJgQun/Q94XTfH9Q5kxUfPryFS7F33uen
        h90RgW927hASS9E+WZqIZAKsakAJU5CU01Y=
X-Google-Smtp-Source: ABdhPJyrz9ZaTwIBkNvZxIjwvnbVIynOzP3cfbLTpgTDUROl0innMbtXgRZiAm3O4eiCFpYLebjPrA+i+Oqh0+8=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:ad4:4891:: with SMTP id
 bv17mr9572494qvb.27.1599756799211; Thu, 10 Sep 2020 09:53:19 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:53:17 -0400
Message-Id: <20200910165317.2024700-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 3/5] tcp: simplify tcp_set_congestion_control():
 always reinitialize
From:   Neal Cardwell <ncardwell@google.com>
To:     Alexei Starovoitov <ast@kernel.org>
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
index 067f6759a68f..e89d6d7da03c 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A2F264DA8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIJSrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgIJSrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:47:20 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723D7C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 11:47:20 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id f21so3859813qve.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 11:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=S6AuheHIRwyrJQTuUfR58Qd8kmBi7CvFbpaQ8Qcutxg=;
        b=BQ3XXPlkAlxCvnZmmC6N8uGJe5SQ7IcTN5TURq1FqCbeG+fEEwewf44Y6ILvziw3IZ
         vtz+rUA9G+jk62FHlfKulGE+hMlG35dg5Cxi4/0OX2iTNIp1742Hon9FQmdDbfGuBSpV
         KTRt8yRIdr8Yn5IoAkJNUQyo7HkDyY1bBv7OoDt7yI9ekh2YoTuG+5vJUixqamGcc8hL
         twTJjH6Pnai4aZqy0VUDtinUOc2NZmy9QkidCebS1tYoAgBS2BoQvIk9t+14SNdnGxJ1
         zDyW1QiF6PBgrayQXZ8ZZYyjMPQqQMssO5cPpZ3eipkSsLPtULjooj0T/ct7vVTybUbU
         7RYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=S6AuheHIRwyrJQTuUfR58Qd8kmBi7CvFbpaQ8Qcutxg=;
        b=lZllJ0JpZQQBa9pWCiOVRXCfBnZ+EsNKB7xE34FQxTgjrGNcXSR+RQAAQydsfnNn57
         0fkZcEKTSu74SM+hM4v5v65bHXHFl8sAxoCRuGHmOFdwNxq+rBG7D5/t+RN9bw92aZhS
         F69CNboLrpO0fBIe5143Hi+A0mOgMUVm3BYMCmjq37JSuoSjbniqyhojGwlPOtxgaQRC
         fpMB+nsUb52O+Nj3qHsbMtsowzVrRkvu5A25YlmSjKt1faQ0sqdknJUc2e0huqw6IT2N
         Y5mnqZ00fCgfD9mODtK3g1sEN7ayhFbdTzjJ3o/PMFJ+54ufPPjOYAvfjAmr0N77fG4z
         dM7g==
X-Gm-Message-State: AOAM530iLRUxyFWNtALwkhnoK0JT45lZt4EC+rCNz88qZ53BOyNQXeYc
        WjxbK7mmweqapgQwcDGQlL/75lpFBImCQRE=
X-Google-Smtp-Source: ABdhPJzNP5Was4817E7/HCtUWsRi6IhOQ11gl+M3ZNIyh3+Lap9wfKfCGO0gomqxI1RatrK6KkNxJ2n0r0V+4a8=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a05:6214:921:: with SMTP id
 dk1mr10292241qvb.34.1599763639364; Thu, 10 Sep 2020 11:47:19 -0700 (PDT)
Date:   Thu, 10 Sep 2020 14:47:18 -0400
Message-Id: <20200910184718.2663132-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
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


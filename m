Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A56D90F
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 04:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfGSC2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 22:28:23 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:42204 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfGSC2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 22:28:22 -0400
Received: by mail-pf1-f201.google.com with SMTP id 21so17781275pfu.9
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 19:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1T83Q0rAGqDe+R42D9zFqRrCWQB+G1xTx21pdHHrd/8=;
        b=C8d8oJpeEP/LL+IRIgxv+zOiDc9NsPrxNJNsnzKPqrTSwkf5ekZg4RQhJVgNX+A6jN
         Zp756u7cN/yvMJKJclrSTaMvWmT8bEzgGPcOKM5rle959SHGINj86FBU9lOZjzAys222
         GjBMRh5x7u+Nzp2zNSIENwBPVbH5Weam8CToW4W50LJ3tEmg6otPJFvyDKG6apJtRxNV
         W916VBKIspqHFUsde6eKS9asAPpaY3bmDpwzNIYhHYfO4H6N+vtMRBl8UnKNRnMD2hmM
         MP1krhDUDCwQL3v62z26K5uKNeyTGKOqGzWPbQbSCHTHpkuEOJXxkdkjZYeFRUWbaLiY
         zyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1T83Q0rAGqDe+R42D9zFqRrCWQB+G1xTx21pdHHrd/8=;
        b=pqZ78RdPpXoTyeHT5jKvflj7yJv2j/qwj6Fj7Nv/sSdRyme4RQ5JGY05E5vnbJmLL7
         M+JqHcms61dcKrjJLU4BIDvbddBW5ixylWz6vo/P7YwLusQ4zisPsjmTqqO9uNGKS9j4
         RHnIAjR7WVkzqFyb/gJLOk5Rti7YTY+WnTElsCz/VQJozjbtCwjcGAmCqW3bsLlkZ6JU
         g1vpFN65/klY1xaBueGXsSWt0Xypbs2zigAqbp9pkrEcK8mkyO+lG4H9d7xYQp/HDArx
         Fqycetzz04Rze4vRPcC0EU43qjNUsQ4uO+WFxFSFpZFkBnl9H2ljbN3+jDrvVR7tpaoU
         svxQ==
X-Gm-Message-State: APjAAAVUV+cB6M8mxObZWw7AC518avrj7zumEeLLeCvz5LqI/NeLL6Za
        FjX725qHAplzq8gBqtHtB5M9YR+MXAuYyg==
X-Google-Smtp-Source: APXvYqx2it9nGx/55WF7yaki+4hBxh6RiidvIE6TR3VpTjwDpo1yPjlcX426Hwysu00uLWpE3bRDDAYVH1jS8Q==
X-Received: by 2002:a63:455c:: with SMTP id u28mr31762858pgk.416.1563503301606;
 Thu, 18 Jul 2019 19:28:21 -0700 (PDT)
Date:   Thu, 18 Jul 2019 19:28:14 -0700
Message-Id: <20190719022814.233056-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH net] tcp: fix tcp_set_congestion_control() use from bpf hook
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal reported incorrect use of ns_capable() from bpf hook.

bpf_setsockopt(...TCP_CONGESTION...)
  -> tcp_set_congestion_control()
   -> ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)
    -> ns_capable_common()
     -> current_cred()
      -> rcu_dereference_protected(current->cred, 1)

Accessing 'current' in bpf context makes no sense, since packets
are processed from softirq context.

As Neal stated : The capability check in tcp_set_congestion_control()
was written assuming a system call context, and then was reused from
a BPF call site.

The fix is to add a new parameter to tcp_set_congestion_control(),
so that the ns_capable() call is only performed under the right
context.

Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
Reported-by: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h   | 3 ++-
 net/core/filter.c   | 2 +-
 net/ipv4/tcp.c      | 4 +++-
 net/ipv4/tcp_cong.c | 6 +++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index cca3c59b98bf85c2bdd7adf79157159df163b1ae..f42d300f0cfaa87520320dd287a7b4750adf7d8a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1064,7 +1064,8 @@ void tcp_get_default_congestion_control(struct net *net, char *name);
 void tcp_get_available_congestion_control(char *buf, size_t len);
 void tcp_get_allowed_congestion_control(char *buf, size_t len);
 int tcp_set_allowed_congestion_control(char *allowed);
-int tcp_set_congestion_control(struct sock *sk, const char *name, bool load, bool reinit);
+int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
+			       bool reinit, bool cap_net_admin);
 u32 tcp_slow_start(struct tcp_sock *tp, u32 acked);
 void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 0f6854ccf8949f131f7e229d552f9f947dc205a2..4e2a79b2fd77f36ba2a31e9e43af1abc1207766e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4335,7 +4335,7 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 						    TCP_CA_NAME_MAX-1));
 			name[TCP_CA_NAME_MAX-1] = 0;
 			ret = tcp_set_congestion_control(sk, name, false,
-							 reinit);
+							 reinit, true);
 		} else {
 			struct tcp_sock *tp = tcp_sk(sk);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7846afacdf0bfdbc5ba5c6d48b2c5873df1309c9..776905899ac06bcbaa7ece1f580303478e736d56 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2785,7 +2785,9 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		name[val] = 0;
 
 		lock_sock(sk);
-		err = tcp_set_congestion_control(sk, name, true, true);
+		err = tcp_set_congestion_control(sk, name, true, true,
+						 ns_capable(sock_net(sk)->user_ns,
+							    CAP_NET_ADMIN));
 		release_sock(sk);
 		return err;
 	}
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index e1862b64a90fba25b84dd9d5584e1f843406edd0..c445a81d144ea4ed1c67ad80a96433df35f5f8de 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -333,7 +333,8 @@ int tcp_set_allowed_congestion_control(char *val)
  * tcp_reinit_congestion_control (if the current congestion control was
  * already initialized.
  */
-int tcp_set_congestion_control(struct sock *sk, const char *name, bool load, bool reinit)
+int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
+			       bool reinit, bool cap_net_admin)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcp_congestion_ops *ca;
@@ -369,8 +370,7 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load, boo
 		} else {
 			err = -EBUSY;
 		}
-	} else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) ||
-		     ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))) {
+	} else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin)) {
 		err = -EPERM;
 	} else if (!try_module_get(ca->owner)) {
 		err = -EBUSY;
-- 
2.22.0.657.g960e92d24f-goog


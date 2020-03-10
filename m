Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2231217EFE8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgCJFRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:17:01 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:52863 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgCJFQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:16:59 -0400
Received: by mail-pl1-f202.google.com with SMTP id 64so3412846plf.19
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 22:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TNtB+QSpy4uNCr/VYeHhGUHpJm44aSfYPkSBHYJ0zsw=;
        b=WSg4BIUKLHoYQm/UXhi2utv1mRHFPdRhsVGHEtX37hLa6oKvf+GiEOyE40iROyKSf+
         L8F8KCMSY/cpHRmKMpDK5fpqRQM8P7TbJm/Y+ZT7w3HU2m09s3n7nYI66paQrMjhnAsx
         oSA3qeYL4hyN6rQC8zQrXFwCNsA67HPzYJJVlVE5ai9KnE1ahr9W70vJ+Tpw3xqWS5h2
         OQY2h9TXySmUQic68Xmva58powbgn/8Fcnq6BG1k1/u742vQOOniW8UqSBo1e3jGV6Eg
         zzbwVCS93BgxblcxdJjABsarILtkj4oJJpF9GaltxoxQuwVY2OU2qJz6tVGcGaCL6x5s
         miZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TNtB+QSpy4uNCr/VYeHhGUHpJm44aSfYPkSBHYJ0zsw=;
        b=i/SjJ+7e/zM0jnlXrJgyY5irYEAaHdgzDGi4Zmac2OXx+yC/QEAPC9/6kB1fyIq39t
         tgXBRXio1UoSPURZqOVfz2Zr4g3dP/NavG6DjzBkdrRfTlALXr+WnNbVeKogX/KeOp2U
         EQ4kkr487RUghQacFlSIthsiWRnjgfJooe87LhMHKeJpNTlpMHnSTsk4Gz/dUlnG1QLY
         8I4rmfelajBHaudLF9MKJY4oSFRYfryzbOmBgYLXH2IwP/F+0gJQIz1CUczsb048BeEA
         nvxyCAP7d/kYiYOwhpABU7G/9CWLYs61AQ2tk/AiixhdsS3ZemaNum/KEeO+sAYoxPuH
         6RJQ==
X-Gm-Message-State: ANhLgQ25jXkLCwWGle2PBlEBknjtGSTAIS/HIMTAfOJssaoa6mJeC6fQ
        4sNEXq1dFerk62NSPaZlM3/D7j/kRjbb9g==
X-Google-Smtp-Source: ADFU+vvCgK2su0Vey9F/dsAYP7pK2PzEwMOn7opQOpgiX/aLfjRILGRM2uW867o24mCxDlVAb6tRZVuzSwHkyQ==
X-Received: by 2002:a17:90a:8005:: with SMTP id b5mr1361533pjn.37.1583817417871;
 Mon, 09 Mar 2020 22:16:57 -0700 (PDT)
Date:   Mon,  9 Mar 2020 22:16:06 -0700
In-Reply-To: <20200310051606.33121-1-shakeelb@google.com>
Message-Id: <20200310051606.33121-2-shakeelb@google.com>
Mime-Version: 1.0
References: <20200310051606.33121-1-shakeelb@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v4 2/2] net: memcg: late association of sock to memcg
From:   Shakeel Butt <shakeelb@google.com>
To:     Eric Dumazet <edumazet@google.com>, Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a TCP socket is allocated in IRQ context or cloned from unassociated
(i.e. not associated to a memcg) in IRQ context then it will remain
unassociated for its whole life. Almost half of the TCPs created on the
system are created in IRQ context, so, memory used by such sockets will
not be accounted by the memcg.

This issue is more widespread in cgroup v1 where network memory
accounting is opt-in but it can happen in cgroup v2 if the source socket
for the cloning was created in root memcg.

To fix the issue, just do the association of the sockets at the accept()
time in the process context and then force charge the memory buffer
already used and reserved by the socket.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
Changes since v3:
- Moved the memcg association completely at accept time.

Changes since v2:
- Additional check for charging.
- Release the sock after charging.

Changes since v1:
- added sk->sk_rmem_alloc to initial charging.
- added synchronization to get memory usage and set sk_memcg race-free.

 mm/memcontrol.c                 | 14 --------------
 net/core/sock.c                 |  5 ++++-
 net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 06a889b0538b..351603c6c1c9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6737,20 +6737,6 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 	if (!mem_cgroup_sockets_enabled)
 		return;
 
-	/*
-	 * Socket cloning can throw us here with sk_memcg already
-	 * filled. It won't however, necessarily happen from
-	 * process context. So the test for root memcg given
-	 * the current task's memcg won't help us in this case.
-	 *
-	 * Respecting the original socket's memcg is a better
-	 * decision in this case.
-	 */
-	if (sk->sk_memcg) {
-		css_get(&sk->sk_memcg->css);
-		return;
-	}
-
 	/* Do not associate the sock with unrelated interrupted task's memcg. */
 	if (in_interrupt())
 		return;
diff --git a/net/core/sock.c b/net/core/sock.c
index e4af4dbc1c9e..0fc8937a7ff4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1832,7 +1832,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		atomic_set(&newsk->sk_zckey, 0);
 
 		sock_reset_flag(newsk, SOCK_DONE);
-		mem_cgroup_sk_alloc(newsk);
+
+		/* sk->sk_memcg will be populated at accept() time */
+		newsk->sk_memcg = NULL;
+
 		cgroup_sk_alloc(&newsk->sk_cgrp_data);
 
 		rcu_read_lock();
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a4db79b1b643..65a3b2565102 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 		}
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
+
+	if (mem_cgroup_sockets_enabled) {
+		int amt;
+
+		/* atomically get the memory usage, set and charge the
+		 * sk->sk_memcg.
+		 */
+		lock_sock(newsk);
+
+		/* The sk has not been accepted yet, no need to look at
+		 * sk->sk_wmem_queued.
+		 */
+		amt = sk_mem_pages(newsk->sk_forward_alloc +
+				   atomic_read(&sk->sk_rmem_alloc));
+		mem_cgroup_sk_alloc(newsk);
+		if (newsk->sk_memcg && amt)
+			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
+
+		release_sock(newsk);
+	}
 out:
 	release_sock(sk);
 	if (req)
-- 
2.25.1.481.gfbce0eb801-goog


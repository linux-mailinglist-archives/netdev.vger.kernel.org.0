Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89E014A49C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgA0NLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34228 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgA0NLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:06 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so6162320lfc.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmmvmFYM1C2O/HFL+O+XUj+uU0hQmm347kKY5Qq/hzA=;
        b=TBBx6WMRyAEvOO3FBy/R1uI33vrlSfPcV0kAoQqf1g1Sr5FAFGAr8ZiuJG5yYTJnNL
         4EB7LgRAXiqB1+B3g+6CmutB/wBgAgtEHZwEHTelYEGEXZNT3PZ/H6+xsskc79bzMWJ7
         ul8mF+A4W/A99fRsZy0VzrFuhQuz6BxL3YNZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmmvmFYM1C2O/HFL+O+XUj+uU0hQmm347kKY5Qq/hzA=;
        b=WhbBzE7158+itSx3xNEQQhA2xcVmmkw68hxq32nvUpfvzqyBWzyTi8iWLZCOLq+WeZ
         RlDdhgds+wgQAcP5NAl4dEXbQyFfoef1+nJAgYHjGQd3fI3MHcRtxwt07q+/tYkD0Bei
         cPbjpQXOY/GKIoggJ3JB8CBJK01WoZ3sjNrlmJvuPNcdPePb53djsWKVjx6tKlURqCak
         j3RbLuCI2mGdngV4MJ038jirfi0ZvnWe481s5dwmPhcbxkGcsaR41fUIEtVBJWNqIQcs
         cuQLIVbOzkcRyU4GDk75zdKTUGvJlzHbn7EA3NRYFolNVwDkp+hq6m+wNi8xa4czlRpA
         WcfA==
X-Gm-Message-State: APjAAAUkrmoX53m0QGV8xgUVD+/LZ00PIgBv4SGa9pCB/9QuNclheAp1
        M9F9ie25EfkuTER78ysLGfF29Q==
X-Google-Smtp-Source: APXvYqyJjwuvWoDLSqdlvwpowMRPM/+Th4yxUBLap6lmvXgjMWvctxHCKWxImoYZ76xY3YxseAAeYQ==
X-Received: by 2002:a19:ee1a:: with SMTP id g26mr8077514lfb.147.1580130663484;
        Mon, 27 Jan 2020 05:11:03 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s7sm2780464ljc.50.2020.01.27.05.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:03 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v6 03/12] net, sk_msg: Clear sk_user_data pointer on clone if tagged
Date:   Mon, 27 Jan 2020 14:10:48 +0100
Message-Id: <20200127131057.150941-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_user_data can hold a pointer to an object that is not intended to be
shared between the parent socket and the child that gets a pointer copy on
clone. This is the case when sk_user_data points at reference-counted
object, like struct sk_psock.

One way to resolve it is to tag the pointer with a no-copy flag by
repurposing its lowest bit. Based on the bit-flag value we clear the child
sk_user_data pointer after cloning the parent socket.

The no-copy flag is stored in the pointer itself as opposed to externally,
say in socket flags, to guarantee that the pointer and the flag are copied
from parent to child socket in an atomic fashion. Parent socket state is
subject to change while copying, we don't hold any locks at that time.

This approach relies on an assumption that sk_user_data holds a pointer to
an object aligned at least 2 bytes. A manual audit of existing users of
rcu_dereference_sk_user_data helper confirms our assumption.

Also, an RCU-protected sk_user_data is not likely to hold a pointer to a
char value or a pathological case of "struct { char c; }". To be safe, warn
when the flag-bit is set when setting sk_user_data to catch any future
misuses.

It is worth considering why clearing sk_user_data unconditionally is not an
option. There exist users, DRBD, NVMe, and Xen drivers being among them,
that rely on the pointer being copied when cloning the listening socket.

Potentially we could distinguish these users by checking if the listening
socket has been created in kernel-space via sock_create_kern, and hence has
sk_kern_sock flag set. However, this is not the case for NVMe and Xen
drivers, which create sockets without marking them as belonging to the
kernel.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/sock.h | 37 +++++++++++++++++++++++++++++++++++--
 net/core/skmsg.c   |  2 +-
 net/core/sock.c    |  6 ++++++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 02162b0378f7..9f37fdfd15d4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -502,10 +502,43 @@ enum sk_pacing {
 	SK_PACING_FQ		= 2,
 };
 
+/* Pointer stored in sk_user_data might not be suitable for copying
+ * when cloning the socket. For instance, it can point to a reference
+ * counted object. sk_user_data bottom bit is set if pointer must not
+ * be copied.
+ */
+#define SK_USER_DATA_NOCOPY	1UL
+#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY)
+
+/**
+ * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be copied
+ * @sk: socket
+ */
+static inline bool sk_user_data_is_nocopy(const struct sock *sk)
+{
+	return ((uintptr_t)sk->sk_user_data & SK_USER_DATA_NOCOPY);
+}
+
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
-#define rcu_dereference_sk_user_data(sk)	rcu_dereference(__sk_user_data((sk)))
-#define rcu_assign_sk_user_data(sk, ptr)	rcu_assign_pointer(__sk_user_data((sk)), ptr)
+#define rcu_dereference_sk_user_data(sk)				\
+({									\
+	void *__tmp = rcu_dereference(__sk_user_data((sk)));		\
+	(void *)((uintptr_t)__tmp & SK_USER_DATA_PTRMASK);		\
+})
+#define rcu_assign_sk_user_data(sk, ptr)				\
+({									\
+	uintptr_t __tmp = (uintptr_t)(ptr);				\
+	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
+	rcu_assign_pointer(__sk_user_data((sk)), __tmp);		\
+})
+#define rcu_assign_sk_user_data_nocopy(sk, ptr)				\
+({									\
+	uintptr_t __tmp = (uintptr_t)(ptr);				\
+	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
+	rcu_assign_pointer(__sk_user_data((sk)),			\
+			   __tmp | SK_USER_DATA_NOCOPY);		\
+})
 
 /*
  * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 3866d7e20c07..cd133688fd78 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -512,7 +512,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
 	refcount_set(&psock->refcnt, 1);
 
-	rcu_assign_sk_user_data(sk, psock);
+	rcu_assign_sk_user_data_nocopy(sk, psock);
 	sock_hold(sk);
 
 	return psock;
diff --git a/net/core/sock.c b/net/core/sock.c
index 3953bb23f4d0..74662943af5c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1864,6 +1864,12 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 			goto out;
 		}
 
+		/* Clear sk_user_data if parent had the pointer tagged
+		 * as not suitable for copying when cloning.
+		 */
+		if (sk_user_data_is_nocopy(newsk))
+			RCU_INIT_POINTER(newsk->sk_user_data, NULL);
+
 		newsk->sk_err	   = 0;
 		newsk->sk_err_soft = 0;
 		newsk->sk_priority = 0;
-- 
2.24.1


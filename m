Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF230D293
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhBCEVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhBCETV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:19:21 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661CEC061351;
        Tue,  2 Feb 2021 20:17:18 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id x23so5704323oop.1;
        Tue, 02 Feb 2021 20:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FCPDcm2U8/mVowiAl26odeeIloTX+VCHLbcc34SXhNg=;
        b=KygWNLfC1FY5z3olUJ14gMzLoUBOpOOHpXUNc6udgsKN13ZIUd4Zc6YSKzU8aQ1Ykt
         4nX0Is7bxVk3/QMseeZQEpVvFNvzpqlNhdD5diHAWaVg6q7xXBfEuaeytbhHIJhry2Qk
         0NvbYQtxIAf0j6KSyhLpW8fOgq38YmDNOjVu+q2niaHw+lNhUUEGEiBABvpEM0HsxcSh
         d73xvEFQGJ+H75E01LJbIZ2Mo+mXIF4TyMITrNe9rBbO8nUwyC7aAdqUtuNfaLifhGkn
         Zmg9WDG7XN+NlcY8UxWpWyVHjycGr8Xd36auU7DbsosSKzF5vYD4sfQrjh8pCBRwktwX
         5U2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FCPDcm2U8/mVowiAl26odeeIloTX+VCHLbcc34SXhNg=;
        b=PiNdyKj/nrY/XR3dzlTuawnTflMGlK95mGhIzWKcxd2nSgB8q8IvIYm7T2VImhT/ue
         veRqprdQDDUs0pVmyk1jKiUH+6beH3PVQ8Zden44Z/9ZyZlFvJrC3rSdzZEOO9QWzCJo
         9/Gz4kPY/fprbIArxhJx4zHTNBLjgvjmDUplGFz3MOS/RG4jGsW+btmEh7k1ima7Cg0c
         Z5c+fYm24+wgULcPKRHo5Gh80vtrOngQYCD1VUbzaALu8zR1U6LtOy6MjdMolnpynFrS
         1vGCTYt/tMRkN/dQgQvyMf+Ih5118QS/kqZqrGET6+OeXEJipPloWCWZV5LWgQ91REYa
         SfGQ==
X-Gm-Message-State: AOAM530dZzdAXQKElU+QLmHi35osaAamRT5lpV3TKwnx4Ww0dJV6HkMJ
        nTeGsCEpMf0xTJgTBLBw/eIqNAQuxoIAlA==
X-Google-Smtp-Source: ABdhPJyKa0cfPJhBmE40ohTRIkysvgja2gz1icWBPmYBMWNAqtpuU8mN91+qkg9Yn2IPLSyAe+GpOA==
X-Received: by 2002:a4a:d112:: with SMTP id k18mr682277oor.48.1612325837706;
        Tue, 02 Feb 2021 20:17:17 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:16 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 16/19] af_unix: implement unix_dgram_bpf_recvmsg()
Date:   Tue,  2 Feb 2021 20:16:33 -0800
Message-Id: <20210203041636.38555-17-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We have to implement unix_dgram_bpf_recvmsg() to replace the
original ->recvmsg() to retrieve skmsg from ingress_msg.

AF_UNIX is again special here because the lack of
sk_prot->recvmsg(). I simply add a special case inside
unix_dgram_recvmsg() to call sk->sk_prot->recvmsg() directly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/af_unix.h |  3 +++
 net/unix/af_unix.c    | 21 ++++++++++++++++---
 net/unix/unix_bpf.c   | 49 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index fa75f899e88a..f6c43667e995 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -82,6 +82,9 @@ static inline struct unix_sock *unix_sk(const struct sock *sk)
 long unix_inq_len(struct sock *sk);
 long unix_outq_len(struct sock *sk);
 
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int nonblock, int flags, int *addr_len);
+
 #ifdef CONFIG_SYSCTL
 int unix_sysctl_register(struct net *net);
 void unix_sysctl_unregister(struct net *net);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 21c4406f879b..eebcd6f7ef88 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2094,11 +2094,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 	}
 }
 
-static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
-			      size_t size, int flags)
+int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			 int nonblock, int flags, int *addr_len)
 {
 	struct scm_cookie scm;
-	struct sock *sk = sock->sk;
+	struct socket *sock = sk->sk_socket;
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb, *last;
 	long timeo;
@@ -2201,6 +2201,21 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+			      int flags)
+{
+	struct sock *sk = sock->sk;
+	int addr_len = 0;
+
+#ifdef CONFIG_BPF_SOCK_MAP
+	if (sk->sk_prot != &unix_proto)
+		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+					    flags & ~MSG_DONTWAIT, &addr_len);
+#endif
+	return __unix_dgram_recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+				    flags, &addr_len);
+}
+
 int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		   sk_read_actor_t recv_actor)
 {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 2e6a26ec4958..570261fd18cd 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -5,6 +5,54 @@
 #include <net/sock.h>
 #include <net/af_unix.h>
 
+static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int nonblock, int flags,
+				  int *addr_len)
+{
+	struct sk_psock *psock;
+	int copied, ret;
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return __unix_dgram_recvmsg(sk, msg, len, nonblock, flags,
+					    addr_len);
+
+	lock_sock(sk);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock)) {
+		ret = __unix_dgram_recvmsg(sk, msg, len, nonblock, flags,
+					   addr_len);
+		goto out;
+	}
+
+msg_bytes_ready:
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		int data, err = 0;
+		long timeo;
+
+		timeo = sock_rcvtimeo(sk, nonblock);
+		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		if (data) {
+			if (!sk_psock_queue_empty(psock))
+				goto msg_bytes_ready;
+			ret = __unix_dgram_recvmsg(sk, msg, len, nonblock,
+						   flags, addr_len);
+			goto out;
+		}
+		if (err) {
+			ret = err;
+			goto out;
+		}
+		copied = -EAGAIN;
+	}
+	ret = copied;
+out:
+	release_sock(sk);
+	sk_psock_put(sk, psock);
+	return ret;
+}
+
 static struct proto *unix_prot_saved __read_mostly;
 static DEFINE_SPINLOCK(unix_prot_lock);
 static struct proto unix_bpf_prot;
@@ -13,6 +61,7 @@ static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base
 {
 	*prot        = *base;
 	prot->close  = sock_map_close;
+	prot->recvmsg = unix_dgram_bpf_recvmsg;
 }
 
 static void unix_bpf_check_needs_rebuild(struct proto *ops)
-- 
2.25.1


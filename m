Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541B1F0946
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfKEWY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:24:59 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46432 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfKEWY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:24:59 -0500
Received: by mail-lj1-f195.google.com with SMTP id e9so10434394ljp.13
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZS1jFax+2UxUSONAINTJJT6NSOgXpazCzY0vS224Ozc=;
        b=Y6Th/8E+ihePmfNlm2fXFFQwpWO2aN7ltlRfoSVk0FVCuXRTpUyXEL7MezU1BSTZsL
         PFkoHgP0Gf8ypgF6vmEwTa4b2lacdizfmhnC8T2g7krrobumZvLPL/9RJ2G+vcjG9Hmw
         reqBi4yWPwf/oJAnf/Zv9JTJXdBoY0baUd0EG0hXQWA7HvGmLRohzlJRtNessMpyq8Lm
         AHtpsBiOCk/ymQCdv0DCm84Uxk1CMdend8BElx4tGxTkPV+26KFVm5xkCoZEI+yA+iSc
         XAhCZJDfnzdWW0eDyzC3tnhnEMsBHzPhSXNtRDCw3izz1yk0eI+dDBf6y9YufKCSnkUv
         jECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZS1jFax+2UxUSONAINTJJT6NSOgXpazCzY0vS224Ozc=;
        b=jhzBwqCAwLyWjIWlL55qlfrBfBRum+Dym95l6cIeIJAUHa+TQFvZfo6vezPJQ7zmxl
         qfO7OpmNwe88zA7iq7e1d6HC+wuQHFwTaymsrUycCiaDqGofN8igYUpEzs2qLVMiZXV7
         c6O12cSbNh5uVXVGNFM60Wcu6XouDkU7CG+XUnsDlJzM85RDvCWcE9P56K2q0e+8IfhQ
         2MIASuyWPuEG4CR0YnvS3P0sYAhDvAIl/997reUiP0aAPvLQWzzQszBsTutQl9moI8UM
         Bm3RAyCeDyco34atItUZs5mGKducThCugMFqE8lFtRSbhHOljBKMnjk5v90ZmJc3F4aX
         O2iw==
X-Gm-Message-State: APjAAAV32AknKOf+Tds5Xa/H/uT1BMcmxrdeodMPgW+kTFr4oTnua8Ux
        1/KRovnJbmWmPQW0mm23XmFFnQ==
X-Google-Smtp-Source: APXvYqxc0MPo7+gu36M8ftZEqf1FcWsYEU/9K7jRunhrcCXdbwlwq27RPMMaMLwiCjBmkYJXowILYg==
X-Received: by 2002:a2e:900e:: with SMTP id h14mr16768218ljg.27.1572992696371;
        Tue, 05 Nov 2019 14:24:56 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s25sm4020139lji.81.2019.11.05.14.24.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:24:55 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>,
        Pooja Trivedi <poojatrivedi@gmail.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 2/3] net/tls: add a TX lock
Date:   Tue,  5 Nov 2019 14:24:35 -0800
Message-Id: <20191105222436.27359-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105222436.27359-1-jakub.kicinski@netronome.com>
References: <20191105222436.27359-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS TX needs to release and re-acquire the socket lock if send buffer
fills up.

TLS SW TX path currently depends on only allowing one thread to enter
the function by the abuse of sk_write_pending. If another writer is
already waiting for memory no new ones are allowed in.

This has two problems:
 - writers don't wake other threads up when they leave the kernel;
   meaning that this scheme works for single extra thread (second
   application thread or delayed work) because memory becoming
   available will send a wake up request, but as Mallesham and
   Pooja report with larger number of threads it leads to threads
   being put to sleep indefinitely;
 - the delayed work does not get _scheduled_ but it may _run_ when
   other writers are present leading to crashes as writers don't
   expect state to change under their feet (same records get pushed
   and freed multiple times); it's hard to reliably bail from the
   work, however, because the mere presence of a writer does not
   guarantee that the writer will push pending records before exiting.

Ensuring wakeups always happen will make the code basically open
code a mutex. Just use a mutex.

The TLS HW TX path does not have any locking (not even the
sk_write_pending hack), yet it uses a per-socket sg_tx_data
array to push records.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Reported-by: Mallesham  Jatharakonda <mallesh537@gmail.com>
Reported-by: Pooja Trivedi <poojatrivedi@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls.h    |  5 +++++
 net/tls/tls_device.c |  6 ++++++
 net/tls/tls_main.c   |  2 ++
 net/tls/tls_sw.c     | 21 +++++++--------------
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index c664e6dba0d1..794e297483ea 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -40,6 +40,7 @@
 #include <linux/socket.h>
 #include <linux/tcp.h>
 #include <linux/skmsg.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/rcupdate.h>
 
@@ -269,6 +270,10 @@ struct tls_context {
 
 	bool in_tcp_sendpages;
 	bool pending_open_record_frags;
+
+	struct mutex tx_lock; /* protects partially_sent_* fields and
+			       * per-type TX fields
+			       */
 	unsigned long flags;
 
 	/* cache cold stuff */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 5a3715ddc592..683d00837693 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -523,8 +523,10 @@ static int tls_push_data(struct sock *sk,
 int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	int rc;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -538,12 +540,14 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 out:
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return rc;
 }
 
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct iov_iter	msg_iter;
 	char *kaddr = kmap(page);
 	struct kvec iov;
@@ -552,6 +556,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
 	if (flags & MSG_OOB) {
@@ -568,6 +573,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 
 out:
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return rc;
 }
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ac88877dcade..0775ae40fcfb 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -267,6 +267,7 @@ void tls_ctx_free(struct sock *sk, struct tls_context *ctx)
 
 	memzero_explicit(&ctx->crypto_send, sizeof(ctx->crypto_send));
 	memzero_explicit(&ctx->crypto_recv, sizeof(ctx->crypto_recv));
+	mutex_destroy(&ctx->tx_lock);
 
 	if (sk)
 		kfree_rcu(ctx, rcu);
@@ -612,6 +613,7 @@ static struct tls_context *create_ctx(struct sock *sk)
 	if (!ctx)
 		return NULL;
 
+	mutex_init(&ctx->tx_lock);
 	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	ctx->sk_proto = sk->sk_prot;
 	return ctx;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e155b792df0b..446f23c1f3ce 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -897,15 +897,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -ENOTSUPP;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
-	/* Wait till there is any pending write on socket */
-	if (unlikely(sk->sk_write_pending)) {
-		ret = wait_on_pending_writer(sk, &timeo);
-		if (unlikely(ret))
-			goto send_end;
-	}
-
 	if (unlikely(msg->msg_controllen)) {
 		ret = tls_proccess_cmsg(sk, msg, &record_type);
 		if (ret) {
@@ -1091,6 +1085,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
 
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return copied ? copied : ret;
 }
 
@@ -1114,13 +1109,6 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
-	/* Wait till there is any pending write on socket */
-	if (unlikely(sk->sk_write_pending)) {
-		ret = wait_on_pending_writer(sk, &timeo);
-		if (unlikely(ret))
-			goto sendpage_end;
-	}
-
 	/* Call the sk_stream functions to manage the sndbuf mem. */
 	while (size > 0) {
 		size_t copy, required_size;
@@ -1219,15 +1207,18 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags)
 {
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	int ret;
 
 	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -ENOTSUPP;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return ret;
 }
 
@@ -2170,9 +2161,11 @@ static void tx_work_handler(struct work_struct *work)
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 	tls_tx_records(sk, -1);
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 }
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
-- 
2.23.0


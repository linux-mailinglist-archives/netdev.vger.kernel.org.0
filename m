Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE062B0D62
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgKLTDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbgKLTDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:03:02 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFD0C0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:03:01 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f27so5000076pgl.1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ej/ere3U8cds1oBI8o3BGl4O7tQDAJUPvUxGNKrx630=;
        b=UjJcQ35XsQvFnjW6IMbXC9yfwNGVlpvK5WBA76EqsULKYbgI6t3ExTefRhTS2ska6V
         VhBRPW8otyVSwZh8TZSTV66LUmGZiiBEmRQJ6Ho9juJ2aou1FgxbnlNloe4GUKvUSVUL
         Nfa5yPhNRt/PHSkhYVs0RikkE6iXGr7yFiB8bj6TzSfUY4iP9r6qppBjnSKVri+ld62c
         iduLWU4hraTk62tKB4XLe8pebLf8EG2L4KTFEZGNPzKEg2NRi2rA0AF3opOxuEynHrjd
         jLhD/FTgM8eXLOvQq1WLI3ckNMzrM6U//3PsVZ4qTzTy0uD0YisBD2bMAunHFfM2MdCj
         4q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ej/ere3U8cds1oBI8o3BGl4O7tQDAJUPvUxGNKrx630=;
        b=hzUfWuHAiVk3aIhtB+Bzxfs3gfp6j3AYGrQAlI6+HCh2os+DLzDqWDsDnZV0iTnHoV
         xTCyD9P6k/JQE2muxJEHziqY5wocUtT84qFz7nr8YChACj48Y/czIbzjfHVEzP9R+f1l
         N8QCYxBRf3EatlKdmfqNaXPyf9xkd7Ti2nbxnS3S/c1NkQdvcYciZy/ahpXM6CAtzpgk
         A1SnDORRELNG/wHPXa+bqOYJcTx8j35PCHZZVMRQksukNDureH+t6rcWEwE64sbxN34G
         1CkuGcOsSm/OCVhQrlZCr2SaMjU5GrWsbrMeLZF3+jcC4ULnR6loDw+4myFhXJGD380Q
         bvZw==
X-Gm-Message-State: AOAM533F29bAccWd2B8yTaKW/KrvuQjKdQEju+vAbtsZzCE3Wp+sRAKI
        LR0C283ltOcrd04nrv55E56KETgdsXY=
X-Google-Smtp-Source: ABdhPJzmO5935W2f3gVfx7VmIWuy0XUsNtt6O0D+k7PvGUTlNQHcqtWN9PpQ8D++F8uwANkdGc/Hfw==
X-Received: by 2002:a63:db50:: with SMTP id x16mr760072pgi.205.1605207781555;
        Thu, 12 Nov 2020 11:03:01 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:03:01 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 6/8] tcp: Introduce short-circuit small reads for recv zerocopy.
Date:   Thu, 12 Nov 2020 11:02:03 -0800
Message-Id: <20201112190205.633640-7-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Sometimes, we may call tcp receive zerocopy when inq is 0,
or inq < PAGE_SIZE, or inq is generally small enough that
it is cheaper to copy rather than remap pages.

In these cases, we may want to either return early (inq=0) or
attempt to use the provided copy buffer to simply copy
the received data.

This allows us to save both system call overhead and
the latency of acquiring mmap_sem in read mode for cases where
it would be useless to do so.

This patch enables this behaviour by:
1. Returning quickly if inq is 0.
2. Attempting to perform a regular copy if a hybrid copybuffer is
   provided and it is large enough to absorb all available bytes.
3. Return quickly if no such buffer was provided and there are less
   than PAGE_SIZE bytes available.

For small RPC ping-pong workloads, normally we would have
1 getsockopt(), 1 recvmsg() and 1 sendmsg() call per RPC. With this
change, we remove the recvmsg() call entirely, reducing the syscall
overhead by about 33%. In testing with small (hundreds of bytes)
RPC traffic, this yields a syscall reduction of about 33% and
an efficiency gain of about 3-5% when defined as QPS/CPU Util.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 38f8e03f1182..ca45a875147e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1785,6 +1785,35 @@ static int find_next_mappable_frag(const skb_frag_t *frag,
 	return offset;
 }
 
+static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
+			      int nonblock, int flags,
+			      struct scm_timestamping_internal *tss,
+			      int *cmsg_flags);
+static int receive_fallback_to_copy(struct sock *sk,
+				    struct tcp_zerocopy_receive *zc, int inq)
+{
+	struct scm_timestamping_internal tss_unused;
+	int err, cmsg_flags_unused;
+	struct msghdr msg = {};
+	struct iovec iov;
+
+	zc->length = 0;
+	zc->recv_skip_hint = 0;
+
+	err = import_single_range(READ, (void __user *)zc->copybuf_address,
+				  inq, &iov, &msg.msg_iter);
+	if (err)
+		return err;
+
+	err = tcp_recvmsg_locked(sk, &msg, inq, /*nonblock=*/1, /*flags=*/0,
+				 &tss_unused, &cmsg_flags_unused);
+	if (err < 0)
+		return err;
+
+	zc->copybuf_len = err;
+	return 0;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1885,6 +1914,9 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
+	if (inq && inq <= copybuf_len)
+		return receive_fallback_to_copy(sk, zc, inq);
+
 	if (inq < PAGE_SIZE) {
 		zc->length = 0;
 		zc->recv_skip_hint = inq;
-- 
2.29.2.222.g5d2a92d10f8-goog


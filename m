Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEBF2CCA0A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgLBWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387744AbgLBWzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:55:15 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A85C061A4C
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:59 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id b23so32741pls.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ydveksiLM6/azYNCUoqD8knHGXlio7YZIFn6mGmF60c=;
        b=VMe5ka88AZ2cZLL0nTuwk57+X+LN4xGH76PN6YiMs+62nxNklIzr57sVc2xeD2XlGa
         gl3EcCywX4sedNnlYDJ1vSgZza+c1e4BmzmMcY0Lznk7uorxKAt8i0QNUyHhG63Mlsmq
         VAjUuUp+JLMR2rRPtGB79IkN6PbBI5kFI5HP6CneV7ViU2hR2EE1PC7diwmlSH/SwXzq
         oSPGxTF/qIqe01psoVx++gH/zwlBZjsWCX08Q6IMU2jhOR4eCXVNbIRW2QBVsXrLbVG7
         HUOaV+Bu5UbWEHfmZh6Xq8AU4y6VjqJIlYZ+9+gKTy8KeJh05AmtRdKmvTNnfPLxPmkP
         tbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ydveksiLM6/azYNCUoqD8knHGXlio7YZIFn6mGmF60c=;
        b=HLOiXISOvY9eWFFy8CHWuTuZsJVb1MMs2LrlCvRiF1Lt4x4mkJxzd1A5FKRaRYd0RL
         GvHQByqwkPmxLvdASOGGYeS4zrm15zHBDjNNerBg16AwwbJ0TCDkFBJJVDiTQmrqY7ZI
         83KSZDe4fT/v3hTnSkP/oTAetE/zoIZZ8WgEQ7vQZdmn9VA79rI/LCH1LvcHE29ANAkm
         VMix29oQbUOIdv+N+X5ZDOGFSrpVQ5pY2WXT0PUDOG14BL/KGSjeR2KGCUEyynmD7NBV
         Zrc2AFFpRjsulhHgbiMWbrWe6fjs4SO5F/YCDf+UR4AXkcnazmXjvlx6Ef6yD58Pk1cl
         5JjA==
X-Gm-Message-State: AOAM530HGGxZSxeEuf9s6WxKUIh/8BoP0DyAPQ+WdTIiLVO4vvrpgGjY
        CXpdLUGsvQZjP6ds7x9dak4=
X-Google-Smtp-Source: ABdhPJwMsiQX5q5kik1I5gsvDGOPUTe002Jm6M7pGrGhF/EckKnrhle14LmxYzi1tS2neYCpfca0yw==
X-Received: by 2002:a17:90a:7844:: with SMTP id y4mr209191pjl.68.1606949639566;
        Wed, 02 Dec 2020 14:53:59 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:59 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 6/8] net-zerocopy: Introduce short-circuit small reads.
Date:   Wed,  2 Dec 2020 14:53:47 -0800
Message-Id: <20201202225349.935284-7-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
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

This patchset enables this behaviour by:
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
 net/ipv4/tcp.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b2f24a5ec230..f67dd732a47b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1785,6 +1785,39 @@ static int find_next_mappable_frag(const skb_frag_t *frag,
 	return offset;
 }
 
+static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
+			      int nonblock, int flags,
+			      struct scm_timestamping_internal *tss,
+			      int *cmsg_flags);
+static int receive_fallback_to_copy(struct sock *sk,
+				    struct tcp_zerocopy_receive *zc, int inq)
+{
+	unsigned long copy_address = (unsigned long)zc->copybuf_address;
+	struct scm_timestamping_internal tss_unused;
+	int err, cmsg_flags_unused;
+	struct msghdr msg = {};
+	struct iovec iov;
+
+	zc->length = 0;
+	zc->recv_skip_hint = 0;
+
+	if (copy_address != zc->copybuf_address)
+		return -EINVAL;
+
+	err = import_single_range(READ, (void __user *)copy_address,
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
@@ -1889,6 +1922,9 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
+	if (inq && inq <= copybuf_len)
+		return receive_fallback_to_copy(sk, zc, inq);
+
 	if (inq < PAGE_SIZE) {
 		zc->length = 0;
 		zc->recv_skip_hint = inq;
-- 
2.29.2.576.ga3fc446d84-goog


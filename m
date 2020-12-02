Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167812CC969
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgLBWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBWL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:11:28 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E0AC061A49
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p6so1897892plr.7
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HGWorQKZtUsiU/9suEjJpSdiZpLS/Ni42A/DUaNeKYo=;
        b=P96ZJ68lxk+tVis5jmLz+0ask2CfEC/tkDVQPgCVJv1h3xE7Z12IhQNZy3Y4HwK0ch
         1HKWJli7gwKn8u+OX3EyUWF6KXrPgYo9Vipo9QA5PuoyJBv0/VOInsgOZtvAOZ+ob81U
         vgDuoMSvgOx7eqBOLp2kus8GQR17etf2w1k1XZAZpgUqCt9bzvtLTeVpYS3lQFH4Phkb
         FTEj9q5PnO28F1PMrzUpq+PjvZz0jdhCM+9WH5NhtpG/7YlsQcP2U3IVz74+30STEAlQ
         MCAPKkvfB3DSW7EqHiGjMx8XPqXOwaLzU+49/s+NLHeZnFZ0PJStnxen3DnKJprAmU7H
         R9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HGWorQKZtUsiU/9suEjJpSdiZpLS/Ni42A/DUaNeKYo=;
        b=K4XCXi7Ju1TqaXHRKxjR7gH1CwxvQTs9PNkLbxrBNBAkit1myMg2L+c/y+F+45vtbz
         wg7j2mU7/wWZIj4j+u/w25LcElSmUNXLCCID+dLRMgHqIlBanV+yFEmzucoHoE1b6Ca1
         eQLyEFTR7ZCEkg1RBpYtrFiaMbwhaiK1hx8S5VZPvt1GBJBsIWupI9OyeaItzPV4C+YL
         fVIfFwu1QwPStQG75MrAtiO5khDFYJbOTkURoelgFKRX48qOA86ZnOVt4Ta6FK7bw1bK
         VaPUXgFlzidnsm8oSsUMChJyBbf4leSCXlzjhqzx716XwXdf2ZxhjhRG9Wlwm8WQFbKR
         FWPw==
X-Gm-Message-State: AOAM532GUY75iwWOEDOKG43Jc4bnrfO7ygnWbFIpIbEB/SUT3LU/cTL9
        WfxMkchfLk1ZZvSd9uvvW48=
X-Google-Smtp-Source: ABdhPJyq8709qKjfU+XkFCEYPuJpHhBitVwdDLvad38KLW1Ot6a9QAanBWEx2BDCOflX8Y0UXGVe4A==
X-Received: by 2002:a17:90a:cce:: with SMTP id 14mr47841pjt.163.1606947022339;
        Wed, 02 Dec 2020 14:10:22 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:21 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 6/8] net-zerocopy: Introduce short-circuit small reads.
Date:   Wed,  2 Dec 2020 14:09:43 -0800
Message-Id: <20201202220945.911116-7-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
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


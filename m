Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42C7513FB2
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353041AbiD2As1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 20:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353051AbiD2As0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 20:48:26 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBD012751
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 17:45:09 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x12so5305725pgj.7
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 17:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=73WGbLuhgqmsQkqIE+PxAoJ2hPjtW4L9aOsoeXCm0WM=;
        b=jnEhORTZuKLZOqAwLfQiGMJPkiTXPqqqZ0funLXJEvf/I6w+XgebbrxRFRZJcgntHP
         JoXorrujXRm0oW6py95ULW6RNYluUmtPY0JJ9Gwr4OnpYRx+6PRH4qgpcYpsJBhIDVyY
         f+qetaO7JcmuzY5ZvB/hXQu3Qmt1I4T9Y2K+HzBvH5mFOma+++new0dOUAn6dzg2pcvJ
         xA0wxQR37OyQOQWCGIRIZHk4pO/46t22FDdZyYjXB4mNpcbP4dKtBrNgJEfR6R16A0fg
         RB0BQVVMGp66bx1EwdV5dmLANqh2zQhiQmlX6oof36EBnJMzH3Ds4eOkx2/FhjpQZk13
         Q8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=73WGbLuhgqmsQkqIE+PxAoJ2hPjtW4L9aOsoeXCm0WM=;
        b=ZwC1ykvmRqxqQ54/SLZStskfLwJljvQCZ9URr/xAIUg6BBNEmGjri5sob5Eceh76mp
         mijtwEcuZBoD6yNcoW5xrIh5Lgg8qo0quhmV8oVE+l+vna4ppd6ld77YdtPCK1FDizIA
         sx7p7JLjtmuyi0/bLTTv3KbCEzeXy3AEFVOZ7orck+dFaXcLSQ8YLPfuXrXLg2L+L9st
         WaYJnhd73UOxKRi6acEj42wEP2b+si3RZ+pPu7HjIWyKxgy2VjqDqV5IPjdHl2tegZfR
         oRJV/dGQoH0oeTOrL4+VtSL7oykCJ9q3UhqXwwpJWUxTQ5+myMKeq+icfZ7A85K4IP2v
         1KPA==
X-Gm-Message-State: AOAM533vDtKlnZ+mLlvVtlYG9wtbzs3Ktx7Wfz07j0MBkT8jMoV9uBvy
        VqX4GS2svzWlyBto73dPEGXlrie38qpK+Nmo
X-Google-Smtp-Source: ABdhPJzvjj87VMcg0XCFSrqyT4TAxxfwJx8uYvI7gk18QG4CvOEqI2fgLUKdoWS7vPa2d3um9BJA2g==
X-Received: by 2002:a05:6a00:1514:b0:50d:9d1c:309 with SMTP id q20-20020a056a00151400b0050d9d1c0309mr5190081pfu.85.1651193108319;
        Thu, 28 Apr 2022 17:45:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c2-20020aa781c2000000b0050a7ff01d2bsm987309pfn.30.2022.04.28.17.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 17:45:07 -0700 (PDT)
Message-ID: <650c22ca-cffc-0255-9a05-2413a1e20826@kernel.dk>
Date:   Thu, 28 Apr 2022 18:45:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3] tcp: pass back data left in socket after receive
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is currently done for CMSG_INQ, add an ability to do so via struct
msghdr as well and have CMSG_INQ use that too. If the caller sets
msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.

Rearrange struct msghdr a bit so we can add this member while shrinking
it at the same time. On a 64-bit build, it was 96 bytes before this
change and 88 bytes afterwards.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

v3: - put TP_CMSG_INQ branch inside msg->msg_get_inq
    - Add Eric's Reviewed-by

 include/linux/socket.h |  6 +++++-
 net/ipv4/tcp.c         | 16 ++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 6f85f5d957ef..12085c9a8544 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -50,6 +50,9 @@ struct linger {
 struct msghdr {
 	void		*msg_name;	/* ptr to socket address structure */
 	int		msg_namelen;	/* size of socket address structure */
+
+	int		msg_inq;	/* output, data left in socket */
+
 	struct iov_iter	msg_iter;	/* data */
 
 	/*
@@ -62,8 +65,9 @@ struct msghdr {
 		void __user	*msg_control_user;
 	};
 	bool		msg_control_is_user : 1;
-	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
+	bool		msg_get_inq : 1;/* return INQ after receive */
 	unsigned int	msg_flags;	/* flags on received message */
+	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index db55af9eb37b..b44fde435bd1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2314,8 +2314,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	if (tp->recvmsg_inq)
+	if (tp->recvmsg_inq) {
 		*cmsg_flags = TCP_CMSG_INQ;
+		msg->msg_get_inq = 1;
+	}
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	/* Urgent data needs to be handled specially. */
@@ -2537,7 +2539,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		int *addr_len)
 {
-	int cmsg_flags = 0, ret, inq;
+	int cmsg_flags = 0, ret;
 	struct scm_timestamping_internal tss;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
@@ -2552,12 +2554,14 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	ret = tcp_recvmsg_locked(sk, msg, len, flags, &tss, &cmsg_flags);
 	release_sock(sk);
 
-	if (cmsg_flags && ret >= 0) {
+	if ((cmsg_flags || msg->msg_get_inq) && ret >= 0) {
 		if (cmsg_flags & TCP_CMSG_TS)
 			tcp_recv_timestamp(msg, sk, &tss);
-		if (cmsg_flags & TCP_CMSG_INQ) {
-			inq = tcp_inq_hint(sk);
-			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
+		if (msg->msg_get_inq) {
+			msg->msg_inq = tcp_inq_hint(sk);
+			if (cmsg_flags & TCP_CMSG_INQ)
+				put_cmsg(msg, SOL_TCP, TCP_CM_INQ,
+					 sizeof(msg->msg_inq), &msg->msg_inq);
 		}
 	}
 	return ret;
-- 
2.35.1

-- 
Jens Axboe


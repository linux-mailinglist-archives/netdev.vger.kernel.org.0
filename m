Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B30B512318
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiD0Tww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiD0Tws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:52:48 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC664CD60
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 12:49:36 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id m6so220764iob.4
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 12:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=z3O16WhfxqrDX7OBJdD8vDw/C0xRNN3lTfjHLGP145k=;
        b=G6nfxuV62L6x8ug5EoE9oeH0o4NIGdlLI8tcVJSAqAB+yP80E1Khr/95VfZ+4c43sQ
         KY6NYBU3bOK0yct2T5yqp5eVYH37QAQEWlSLxtRnDd4fCcuKWOzSvgmasMGoi+wMc9GB
         1G3SUEMnRMKrPsJTqs+hjZA95UcoxtowmOWFl7KYsCfznZsEVGxH0EIx12ISuqD7nuvu
         muOZdny95QSmRMaqX91ax8E7oHCzV+nxSnfMz2Cbk06/9OSLSnz0nIId6R/xe/0A/+Hp
         sZGGR4qrHq+ouLogDydYrbzasmEs8HhmgCtd8UG/1967A8i5Mg/MGAuDRWysgLnSr97R
         0ZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=z3O16WhfxqrDX7OBJdD8vDw/C0xRNN3lTfjHLGP145k=;
        b=HGdPGfsFmD/y2vQz8aff41jpJp6/BG3uYejuBd1ZlhXG7vcITUb+QK1JFNhxxD5S3o
         tQerPYMiQ66lOhttmqT8gv/vQeGyfthg3x9oqKN6dJxMv3PKBz9VolWbpG2SxJX7JtVC
         TTvYAc4a13zm2vzwxaDMDgbaO/g8ItHM1ftb3dvSe97mnnpQiJ8en77Su88p8ZLebtIw
         5urleouI/to8Wt4M0av9MZprq7+4x4m7+38ZvrvjAawBWI6VtLn5bY5syQshqo4pQzkL
         9MJ/PjZLnzNRCmFreqGtf0HKt1ESn2HuzXmO7xuWCjpCGg3FAl/rxYVp2OCHxmMyi12m
         Fgbw==
X-Gm-Message-State: AOAM533JdBZgJoenc5LJY5hb1LEvbzG+33tMdFXcDLe6kjKQ81adPZ/d
        VS7gMvgMnMG+sNNnJPhRb66aMuGHTJbzbg==
X-Google-Smtp-Source: ABdhPJzf684Sm2jApm9r0SagebC9H7MRimrxJzOh5yCUKQhgXAH4jVfsp9ypz9FT5StjLPyPGLiVsA==
X-Received: by 2002:a05:6638:3014:b0:317:9daf:c42c with SMTP id r20-20020a056638301400b003179dafc42cmr12934579jak.10.1651088975227;
        Wed, 27 Apr 2022 12:49:35 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r14-20020a92ce8e000000b002cd66e0bbc1sm10117855ilo.33.2022.04.27.12.49.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 12:49:34 -0700 (PDT)
Message-ID: <064c8731-e7f9-c415-5d4d-141a559e2017@kernel.dk>
Date:   Wed, 27 Apr 2022 13:49:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] net: pass back data left in socket after receive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

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
index cf18fbcbf123..78d79e26fb4d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2335,8 +2335,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	if (tp->recvmsg_inq)
+	if (tp->recvmsg_inq) {
 		*cmsg_flags = TCP_CMSG_INQ;
+		msg->msg_get_inq = 1;
+	}
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	/* Urgent data needs to be handled specially. */
@@ -2559,7 +2561,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		int flags, int *addr_len)
 {
-	int cmsg_flags = 0, ret, inq;
+	int cmsg_flags = 0, ret;
 	struct scm_timestamping_internal tss;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
@@ -2576,12 +2578,14 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	release_sock(sk);
 	sk_defer_free_flush(sk);
 
-	if (cmsg_flags && ret >= 0) {
+	if ((cmsg_flags || msg->msg_get_inq) && ret >= 0) {
 		if (cmsg_flags & TCP_CMSG_TS)
 			tcp_recv_timestamp(msg, sk, &tss);
+		if (msg->msg_get_inq)
+			msg->msg_inq = tcp_inq_hint(sk);
 		if (cmsg_flags & TCP_CMSG_INQ) {
-			inq = tcp_inq_hint(sk);
-			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
+			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(msg->msg_inq),
+				 &msg->msg_inq);
 		}
 	}
 	return ret;

-- 
Jens Axboe


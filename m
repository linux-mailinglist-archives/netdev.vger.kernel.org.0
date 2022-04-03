Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2AF4F0998
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358515AbiDCNKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358552AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81B217A8D
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:34 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w4so10596416wrg.12
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQROuweWM/sccPHitCdr191lrVLAeR8d9SPDAu73ZAg=;
        b=pyoE93zTijQuGGdL+1oQIdwkjWOaN0xSooVn7JV+eEsMbLCpfzRhF/5E+u4J/yRS6K
         EHWA9taZyO0+ZA0uc0yyn9pb0uy5X2XlIr/L/E74e05kFX4eim5F6p/9RCfGuQ2p39dU
         P29vwVFOqaI+qbwBKT4BLL23yYsszGC0MRABA6B1xjUTAKsjR3kiyqZIaeDAXwLWm1Q9
         ry4blh8Tlnw0DYX0OCB6XwJs3PGG9xA8exq+lmJfgPK+ikq3/tk56+NKEEzyEl6NEM3d
         P4oTt4UucejAIeUnDvrwAHSY9FkZz7Su7zb7VGzaAxNsffcFJQEVzJVYzBulMcUvvJ4F
         3sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQROuweWM/sccPHitCdr191lrVLAeR8d9SPDAu73ZAg=;
        b=ozKAyCeUJ3s3hbkWxMOrIpbO1ZbEUFN73SsWYQUxscZa9oASODVuZX/BqsJeKn9AUG
         hoiQFUaX0dao/E8q6owRuTBKav9oMme2+ZgCsF2IDvxVQF2T+0sTI1g9F1cV7geqjAju
         yqlVZ5sYu4JtJNVBfO53KMUFNY/tLByM3o8ibHv6YavwXS/CruIzbxxNJuLuFAMM7EiR
         W+UEGxKsCjtKrlxkWTUcukb/OJXsyQewcv38D6af3QY3VYqiKFVI6k2hjUzR+s8NEAsy
         mNMhvcs47ST3eaWnwOdnI5WS3VxETakojXGyncinZA7DPlmRgH73EjeI2miCjmdn+rI4
         OOMQ==
X-Gm-Message-State: AOAM532DHkdbMF0aHFlnaA5m78aLzn3dtZnfjWXLNd5nixtvBXSols3z
        zPSLbpErQ/R1s7NSeOTzzcNrlWsKEB0=
X-Google-Smtp-Source: ABdhPJxm1FlYXT68QjSdTZIe4HVfMLFopV6TPF7TaBDUTGuCczRYIa3zqmeLFQQMTMX4eR2YWtIvXw==
X-Received: by 2002:a5d:54ce:0:b0:205:133d:c152 with SMTP id x14-20020a5d54ce000000b00205133dc152mr13820207wrv.334.1648991312548;
        Sun, 03 Apr 2022 06:08:32 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 19/27] udp/ipv6: refactor udpv6_sendmsg udplite checks
Date:   Sun,  3 Apr 2022 14:06:31 +0100
Message-Id: <06d86a707139f7a0127952bb6dae977cad94e573.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't save a IS_UDPLITE() result in advance but do when it's really
needed, so it doesn't store/load it from the stack. Same for resolving
the getfrag callback pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4b15b37fc8f9..588bd7e3ebc1 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1310,7 +1310,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int ulen = len;
 	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
-	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
 	ipcm6_init_sk(&ipc6, np);
@@ -1371,7 +1370,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (len > INT_MAX - sizeof(struct udphdr))
 		return -EMSGSIZE;
 
-	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
 		if (up->pending == AF_INET)
 			return udp_sendmsg(sk, msg, len);
@@ -1538,6 +1536,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (!corkreq) {
 		struct sk_buff *skb;
 
+		getfrag = IS_UDPLITE(sk) ? udplite_getfrag : ip_generic_getfrag;
 		skb = ip6_make_skb(sk, getfrag, msg, ulen,
 				   sizeof(struct udphdr), &ipc6,
 				   (struct rt6_info *)dst,
@@ -1564,6 +1563,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 do_append_data:
 	up->len += ulen;
+	getfrag = IS_UDPLITE(sk) ? udplite_getfrag : ip_generic_getfrag;
 	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
 			      &ipc6, fl6, (struct rt6_info *)dst,
 			      corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
@@ -1594,7 +1594,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	 */
 	if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
 		UDP6_INC_STATS(sock_net(sk),
-			       UDP_MIB_SNDBUFERRORS, is_udplite);
+			       UDP_MIB_SNDBUFERRORS, IS_UDPLITE(sk));
 	}
 	return err;
 
-- 
2.35.1


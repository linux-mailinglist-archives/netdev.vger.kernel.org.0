Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F27D5135E3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347881AbiD1OCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347841AbiD1OCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2F0AFB22;
        Thu, 28 Apr 2022 06:58:50 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id i19so9713498eja.11;
        Thu, 28 Apr 2022 06:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mnpdGRyJiicLRHa2IgTDV7oi07PrHAZNJEbFWn+qIEE=;
        b=A+uJOXp/j0z7GOW61vteBo9ZVMEVCsOZulAkxcSZnlPvNcWxmqsmQjjY8i9V7h5h19
         cL1exyl2qXaWU+bMycx9p0kvebfLwR8UTBespx+6IYc+YbRzfn9nNsW7xzMpoUKYbQqp
         vANrrRlMdfm5Mja0XV+EwiHyusJsxKqkjktpN4xCSNByH0fbVq4cfjATJpENW6bJfBir
         8Gh1L8nwcnpri9wsJLZ1f6f0TxqS4Xn5T0g7M9YKsoZAi8z6+5FEVC2QH8+B2IxhHWId
         loeMl54tmrV9bimmLVJNMlqbLB93nIAB+iiwG1+CrzBVKD0Lf2c8SJZ+xvgij+2qF90l
         bjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mnpdGRyJiicLRHa2IgTDV7oi07PrHAZNJEbFWn+qIEE=;
        b=lvIApdNJa8zj/zL1SCY90hO/nmHcH7BTOBkEPgu1EFCP6aho9Mhqfw6parzMDjZtCt
         u0p6yHFf52zUh3QSPGKmCTCrx3ihoT9h/p+zHginpGtpO8oteuY3xjBtg2kdekU1jxh0
         9p1n01GoYqjXqB45RlVBnf7TiCaKAtFbd3hUIMlzymsV1aYdPmuPhcYlf9xOnSkgRRc/
         wuFF7CnDukl6vFmSyUFN7MG2d0FjqoJjzJ2pH5sYhR7S5JZ1dI5jN7N6E0vrxxDXX3nF
         mOgNCT5HM6UrSdA1VVxJ8k9qIngstzgwqWxS2AQn0tyStba1EyuBF8Nk7S8cHY6WvmQQ
         B79A==
X-Gm-Message-State: AOAM531jnVVC7Svy7A2s4gXr+lX6j44t6q2NiZzgVDrrCOItJB0Fvgy6
        iB648qICDfqjj261utYdORZMh7mGeOs=
X-Google-Smtp-Source: ABdhPJy9YAqifjCUO6Yv1OvhtoJLZRpJ5O48gsyaDASK26eIGM02T+Cq6Npt0ToouWD54F6k2YRYgA==
X-Received: by 2002:a17:907:7ba6:b0:6f3:8f56:793b with SMTP id ne38-20020a1709077ba600b006f38f56793bmr21612573ejc.473.1651154328438;
        Thu, 28 Apr 2022 06:58:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 02/11] udp/ipv6: refactor udpv6_sendmsg udplite checks
Date:   Thu, 28 Apr 2022 14:57:57 +0100
Message-Id: <33dfdf2119c86e35062f783d405bedec2fde2b4c.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index de8382930910..705eea080f5e 100644
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
2.36.0


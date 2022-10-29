Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26115612335
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJ2NMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJ2NMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:12:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA14696F9;
        Sat, 29 Oct 2022 06:11:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r18so7043032pgr.12;
        Sat, 29 Oct 2022 06:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GL2gYlQkLzPoDIZWhMbnN0oVuFwh4pQ+nvuIXIbJr+k=;
        b=PeaKicSueNNwluthUUpLsFaq4Oj21LPmkC/i5Gdlq5zEE9BT0YDTR8Kqi/fnm1F5sV
         +8uDPDHqoBVfdOT4zMA/pSVNMf9OYraBUZ+xXf5gGgJr8prnuTMs30zyNATc7ziJhAE5
         ujEcqWO0hCaFV0bDBxbFoxzlKyZuFM9je8Btqzt/4ls/bvwU/h8IipaXmX3TRj2yWtZr
         FWpacKnidQtvv7lLjc49Ahfj8J5KFIyZlwDSVHnXacJbmN8wIf9gAQUN5y6GYBVFOnKd
         G5dOrhmqUZRZT5/mNW2W5//Mph8u5/foYXEj1dguhFJHxNt7JTyUBMC31MAuaYMrvbmK
         u1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GL2gYlQkLzPoDIZWhMbnN0oVuFwh4pQ+nvuIXIbJr+k=;
        b=2IOIhz9q8VmjEG0Xy253nQvueqI0gKcVZxpVAe0KxbmCmNWVKjy7QjKTWf+aK9Z2xq
         T7ma7N1kwJDDNNY/Ya9wWD8CG+VXiADKOZdSQPoU23I0ElyKnLUof8pTRL+vgo972t2P
         QIvU5wcO3mn7J5AMOYPELCXFzgcZjARYFx6ykfoc5TzSR3XdnE4+rwkwKXPsgg7iKxdw
         UfO00IbH0hE/JEcf0AVvczHIohsuZjXA0AiA62CQFlXRHkXvG/KNbjjEsPMveCDrVzLs
         s1oaXHMd08YolxDQDdavUXAjGuf8SnGTZqOZVl5NQ07aui+cyq2L5tUitpK/87QDOIzT
         zCNw==
X-Gm-Message-State: ACrzQf0A4kXmJYowwMVuJX4ZMbl7rCEAMtBb68ZGaGJVxuKG3cS4kovy
        Qk3IOw19mL8trCGHK+LLSR8=
X-Google-Smtp-Source: AMsMyM639daYTjQLLAVsASBpP5PG4tJO8nJOAJTvEFIdJkFHmhZrejqjpXA68+/YdvBAvqcDSqdWMQ==
X-Received: by 2002:a65:5184:0:b0:439:14cb:fbe4 with SMTP id h4-20020a655184000000b0043914cbfbe4mr3956186pgq.166.1667049094003;
        Sat, 29 Oct 2022 06:11:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:33 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 8/9] net: tcp: store drop reasons in route_req
Date:   Sat, 29 Oct 2022 21:09:56 +0800
Message-Id: <20221029130957.1292060-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221029130957.1292060-1-imagedong@tencent.com>
References: <20221029130957.1292060-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Add skb drop reasons to tcp_v4_route_req() and tcp_v6_route_req().

And the new reason SKB_DROP_REASON_LSM is added, which is used when
skb is dropped by LSM.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h |  5 +++++
 net/ipv4/tcp_ipv4.c      | 11 +++++++++--
 net/ipv6/tcp_ipv6.c      | 11 +++++++++--
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 364811bce63f..a5de00d02213 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -74,6 +74,7 @@
 	FN(TCP_REQQFULLDROP)		\
 	FN(TCP_ABORTONDATA)		\
 	FN(TCP_ABORTONLINGER)		\
+	FN(LSM)				\
 	FNe(MAX)
 
 /**
@@ -336,6 +337,10 @@ enum skb_drop_reason {
 	 * LINUX_MIB_TCPABORTONLINGER
 	 */
 	SKB_DROP_REASON_TCP_ABORTONLINGER,
+	/**
+	 * @SKB_DROP_REASON_LSM: dropped by LSM
+	 */
+	SKB_DROP_REASON_LSM,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a85bc7483c5a..8fdea8e6207f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1447,12 +1447,19 @@ static struct dst_entry *tcp_v4_route_req(const struct sock *sk,
 					  struct flowi *fl,
 					  struct request_sock *req)
 {
+	struct dst_entry *dst;
+
 	tcp_v4_init_req(req, sk, skb);
 
-	if (security_inet_conn_request(sk, skb, req))
+	if (security_inet_conn_request(sk, skb, req)) {
+		TCP_SKB_DR(skb, LSM);
 		return NULL;
+	}
 
-	return inet_csk_route_req(sk, &fl->u.ip4, req);
+	dst = inet_csk_route_req(sk, &fl->u.ip4, req);
+	if (!dst)
+		TCP_SKB_DR(skb, IP_OUTNOROUTES);
+	return dst;
 }
 
 struct request_sock_ops tcp_request_sock_ops __read_mostly = {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2c2048832714..44c4aa2789d6 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -823,12 +823,19 @@ static struct dst_entry *tcp_v6_route_req(const struct sock *sk,
 					  struct flowi *fl,
 					  struct request_sock *req)
 {
+	struct dst_entry *dst;
+
 	tcp_v6_init_req(req, sk, skb);
 
-	if (security_inet_conn_request(sk, skb, req))
+	if (security_inet_conn_request(sk, skb, req)) {
+		TCP_SKB_DR(skb, LSM);
 		return NULL;
+	}
 
-	return inet6_csk_route_req(sk, &fl->u.ip6, req, IPPROTO_TCP);
+	dst = inet6_csk_route_req(sk, &fl->u.ip6, req, IPPROTO_TCP);
+	if (!dst)
+		TCP_SKB_DR(skb, IP_OUTNOROUTES);
+	return dst;
 }
 
 struct request_sock_ops tcp6_request_sock_ops __read_mostly = {
-- 
2.37.2


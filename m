Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3655131CC
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344958AbiD1LBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344905AbiD1LA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:56 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6015B9548E;
        Thu, 28 Apr 2022 03:57:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u3so6248310wrg.3;
        Thu, 28 Apr 2022 03:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5oHEvN5cdUAoS8mD1OQl++xLisYKnIOLW+OJZESkSc=;
        b=Sm8A1q1kxYVEA47HbAXch0kITv+fN1ewep5piymoRTT2yvxRDpNjA5qTb1XHCZk4Ph
         cswY8xb8/OYBdhrlLvntm4ZMGWOFlJ+fdvKrw9xiHpTynlvhY5NoQnpyrThiik1Lpr+X
         wTwWXLNd+lYnhBNQOwxvgluJ5yAHGlACFJpw/iMcXdLUvK1cGrdR0tWwlAnk46FSU3b8
         AcwjbIdx50IMQyTWtksImz9PQw+OMb+b3sqorwcDE3duSsxDVnEpc2i+z1qHY3MI0rXF
         n1eHeEEUdBUqARPzBRYKQKdZHUlb3nYXxea+OAu53QPcqloCZkD1tJy4ECEWzIqukD0w
         u7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5oHEvN5cdUAoS8mD1OQl++xLisYKnIOLW+OJZESkSc=;
        b=gIpPWEvl9BcxxvTznftfiHrKzZR0eQ1+8rvvRZYaGZLjY7AYHp/vQfaKyDEJ+ceAy2
         aTu84SY9fsDpy9n3/j2TwpajBAYhx5xVLVjbOxtaflJ37PeTEoxG3cfS226VUYPPSiDX
         bFs+cMsPwX7ecdkvLUapSGdEgHY5ut6JOPHgBRQPi2fl+CieETli47ikiIFTyH7gjxUj
         G9BZbjJy4sbxM+/5puy0kUlEQbfIfX8BYgwhPDhzFJEBxWWlT6YMSrZyZhOEokBPgzV9
         F2E31GZt3ID8YRxvlnA12lkd7yoP9HvIQsDrrpOfzyMmpnfoxQqoXUWP2QYSlIktpPzy
         JGpQ==
X-Gm-Message-State: AOAM530VP1jTEcuBvb1F29u48tjqYD9ZKqabn8JKrLrFn7WzykyeNY4i
        4DWXaIJhHYyFtU6+s7mVsjgRPa474Gs=
X-Google-Smtp-Source: ABdhPJzZbpxwneCyAF012dB97jHs7fdeootMPA96+c/JS4UFCvxVaef9WC/mJFOT3tvJq0xsc6sRTw==
X-Received: by 2002:adf:f152:0:b0:20a:cb56:c20d with SMTP id y18-20020adff152000000b0020acb56c20dmr24137259wro.699.1651143459674;
        Thu, 28 Apr 2022 03:57:39 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 07/11] udp/ipv6: clean up udpv6_sendmsg's saddr init
Date:   Thu, 28 Apr 2022 11:56:38 +0100
Message-Id: <ba41e7ce639f7d8c7c111ef1aa1b3ee6b7a97cae.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
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

We initialise fl6 in udpv6_sendmsg() to zeroes, that sets saddr to any
addr, then it might be changed in by cmsg but only to a non-any addr.
After we check again for it left set to "any", which is likely to be so,
and try to initialise it from socket saddr.

The result of it is that fl6->saddr is set to cmsg's saddr if specified
and inet6_sk(sk)->saddr otherwise. We can achieve the same by
pre-setting it to the sockets saddr and potentially overriding by cmsg
after.

This looks a bit cleaner comparing to conditional init and also removes
extra checks from the way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 34c5919afa3e..ae774766c116 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1431,14 +1431,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		connected = true;
 	}
 
+	fl6->flowi6_uid = sk->sk_uid;
+	fl6->saddr = np->saddr;
+	fl6->daddr = *daddr;
+
 	if (!fl6->flowi6_oif)
 		fl6->flowi6_oif = sk->sk_bound_dev_if;
-
 	if (!fl6->flowi6_oif)
 		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	fl6->flowi6_uid = sk->sk_uid;
-
 	if (msg->msg_controllen) {
 		opt = &opt_space;
 		memset(opt, 0, sizeof(struct ipv6_txoptions));
@@ -1473,9 +1474,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6->flowi6_proto = sk->sk_protocol;
 	fl6->flowi6_mark = ipc6.sockc.mark;
-	fl6->daddr = *daddr;
-	if (ipv6_addr_any(&fl6->saddr) && !ipv6_addr_any(&np->saddr))
-		fl6->saddr = np->saddr;
 	fl6->fl6_sport = inet->inet_sport;
 
 	if (cgroup_bpf_enabled(CGROUP_UDP6_SENDMSG) && !connected) {
-- 
2.36.0


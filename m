Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035505131DE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344889AbiD1LA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbiD1LAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7263591555;
        Thu, 28 Apr 2022 03:57:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e24so6211870wrc.9;
        Thu, 28 Apr 2022 03:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtTf6OOj87b2Qg9AkM3LVkPT3Rm+KpZX5qOlOG7aTiU=;
        b=KHmTOEyyRIQseOWLkxAAeS+EbwjSn2HGLqeyy3qFQFbG6ddhltiuXxDZsbqGFVTOj7
         BhS9D635h69Uenqkxpz20EXUHhuQNy8PKeKYPrQbOXTn84/5cOGwrFra/30yBG44j/JT
         ndDniVAQg7cBTr/Ssxlxpf5O+0DfzblWN+PBJvpZ/Rb2vkNQN1G++uKMwncuQzBE4d8M
         tldXJfaW5rtQ6XCfMkNLLGirZZgTZO9iktnf+Dj0qhScyhxfxmXRcGh5u3uRQnRD/g8J
         TggB7x+VhLpfbpFnRUYal0m7NdZO1YJRi4/FwJBoh/Gn2VWCl5ZH2SvlyaAp8r2B4fzh
         injA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtTf6OOj87b2Qg9AkM3LVkPT3Rm+KpZX5qOlOG7aTiU=;
        b=Eicr5/tiHe7YacW3CpGLzx3abgr7USkoayjAbrhU24VVSDSW0vD1lqWngcIK6wxbd7
         SyNCLnugW8EDCUAPKoAhA+ytAyBuvgObk4Kawffq+xUQaJq5EvWUjEDSFFD7EyD8jYA0
         pZpQITH1TNm1w7LE7r2qo3XPKmR5UiY+PufnxWmclIL44YcsPSEVnIJ1QCkZnLdTl+s9
         2aia64dr2yt1jtUCucQtYckX/xlN8xzjXfqOgS51BxMBz/xajDhBObl1NrP5sKoAd+PW
         eoqsbVZVG5NxsYY2NjGhDcHN3Pt4qdZTkgAZkmYzn6Lon29BnQocQWF620FKqyGDAI7X
         E6JA==
X-Gm-Message-State: AOAM532K77g9RC0xOeC5bIT6ClrsdSNeRX30kU5VSZwgoFeAdpj/vsNm
        RR8xKrSqFLPyGwwLi0pZHIvoTThL7Hk=
X-Google-Smtp-Source: ABdhPJwW1CcIYUBS+m4yhZqOXXXcMT7J1rD+0KloFX8VoQY5lBkrSHdUxYsT4GVCiZe/AZ2Nf+AQzw==
X-Received: by 2002:adf:fc47:0:b0:20a:d494:3ee5 with SMTP id e7-20020adffc47000000b0020ad4943ee5mr20486085wrs.696.1651143454893;
        Thu, 28 Apr 2022 03:57:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 05/11] udp/ipv6: optimise udpv6_sendmsg() daddr checks
Date:   Thu, 28 Apr 2022 11:56:36 +0100
Message-Id: <785698dcf3e1f62e6fbe5b85a42d9704a3a48793.1651071843.git.asml.silence@gmail.com>
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

All paths taking udpv6_sendmsg() to the ipv6_addr_v4mapped() check set a
non zero daddr, we can safely kill the NULL check just before it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 78ce5fc53b59..1f05e165eb17 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1383,19 +1383,18 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		daddr = &sk->sk_v6_daddr;
 	}
 
-	if (daddr) {
-		if (ipv6_addr_v4mapped(daddr)) {
-			struct sockaddr_in sin;
-			sin.sin_family = AF_INET;
-			sin.sin_port = sin6 ? sin6->sin6_port : inet->inet_dport;
-			sin.sin_addr.s_addr = daddr->s6_addr32[3];
-			msg->msg_name = &sin;
-			msg->msg_namelen = sizeof(sin);
+	if (ipv6_addr_v4mapped(daddr)) {
+		struct sockaddr_in sin;
+
+		sin.sin_family = AF_INET;
+		sin.sin_port = sin6 ? sin6->sin6_port : inet->inet_dport;
+		sin.sin_addr.s_addr = daddr->s6_addr32[3];
+		msg->msg_name = &sin;
+		msg->msg_namelen = sizeof(sin);
 do_udp_sendmsg:
-			if (__ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
-		}
+		if (__ipv6_only_sock(sk))
+			return -ENETUNREACH;
+		return udp_sendmsg(sk, msg, len);
 	}
 
 	ulen += sizeof(struct udphdr);
-- 
2.36.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6E52660C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382022AbiEMP1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381980AbiEMP0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:26:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA241C930;
        Fri, 13 May 2022 08:26:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a21so10412972edb.1;
        Fri, 13 May 2022 08:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fJZZgrjkTi2qnW8nR0govA2RNr4bkeylxJH5h6SSPcI=;
        b=itkRUtaB+7FjBPttdl0q8s0A4s4kv4P0zhXHnCuqdVsRxaeDYz3rPP9k7hy6icPm/4
         tSc7YmJ4nW+nlYxa2ptt14VEjpSmAA66L49IF4mKyB0uPaGRt/4zEFBT31GjztTtpKnL
         oVcZ4lHBh7tmqGbOx0W/PyoQl+C2UX4lfOK8I07tTFprYXYLaZ1HUpW+P/6N9qePUa9V
         RSm0H2iNyDn5mnPJyz0QsJ4EgyDEWjFYFUPac1fUY50MwnXTLXUewxHTbjAkpJAjIvv2
         yoHJYEm9s0e3gvjV0oa5shrPMBoiQcYryax4FSg3FKNssv2VK4R+f8ALd6q2Xgh+dKOX
         3cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fJZZgrjkTi2qnW8nR0govA2RNr4bkeylxJH5h6SSPcI=;
        b=IeUP+N7XZ9BgoaoEnUuWyo9baUKmoiqXcgysig1O7wZ1QWsufWY6eaRG0Al6S49ktV
         4e+F3Fu+NQ5WHl9+0inSbEDUNpl9l0dibGw54NvAXTl6AsCsPQQAoKr9x9rSheoi8s00
         kzvvxVnvtTcvkUJ+TyyWsmhy+iGPSLG3dc8lelJ5vQC/F3cxBNqqYHQdmr0C1u19jv5+
         NQUxgHRtiP4WDbXxsgDlvalN0R5VWz9s552OgKPELbK90DKedx6LavLFPVQgtlEYkNzP
         K3YHnGcH8tmbgSmzRj1L6NNAOlDN6NWfU8u3jAWaEFg56OQ1tU9VebKcB6D9FxePf3db
         79yQ==
X-Gm-Message-State: AOAM5328MADDziXG2SkI1tO31p5+E+39xPOalP2mo3Nlpq3hUIby5raZ
        8Qc42FhiacROiAKTXJTO6zzbVjLRCt4=
X-Google-Smtp-Source: ABdhPJwmO9sZAnEMkpE4QPhtI+gyLA3gKGVloOSQ5aZeKl8rdXstyfkRpHodqot7vd/FsYBjVzfMWw==
X-Received: by 2002:a05:6402:4304:b0:427:cb08:b085 with SMTP id m4-20020a056402430400b00427cb08b085mr41024752edc.194.1652455610076;
        Fri, 13 May 2022 08:26:50 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 03/10] udp/ipv6: prioritise the ip6 path over ip4 checks
Date:   Fri, 13 May 2022 16:26:08 +0100
Message-Id: <50cca375d8730b5bf74b975d0fede64b1a3744c4.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
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

For AF_INET6 sockets we care the most about ipv6 but not ip4 mappings as
it's requires some extra hops anyway. Take AF_INET6 case from the address
parsing switch and add an explicit path for it. It removes some extra
ifs from the path and removes the switch overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 85bff1252f5c..e0b1bea998ce 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1360,30 +1360,27 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	/* destination address check */
 	if (sin6) {
-		if (addr_len < offsetof(struct sockaddr, sa_data))
-			return -EINVAL;
+		if (addr_len < SIN6_LEN_RFC2133 || sin6->sin6_family != AF_INET6) {
+			if (addr_len < offsetof(struct sockaddr, sa_data))
+				return -EINVAL;
 
-		switch (sin6->sin6_family) {
-		case AF_INET6:
-			if (addr_len < SIN6_LEN_RFC2133)
+			switch (sin6->sin6_family) {
+			case AF_INET:
+				goto do_udp_sendmsg;
+			case AF_UNSPEC:
+				msg->msg_name = sin6 = NULL;
+				msg->msg_namelen = addr_len = 0;
+				goto no_daddr;
+			default:
 				return -EINVAL;
-			daddr = &sin6->sin6_addr;
-			if (ipv6_addr_any(daddr) &&
-			    ipv6_addr_v4mapped(&np->saddr))
-				ipv6_addr_set_v4mapped(htonl(INADDR_LOOPBACK),
-						       daddr);
-			break;
-		case AF_INET:
-			goto do_udp_sendmsg;
-		case AF_UNSPEC:
-			msg->msg_name = sin6 = NULL;
-			msg->msg_namelen = addr_len = 0;
-			daddr = NULL;
-			break;
-		default:
-			return -EINVAL;
+			}
 		}
+
+		daddr = &sin6->sin6_addr;
+		if (ipv6_addr_any(daddr) && ipv6_addr_v4mapped(&np->saddr))
+			ipv6_addr_set_v4mapped(htonl(INADDR_LOOPBACK), daddr);
 	} else {
+no_daddr:
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -EDESTADDRREQ;
 		daddr = &sk->sk_v6_daddr;
-- 
2.36.0


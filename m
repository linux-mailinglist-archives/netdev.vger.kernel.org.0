Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCC652660D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381979AbiEMP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381990AbiEMP05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:26:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70D41EEDA;
        Fri, 13 May 2022 08:26:52 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ch13so16868291ejb.12;
        Fri, 13 May 2022 08:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SqsVpBZTO69SaS86arPCUwx/Sngb5RJIeJy9Pl3nXJs=;
        b=G5FEGo5NPJnEqtpihWcRp0nfTfjkKyXFvmIiujeTGb4FF2OFWtjC7fm+hBOsYjKHhw
         EkvQ8n3yG+1VJwRreW/Lp7ZTnhrSBD3/VIIdRFNLgToUnwwhHaqjLPL4bCEGcWVUx9EF
         pVmLxtFTCidRjum4NlfGZNl1jD0OcRYH+D3HOmZOuKuLeDaTYIc9gT+5mqufVpbutplB
         g9EHzP6tM6SQgAPpI50MaiwFkNMkYPCGrvw2+xMiGnAqabUm+snhV/rugQvaAN1nXSdw
         hUGm+d97CHt1Zul+sTIz6OdiiIogQqJ41oy9i7gILbsRO2Fh+Pufsyp13Bj/weBQ7kJs
         eT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SqsVpBZTO69SaS86arPCUwx/Sngb5RJIeJy9Pl3nXJs=;
        b=l40htkN1GbiDLRnSp+5hEBBI+PizdEPBlGPttgDRD2pdPDP6F4EYzHsQlk8EcawryU
         TRLmwvhHPTsa6nAvkv2SU4aE3iyBMQfHBKx+lFO91wdrNBGjbez+8B41AK9gevuspmUV
         IwR6xHrzQSxeJIy5GYHxOEgRA+nmJvL5Ho+C8rrVpCJx34XNgw1c8KHCPu1mqHnCy9xF
         UoxNAyhHY2VDueMYMxmR70SsUHji+s5kWNtu7vsSjFHo6bQFH+3mDWvn8NWAduMhVDGu
         En+tnN2aSJMiFUgCQvdDgD2N1tu9gpVx+/7jHnSEBoNVHTm8c8ax3JuedgN0+kJr2j1z
         DK5w==
X-Gm-Message-State: AOAM533Eq+KIoMOqVkVTJ4zWgIc7F3SrcefagK4bz9jERWgfC9JOrO+w
        vI1bjMO/2LTzdoREcWAoA3oIy/Z2dhY=
X-Google-Smtp-Source: ABdhPJwK2weACZdaXKWumhZ3sBVozkEGfZk957OqVTilvxG1PCyvh+KEaQJ/3jXh7nDuHIMine7v9Q==
X-Received: by 2002:a17:906:7944:b0:6da:b834:2f3e with SMTP id l4-20020a170906794400b006dab8342f3emr4879809ejo.353.1652455611166;
        Fri, 13 May 2022 08:26:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 04/10] udp/ipv6: optimise udpv6_sendmsg() daddr checks
Date:   Fri, 13 May 2022 16:26:09 +0100
Message-Id: <96848ef2c22f73cd819c719fec0ce7a608d1c93e.1652368648.git.asml.silence@gmail.com>
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

All paths taking udpv6_sendmsg() to the ipv6_addr_v4mapped() check set a
non zero daddr, we can safely kill the NULL check just before it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e0b1bea998ce..8a37e2d7b14b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1386,19 +1386,18 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
-			if (ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
-		}
+		if (ipv6_only_sock(sk))
+			return -ENETUNREACH;
+		return udp_sendmsg(sk, msg, len);
 	}
 
 	ulen += sizeof(struct udphdr);
-- 
2.36.0


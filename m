Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340B55131C9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbiD1LAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344638AbiD1LAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:48 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E1C92D00;
        Thu, 28 Apr 2022 03:57:34 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m62so2711174wme.5;
        Thu, 28 Apr 2022 03:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmcy+WVcUMSTKq+Fw5VOoyUvErPXIVULV+9+XIhSEP4=;
        b=gaPJ1myz3ORkg3khe+GsiTL9USx8RrLhCVgZkf7zj8cbCTNx4nLwRIQTMUWLS4OuWV
         Li09z4i+uZ86UwNSLtaQdwQcRKFulHUb1PK2n0Wn3nnrFrVsZVuH5+nY0DGDmcy8NR4d
         GRjhrQhCbNFDX++dCjan1e5XBM0YmtV46Edv+SsPKT67d71vJNgnPss2MuVOLmD7B3IQ
         s/W2DZp1/vOcAuY4oMJ9vYHMwKAmcr+cAIfS4oC6Z8maRGjTOskjAj/F97UgOB67bhuO
         duXt1WjiX4KtUIMxIdV24cp1bxxzkwwH2nTNyN58rb1L/FWm7Fj413UQXDDYvFhEts4W
         gm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmcy+WVcUMSTKq+Fw5VOoyUvErPXIVULV+9+XIhSEP4=;
        b=33JdMtfWhJAIEG0jpAw7hs3ykC0BHnuIoarnkleX44DFMQK/geZGWmfNwof97RqXYh
         fVUXO0FUQf9nysHIg26D8IhnoBkfwTn95PcMy3r65/4+7aZo/yvrt0wBUWeguI4bFECN
         NKvKL9ep8DuhR+qi3uw8wHwQmO9fdXAffOeqPbwsw6im1Wmw2JLeeToqb6LlUAluwcK9
         JCHUdSWOsdYBYtP0733ch5Og2alRjcC7KzxELLREZqStw+7laFgcxToTWPSVMFToqh63
         UwaJa7Ir/OtX4xqYRInCSIWljIMmdTTWzE/KJPlBprmJdaAVoOMBRhVSai3N0fsb05c8
         5EgA==
X-Gm-Message-State: AOAM533Ev3O9UijQA0X8G2DEef1yIuVcamuj8oLnKY3LaTFZJ9HsBjN6
        Mb+/wub8zg7UnQUoR14STl756mygjmw=
X-Google-Smtp-Source: ABdhPJyhqNJkki/+WJX9ucIac/27OlWIn/E7Tz7hztKxMFN4whZom2MlU+VD28AUyn67qHICKdoEGw==
X-Received: by 2002:a7b:c7c2:0:b0:394:18b:4220 with SMTP id z2-20020a7bc7c2000000b00394018b4220mr7356397wmk.118.1651143452524;
        Thu, 28 Apr 2022 03:57:32 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 04/11] udp/ipv6: prioritise the ip6 path over ip4 checks
Date:   Thu, 28 Apr 2022 11:56:35 +0100
Message-Id: <4436ef2b79305e059a9c4c363a3ddd709003eda5.1651071843.git.asml.silence@gmail.com>
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

For AF_INET6 sockets we care the most about ipv6 but not ip4 mappings as
it's requires some extra hops anyway. Take AF_INET6 case from the address
parsing switch and add an explicit path for it. It removes some extra
ifs from the path and removes the switch overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d6aedd4dab25..78ce5fc53b59 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1357,30 +1357,27 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA255135F4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiD1OCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347884AbiD1OCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0E54FB5;
        Thu, 28 Apr 2022 06:58:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bv19so9755026ejb.6;
        Thu, 28 Apr 2022 06:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtTf6OOj87b2Qg9AkM3LVkPT3Rm+KpZX5qOlOG7aTiU=;
        b=Gx257gqfWgJ/LzNF0zvajSwKTJAdku50mcLTP3RgtgUNB+lwjlaJdnjnqCIa4zcvuC
         SZvAuIGJB1mplQtiTdUTUtMEcnqnPRlfk3l2QzGYiY6TFgrQqHFhox7JKOfna3xkFL3V
         DcyfX9hCeIl7+1076cGJ/1aAR5XHbE5/fjvPCbguCikS8OR93DaGfAJh0U3V4JkMbZGi
         n3oE+9bnjyG7Md/padfxXYhlYBWDcu9iWKDv11fB+F4be5KGh9zZNy4nuktM6RjP66ms
         fRPpbo0q6U6gdS0T1GuUeY2fMTn55knpj1zH5k+D8zu4eJTCcU3B6eOPG01fL/m0ZOL8
         R77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtTf6OOj87b2Qg9AkM3LVkPT3Rm+KpZX5qOlOG7aTiU=;
        b=OoDZfpZpIi4OgoIxyioba4LQgdyY70NVz1fIsqC+jrElaBYJGl0i+acVeDjzB+J+54
         /wJGRTt9TKwPUi+FUfYsBv/wmfy8S/cok8TOsY6jzUJAhcoJvDQAdM2F72tjztikfVjb
         Qucp33dHg4VUZPAs3EmwbhUimr/QlZ+glFq0cETMWMijcFTPUb73IRqd4ZwXe0347r85
         klsD1R7PfeDjgKJPmYshHFtNditOWCy2Lzjt0XgdCHyq+t7ZqYlv2CwKcNLNKdiLwxcj
         5R0mqEntMaqTI/1WnuxcIgXIGXHAcI9OsGjTt5Th43D5PqMg3Yam+8/XXdWe3Mv9JeVr
         XU+w==
X-Gm-Message-State: AOAM532r4dstBtQTc8VwHjOEC49E3/Iv5NdXSrNIXHaMSIMXJYkz0ZAx
        AQcCoi9MVKZ0L7OIhm3GFoA4BE26PF0=
X-Google-Smtp-Source: ABdhPJxyQ4KMR89VDmB1Dw7z/c306imVzPMyLDhFXKAbPhn3OCj465FmybaXLVGVwBXLhfRo154/sA==
X-Received: by 2002:a17:907:9482:b0:6da:a24e:e767 with SMTP id dm2-20020a170907948200b006daa24ee767mr31614783ejc.479.1651154332124;
        Thu, 28 Apr 2022 06:58:52 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 05/11] udp/ipv6: optimise udpv6_sendmsg() daddr checks
Date:   Thu, 28 Apr 2022 14:58:00 +0100
Message-Id: <785698dcf3e1f62e6fbe5b85a42d9704a3a48793.1651153920.git.asml.silence@gmail.com>
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


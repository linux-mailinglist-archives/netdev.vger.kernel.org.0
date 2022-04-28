Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A788F5135EA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347885AbiD1OCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347878AbiD1OCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EF5B53DA;
        Thu, 28 Apr 2022 06:58:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id kq17so9757702ejb.4;
        Thu, 28 Apr 2022 06:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmcy+WVcUMSTKq+Fw5VOoyUvErPXIVULV+9+XIhSEP4=;
        b=AhG1ruQbfC+S1+aq8qQZicm+JQ6eFjo9U+seqTxUn6Wdv/069iL+/6wBL+2K11DAiA
         YjL/C93lBMFqj7WpPFSoPilUlaoiJ4hxO8UhU0SbCDmEsduHi7jdlLlQF4ana6Xwgr9V
         2wNgjaUA5EA20JCCLcv3rFiwA6PlyrzgEYGVrofb81Euq3VO59rR+Oap8gKRoDqckxYW
         YrESuNqWY42sNN4z+a80rAZwAljtUkvh9u5T8yqLX8I/lhKsi90JFpvmEL5trh4KVKY0
         x/HD6S4KojJ2elMxoNuKcHW+fMWMWIAxniwM1CVf2/y/Zgh7YoT5J4FKcf7HU+WxSQiv
         k3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmcy+WVcUMSTKq+Fw5VOoyUvErPXIVULV+9+XIhSEP4=;
        b=0/k/d7p8ojlJXmNPBpn3WZhohUwq5AjCdNjBUP3pNwwzQP6a7MbMi84jGRiOPimzZK
         b48eGKcULV9dXnZPLHsZmCXetX91svR1Knz4yayIZlzQC+3yLN3iEnIp2mW0mY7nP2pc
         a9WdrQfibmd3YX5RLmjuP/ZbRFDkF6hM1LKnt7Z4qhz2r9q3c+2mXSFhLNcXKV7EP1e5
         SMPpLF1DLoFRhcFiNs/9exmoGYcMbD7fl8Z80PH4ujbYar4n3Icn3MAySIhWv9oEtz7b
         L0zRNnfEU9tmljtTRyZpPeUJbRtcYg2+34PrBt0u/r/wSvNbA1tp7Kqx9dEZM54JEW+1
         rCfA==
X-Gm-Message-State: AOAM5320uItftD7gDkuASrXaz5tu2/XRTIoPKASXCXrRm9Le5JvegtJ8
        L8jREj4eqnErrSG+WbALr2z0cvaEJHs=
X-Google-Smtp-Source: ABdhPJzqAu3nWPsQh1b3nUXS4Fud941GK8pBuVyMMfVxT7x1bNfIZY6rKC3s5Kh19T36gcCnfohP1g==
X-Received: by 2002:a17:907:1b02:b0:6ef:ea73:b2ea with SMTP id mp2-20020a1709071b0200b006efea73b2eamr32659309ejc.753.1651154330793;
        Thu, 28 Apr 2022 06:58:50 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 04/11] udp/ipv6: prioritise the ip6 path over ip4 checks
Date:   Thu, 28 Apr 2022 14:57:59 +0100
Message-Id: <4436ef2b79305e059a9c4c363a3ddd709003eda5.1651153920.git.asml.silence@gmail.com>
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


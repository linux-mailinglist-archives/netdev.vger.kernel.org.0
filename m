Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BA74F09A3
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358552AbiDCNKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358767AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BD713B
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d7so10624620wrb.7
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkBtV/cBPJqLk8JiVyuTBgO4OMSKymsJTd5NAuhuvMo=;
        b=l9XcWzk6W9tBWqE6mf8ZDT7U9zlat0PiHJ+uiTmCIh0aSKB9ahLyABVnEzf7zUFQj8
         LqhjgsoNYhS+zPeweNFNcjwkv7Z5jVBegpUVvuDVWuY55v3oQile3tNzEadxDOcsJeKK
         QN3dF9d5G6Fd5+o94dU81SREYCCWXqGrZomMRJ7tRTE3T74ax1mQSdyDDawOO+TH7VG/
         7gV998WhuPUbgXrXgniaTR8aBDzVtxbHnj5NRQMUmQ7JRA0qdlG0GGjOlRueCD00V8A3
         emM1AdD+UrRTVZsM0czmv684aqgPNRA956PkX7K5NfnM/cwZBS84xaKVB6XILgU87e7e
         +ROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkBtV/cBPJqLk8JiVyuTBgO4OMSKymsJTd5NAuhuvMo=;
        b=3Hd54FdpZZuNSPfUvKvIOCUS1y7E1VHgiyv4Al3cTg+F41Vfj7HI9kr4RP3Kxg71Gb
         CaDpkV7NMNqH/tzMs1Cty/yi76P7DbXQZ9ht+5TYDJ9WOwOqhbBfbFTuT5TfbI2lqvDU
         cLdtlx41YbKYqmYks8Z0Ph1THrgSejo92xRqNCR28XrZJTvkc1tPmWS4DbWSukqRdlF9
         H/8UECyoAJmPx/f7yhjQMq0CA/nUYro5tmAAi04c79SbQbdmZ3Xhw3b4EktTXitsBRIB
         XiMopoetEsxxfEflBOkqubd7PsLFVdX076fAKPZ6IUj4GavGFuvkAzwRVDtdPvYOq6dY
         k8Yg==
X-Gm-Message-State: AOAM532u3+CdwGhE7+RHTJ0Jt+8SMaTJSG42Tf8y5dLCEGKh1ctFPyox
        +/hPoiLWElP8SGyNO863SslZL0eyT3M=
X-Google-Smtp-Source: ABdhPJwGUChmaVZLKLi9NVGKBAkkLssNISqu9W/lNq42i5YqfHL5cSEsEcrsjfZQs6qgnVy0EHAspA==
X-Received: by 2002:adf:df81:0:b0:206:dad:ba4a with SMTP id z1-20020adfdf81000000b002060dadba4amr2233519wrl.657.1648991314954;
        Sun, 03 Apr 2022 06:08:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 21/27] udp/ipv6: prioritise the ip6 path over ip4 checks
Date:   Sun,  3 Apr 2022 14:06:33 +0100
Message-Id: <c1e13157b5a70df737a36fcfe752d0db7d5b6344.1648981571.git.asml.silence@gmail.com>
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

For AF_INET6 sockets we care the most about ipv6 but not ip4 mappings as
it's requires some extra hops anyway. Take AF_INET6 case from the address
parsing switch and add an explicit path for it. It removes some extra
ifs from the path and removes the switch overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 26832be40f31..707e26ed45a4 100644
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
2.35.1


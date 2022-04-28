Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03275135EB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347890AbiD1OCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347887AbiD1OCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:14 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFDDB53CB;
        Thu, 28 Apr 2022 06:58:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so9699875ejo.12;
        Thu, 28 Apr 2022 06:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Um7nfo9XPd/rjD8amGsCD9u/7MH/cL46Hqd0sO1U0M=;
        b=WD7KTtvqIX9d97uuqpFX/9XoDDW/Q9dAINAh5tr4EFrqfpHEnDfAkj1VpSowRSP+6S
         asG7wHDX7Gqdw3Ef243+nwJVwQ5UASmwjgrz6IdUlxBaNtkP0qZbcKcvVOyDtIES1gk1
         ezHSvumLDOEYa4wxWhvCcRYWEJ/w7KSqya+fkfTPQN1tahoG6XuPiu/6wc1/ihoqdKzc
         fXLUK1nycOPU9x0wziyUB3eB6X1bAJA+rD5EjQGEoPWYJw6UN2yFMy/QDzcF+LJgNP6m
         PeM9/oJMKRzIRj+P/5SN+cARkTcRvR4KsKVC6FhIbqAnbMoZzz28BwWZbx/c1IkMbZIK
         X4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Um7nfo9XPd/rjD8amGsCD9u/7MH/cL46Hqd0sO1U0M=;
        b=YJtx+aVROJX0vPDSP77kB4/cIuwj6PmWSfNqwnPaGmIriUg/si/oWG84SS+WcyJqG/
         xupZzKOt/+/8FOeB0+TtCu5ENUu+JDYkxlneww8MULYXXtwfqUBI8g92dom5tzYHyaHu
         3NiX+KrMe0kVTy251lS69+jPJQnGQzFPfbLmsu8IFLSKWCR/8bPytNc1yCqpRyPZinm9
         vSENjn9m7bIIYqc+6wI0GWqrXF7MpNE8U5qaHETEk9k9zCPrNDmLGSHqy0g6EejCZ3IQ
         w7hqn6hqKZ99i+NMbINbplcu39CjeMqr6o9tjN8rB2uwKNUsISPP4OHjMaMYJlahQpT2
         Ae3Q==
X-Gm-Message-State: AOAM531EGVcGXBoo+j010uAjyqIUhTQz6PmpYwOK06kZIO9C2KL6LuHX
        jy18KMVjksNriJQkolvbk7tk2bRrAR8=
X-Google-Smtp-Source: ABdhPJwrjWasSGuZDAAAJKhaWNQCpExa3f5CuSI3/IzyNKYK0hmEmFBjz2tQRxlb8jSnfISRXYu1iA==
X-Received: by 2002:a17:907:968f:b0:6db:a3c5:ae3e with SMTP id hd15-20020a170907968f00b006dba3c5ae3emr33016761ejc.770.1651154333254;
        Thu, 28 Apr 2022 06:58:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 06/11] udp/ipv6: optimise out daddr reassignment
Date:   Thu, 28 Apr 2022 14:58:01 +0100
Message-Id: <e66e22f3f148e3bd5911fe4483af39088a74e684.1651153920.git.asml.silence@gmail.com>
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

There is nothing that checks daddr placement in udpv6_sendmsg(), so the
check reassigning it to ->sk_v6_daddr looks like a not needed anymore
artifact from the past. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 1f05e165eb17..34c5919afa3e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1417,14 +1417,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			}
 		}
 
-		/*
-		 * Otherwise it will be difficult to maintain
-		 * sk->sk_dst_cache.
-		 */
-		if (sk->sk_state == TCP_ESTABLISHED &&
-		    ipv6_addr_equal(daddr, &sk->sk_v6_daddr))
-			daddr = &sk->sk_v6_daddr;
-
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    sin6->sin6_scope_id &&
 		    __ipv6_addr_needs_scope_id(__ipv6_addr_type(daddr)))
-- 
2.36.0


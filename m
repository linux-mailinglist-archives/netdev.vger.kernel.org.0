Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59BE526616
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382040AbiEMP1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381968AbiEMP1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:27:03 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B981EAE2;
        Fri, 13 May 2022 08:26:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p4so10458088edx.0;
        Fri, 13 May 2022 08:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2f0ybbz8E7mN3j4Tb5d9P3U+4UfBTwfy+rp+to+TOMc=;
        b=SnN97loAqd01nKEevEa8om4+j+zhtJvbfcYe6gAc4dnVt78jwBv30d9Lj1VwOdRT7j
         JbdvjHayTNwhnb2Tzihh6iil++p9o51C7jSzJjyk+YLkdwYoj7/9GYL8KtzaBFc5iV/M
         Ny9+760xuw06BLik3fooaGQHiUkg2QqO/NEx22Dp98VsLHG27j3c6/3MI/QAYwF34D6Q
         QsrexPPyR45vkMmILm7MZsiu+K53fYaKzje4Ce5c2eCpZg9CnJthPG8aAmdB8grfMBch
         hH8rzJw6lj2vrbMMMAoVXDxtijDbfUksZ2HaiT7BQLkIj50L3v1+Fr0l+64WoD9aNnso
         4iKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2f0ybbz8E7mN3j4Tb5d9P3U+4UfBTwfy+rp+to+TOMc=;
        b=Sn/jPa1J7OqtT/yiZt5ZcBU/7On8Rg4PULVBmSVgciKUcaUx4Oc8XfehZhyUEUYury
         umqW43QeHcuBv0UIUnFxWdQ1n8NMgXAhv7ehaVegjBIBU7Pr4OK82dRUE0NYkzQXeKdP
         BAwewWApKfNIUmnjK9WD09zpqE94v5UnkKbXezF7Sn/MmFWkULFBVH4HaLr2VZDM/Px0
         JZt3eAZ8DLQGDYVHAENmvWYnwTUHGSnckBov4+H2BDUQbO7QfwP4l4Y7kTeB3DEdr1Sq
         oQhEi3D5MN05YA7sBdpZQCyNCW+CcU9KlwIwIM9ti2iWcthaX+a27C3HmZBAh/Tcz68d
         HDeg==
X-Gm-Message-State: AOAM531TVnWq+oQgkptMyBJ78dFpmcgh7h2w71SV8wJ4tghPc8WJF0d5
        y/Jf+uFbv4NMuzncPN8doHD8K93tBq8=
X-Google-Smtp-Source: ABdhPJxwCDx4BAdWGWk3w9oCniYQ4oGFoyalXpn8i9svkQlZBZXkKzyD7pTLXTt0mdL93QP9y9G1mQ==
X-Received: by 2002:a05:6402:278f:b0:428:3c79:4eb8 with SMTP id b15-20020a056402278f00b004283c794eb8mr40872954ede.81.1652455612180;
        Fri, 13 May 2022 08:26:52 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 05/10] udp/ipv6: optimise out daddr reassignment
Date:   Fri, 13 May 2022 16:26:10 +0100
Message-Id: <f7f7fc42f950218e9e6d5794c1c675dfac29df26.1652368648.git.asml.silence@gmail.com>
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

There is nothing that checks daddr placement in udpv6_sendmsg(), so the
check reassigning it to ->sk_v6_daddr looks like a not needed anymore
artifact from the past. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8a37e2d7b14b..61dbe2f04675 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1420,14 +1420,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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


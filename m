Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7909584DE7
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiG2JMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiG2JMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:12:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA16D7AC2E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:12:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f46b4759bso37899697b3.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pJdSBb7O8PnwlywD8R6h4XL/pLwOLWurVYrErxcvuqw=;
        b=qu9JjMzdASyGUR9AZwPIsAJ23wNf5YQoK1/1nRGjjLGeOoNjQXanO78rWs2cOUt4Hp
         3knIkqd8dMF4wizMjZfp2mm/kYkz3cTLDh80G9y6CRCmWY1v1Na+eCouBfQ3eEa7FnYk
         ETvTzzZZ/lYRQqoOGGJup+ZTfnHxsem/+Hgk/S1cEdohBOLuBTbjr8RSC+zTiZZJUlkv
         93Ked168e48bEwYWwYDbzZjQWIdZ6nGeJfswylvbUMcA6hCNKzLbbAdAI0Hb9olieyFc
         nHgWh0cdQgtGjuWe+AXmdk5ToyLbWaIDBW6CJru/gRi02up9fL/d901P3pQlEwJjJocp
         y9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pJdSBb7O8PnwlywD8R6h4XL/pLwOLWurVYrErxcvuqw=;
        b=NXAhpKS5Dq4qQJSskP+dp/ZJ+wxyNa5jUuD4I9Q4FZ6oX8JzJTNJYT4HBSpHH+IHvf
         Ne7cRiffjXAPZKU1/uO50xHAWS9j6ru91Za0RtAOIZTYpymMYK02cYcktgrPcODFQLHV
         hZofCUTfBWZJtBlQS4QzXSx3dkhNV1bvoKCId3ufKTEcbNeypQtlXMm9+bk1oo8kGTCA
         WGLnY8zoetXqRPZQv71DsbtlG1cbQQ6tCAK3C0Lasq9pfck8JExjCFp1cSAb7kI+aidh
         SsaTlRxxksZ0WTySNTpb2Ue4xOfp2YJAN2c4w8Dssx+iwWIh2cxPa6pCR3qOQeTolH5a
         YxDg==
X-Gm-Message-State: ACgBeo22QNryxUK4wn888ZbGnFo+kkmZxj+Zh50urdEKHuujvROFU9fF
        LIF32K/iEFmpocFimQ5YoakL1QYTvPb7IQ==
X-Google-Smtp-Source: AA6agR4MG0Xwo81UbKRSbA4dOLd9VmStfg4AYqeMXrj9fdc938o58Y7L/nSTvsCayutX4Br36/ZxAZQDUIUoDw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:3686:0:b0:31e:322a:f3af with SMTP id
 d128-20020a813686000000b0031e322af3afmr2163332ywa.497.1659085958996; Fri, 29
 Jul 2022 02:12:38 -0700 (PDT)
Date:   Fri, 29 Jul 2022 09:12:32 +0000
In-Reply-To: <20220729091233.1030680-1-edumazet@google.com>
Message-Id: <20220729091233.1030680-2-edumazet@google.com>
Mime-Version: 1.0
References: <20220729091233.1030680-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH net-next 1/2] net: rose: fix netdev reference changes
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Bernard Pidoux <f6bvp@free.fr>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard reported that trying to unload rose module would lead
to infamous messages:

unregistered_netdevice: waiting for rose0 to become free. Usage count = xx

This patch solves the issue, by making sure each socket referring to
a netdevice holds a reference count on it, and properly releases it
in rose_release().

rose_dev_first() is also fixed to take a device reference
before leaving the rcu_read_locked section.

Following patch will add ref_tracker annotations to ease
future bug hunting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Bernard Pidoux <f6bvp@free.fr>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Bernard Pidoux <f6bvp@free.fr>
---
 net/rose/af_rose.c    | 11 +++++++++--
 net/rose/rose_route.c |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc392a9d830b1dfa7fbaa3bca969aa3..a8e3ec800a9c84f19e1f87630aa1eea4cb9d9390 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -192,6 +192,7 @@ static void rose_kill_by_device(struct net_device *dev)
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
 			if (rose->neighbour)
 				rose->neighbour->use--;
+			dev_put(rose->device);
 			rose->device = NULL;
 		}
 	}
@@ -592,6 +593,8 @@ static struct sock *rose_make_new(struct sock *osk)
 	rose->idle	= orose->idle;
 	rose->defer	= orose->defer;
 	rose->device	= orose->device;
+	if (rose->device)
+		dev_hold(rose->device);
 	rose->qbitincl	= orose->qbitincl;
 
 	return sk;
@@ -645,6 +648,7 @@ static int rose_release(struct socket *sock)
 		break;
 	}
 
+	dev_put(rose->device);
 	sock->sk = NULL;
 	release_sock(sk);
 	sock_put(sk);
@@ -721,7 +725,6 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	struct rose_sock *rose = rose_sk(sk);
 	struct sockaddr_rose *addr = (struct sockaddr_rose *)uaddr;
 	unsigned char cause, diagnostic;
-	struct net_device *dev;
 	ax25_uid_assoc *user;
 	int n, err = 0;
 
@@ -778,9 +781,12 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	}
 
 	if (sock_flag(sk, SOCK_ZAPPED)) {	/* Must bind first - autobinding in this may or may not work */
+		struct net_device *dev;
+
 		sock_reset_flag(sk, SOCK_ZAPPED);
 
-		if ((dev = rose_dev_first()) == NULL) {
+		dev = rose_dev_first();
+		if (!dev) {
 			err = -ENETUNREACH;
 			goto out_release;
 		}
@@ -788,6 +794,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 		user = ax25_findbyuid(current_euid());
 		if (!user) {
 			err = -EINVAL;
+			dev_put(dev);
 			goto out_release;
 		}
 
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index eb0b8197ac825479e8fa6c00c77db71b5f74d41b..fee772b4637c8897cd606b6e7c30447619327cab 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -615,6 +615,8 @@ struct net_device *rose_dev_first(void)
 			if (first == NULL || strncmp(dev->name, first->name, 3) < 0)
 				first = dev;
 	}
+	if (first)
+		dev_hold(first);
 	rcu_read_unlock();
 
 	return first;
-- 
2.37.1.455.g008518b4e5-goog


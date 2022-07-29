Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF8E584DE8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiG2JMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiG2JMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:12:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB807E302
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:12:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v19-20020a252f13000000b0067174f085e9so3461698ybv.1
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=itPhKLTRYsDUWhvv6NIn83wr0s0F9Em1GkdyLWdXkQg=;
        b=IeNRqdBYsc/iAGEbgaAJV3CaHpSSuk6j2ykP0c0Jn4E8pmd4JiV3Ns5rUnREw/Btm+
         v1wWDyDMW7qoQn0DLznAEekDrm9xHUU8FlmhxZflTQTCrHpsUdfIynC0b40jtfOFKPg3
         +XKe+ALAlfeU9F4i1F0Y1tsDRiRoMGlKglLwYTnx2U+FxjjIVfUEx8irQU2JyZI6AMa9
         LpvpM5Hj7X006zetYjR3rOaViW+25SagJkCh4NlR0Has7pywuGCCgr+E6U6ny6/h6xXu
         3nDYXHWD2Ox2sdUxf1CXjKeUTRtzw6vcJllafuElaGSvClSCdNw8onQa879/LhGGzSdg
         tCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=itPhKLTRYsDUWhvv6NIn83wr0s0F9Em1GkdyLWdXkQg=;
        b=E5Qr9vJbNKP41HpQajrQIARKdlBLs+wvGJr+rs7Bs3XSw0ijfwWhlhM86rlFPFLBRD
         87SYStAX7ZyUSkYFCW/JHTK+BWl1TNNZowzdTmRrewjVnSb2XIJiZz728vWg2ubRnM8q
         ot0evcNhGctQnlvC8y66fLAYMoOAr98PAWTzpz/v5KW3ZNhUs2KyWjBqhvLk6bvNFaq7
         b8Sj73Gn7Y3P8EQgw/BE+jJBl5dVmasVDFsx0S2w6CGanbxgNExrSmVJEP3UK8owG10z
         OIB5rTR7ekY2RHdmjqkZllXN8Nhviw7irTtG1n+fwqDmf9a174J8bTH785NsgjjAzmdv
         JN1A==
X-Gm-Message-State: ACgBeo3+VhNQzgiUGx8VbcfJ7yHNj8GpB45TYARVTkwFsIs4bmRooTvK
        206q37tDMajNj2Sega5iXO7iEUCC2fnMrQ==
X-Google-Smtp-Source: AA6agR4y8BLMMg+7BPJU2zjJi50DLpk+UyNzUxoJb4tgD1xJFmns/yLNsRew/5iifTQXp6PF54anNfy1msaexA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1348:0:b0:31f:62f4:4dab with SMTP id
 69-20020a811348000000b0031f62f44dabmr2346599ywt.344.1659085960642; Fri, 29
 Jul 2022 02:12:40 -0700 (PDT)
Date:   Fri, 29 Jul 2022 09:12:33 +0000
In-Reply-To: <20220729091233.1030680-1-edumazet@google.com>
Message-Id: <20220729091233.1030680-3-edumazet@google.com>
Mime-Version: 1.0
References: <20220729091233.1030680-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH net-next 2/2] net: rose: add netdev ref tracker to 'struct rose_sock'
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

This will help debugging netdevice refcount problems with
CONFIG_NET_DEV_REFCNT_TRACKER=y

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tested-by: Bernard Pidoux <f6bvp@free.fr>
---
 include/net/rose.h |  3 ++-
 net/rose/af_rose.c | 12 +++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index f192a64ddef23b272d0fdacd9d5c30e03d2bbebd..23267b4efcfa326304c56cdd744ab6fbdd8c3907 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -132,7 +132,8 @@ struct rose_sock {
 	ax25_address		source_digis[ROSE_MAX_DIGIS];
 	ax25_address		dest_digis[ROSE_MAX_DIGIS];
 	struct rose_neigh	*neighbour;
-	struct net_device		*device;
+	struct net_device	*device;
+	netdevice_tracker	dev_tracker;
 	unsigned int		lci, rand;
 	unsigned char		state, condition, qbitincl, defer;
 	unsigned char		cause, diagnostic;
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index a8e3ec800a9c84f19e1f87630aa1eea4cb9d9390..36fefc3957d772257755f9e5b90e71e423370ca5 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -192,7 +192,7 @@ static void rose_kill_by_device(struct net_device *dev)
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
 			if (rose->neighbour)
 				rose->neighbour->use--;
-			dev_put(rose->device);
+			netdev_put(rose->device, &rose->dev_tracker);
 			rose->device = NULL;
 		}
 	}
@@ -594,7 +594,7 @@ static struct sock *rose_make_new(struct sock *osk)
 	rose->defer	= orose->defer;
 	rose->device	= orose->device;
 	if (rose->device)
-		dev_hold(rose->device);
+		netdev_hold(rose->device, &rose->dev_tracker, GFP_ATOMIC);
 	rose->qbitincl	= orose->qbitincl;
 
 	return sk;
@@ -648,7 +648,7 @@ static int rose_release(struct socket *sock)
 		break;
 	}
 
-	dev_put(rose->device);
+	netdev_put(rose->device, &rose->dev_tracker);
 	sock->sk = NULL;
 	release_sock(sk);
 	sock_put(sk);
@@ -700,6 +700,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	rose->source_addr   = addr->srose_addr;
 	rose->device        = dev;
+	netdev_tracker_alloc(rose->device, &rose->dev_tracker, GFP_KERNEL);
 	rose->source_ndigis = addr->srose_ndigis;
 
 	if (addr_len == sizeof(struct full_sockaddr_rose)) {
@@ -801,6 +802,8 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 		memcpy(&rose->source_addr, dev->dev_addr, ROSE_ADDR_LEN);
 		rose->source_call = user->call;
 		rose->device      = dev;
+		netdev_tracker_alloc(rose->device, &rose->dev_tracker,
+				     GFP_KERNEL);
 		ax25_uid_put(user);
 
 		rose_insert_socket(sk);		/* Finish the bind */
@@ -1024,6 +1027,9 @@ int rose_rx_call_request(struct sk_buff *skb, struct net_device *dev, struct ros
 		make_rose->source_digis[n] = facilities.source_digis[n];
 	make_rose->neighbour     = neigh;
 	make_rose->device        = dev;
+	/* Caller got a reference for us. */
+	netdev_tracker_alloc(make_rose->device, &make_rose->dev_tracker,
+			     GFP_ATOMIC);
 	make_rose->facilities    = facilities;
 
 	make_rose->neighbour->use++;
-- 
2.37.1.455.g008518b4e5-goog


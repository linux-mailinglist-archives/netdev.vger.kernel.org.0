Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A8D48A4F1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346275AbiAKBY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346223AbiAKBYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:49 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A5AC06173F;
        Mon, 10 Jan 2022 17:24:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p18so3201350wmg.4;
        Mon, 10 Jan 2022 17:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MVu4ZlnCBCVeXmBG2E3bbhj24V2QUrRwSLSKs/b5k4Y=;
        b=RY2UaPlIu2ZLXtF5wq4iDrUcRhU/hq0s/Ut2Ah76TSHS7hzBq4dyrNXIsz5P7d6xtj
         UIwrFaB68X9fJ9fNacw4DLof5TE5IVNjBf0R6Bur1sACvUdQUp6Y2KK/zqQH8pEoUn21
         PQIVV+V2EQY+54AY//7QgXsOKGI9dbx7PU78BSYa7iexrsgcsNZmWGjmWYg/OJXsJ0EX
         qUB4E1uefG61gGjCKktu+hdbpC4RYYGO2wEE6qVEZnvsTol12eRODAZNtbFmmhY/ohpV
         +Uf6el5KQOjmmKl5ydaDrBjIs2BcRCw2jtcrY1YKneYzc3JkqXcp27i5rHgoIH6EKM7+
         6lEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MVu4ZlnCBCVeXmBG2E3bbhj24V2QUrRwSLSKs/b5k4Y=;
        b=HPl34G+IBNXjXbezFw3oTU78ocAlFvCB19iVVytugCQlBtlANkbOApVvo7p9o2DtGe
         z9b9hae+eqvBCPvfvsHwj5xuQGLSXvsC9NRi4Iu3hfXny0tLtMYKklkLHtclh1fmPnfw
         8sH+52wcR+VoM7HlqiH8L1veC1m2iek/iV1OcOKwOE1UbSVbuF5ZOuvxbUf9vzLoJHhj
         ntFREoRPVM0i5Rsd5JjcG2rVoufg74KBlAPC88p4rDRl58FvaB14dW3/iB/ZRg+9mTek
         scUwrzoBTRhM8puxp+IZ+xs5ag3lO8KktCKUZq7t77pXg3MVUwC2YTe4pbOWVGVeEzsj
         8g4A==
X-Gm-Message-State: AOAM530ZbLWMWMQpG4yZo07I27iDafIh0J4frWGS36BmQKf+4ySslpSM
        GP43uc5X1+etBGgjgzYC+0DAK3hTl4A=
X-Google-Smtp-Source: ABdhPJyhpv5Nw5z9W/M1+7t21+Cq0fH4GbgYhfe5w0dQXmV8XptfQErVxY/+FFHSJM1izV1V57lNxQ==
X-Received: by 2002:a05:600c:a45:: with SMTP id c5mr318937wmq.127.1641864287529;
        Mon, 10 Jan 2022 17:24:47 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 04/14] ipv6: clean up cork setup/release
Date:   Tue, 11 Jan 2022 01:21:36 +0000
Message-Id: <1e6f9ddca160b1dc3d81ac32f10ddb302cb216a9.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple cleanup of ip6_setup_cork() and ip6_cork_release() adding a
local variable for v6_cork->opt instead of retyping it many times. It
serves as a preparation patch to make further work cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 44 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4acd577d5ec5..88349e49717a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1354,7 +1354,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	unsigned int mtu;
-	struct ipv6_txoptions *opt = ipc6->opt;
+	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
 
 	/*
 	 * setup for corking
@@ -1363,32 +1363,28 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 		if (WARN_ON(v6_cork->opt))
 			return -EINVAL;
 
-		v6_cork->opt = kzalloc(sizeof(*opt), sk->sk_allocation);
-		if (unlikely(!v6_cork->opt))
+		nopt = v6_cork->opt = kzalloc(sizeof(*opt), sk->sk_allocation);
+		if (unlikely(!nopt))
 			return -ENOBUFS;
 
-		v6_cork->opt->tot_len = sizeof(*opt);
-		v6_cork->opt->opt_flen = opt->opt_flen;
-		v6_cork->opt->opt_nflen = opt->opt_nflen;
+		nopt->tot_len = sizeof(*opt);
+		nopt->opt_flen = opt->opt_flen;
+		nopt->opt_nflen = opt->opt_nflen;
 
-		v6_cork->opt->dst0opt = ip6_opt_dup(opt->dst0opt,
-						    sk->sk_allocation);
-		if (opt->dst0opt && !v6_cork->opt->dst0opt)
+		nopt->dst0opt = ip6_opt_dup(opt->dst0opt, sk->sk_allocation);
+		if (opt->dst0opt && !nopt->dst0opt)
 			return -ENOBUFS;
 
-		v6_cork->opt->dst1opt = ip6_opt_dup(opt->dst1opt,
-						    sk->sk_allocation);
-		if (opt->dst1opt && !v6_cork->opt->dst1opt)
+		nopt->dst1opt = ip6_opt_dup(opt->dst1opt, sk->sk_allocation);
+		if (opt->dst1opt && !nopt->dst1opt)
 			return -ENOBUFS;
 
-		v6_cork->opt->hopopt = ip6_opt_dup(opt->hopopt,
-						   sk->sk_allocation);
-		if (opt->hopopt && !v6_cork->opt->hopopt)
+		nopt->hopopt = ip6_opt_dup(opt->hopopt, sk->sk_allocation);
+		if (opt->hopopt && !nopt->hopopt)
 			return -ENOBUFS;
 
-		v6_cork->opt->srcrt = ip6_rthdr_dup(opt->srcrt,
-						    sk->sk_allocation);
-		if (opt->srcrt && !v6_cork->opt->srcrt)
+		nopt->srcrt = ip6_rthdr_dup(opt->srcrt, sk->sk_allocation);
+		if (opt->srcrt && !nopt->srcrt)
 			return -ENOBUFS;
 
 		/* need source address above miyazawa*/
@@ -1820,11 +1816,13 @@ static void ip6_cork_release(struct inet_cork_full *cork,
 			     struct inet6_cork *v6_cork)
 {
 	if (v6_cork->opt) {
-		kfree(v6_cork->opt->dst0opt);
-		kfree(v6_cork->opt->dst1opt);
-		kfree(v6_cork->opt->hopopt);
-		kfree(v6_cork->opt->srcrt);
-		kfree(v6_cork->opt);
+		struct ipv6_txoptions *opt = v6_cork->opt;
+
+		kfree(opt->dst0opt);
+		kfree(opt->dst1opt);
+		kfree(opt->hopopt);
+		kfree(opt->srcrt);
+		kfree(opt);
 		v6_cork->opt = NULL;
 	}
 
-- 
2.34.1


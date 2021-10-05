Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB3E42274D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhJENFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhJENFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 09:05:35 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC66C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 06:03:44 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m22so31788430wrb.0
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 06:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=crlvycmoEgIUId+ELgqLlZyo7QI5rzQ/0MPaXPfjEsA=;
        b=SP15jn5jZkM2ExtVS6fd8QaDYRPbvqt6K2Yap6B4KoPZaBQI6zVxUER71Wzoe9dwYD
         ePY+/oq9zxBiz83l3TJgFWAA6NPkeTr5X2JaHjE/nVGH/lGDsrv0ienftwXCIcjxfCcl
         I59NWTbVA2VDSXgbohvkXeFV16qaJKWL1+SMZ8KZVz6GZoMFkNwdnZ+MO30whkRS7imW
         lDp0rgguPLZUb3JQTcm29Bvkxr7xW+wYrwfsz0CeOzPeTDiUMkOAWH4oknhGceOU/CL8
         FnwtamN3WKqXpUHHKcMcHsNlberQnjdLwg6A+72yBwFlJ95JNsTCLaaWhLcec1GSCBtZ
         PYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=crlvycmoEgIUId+ELgqLlZyo7QI5rzQ/0MPaXPfjEsA=;
        b=Ggt2lB8orylIEvseVtNVCIV/GB6rMWPgp4j09Y9+Lc9vxepjJGz5unl+fCJMXhB8xi
         iFIOySdT1onnC4bgSFJlqSZHZLCBz6YL3hIl2kJggqg4uO1BdpTuVkwAitEC4oRZeIXc
         7IDN6Rd4r34I17fxWzvYYOosJliJEumxkR3ZUiioxtTk3mIsB/s/+vmr2dN2O9lyHElX
         wVApf87lsj2lEf+KnUkSLKpBjGyT+zf6ga9r7bWx/OS8ejsxyepETzwJFlXcKvQcqHZl
         EzJrywliQMf97U37YHgS11J09GUM/Wus+Uz8g+Qw0zibFgpeWRzYFW8FHONHxlZsJKqL
         ADeQ==
X-Gm-Message-State: AOAM530GQJQiouR6hMePVPqMQAYLuQsFhSVuKw5sKNtjZu3ofDxrPxnm
        1WuZfasANy7+/yS+Qr+3okI=
X-Google-Smtp-Source: ABdhPJxIm9pGLjOBQU71Ri/jYOJIkLrdZiYLFk1kIWqfrG9+SWV4CHK1CXqpucvkAm+SGM3TVpGfrg==
X-Received: by 2002:a05:6000:1624:: with SMTP id v4mr20959899wrb.401.1633439023404;
        Tue, 05 Oct 2021 06:03:43 -0700 (PDT)
Received: from [192.168.0.17] (97e2dc19.skybroadband.com. [151.226.220.25])
        by smtp.gmail.com with ESMTPSA id u17sm3514495wrw.85.2021.10.05.06.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 06:03:42 -0700 (PDT)
From:   Mike Manning <mvrmanning@gmail.com>
Subject: [PATCH] net: prefer socket bound to interface when not in VRF
To:     Netdev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Saikrishna Arcot <sarcot@microsoft.com>
Message-ID: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
Date:   Tue, 5 Oct 2021 14:03:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 6da5b0f027a8 ("net: ensure unbound datagram socket to be
chosen when not in a VRF") modified compute_score() so that a device
match is always made, not just in the case of an l3mdev skb, then
increments the score also for unbound sockets. This ensures that
sockets bound to an l3mdev are never selected when not in a VRF.
But as unbound and bound sockets are now scored equally, this results
in the last opened socket being selected if there are matches in the
default VRF for an unbound socket and a socket bound to a dev that is
not an l3mdev. However, handling prior to this commit was to always
select the bound socket in this case. Reinstate this handling by
incrementing the score only for bound sockets. The required isolation
due to choosing between an unbound socket and a socket bound to an
l3mdev remains in place due to the device match always being made.
The same approach is taken for compute_score() for stream sockets.

Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
---

diff nettest-baseline-9e9fb7655ed5.txt nettest-fix.txt
955,956c955,956
< TEST: IPv4 TCP connection over VRF with SNAT                                  [FAIL]
< TEST: IPv6 TCP connection over VRF with SNAT                                  [FAIL]
---
> TEST: IPv4 TCP connection over VRF with SNAT                                  [ OK ]
> TEST: IPv6 TCP connection over VRF with SNAT                                  [ OK ]
958,959c958,959
< Tests passed: 713
< Tests failed:   5
---
> Tests passed: 715
> Tests failed:   3

---
 net/ipv4/inet_hashtables.c  | 4 +++-
 net/ipv4/udp.c              | 3 ++-
 net/ipv6/inet6_hashtables.c | 2 +-
 net/ipv6/udp.c              | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 80aeaf9e6e16..bfb522e51346 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -242,8 +242,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
 
 		if (!inet_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 			return -1;
+		score =  sk->sk_bound_dev_if ? 2 : 1;
 
-		score = sk->sk_family == PF_INET ? 2 : 1;
+		if (sk->sk_family == PF_INET)
+			score++;
 		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8851c9463b4b..c6aedc674713 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -390,7 +390,8 @@ static int compute_score(struct sock *sk, struct net *net,
 					dif, sdif);
 	if (!dev_match)
 		return -1;
-	score += 4;
+	if (sk->sk_bound_dev_if)
+		score += 4;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 55c290d55605..67c9114835c8 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -106,7 +106,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
 		if (!inet_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 			return -1;
 
-		score = 1;
+		score =  sk->sk_bound_dev_if ? 2 : 1;
 		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ea53847b5b7e..c5267929825d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -133,7 +133,8 @@ static int compute_score(struct sock *sk, struct net *net,
 	dev_match = udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif);
 	if (!dev_match)
 		return -1;
-	score++;
+	if (sk->sk_bound_dev_if)
+		score++;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
-- 
2.20.1


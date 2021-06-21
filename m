Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6EA3AE743
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFUKlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhFUKlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:41:03 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163F6C061574;
        Mon, 21 Jun 2021 03:38:48 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id q64so22784285qke.7;
        Mon, 21 Jun 2021 03:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wqPsiTjn3y34NIB0txQqm3bYJeUD7nTZah6VlYwyDvw=;
        b=fRNs9Zi/uOSEbURx7ABqOmbwARWVSC+180v2trvI2kOex9/oQ27tA0DkbHuk3l/EHt
         r//uDv/OPjfvnvcl8/dFZ3QfK6gEN0y0nLKvZLKZ8hS8PphiXnrBifC3jcKEbJN9dOrX
         Hm4tNTwPjkywwVmCYRVRGOureCrWwDxE7WqELo2Cdm5S0AthAAw8ECaC9hhJBbhhLmLI
         DqnCS3chMhsJtkV7RWtdhL7Y0+UKX+K3nrI+VR52LJ0+Xf3Cjl0mWp9pa0/FuSGhBmDN
         OyVyZSHLKKrjdrEmf91VX+aSa2i30vuP2SK+miGkxHbn7G4pRazjjgPrxRKlBF7cvc8m
         fLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wqPsiTjn3y34NIB0txQqm3bYJeUD7nTZah6VlYwyDvw=;
        b=SUpBHuVSOxtJMKPLHNOgDXg/KV6s7b+lmmtsX0Fb3jPib6stDExrO1zmtGlVM3QKfj
         xaoNUXBe7Z5cm5kL7SqYbf7DU0+y8QcB40xiqVaEE/LA+Do5We/n9hC+8Kv3bAgwzAW4
         LfubmTMdpEmuXQhITMOnuKTVGlL8NSBIjxmeKCB42akGhFuSk2azh0rFKEkPdIlV2/0o
         p1yb72Kk676Xtkhgox1UpRmTsbcynLwtVsE2VSKdxtVdvWPkRq8B9JgrKdgKNKnTKwOI
         q4GxNN3t+TOTtmHzgtIkDK+ThMSGd0p2Jsp7kDLUukqM0g6AQfrV1dC8EUv4kbFtzy2L
         tHYg==
X-Gm-Message-State: AOAM530RKyjEMCTitGCwdbl4S16TX0Lv2pyjwopZ61+ZkK+KXVaKI3qC
        NBfAbYwYy/YUV3GE9VpcMeM=
X-Google-Smtp-Source: ABdhPJzEHDMzYkCX84hBARARNxsv87s7p5D0N2hRoR9/criB4+J8tMwOUsEUpQgnAGCQc4MHl9Unog==
X-Received: by 2002:a37:46c2:: with SMTP id t185mr20561684qka.466.1624271927300;
        Mon, 21 Jun 2021 03:38:47 -0700 (PDT)
Received: from localhost.localdomain (email.nillco.net. [139.177.202.100])
        by smtp.gmail.com with ESMTPSA id q25sm2149031qkm.33.2021.06.21.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 03:38:46 -0700 (PDT)
From:   Rong Zhang <ulin0208@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rong Zhang <ulin0208@gmail.com>
Subject: [PATCH] tcp: fix ipv6 tproxy doesn't work on kernel 4.4.x
Date:   Mon, 21 Jun 2021 18:38:29 +0800
Message-Id: <20210621103829.506112-1-ulin0208@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not only in tcp_v4_init_req() but also in tcp_v6_init_req()
need to initialize no_srccheck, otherwise ipv6 tproxy doesn't work.
So move it before init_req().

Signed-off-by: Rong Zhang <ulin0208@gmail.com>
---
 net/ipv4/tcp_input.c | 1 +
 net/ipv4/tcp_ipv4.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0919183b003f..e2bfcb30564d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6360,6 +6360,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;
 	tcp_openreq_init(req, &tmp_opt, skb, sk);
+	inet_rsk(req)->no_srccheck = inet_sk(sk)->transparent;
 
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = sk->sk_bound_dev_if;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3826745a160e..91c7a76f3bb3 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1206,7 +1206,6 @@ static void tcp_v4_init_req(struct request_sock *req,
 
 	sk_rcv_saddr_set(req_to_sk(req), ip_hdr(skb)->daddr);
 	sk_daddr_set(req_to_sk(req), ip_hdr(skb)->saddr);
-	ireq->no_srccheck = inet_sk(sk_listener)->transparent;
 	RCU_INIT_POINTER(ireq->ireq_opt, tcp_v4_save_options(skb));
 }
 
-- 
2.32.0


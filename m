Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D16496C3B
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 12:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiAVLlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 06:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiAVLlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 06:41:02 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E9C06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 03:41:02 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso24354789wms.4
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 03:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81H3x9oJNsbZIX2rvqjbCUTazok+XvxuJ34prg+NCRM=;
        b=kmxGW8LIgQm3DmUQBDDSO7rIekCvLXo4Tq7w6x5tEsCX/jUZ1Gyjusngcp7jh5W2w1
         dM+aGbX+BgYOFIT8KrZoN+dJOf6gwqfMdBPOBbVoXFu7SC3hXA05pkV4sOdhQIK4vQWa
         r22H8wCFj4IAEpfbG/TtWmGZ5UQ6Y7kW2necjCawDIjuPrEX2YUeNuT4q3WAGA+BiouL
         Ghkd9pbw43r5GJ7jBu9psc16ad3M2CXGX+nrZusKNtDG5VOotaxeg745T+k1n/BaTZ6c
         oy4igQn1h3hNrb2e1pvCWSJkqdbTUYP0KYklqM3gyDRg+aQLoYnd+DWzbKYr9PNDge0y
         b4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81H3x9oJNsbZIX2rvqjbCUTazok+XvxuJ34prg+NCRM=;
        b=wo4ltRqdUjiKMh252WCGKfl5Fk/hfatKPgaDUvrYwmpBp0ryQHPKO6NFq8K3KKVgJr
         HV6wUiajN1L8oGu5fNBV07KbfeM3nAvGCpBZl5JzwSNEpPUqj9HAtfx7qP2EIEeYMALI
         zi222XcrTAxKObluE9H6zGG14CeEqo1gAoP/oIREqyWVDlrLd8bEuLzbgzDagpwRbwza
         mb8qcc5XVi5O2/Y1fLNKcT3V+lDxJ8jKwZ9S8bLAz3thaha1CyAZsaSK/Cr5w+bO42WN
         W3nbRimp99S/nmKdvIvY8l19IzWH36HBVFF/hAByEU3AFXjpFzAHhQYv2867ENjfCaFE
         OVlQ==
X-Gm-Message-State: AOAM530795Tyd4KzW/YtyrThWBbzSxMBcOP9YRejb+3MOo67M1ztq6z2
        NkORg/XiKw4vi1GqkZu8XQbXZ2bbpJc=
X-Google-Smtp-Source: ABdhPJwjXdB21w6xcmkMrCY4onO1d4yeZYHGzwmOO60Ip5rELXE/vk8rcgAai0Arjc+tifsRTdNW8A==
X-Received: by 2002:a1c:3b55:: with SMTP id i82mr4320174wma.22.1642851660399;
        Sat, 22 Jan 2022 03:41:00 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y7sm2278265wrr.74.2022.01.22.03.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 03:40:59 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ping: fix the sk_bound_dev_if match in ping_lookup
Date:   Sat, 22 Jan 2022 06:40:56 -0500
Message-Id: <9a0135a36d3f5b14af375a23459325d7bc97bb9c.1642851656.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 'ping' changes to use PING socket instead of RAW socket by:

   # sysctl -w net.ipv4.ping_group_range="0 100"

the selftests 'router_broadcast.sh' will fail, as such command

  # ip vrf exec vrf-h1 ping -I veth0 198.51.100.255 -b

can't receive the response skb by the PING socket. It's caused by mismatch
of sk_bound_dev_if and dif in ping_rcv() when looking up the PING socket,
as dif is vrf-h1 if dif's master was set to vrf-h1.

This patch is to fix this regression by also checking the sk_bound_dev_if
against sdif so that the packets can stil be received even if the socket
is not bound to the vrf device but to the real iif.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 0e56df3a45e2..bcf7bc71cb56 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -220,7 +220,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
+		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
+		    sk->sk_bound_dev_if != inet_sdif(skb))
 			continue;
 
 		sock_hold(sk);
-- 
2.27.0


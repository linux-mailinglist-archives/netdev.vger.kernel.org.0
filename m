Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880C331902
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFACRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:17:38 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:35219 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfFACRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:17:38 -0400
Received: by mail-vk1-f201.google.com with SMTP id q13so2537309vke.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OaJKiB/0UCj26bgTSRls30D6wUjafQtzUHIW/ljpW+U=;
        b=FAsSXoDO+qIRtwn5bpvoopsEUwa3o4SSRqPbMU6DslC7jC48NyVgK9Kjjp4mTkHZr5
         LDmF/Ao3NRmE1ewuPJJVlrYWS75ATgD1dB8c+9nZydzZOXU8Za8ZB/A4M/bOrpH0gbzt
         KEpiyK7uHLxsbbu3KPbzSVOnWxAMgb8DwAqE44rFxT6gM/M0iYgJz+yeONzHcDF9pz2O
         nvRCpkNd2UlfVfb64LQODGypmpGlhXaZpYI3H4/dY9JZLDzfTefijJZTsfoVPwxPcgBH
         plsx16iCCFGlZuREfxy8jQj8DZiRH0VfQmByeKwiUphBQeeiezGHlgpBIY3Ewkug9DpI
         9nOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OaJKiB/0UCj26bgTSRls30D6wUjafQtzUHIW/ljpW+U=;
        b=ry0JrAUKJ0jkJsFqVsRqG0PmhK0E1eZ3irtx2C2+du/N03PYdHyzlxgZTTb+1sEKl/
         1nAiG4xSIAkSJ4bmZ9qX3uo6xd9sKnn7vFHMSkWcZTHsOH4COPsna8652rCYsvnJ9iDn
         RkaEzUNt4ZcKsejhH3i82T+dympAU6ziKb6jA6G3YtBbdNlCSbpmKk6EnM1pEmcv0m4W
         PT/MzlGULGlSIb1k5NIZXG/ABk03jW0xE2PwnXDqNXX5MAS67eZQVZDuJt6ThxYPmbRU
         v4KtSbdXmVayghUZnamt9q9pMtBntm9xtg7XqoXGUOGw+QT7HxsEixUtYyjuJNuHLpDr
         t8GQ==
X-Gm-Message-State: APjAAAUSDeItgyfOUhnQilV+4vD88xcv+FSySJFJvOQMBcwMIN9IGtdA
        wK0LAWyYBhGHVSchAK01h2tpIaS6xH5P1g==
X-Google-Smtp-Source: APXvYqzduq5S8HYh0AJongwqihzgT64mIwrDlsmuOjXCTDF0QEjyp8+i6VyBFD81eOiiKtRsAqFvj1kzOIxrdg==
X-Received: by 2002:ab0:671a:: with SMTP id q26mr4295729uam.7.1559355457326;
 Fri, 31 May 2019 19:17:37 -0700 (PDT)
Date:   Fri, 31 May 2019 19:17:33 -0700
Message-Id: <20190601021733.190857-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next] tcp: use this_cpu_read(*X) instead of *this_cpu_ptr(X)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this_cpu_read(*X) is slightly faster than *this_cpu_ptr(X)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index af81e4a6a8d8eac9aad551a129384ff6b1bf2f6c..59b7edd8719c33d747169b7ae97e4cb3d5e7bcb4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -771,7 +771,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.tos = ip_hdr(skb)->tos;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = *this_cpu_ptr(net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
 	if (sk)
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
@@ -863,7 +863,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	arg.tos = tos;
 	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = *this_cpu_ptr(net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
 	if (sk)
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
-- 
2.22.0.rc1.257.g3120a18244-goog


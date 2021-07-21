Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2D83D1517
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhGUQrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhGUQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:47:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1D2C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 10:27:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a4-20020a25f5040000b029054df41d5cceso4078601ybe.18
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WTY+dOgPzunFJh8yPu+/qvg1Ga1eXwF2h0AlBnfGojM=;
        b=js1VLxNyt3aPH4VsXoaHf5BV9TZ4p/ZN4aSskaEd7gDRYhR/1FHjDiVjLdKJItWvtx
         E+dT2VfZlAxpjC1guAqEbSX5OQUznPB5WcQQrGDzySvU0hmo686YhwG7go9Lr+STNX2a
         jXCvsnsc7sJfQFKj+cePFCLdD2+BTMNjqBY9TjZPSyz3HF8mRm9C3p8Fm70XRh1W+kks
         +Bk9ewGEOvVYKCYvhJJ7ebOJcMZEAfPnoan8xlQNAGpNLMB2IwQKsczS1rElY/mxq9Ea
         Q2macWeUNIi3K2K5Mvtc9saEUKBdymJLrylOGyLjMfqTyt87nEssNHrfF3RgudhCAA/o
         6OFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WTY+dOgPzunFJh8yPu+/qvg1Ga1eXwF2h0AlBnfGojM=;
        b=NhJGXj7o8ofiiixAcuA9GsnCGA51sAagnvWY4xv6rt8VLSOTENV+QZHxR9rbM4/51S
         9h0Ik/MhQG+ELhu4WBZ7fYRqWpTHvz2DLAhmNNVN4j5Pd8/KbXyAxt8ms9i5RO5iKws+
         avqBvOPMa9qdq7V+hg93osLO6qCTav4aQ3vUSqXCwJxL3ka6TYUIOz/xxxndSbOTlyT9
         S0X39KDE4lHhVavJKxPlM/WwcNszKX1bvwNeDlKNndRs+GIT2LZhcHQnDWxGCK9kjkiA
         r2qHhJuBkqRjUnM2wMIpYIIm1breLsRwE1ouJZ3negFaH/RcE1EyjUDzsWB6KmcoYlyn
         5h6g==
X-Gm-Message-State: AOAM5326gwoD5AO+wH8JBQ0kBOyaldnfi+MDYB81nSuSSA8yiZ2ZyzN5
        klEbUdv6R9Q4Al72ZJHGalDu0xKY848=
X-Google-Smtp-Source: ABdhPJxGG8lJzjhA9F+rcnOnITA3jz6rfV4lhV6dK2ry6Xh6OHlWzr8XPK+UkZ01K0LgLEwIoCVK6HIoyfY=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:76c5:a54a:5207:cec7])
 (user=weiwan job=sendgmr) by 2002:a25:678b:: with SMTP id b133mr27130916ybc.515.1626888461180;
 Wed, 21 Jul 2021 10:27:41 -0700 (PDT)
Date:   Wed, 21 Jul 2021 10:27:38 -0700
Message-Id: <20210721172738.1895009-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH net] tcp: disable TFO blackhole logic by default
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple complaints have been raised from the TFO users on the internet
stating that the TFO blackhole logic is too aggressive and gets falsely
triggered too often.
(e.g. https://blog.apnic.net/2021/07/05/tcp-fast-open-not-so-fast/)
Considering that most middleboxes no longer drop TFO packets, we decide
to disable the blackhole logic by setting
/proc/sys/net/ipv4/tcp_fastopen_blackhole_timeout_set to 0 by default.

Fixes: cf1ef3f0719b4 ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
---
 Documentation/networking/ip-sysctl.rst | 2 +-
 net/ipv4/tcp_fastopen.c                | 9 ++++++++-
 net/ipv4/tcp_ipv4.c                    | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b3fa522e4cd9..316c7dfa9693 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -826,7 +826,7 @@ tcp_fastopen_blackhole_timeout_sec - INTEGER
 	initial value when the blackhole issue goes away.
 	0 to disable the blackhole detection.
 
-	By default, it is set to 1hr.
+	By default, it is set to 0 (feature is disabled).
 
 tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
 	The list consists of a primary key and an optional backup key. The
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index b32af76e2132..25fa4c01a17f 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -507,6 +507,9 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
+	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+		return;
+
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
 	WRITE_ONCE(net->ipv4.tfo_active_disable_stamp, jiffies);
 
@@ -526,10 +529,14 @@ void tcp_fastopen_active_disable(struct sock *sk)
 bool tcp_fastopen_active_should_disable(struct sock *sk)
 {
 	unsigned int tfo_bh_timeout = sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout;
-	int tfo_da_times = atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times);
 	unsigned long timeout;
+	int tfo_da_times;
 	int multiplier;
 
+	if (!tfo_bh_timeout)
+		return false;
+
+	tfo_da_times = atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times);
 	if (!tfo_da_times)
 		return false;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b9dc2d6197be..a692626c19e4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2965,7 +2965,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_comp_sack_nr = 44;
 	net->ipv4.sysctl_tcp_fastopen = TFO_CLIENT_ENABLE;
 	spin_lock_init(&net->ipv4.tcp_fastopen_ctx_lock);
-	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 60 * 60;
+	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 0;
 	atomic_set(&net->ipv4.tfo_active_disable_times, 0);
 
 	/* Reno is always built in */
-- 
2.32.0.402.g57bb445576-goog


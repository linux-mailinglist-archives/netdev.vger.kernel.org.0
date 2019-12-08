Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8550111626D
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 15:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfLHOcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 09:32:13 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37497 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLHOcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 09:32:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so5745072pga.4
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 06:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UGkMwhNrzg0G5Sg3aOYCNrL8WQaNG3IAsZb51Z5iri0=;
        b=JPHEPQ+coER1a3ZCUrrQF3rHTEnMVOae7D7CRtLZJaumcOdjjVa1M71Far9TsPRwlj
         j2L7cobSFg8ZmROSWzEiNTC4+MrZPOYWLp6VKyFUdzZwYbKztNrzoLlwWthxXaj03JXV
         zjDHjWPoNf/6RdTbpuslY1RuZj4IzAbGjyKxtXisOrw1V9CMavzMrY8I6daGga2sKDM6
         vYnMSQrIsfEjjg144c8eSo+sxUqqoUSv1JzvjllsQIL55IhOWpYnjKlkOw2PhW074b/v
         0BQJCCoN9cZ2TQHZuTAIqP8tufZE7dT4tgA7holg/UONwVDIu4y3AeU8BNItF+r1SrnO
         /PrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UGkMwhNrzg0G5Sg3aOYCNrL8WQaNG3IAsZb51Z5iri0=;
        b=EIZ8tduNixU6PR/qSl+FXKDn2HB6jcZdV4r1agksXe6LRVjqLD675i0p9OzBy8c9+Q
         sbiR7OgvwhL6Yipd5FMt7WvE0KR2mA7F7lUTWVxUSiFbe5v85M/hlILUnPCXnafoQlo2
         fOqkMFR6ZGR8+kL0sAWVo9CLfK5fsV5K826AC3yNtXlh0FpTsarGMhQJt8p1IOSOA8r0
         b04zuf0jO33B7xz4j9ZmAEdsjIYfS65xzVuFXNQtdJlzIL7jUmy1CdkIK0EdXtTueIKp
         Htb9vNqQLbYgHEAgUipfGaf0SZbXZNFU4seLmde/s14No3FeKVa9k5etuGAq6NDY5tXQ
         Jxiw==
X-Gm-Message-State: APjAAAWU7Jo34AzgTC9i1x1CauNmKf8xlJUnHWYc7jVH43fIwBmJba9i
        VFyNoWKFj0u8LgiEBQ+57w==
X-Google-Smtp-Source: APXvYqzE4wglfjnY6SKv1KMgA8al70GbbPmXn3WgbF/GXy5LuGPlwkzD8YQypdyAUbLtCkP49RaroQ==
X-Received: by 2002:a63:d94b:: with SMTP id e11mr14013183pgj.79.1575815532961;
        Sun, 08 Dec 2019 06:32:12 -0800 (PST)
Received: from ip-10-0-0-90.ap-northeast-1.compute.internal (ec2-52-194-225-234.ap-northeast-1.compute.amazonaws.com. [52.194.225.234])
        by smtp.gmail.com with ESMTPSA id 2sm21436743pgo.79.2019.12.08.06.32.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Dec 2019 06:32:11 -0800 (PST)
From:   kuni1840@gmail.com
X-Google-Original-From: kuni1840+alias@gmail.com
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, kuniyu@amazon.co.jp,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: [PATCH] net/ipv4/tcp.c: cleanup duplicate initialization of sk->sk_state in tcp_init_sock()
Date:   Sun,  8 Dec 2019 14:31:27 +0000
Message-Id: <20191208143127.10972-1-kuni1840+alias@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuni1840@gmail.com>

When a TCP socket is created, sk->sk_state is initialized twice as
TCP_CLOSE in sock_init_data() and tcp_init_sock(). The tcp_init_sock() is
always called after the sock_init_data(), so it is not necessary to update
sk->sk_state in the tcp_init_sock().

Before v2.1.8, the code of the two functions was in the inet_create(). In
the patch of v2.1.8, the tcp_v4/v6_init_sock() were added and the code of
initialization of sk->state was duplicated.

Signed-off-by: Kuniyuki Iwashima <kuni1840@gmail.com>
---
 net/ipv4/tcp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8a39ee794891..09e2cae92956 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -443,8 +443,6 @@ void tcp_init_sock(struct sock *sk)
 	tp->tsoffset = 0;
 	tp->rack.reo_wnd_steps = 1;
 
-	sk->sk_state = TCP_CLOSE;
-
 	sk->sk_write_space = sk_stream_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
-- 
2.17.2


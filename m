Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE68D14F213
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgAaSWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:22:54 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:52374 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgAaSWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:22:54 -0500
Received: by mail-pj1-f73.google.com with SMTP id u10so4651565pjy.2
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=B5wdAHb0BLY3DXPuoldIIOm84h0+abLBP/2I5e4QJEQ=;
        b=RGJAzLYa3BbK0+2986RaNlSUaYKWMqoofX3uKqlrQZZde7cW0TE24gm7v9RjrwAPMC
         +ULx0vcWQxVHWxXsfRkt/UKOS2jDFttIM1rM0qX3b6IiOfchS+0YpHYfQNr7IdvEgFZE
         hsqPdvwQTi8iO6F4r1MWXKrSbtLEvhrVfQBVsQcuYS73dAIPaTT/bCaty8ZU2GLFYv0g
         C2bh8ZiKCOYq5hXWbEFCGhqgJ7Tu12jinICBG7CY9m7m0O5Z+680BXd7X05Upt+LjKrT
         GIARDZIYuoJNq37INlDwxpL8rRTjP/QPsHlkeuAdPYofJK3Hu2u9pDlwBQYU13p3stCp
         HxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=B5wdAHb0BLY3DXPuoldIIOm84h0+abLBP/2I5e4QJEQ=;
        b=DzRzfz6z+VwYp4B4HhgWcJgtfAzCPaqzBcIuE9/aVKZ9bfvJb8h4N3IoRC1/NSiOYi
         SVPiwsybkJ1OVR/mOruYpc++69/qZRQv3L63Qk8o3ydnAcJDVYYvvJcy1BmveChRZOEw
         4y4UcJq8gRqoEdpxfE4k154yI/6ijdriy/T1g/u+fIKbYbx6Yo/Msjmh+Kjux7ydC/hY
         MWHNYZAxJ52IKFfYTEXTWSoAgU41TADknRjj7wp9ZPE9f7fhAX2D5laXQZonvzaVpQuL
         f5XP9Hqu4NXraZuprPv5R84H3AJhoMbv2b2XFN0RmZ7SWhVuGuMNNVq6cHKBTOY7hIHL
         KZNw==
X-Gm-Message-State: APjAAAUPC0kqQSAQpEGuRXKwFBqghdJMz6dIzbhZ0Xk8Wl7L1ttAlS9r
        UHgQdqlYfuBvYC4SCJ7GI2C1o9rjXXcFmA==
X-Google-Smtp-Source: APXvYqy/96yaDfCpFuFJYUo/zTXs1b7zhsPDJ8vIPx16FZCiq3IzFs66LIAnL+q2/g6myqzLINrME485UbRoQA==
X-Received: by 2002:a63:520a:: with SMTP id g10mr10729404pgb.298.1580494973399;
 Fri, 31 Jan 2020 10:22:53 -0800 (PST)
Date:   Fri, 31 Jan 2020 10:22:47 -0800
Message-Id: <20200131182247.126058-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] tcp: clear tp->delivered in tcp_disconnect()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp->delivered needs to be cleared in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: ddf1af6fa00e ("tcp: new delivery accounting")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dd57f1e3618160c1e51d6ff54afa984292614e5c..a8ffdfb61f422228d4af1de600b756c9d3894ef5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2622,6 +2622,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->snd_cwnd = TCP_INIT_CWND;
 	tp->snd_cwnd_cnt = 0;
 	tp->window_clamp = 0;
+	tp->delivered = 0;
 	tp->delivered_ce = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
-- 
2.25.0.341.g760bfbb309-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2821D14F125
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgAaROx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:14:53 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:41930 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgAaROx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 12:14:53 -0500
Received: by mail-pl1-f201.google.com with SMTP id p19so4038226plr.8
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 09:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=k/1cfF7UXajpAOLkxIsPdNLghWfq5820vzXrW5qZ6Z4=;
        b=V1jj+oN7Hezl8By/Z1e/dRbL9wWQDZ0arJs6cXMQXJq89H/No1tglHParvhDAteObA
         bqgbEegViXbKsqXQ53JQ+Yr2cEIiOgu2sDnUXRBBcLGuPzoFTZ1RlKU763nPF3ShJsgb
         0YlMr8Hd6clf1D9UH4ee0SHmROafzNlkMFT/GWmZVu+VMRBfxlCQSIhGlCXLPxAkcpCq
         ssfzLsgx+Rqo65EmOqi9J00tprLbup8I5v7toELN46ujJCQo4BHMhIBq0pWAVlu26owE
         STMkNBMDW7z2k21cWTxD1DrPwO0gRg5Aj/QppI+rbE7AJxLm7LlSwRn7NM0cnt9AQsAH
         Jk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=k/1cfF7UXajpAOLkxIsPdNLghWfq5820vzXrW5qZ6Z4=;
        b=aZ1M/JhjRupoh5c6FxfT0QlP3dpFbPj+1ikYla/GeqYUxn5i00YONBa1rgeISrLT/J
         qk4gPG7HGclMgg3+W0qjhSqeAVjKd8ZOEDtSwPLwgT4ggr1ouq8wR590O5a+njNm7s3Q
         MmLZkcQZhpSFmn5tWk/7OBoNhGTGLZSkG//ZPOVqZ8mA/u7rdpZwke2aW2XyA7W2iDYM
         Dj9FEqsbfEoQ+5n1oO6M3zycC7oZqXPGkL6wtteVH6sBVWXI5uuXpKCSrLJ26unV8dtA
         F6sebyi/OjjkDYF8KgY8aeLwn8ds04gZQg7iehS4ikDQtgMhaKEiG/kWj87FhW4qtbVB
         7LrQ==
X-Gm-Message-State: APjAAAVJC13Jzg4LeFiT/nMiAZI2QYit87nGdwARLMKPiRcb809gpbEO
        LYVifsgFUMwGkMC5JEs5EC7bf06LAS/9qQ==
X-Google-Smtp-Source: APXvYqy9FugEb84qcQakNsyWBonNARmmZowA2o8jTSlVnTAVDkdKP7zONf6/tEBqHq5ggFtwg84s6xcLGmKtsA==
X-Received: by 2002:a63:d249:: with SMTP id t9mr11696760pgi.263.1580490891136;
 Fri, 31 Jan 2020 09:14:51 -0800 (PST)
Date:   Fri, 31 Jan 2020 09:14:47 -0800
Message-Id: <20200131171447.102357-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] tcp: clear tp->total_retrans in tcp_disconnect()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        SeongJae Park <sjpark@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

total_retrans needs to be cleared in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: SeongJae Park <sjpark@amazon.de>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 484485ae74c26eb43d49d972e068bcf5d0e33d58..dd57f1e3618160c1e51d6ff54afa984292614e5c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2626,6 +2626,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	tcp_clear_retrans(tp);
+	tp->total_retrans = 0;
 	inet_csk_delack_init(sk);
 	/* Initialize rcv_mss to TCP_MIN_MSS to avoid division by 0
 	 * issue in __tcp_select_window()
-- 
2.25.0.341.g760bfbb309-goog


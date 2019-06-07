Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930C73957D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbfFGTXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:23:52 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:44307 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729989AbfFGTXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:23:52 -0400
Received: by mail-yb1-f201.google.com with SMTP id v67so2887032yba.11
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 12:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xyFfYdydnXCfgJvTY+Ob/2GyudKDAABAbq6RIj8n7eM=;
        b=ETJ5P4q+CA6sKI9S+CsYHKGhvylLu8Fb6/1eHkPQb5O+PaSeLCHiRVzim36AqDxxa2
         M0sG6EbKtmcH2X9zcQ6iMUMYxBw/XsJwNoH4DP9Y0U1m5a6TSb8reCC7UhDzU4Jwqiii
         dcOmaz4OlTh8WcvbswsvouXAtN/tTotHU41sksF8cRwot8zox57YCNfxU0CvSUBAuXg5
         OS9roKHFypEW0FksjEttp4GQyA1qS+qwa9viakMBQrZM4ekG4+si0O4OzYscK9UOUHy4
         V/YRJhIm4hUuEHPOxiyO+gIFY3KGLJ3YhqlpbZt+y2cTeXNX+R6RpzQvMH2tfFyvMVOZ
         m2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xyFfYdydnXCfgJvTY+Ob/2GyudKDAABAbq6RIj8n7eM=;
        b=jBKnBnFWtWag1P+CL0oDt1Uo45baoZpdJmZlKjXF1ZbzMJezsHb9PLJvJjWxKIU8xh
         qAN5zGtBi9EH3QUbNlTfSN4PjqxGHFY42FrsUWlg2aKpiUi/P8SEJFJdkMJzzXbeHGBo
         e4XkwUMIzwjuARWuPI9AmqN+lHDnTb20ztNX2avoKmcRCG/MQBWnXL7xQOXbrtBFdYc7
         WwXGjKm6e4Ym+T698oRNL5CHuUl7t+VptkOaPOHkLzAEAdFMRMysGd05QXC2ohoy6i4c
         X9asU/S7MQwCtURhTQFwW+03X9d70VNXsQT5ZBVU7iBsF03wB+usrsP+lVJcrweHT7uo
         lyFg==
X-Gm-Message-State: APjAAAVTJtGHZk10oNJYIwh6+z9FH62MxlDjqU3lZGmjqSKp3addq9aF
        Mh3qJaldJD/MU1HytLj9CjOKTY3GofYk+Q==
X-Google-Smtp-Source: APXvYqwRJXf3IVei0QCfch/RJ8UXCoodvbAjAFHwAxkfthCNmhbMvKg6lBHdSLzOHdgwP8NSfUVIorZU02UUuw==
X-Received: by 2002:a25:c654:: with SMTP id k81mr22123948ybf.514.1559935431241;
 Fri, 07 Jun 2019 12:23:51 -0700 (PDT)
Date:   Fri,  7 Jun 2019 12:23:48 -0700
Message-Id: <20190607192348.189876-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 1/1] ipv6: tcp: fix potential NULL deref in tcp_v6_send_reset()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found a crash in tcp_v6_send_reset() caused by my latest
change.

Problem is that if an skb has been queued to socket prequeue,
skb_dst(skb)->dev can not anymore point to the device.

Fortunately in this case the socket pointer is not NULL.

A similar issue has been fixed in commit 0f85feae6b71 ("tcp: fix
more NULL deref after prequeue changes"), I should have known better.

Fixes: 323a53c41292 ("ipv6: tcp: enable flowlabel reflection in some RST packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d8d18386c99a82e112dd3a1aeee01e4c328ba5d7..c1da52c7f990f2fa3e020e3f3a33934149ad225e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -934,7 +934,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	if (!sk && !ipv6_unicast_destination(skb))
 		return;
 
-	net = dev_net(skb_dst(skb)->dev);
+	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog


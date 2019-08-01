Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7537D79E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 10:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfHAI3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 04:29:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42717 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbfHAI3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 04:29:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so33606067pff.9
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 01:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jOjfA74AUeA8KTWH+Deq++K0nrzDD6cUg7RiKRcAgeQ=;
        b=OenH9eI0I3TWqX5f2AYWDVPL1pKTT7RAEggxtMHYdkl8k/mRA0APtISZb2rEkBVpWn
         k2dFgDbtEWeGBL70n9WRSwwZph63yAglKjPbXA+D268ziVr8AEVM1KqWhRaXDZ/kVx8X
         /2RyvNaIWVp9Rbs7YStZOtvXzLJ2QIQT9g1cpWDsYOh9m4mKsZjIo+u5j6dQMQ5qiJVf
         HHOGp1vomSb/eqptnQDKgb3oKiklLrcqQBe0kcYzItFdAiwc5OVaDzvSpqrvnlrjBFu9
         M39r2bgdHox/femOFj+H0Fw1eFtbc94oJa+BA/Xz2zVyyUGtyQleuzc87xPyhCGXZnCM
         M2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jOjfA74AUeA8KTWH+Deq++K0nrzDD6cUg7RiKRcAgeQ=;
        b=gq/KowVY0OoipM6jcdIoTNRYpA9Sqqz5UffBQ6ZhESqtl4D8zuzN6PEqhsp4rkxMy9
         IXc0Zkoo2R7QXkTq/jaPYMENbrrd9ZbJRuE4eo1solKxpQdw4hCbWqKMi1UqPVB9I3kf
         C3DrLpB8UJvP5dPzOVLqN6auAwX6l6oXMKOiSdcE62DbCt/Z4066UQvOyjjBmyS73pse
         AAaIKZJ8KxXpCPvHRKLqL9nIHvzuLOE0eBgCQ6kE7iA4bw/WoUm/sibUbP/k+clcjMb8
         CnoOqhYNQi37DcVyhU/13OhKbb3cF8FTMExU88LHTeGAPtcTs1ndLRZW+mod/Gier4zV
         G7oQ==
X-Gm-Message-State: APjAAAVcQI7P977Sz/BnFlvH+OoVTeo+CH7UVAfm1IROUBIguyBGUWzi
        c2c1eeI4mNaY11CJmhnY7FVpZ4HH7xqwFg==
X-Google-Smtp-Source: APXvYqwKuF9sQXeXLuXmWv7fHApr7FscmLx6pweQRcJXXR84EQyqr48jizXBJbq4pdtRQicmo+2XRA==
X-Received: by 2002:a63:a66:: with SMTP id z38mr22643094pgk.247.1564648174517;
        Thu, 01 Aug 2019 01:29:34 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f20sm83833522pgg.56.2019.08.01.01.29.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 01:29:33 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipv4/route: do not check saddr dev if iif is LOOPBACK_IFINDEX
Date:   Thu,  1 Aug 2019 16:29:00 +0800
Message-Id: <20190801082900.27216-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
if src_addr is not an address on local system.

\# ip route get 1.1.1.1 from 2.2.2.2
RTNETLINK answers: Invalid argument

While IPv6 would get the default route

\# ip -6 route get 1111::1 from 2222::2
1111::1 from 2222::2 via fe80:52:0:4982::1fe dev eth0 proto ra src \
	2620::2cf:e2ff:fe40:37 metric 1024 hoplimit 64 pref medium

Fix it by disabling the __ip_dev_find() check if iif is LOOPBACK_IFINDEX.

Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 517300d587a7..1be78e8f9e3c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2512,7 +2512,8 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 			goto make_route;
 		}
 
-		if (!(fl4->flowi4_flags & FLOWI_FLAG_ANYSRC)) {
+		if (!(fl4->flowi4_flags & FLOWI_FLAG_ANYSRC) &&
+		    fl4->flowi4_iif != LOOPBACK_IFINDEX) {
 			/* It is equivalent to inet_addr_type(saddr) == RTN_LOCAL */
 			if (!__ip_dev_find(net, fl4->saddr, false))
 				goto out;
-- 
2.19.2


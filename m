Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93B81733A1
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 10:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgB1JTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 04:19:19 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42304 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgB1JTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 04:19:18 -0500
Received: by mail-qk1-f193.google.com with SMTP id o28so2279077qkj.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 01:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hxYxTy74zkJJFnifH/pog6ZHbI59U4pBLoYuXaY2R1E=;
        b=JlyPspXxg9gl6r/h7l9c9asjluYyjm25ecWbCZl023+q2z3/wTIplfo+d0sdA+RjOE
         wlMOW75GEaZ+VUkzLUk7Y7kQjb5tFyr4OsiMzhup9CsJ6ZlVTIQq2ZTfk8xoz6nLWIVx
         zpqIVb3niIfgali7bGTSgL4X1NWTFJ4B62BUM2BLvUIX3bnVyWru5X1hrc3fvtAJQ5fF
         Zdf4pVP/AdW1VLWpwSr599YKCulOPGoF/slhmp4tof0eY1NCJsGKxSi54gZh0mpkl5/g
         n3zuSXGqSrSEvGFkXHFJtt6rFBtz/i02NFYMNohx7WJLvmL7FdLCJeR+o9hDCG7MrsHP
         DXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hxYxTy74zkJJFnifH/pog6ZHbI59U4pBLoYuXaY2R1E=;
        b=DDD6etN1PvUA6RDM89kZkmVcc83sSL4tp2arH3pYGOqEixSYH7o98kIYWxVnWFiRDX
         0Ha5nAD2eOfhMbBPkdkegz2MJrXQxOx2znUxltNWZ+NcZbJRhscI1y3ePWMYhBZ7sUSE
         rFogirSpUP0r1fj4o4BlQvyN1aSgARRNSuWpQpyNiu8zqSUFnHbHcmyqthlUiu/2CFm6
         cy9ZuRCvJWXcuIm+/qHokJdIKT+hAHA/Soh55cJ2nSt/KLe28rf8geRYKCbU7XsIrI+j
         WdHXsCnfHCw0wRnpoqT3DN7ZXCv0GSarbL1MhnADWcSxI1FcqZs9b0AGQAS6+Bin4iWX
         0/ng==
X-Gm-Message-State: APjAAAXZKjR1VBBdBbDS5HiGK3jm31B8slEV0Z2HWz3b+9/E+KSwPEsc
        GyFuXzXnndCIG1Hn0r0orbFbErflXW8=
X-Google-Smtp-Source: APXvYqxp/VQB4BHVdb3DG5gfr3lxfb0la9mvvaod2gMI9DabxSxDw4qMVXUvXKmT23wrggSn5FG3xw==
X-Received: by 2002:a37:47c4:: with SMTP id u187mr3523194qka.165.1582881557196;
        Fri, 28 Feb 2020 01:19:17 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n3sm4737146qtv.2.2020.02.28.01.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 01:19:16 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Jianlin Shi <jishi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] net/ipv6: use configured matric when add peer route
Date:   Fri, 28 Feb 2020 17:18:58 +0800
Message-Id: <20200228091858.19729-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we add peer address with metric configured, IPv4 could set the dest
metric correctly, but IPv6 do not. e.g.

]# ip addr add 192.0.2.1 peer 192.0.2.2/32 dev eth1 metric 20
]# ip route show dev eth1
192.0.2.2 proto kernel scope link src 192.0.2.1 metric 20
]# ip addr add 2001:db8::1 peer 2001:db8::2/128 dev eth1 metric 20
]# ip -6 route show dev eth1
2001:db8::1 proto kernel metric 20 pref medium
2001:db8::2 proto kernel metric 256 pref medium

Fix this by using configured matric instead of default one.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cb493e15959c..164c71c54b5c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5983,9 +5983,9 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 		if (ifp->idev->cnf.forwarding)
 			addrconf_join_anycast(ifp);
 		if (!ipv6_addr_any(&ifp->peer_addr))
-			addrconf_prefix_route(&ifp->peer_addr, 128, 0,
-					      ifp->idev->dev, 0, 0,
-					      GFP_ATOMIC);
+			addrconf_prefix_route(&ifp->peer_addr, 128,
+					      ifp->rt_priority, ifp->idev->dev,
+					      0, 0, GFP_ATOMIC);
 		break;
 	case RTM_DELADDR:
 		if (ifp->idev->cnf.forwarding)
-- 
2.19.2


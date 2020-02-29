Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09131745E1
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 10:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgB2J1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 04:27:30 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:34892 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgB2J13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 04:27:29 -0500
Received: by mail-qt1-f171.google.com with SMTP id 88so3980126qtc.2
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 01:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZBZqyWTn5zf2+FYhgW/SoRBgfQNnNdQ6f7JSBFCXhng=;
        b=DvvoZKsjrcErl+JXqUA60eEWKqrCSQGvQNXtIFNbQFnu51R5+NkvgRKtF8Z9VcXF4P
         kJijZxGgApVSxsv8b7v4LZ7KCVT/U/m1tB1G6zI09wY4/TEocWEkPQZayx26hEwNm5l4
         sOyWfWQHluDxfFwwKgNUxnaRQIcapPJs1TUtc0XuJIqF6odjyMuuPPH6NREAgbSpNWCt
         xpx+g7Eg63902YfkWXvk2y0UwiScn7a+mpBKjW9pDU9PHhz4ZuOB7IlqUHYOPiZFUmWm
         Pcvwzzd22pF65Bl14z7pWqg0nnHOBsUUQ25YMx02f9Fzbz/3uF5LmR0Vrf9eiU50D4H6
         E9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBZqyWTn5zf2+FYhgW/SoRBgfQNnNdQ6f7JSBFCXhng=;
        b=PT3+2M0gipfMmTwSCLc/+mullIYQ3N7xKdnEtphj2r+TahlqFfU2bLK/kKr1MKHQNu
         WCXyT6ozAKXXc1zkekaX/oGPGDn6hWZSw5Gh1iUlVx8lFMzFkiEPyiqKRPnpeVcM0K80
         sktHzUXRwXvAtZQde4mHEXai4Tcn/FyclxQb87Xil2l2ycax5PafMa9B9cRJM+zzhuzT
         q10p7mA53bEpkj36STBZLZGRBVz0E+wdh8JD9l3cqyIyJFsKK85pVeLQ75N7l7shX3eM
         oBdgkUDcRBWe1ovmwqMd180K7/ad7751q7zzv9SGP2IdtYLCIPZxyGKvpm3SYzEhV7dF
         hfKA==
X-Gm-Message-State: APjAAAUeeyT0K6WCgFrlHhknonqwNZ5X6Mgi2CH88NKFMFOqORXL4/um
        vFgSFDhsXFG7GDTjLEmBHBaEW5IiTZI=
X-Google-Smtp-Source: APXvYqy3lniQcnFjMuNFrZSThQnU/iWEoSDqdWlWgO4aGifHxQ8sgIA/z5BfXWrp+EIacCNCl3lVVg==
X-Received: by 2002:ac8:16d4:: with SMTP id y20mr8017395qtk.338.1582968448415;
        Sat, 29 Feb 2020 01:27:28 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m17sm6786qke.24.2020.02.29.01.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 01:27:27 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Jianlin Shi <jishi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] net/ipv6: use configured metric when add peer route
Date:   Sat, 29 Feb 2020 17:27:13 +0800
Message-Id: <20200229092713.29433-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200228091858.19729-1-liuhangbin@gmail.com>
References: <20200228091858.19729-1-liuhangbin@gmail.com>
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

Fix this by using configured metric instead of default one.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v2: fix metric typo
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


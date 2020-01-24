Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C91D14908E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgAXV4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:56:00 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34625 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgAXV4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:56:00 -0500
Received: by mail-yw1-f66.google.com with SMTP id b186so1612735ywc.1
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 13:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJxvwwOnDkL3pWsXr9peLas4v7SNnU0KOKhL/dhULAs=;
        b=GgUzBHeG2HEfdWkFVF2nEkguMV0QrUka5l8ulmn6I6GCqfdEDZymAXu/Yx5EnztuDh
         1Y/W1SZ9tN7AzTg28kVWD//38Bk4KrWxGt6GAN4MYMA1EVaDAvUW3rwCtkiR7s4sWPYO
         erndkEvfjNisSfUgHMHBgicFptUIVmaNM+okE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJxvwwOnDkL3pWsXr9peLas4v7SNnU0KOKhL/dhULAs=;
        b=lCoPy57KstgFLVbR1VkI/g8GHfdh0xWx3V7Km5/jOR24lRsMtxe7V8Y+JU6WxmLa0q
         rSPUlGX68rBhmOe7Oocmy5RPxLVcJZ2R86tmPs5hDIln6iFtvEmzk6BFjc6e6vbZd2lG
         fPEbOg3hOmfzQ6PmHCALRW+hOf5tTEfoT44Tn6vJHUu6Z9pDF09m7+yyD2STKxsDe5ot
         v820HJgvGlHID5nT1Y3IoCZ5rsCy6GKIv9WsHc/iJq8j1ndDRaQ8PSxgzOgj9YsUNuyq
         dEfgPEnp49HBW/vN0AfElXswSP9Ls8KAwOE9831qS6Ht4esprr3u86OxTc+V99XAu3va
         47Og==
X-Gm-Message-State: APjAAAVM0Cz3p9WoRECtbsPCz+c1neTnr5T3Nhz6DIjH55b4B6W80alR
        4YUqe5Y5mZprmOLkpJuPS5myeOqE1Bc=
X-Google-Smtp-Source: APXvYqxiogxhCkc+1pjZc+3wWtaX5BiasQQehjJZT2QB/7MAq+5iFJ22BCjaoSkX6aPJmjklW0Abhg==
X-Received: by 2002:a81:a190:: with SMTP id y138mr3543932ywg.343.1579902959338;
        Fri, 24 Jan 2020 13:55:59 -0800 (PST)
Received: from alfred.rdu.cumulusnetworks.com ([2620:11f:a008:12:33:c558:f7d7:8628])
        by smtp.gmail.com with ESMTPSA id s68sm2829040ywg.69.2020.01.24.13.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:55:58 -0800 (PST)
From:   Stephen Worley <sworley@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, davem@davemloft.net, sharpd@cumulusnetworks.com,
        roopa@cumulusnetworks.com,
        Stephen Worley <sworley@cumulusnetworks.com>
Subject: [PATCH] net: include struct nhmsg size in nh nlmsg size
Date:   Fri, 24 Jan 2020 16:53:27 -0500
Message-Id: <20200124215327.430193-1-sworley@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include the size of struct nhmsg size when calculating
how much of a payload to allocate in a new netlink nexthop
notification message.

Without this, we will fail to fill the skbuff at certain nexthop
group sizes.

You can reproduce the failure with the following iproute2 commands:

ip link add dummy1 type dummy
ip link add dummy2 type dummy
ip link add dummy3 type dummy
ip link add dummy4 type dummy
ip link add dummy5 type dummy
ip link add dummy6 type dummy
ip link add dummy7 type dummy
ip link add dummy8 type dummy
ip link add dummy9 type dummy
ip link add dummy10 type dummy
ip link add dummy11 type dummy
ip link add dummy12 type dummy
ip link add dummy13 type dummy
ip link add dummy14 type dummy
ip link add dummy15 type dummy
ip link add dummy16 type dummy
ip link add dummy17 type dummy
ip link add dummy18 type dummy
ip link add dummy19 type dummy

ip ro add 1.1.1.1/32 dev dummy1
ip ro add 1.1.1.2/32 dev dummy2
ip ro add 1.1.1.3/32 dev dummy3
ip ro add 1.1.1.4/32 dev dummy4
ip ro add 1.1.1.5/32 dev dummy5
ip ro add 1.1.1.6/32 dev dummy6
ip ro add 1.1.1.7/32 dev dummy7
ip ro add 1.1.1.8/32 dev dummy8
ip ro add 1.1.1.9/32 dev dummy9
ip ro add 1.1.1.10/32 dev dummy10
ip ro add 1.1.1.11/32 dev dummy11
ip ro add 1.1.1.12/32 dev dummy12
ip ro add 1.1.1.13/32 dev dummy13
ip ro add 1.1.1.14/32 dev dummy14
ip ro add 1.1.1.15/32 dev dummy15
ip ro add 1.1.1.16/32 dev dummy16
ip ro add 1.1.1.17/32 dev dummy17
ip ro add 1.1.1.18/32 dev dummy18
ip ro add 1.1.1.19/32 dev dummy19

ip next add id 1 via 1.1.1.1 dev dummy1
ip next add id 2 via 1.1.1.2 dev dummy2
ip next add id 3 via 1.1.1.3 dev dummy3
ip next add id 4 via 1.1.1.4 dev dummy4
ip next add id 5 via 1.1.1.5 dev dummy5
ip next add id 6 via 1.1.1.6 dev dummy6
ip next add id 7 via 1.1.1.7 dev dummy7
ip next add id 8 via 1.1.1.8 dev dummy8
ip next add id 9 via 1.1.1.9 dev dummy9
ip next add id 10 via 1.1.1.10 dev dummy10
ip next add id 11 via 1.1.1.11 dev dummy11
ip next add id 12 via 1.1.1.12 dev dummy12
ip next add id 13 via 1.1.1.13 dev dummy13
ip next add id 14 via 1.1.1.14 dev dummy14
ip next add id 15 via 1.1.1.15 dev dummy15
ip next add id 16 via 1.1.1.16 dev dummy16
ip next add id 17 via 1.1.1.17 dev dummy17
ip next add id 18 via 1.1.1.18 dev dummy18
ip next add id 19 via 1.1.1.19 dev dummy19

ip next add id 1111 group 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19
ip next del id 1111

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
---
 net/ipv4/nexthop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 511eaa94e2d1..d072c326dd64 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -321,7 +321,9 @@ static size_t nh_nlmsg_size_single(struct nexthop *nh)
 
 static size_t nh_nlmsg_size(struct nexthop *nh)
 {
-	size_t sz = nla_total_size(4);    /* NHA_ID */
+	size_t sz = NLMSG_ALIGN(sizeof(struct nhmsg));
+
+	sz += nla_total_size(4); /* NHA_ID */
 
 	if (nh->is_group)
 		sz += nh_nlmsg_size_grp(nh);

base-commit: 623c8d5c74c69a41573da5a38bb59e8652113f56
-- 
2.24.1


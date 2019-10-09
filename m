Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A6CD1CC3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbfJIXUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:20:18 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:38613 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732255AbfJIXUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 19:20:18 -0400
Received: by mail-pf1-f202.google.com with SMTP id d126so3098565pfd.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 16:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/n+ehI71rbRCVMQAQxg3HDPOQMoXkcqd431ddfw2Uh0=;
        b=GekLf8RHSg2do9xWdJljMA3fiZPT9PcktMl1ly/ZqsOqSfDZ7umUQBTK8jMRGURPPN
         9eYHOaQ0cGDmwqrI/EpXCRgmThebbDxGxelGiZBilrMkqwE3b10NJwO66rxcuJmv9224
         stDktOSud6BXVuVYp9Fi9O0ImRi/1Pe6nYrNHH7Hkw9BpgjV06M+7M7gSzcDLwMSN47S
         PsFSRx/9JCj8q8oX0CLupgJMsvfdY00PRcQEsfBlDMqV+stT+uhaRi9W+yAV/uV+zrl5
         evG/sFFCnnN5tk9US21W3b8ddTWEI+FXRDD58Y3Bntkl7sFdijQEZYiDXiCORxzwyrAP
         52mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/n+ehI71rbRCVMQAQxg3HDPOQMoXkcqd431ddfw2Uh0=;
        b=EIW5PXDcjaZP5vqQTzbdMP4gUdgblgzJGsH0YARawNk0gbwM4IFm+6D1SPhlHVJmAl
         7jzqPgJshIDU50IyF9yWwxPXvHiYRkjkc4zeB93SPFE1GIRw1r8ov9cP69x8ooDlyPDE
         i3EnqQbsQKKHrOMouNVFcDaQroUnaNtU7RknPlCWnKbDhHDB0XMElNULxELpT1srg9P7
         +tvmAFQ0wepZXAZmAwRJrfOqVwKvXIvj+U29Rs3Md+xA7A+yWuj4TrTu48UipWUNND2V
         +8WR2AbYOScWQH0etjfn61TqbpW7xqpxJJv/cvnGj//Zyg6X59j6CVVnf3bKnsy3Tc8d
         scTA==
X-Gm-Message-State: APjAAAXxEi+Tzwi1bp88E317AkebhiLJmBJRs1ZuCNcXkBQdLnnISEOs
        uaqDA3dsPgfql6jwLckUDEN50Oxp92qGI6l6FIGx8pPrmxdJwU9oj5RIfPkEtxAj3jIqbtpJFlD
        nNLakA7eBjMPA+IhRPfoK4LVxdFh7BveQfRGagG09G1wer5oSV6Led1C3LS0txwjh
X-Google-Smtp-Source: APXvYqwwEXDqLWgRjoNjCkfRT9sx/7TZsLEmJINY2RwfelmzKSlCnTUtl+IsWA4xsS0Tv6Ht7eJxBtdheOgB
X-Received: by 2002:a63:6581:: with SMTP id z123mr7063536pgb.367.1570663216962;
 Wed, 09 Oct 2019 16:20:16 -0700 (PDT)
Date:   Wed,  9 Oct 2019 16:20:11 -0700
Message-Id: <20191009232011.240381-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH next] ipvlan: consolidate TSO flags using NETIF_F_ALL_TSO
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will ensure that any new TSO related flags added (which
would be part of ALL_TSO mask and IPvlan driver doesn't need
to update every time new flag gets added.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 887bbba4631e..b0ac557f8e60 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -108,8 +108,8 @@ static void ipvlan_port_destroy(struct net_device *dev)
 
 #define IPVLAN_FEATURES \
 	(NETIF_F_SG | NETIF_F_CSUM_MASK | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
-	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_GSO_ROBUST | \
-	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
+	 NETIF_F_GSO | NETIF_F_ALL_TSO | NETIF_F_GSO_ROBUST | \
+	 NETIF_F_GRO | NETIF_F_RXCSUM | \
 	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
 
 #define IPVLAN_STATE_MASK \
-- 
2.23.0.581.g78d2f28ef7-goog


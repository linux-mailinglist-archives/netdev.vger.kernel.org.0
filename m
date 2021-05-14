Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D190380196
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 03:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhENBzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 21:55:05 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:35595 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhENBzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 21:55:05 -0400
Received: by mail-ej1-f51.google.com with SMTP id m12so42540277eja.2;
        Thu, 13 May 2021 18:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vf/w0gIA31yDofWDFARiKyZ1Z+Y8XK+6F1QRv5/kfU4=;
        b=WmLNMnnE3vOtWOsu/xxqAn62x+VJI8bbm3FhP01TxgjzD/1vG5e4zDX3GGyo389zOt
         hz4ADJgSSXpFtFAmePOa8L8d1iF4Kiz2H8X3+305rumCXo65pBCebEwA3tnIyZolRBYU
         fGAMPtp8LesvD6YgMU6BZOgtYbjOJVFl2/DWG+CKgbhGvJFhBa38gUGafpW0S5KTQWGP
         +a4t8VgC9ltafuu0iU/MBCL/PJrH742QlYkO8AghlIMXZnMKOfgDH1K1YjtjR/j6uIPB
         SZQJcRsQPokRUorTXX9bKgONph0GK8sOZa3rlDk6El4FT8/2kghfwgufXILVJrSsWEGv
         XEFg==
X-Gm-Message-State: AOAM5314rPfvvu+m0ZAZnUQ2KSEqZrwftegHQzYgSUAjoJkBNb1/DeEw
        CrY7fQjlyAq6tsVuK045L/+bM8gnS9Rr1z3l
X-Google-Smtp-Source: ABdhPJwmNc70bqvNpE9Th6f/yEkJ1KOeim08uzo3Hnotd+SFjmYkETjPqnU1qh91bd+VYsVqs20Dbw==
X-Received: by 2002:a17:907:161e:: with SMTP id hb30mr45346717ejc.360.1620957233559;
        Thu, 13 May 2021 18:53:53 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id w6sm3322574edc.25.2021.05.13.18.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 18:53:53 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: bridge: fix build when IPv6 is disabled
Date:   Fri, 14 May 2021 03:53:48 +0200
Message-Id: <20210514015348.15448-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The br_ip6_multicast_add_router() prototype is defined only when
CONFIG_IPV6 is enabled, but the function is always referenced, so there
is this build error with CONFIG_IPV6 not defined:

net/bridge/br_multicast.c: In function ‘__br_multicast_enable_port’:
net/bridge/br_multicast.c:1743:3: error: implicit declaration of function ‘br_ip6_multicast_add_router’; did you mean ‘br_ip4_multicast_add_router’? [-Werror=implicit-function-declaration]
 1743 |   br_ip6_multicast_add_router(br, port);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
      |   br_ip4_multicast_add_router
net/bridge/br_multicast.c: At top level:
net/bridge/br_multicast.c:2804:13: warning: conflicting types for ‘br_ip6_multicast_add_router’
 2804 | static void br_ip6_multicast_add_router(struct net_bridge *br,
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
net/bridge/br_multicast.c:2804:13: error: static declaration of ‘br_ip6_multicast_add_router’ follows non-static declaration
net/bridge/br_multicast.c:1743:3: note: previous implicit declaration of ‘br_ip6_multicast_add_router’ was here
 1743 |   br_ip6_multicast_add_router(br, port);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this build error by moving the definition out of the #ifdef.

Fixes: a3c02e769efe ("net: bridge: mcast: split multicast router state for IPv4 and IPv6")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 0703725527b3..53c3a9d80d9c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -62,9 +62,9 @@ static void br_multicast_port_group_rexmit(struct timer_list *t);
 
 static void
 br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
-#if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_add_router(struct net_bridge *br,
 					struct net_bridge_port *port);
+#if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 struct net_bridge_port *port,
 					 const struct in6_addr *group,
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2732042A8FD
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbhJLQAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237544AbhJLQAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A697610EA;
        Tue, 12 Oct 2021 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054330;
        bh=rlJJWRLGUe+K+61yThvMk0MzMeXGMqjYPC5OxDyFXMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS2idQk24pL80eUR7gFzq15OdSF0NV73EhSIGh+7q7mrxj7W98g1p221kfdBo3cKU
         AKzvonNd6oONFm8gIC3wST03F+sJ8qXZChB4T07hGWBPhrdaMnLKF951IvTJB6t0JL
         IL1l5xpEOi1DptCdP/14fq3rvLqUbroS16dHpO/8wsnQl6dA4XQFn74YAkpS+RFe3g
         O3k1rg3bNuxIoB/mQI7EvUXQvrNGikQ2GZethcnHhec3etWMBmuLj5+kk4jNLo7lxg
         aTYyNne92Io5vWhub50n0Nzd7fQAvinHU8IYd2Kdl0Nz3Js9n9Tl22IUfJF36fqMKQ
         zRYDfvzr6aS2A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/6] tipc: constify dev_addr passing
Date:   Tue, 12 Oct 2021 08:58:39 -0700
Message-Id: <20211012155840.4151590-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
References: <20211012155840.4151590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for netdev->dev_addr being constant
make all relevant arguments in tipc constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/bearer.c    | 4 ++--
 net/tipc/bearer.h    | 2 +-
 net/tipc/eth_media.c | 2 +-
 net/tipc/ib_media.c  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 443f8e5b9477..60bc74b76adc 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -462,7 +462,7 @@ int tipc_enable_l2_media(struct net *net, struct tipc_bearer *b,
 	b->bcast_addr.media_id = b->media->type_id;
 	b->bcast_addr.broadcast = TIPC_BROADCAST_SUPPORT;
 	b->mtu = dev->mtu;
-	b->media->raw2addr(b, &b->addr, (char *)dev->dev_addr);
+	b->media->raw2addr(b, &b->addr, (const char *)dev->dev_addr);
 	rcu_assign_pointer(dev->tipc_ptr, b);
 	return 0;
 }
@@ -703,7 +703,7 @@ static int tipc_l2_device_event(struct notifier_block *nb, unsigned long evt,
 		break;
 	case NETDEV_CHANGEADDR:
 		b->media->raw2addr(b, &b->addr,
-				   (char *)dev->dev_addr);
+				   (const char *)dev->dev_addr);
 		tipc_reset_bearer(net, b);
 		break;
 	case NETDEV_UNREGISTER:
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 57c6a1a719e2..490ad6e5f7a3 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -117,7 +117,7 @@ struct tipc_media {
 			char *msg);
 	int (*raw2addr)(struct tipc_bearer *b,
 			struct tipc_media_addr *addr,
-			char *raw);
+			const char *raw);
 	u32 priority;
 	u32 tolerance;
 	u32 min_win;
diff --git a/net/tipc/eth_media.c b/net/tipc/eth_media.c
index c68019697cfe..cb0d185e06af 100644
--- a/net/tipc/eth_media.c
+++ b/net/tipc/eth_media.c
@@ -60,7 +60,7 @@ static int tipc_eth_addr2msg(char *msg, struct tipc_media_addr *addr)
 /* Convert raw mac address format to media addr format */
 static int tipc_eth_raw2addr(struct tipc_bearer *b,
 			     struct tipc_media_addr *addr,
-			     char *msg)
+			     const char *msg)
 {
 	memset(addr, 0, sizeof(*addr));
 	ether_addr_copy(addr->value, msg);
diff --git a/net/tipc/ib_media.c b/net/tipc/ib_media.c
index 7aa9ff88458d..b9ad0434c3cd 100644
--- a/net/tipc/ib_media.c
+++ b/net/tipc/ib_media.c
@@ -67,7 +67,7 @@ static int tipc_ib_addr2msg(char *msg, struct tipc_media_addr *addr)
 /* Convert raw InfiniBand address format to media addr format */
 static int tipc_ib_raw2addr(struct tipc_bearer *b,
 			    struct tipc_media_addr *addr,
-			    char *msg)
+			    const char *msg)
 {
 	memset(addr, 0, sizeof(*addr));
 	memcpy(addr->value, msg, INFINIBAND_ALEN);
-- 
2.31.1


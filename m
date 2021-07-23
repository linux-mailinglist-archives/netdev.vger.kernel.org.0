Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288E93D36B9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhGWHtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:39 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:34052 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbhGWHtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:18 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 6AF9721495; Fri, 23 Jul 2021 16:29:50 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 13/16] mctp: Add dest neighbour lladdr to route output
Date:   Fri, 23 Jul 2021 16:29:29 +0800
Message-Id: <20210723082932.3570396-14-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723082932.3570396-1-jk@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

Now that we have a neighbour implementation, hook it up to the output
path to set the dest hardware address for outgoing packets.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/route.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index b961f43b5fbd..b5b3e991046a 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -375,6 +375,9 @@ static unsigned int mctp_route_mtu(struct mctp_route *rt)
 
 static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 {
+	struct mctp_hdr *hdr = mctp_hdr(skb);
+	char daddr_buf[MAX_ADDR_LEN];
+	char *daddr = NULL;
 	unsigned int mtu;
 	int rc;
 
@@ -386,9 +389,12 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 		return -EMSGSIZE;
 	}
 
-	/* TODO: daddr (from rt->neigh), saddr (from device?)  */
+	/* If lookup fails let the device handle daddr==NULL */
+	if (mctp_neigh_lookup(route->dev, hdr->dest, daddr_buf) == 0)
+		daddr = daddr_buf;
+
 	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
-			     NULL, NULL, skb->len);
+			     daddr, skb->dev->dev_addr, skb->len);
 	if (rc) {
 		kfree_skb(skb);
 		return -EHOSTUNREACH;
-- 
2.30.2


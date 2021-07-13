Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CFA3C6A72
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhGMGaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 02:30:15 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:59270 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbhGMGaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 02:30:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 046D021456; Tue, 13 Jul 2021 14:21:39 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH RFC net-next v2 12/16] mctp: Add dest neighbour lladdr to route output
Date:   Tue, 13 Jul 2021 14:20:19 +0800
Message-Id: <20210713062023.3286895-13-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713062023.3286895-1-jk@codeconstruct.com.au>
References: <20210713062023.3286895-1-jk@codeconstruct.com.au>
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
index 1909437f9a15..cf06d88ca0ca 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -169,6 +169,9 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 
 static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 {
+	struct mctp_hdr *hdr = mctp_hdr(skb);
+	char daddr_buf[MAX_ADDR_LEN];
+	char *daddr = NULL;
 	unsigned int mtu;
 	int rc;
 
@@ -180,9 +183,12 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
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


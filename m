Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36C341BFDB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244659AbhI2H2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:31 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33070 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbhI2H22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:28 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id C288C20274; Wed, 29 Sep 2021 15:26:46 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 02/10] mctp: Allow local delivery to the null EID
Date:   Wed, 29 Sep 2021 15:26:06 +0800
Message-Id: <20210929072614.854015-3-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

We may need to receive packets addressed to the null EID (==0), but
addressed to us at the physical layer.

This change adds a lookup for local routes when we see a packet
addressed to EID 0, and a local phys address.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index a953f83ed02b..224fd25b3678 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -474,6 +474,10 @@ static int mctp_alloc_local_tag(struct mctp_sock *msk,
 	int rc = -EAGAIN;
 	u8 tagbits;
 
+	/* for NULL destination EIDs, we may get a response from any peer */
+	if (daddr == MCTP_ADDR_NULL)
+		daddr = MCTP_ADDR_ANY;
+
 	/* be optimistic, alloc now */
 	key = mctp_key_alloc(msk, saddr, daddr, 0, GFP_KERNEL);
 	if (!key)
@@ -552,6 +556,20 @@ struct mctp_route *mctp_route_lookup(struct net *net, unsigned int dnet,
 	return rt;
 }
 
+static struct mctp_route *mctp_route_lookup_null(struct net *net,
+						 struct net_device *dev)
+{
+	struct mctp_route *rt;
+
+	list_for_each_entry_rcu(rt, &net->mctp.routes, list) {
+		if (rt->dev->dev == dev && rt->type == RTN_LOCAL &&
+		    refcount_inc_not_zero(&rt->refs))
+			return rt;
+	}
+
+	return NULL;
+}
+
 /* sends a skb to rt and releases the route. */
 int mctp_do_route(struct mctp_route *rt, struct sk_buff *skb)
 {
@@ -849,6 +867,11 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 	cb->net = READ_ONCE(mdev->net);
 
 	rt = mctp_route_lookup(net, cb->net, mh->dest);
+
+	/* NULL EID, but addressed to our physical address */
+	if (!rt && mh->dest == MCTP_ADDR_NULL && skb->pkt_type == PACKET_HOST)
+		rt = mctp_route_lookup_null(net, dev);
+
 	if (!rt)
 		goto err_drop;
 
-- 
2.30.2


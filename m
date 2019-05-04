Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626BE13A81
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 16:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfEDOAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 10:00:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39391 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfEDN7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:59:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id a9so11336975wrp.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mZBzIvvNgMRVpYhhnkdzLEwHFoExuGomuvWKglGuCvU=;
        b=vYORLASCmDhy5L4/6+Brt9qwGh5fJq2+/PbkpXwr1Eg6Msgv8XdujF2/jc3SMH1bgW
         XOa9fTxYhhuVPqtBlX1IPOiKrraY0kJqT8GVtSGpix39BvUJ/RIQoO0E8Sfax8QQHtF1
         4JTI2bMOG/CfJNFU9rkmIjsRgZnJzjcXu0HJOpgBWU9y0UFCefdrEth5SIYLav6fE59n
         bcR6nkaWm7KBA1Ly4P/Ed2e41o8AEV0aCMcsUHIZAvpAT3LX10J+TFAG7ICDD1+MPGVD
         50Lvhsbbba2Oxe3Xs0XktXd2scttnBcGenGN7K0ShmjtC6Hc5WPsWx59HjNrqz4AQxCe
         EOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mZBzIvvNgMRVpYhhnkdzLEwHFoExuGomuvWKglGuCvU=;
        b=ei2c0YyozLqirrn5u6MRXVeM9zPRTysEfQo8IgtrzW8Fc1RhTjqDvSFSqOZpTF2I35
         DzHrYRelHKCpZCE3WKQrgbmuLPL3NfYqpKjRs/aNsT2EJLBwMMPi3LUvkla4l+9kk6dT
         smo3lQviDzi74BBVUFET7kxEUnFfQHgiqTku4BFkIegHlF8sIMegpIkFpdtKfRygJtju
         D411prBDb+RyHUBUQTHXAUBRGTRLtCvAZ0hlTHw6c5SXvob+bqRGx/44Z6fQ1jShvlu7
         IVmt+BCp16CsuB7b5+MsPNUqIuUZ9DfLg0kj2TPuYn8T3UruGMwEUocHFIgxAp9JeXqt
         MfJQ==
X-Gm-Message-State: APjAAAVwxQBMi3dNHH8eXTdz8sCzLmQ1fkESKjAS/6jKtI7v+odmrQv5
        DCSjxT3mgytCiO7tOKMCmKg=
X-Google-Smtp-Source: APXvYqyXfARV23Wpm13S6eVYt50tQAeXbB+0swO6kut1Au0vfw6IV5IYQ5lA+yqSEVSD7iWzEyHgAg==
X-Received: by 2002:adf:ba93:: with SMTP id p19mr11701868wrg.195.1556978387891;
        Sat, 04 May 2019 06:59:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s16sm5085940wrg.71.2019.05.04.06.59.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:59:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 3/9] net: dsa: Allow drivers to filter packets they can decode source port from
Date:   Sat,  4 May 2019 16:59:13 +0300
Message-Id: <20190504135919.23185-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504135919.23185-1-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frames get processed by DSA and redirected to switch port net devices
based on the ETH_P_XDSA multiplexed packet_type handler found by the
network stack when calling eth_type_trans().

The running assumption is that once the DSA .rcv function is called, DSA
is always able to decode the switch tag in order to change the skb->dev
from its master.

However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
true, since switch tagging piggybacks on the absence of a vlan_filtering
bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
rely on switch tagging, but on a different mechanism. So it would make
sense to at least be able to terminate that.

Having DSA receive traffic it can't decode would put it in an impossible
situation: the eth_type_trans() function would invoke the DSA .rcv(),
which could not change skb->dev, then eth_type_trans() would be invoked
again, which again would call the DSA .rcv, and the packet would never
be able to exit the DSA filter and would spiral in a loop until the
whole system dies.

This happens because eth_type_trans() doesn't actually look at the skb
(so as to identify a potential tag) when it deems it as being
ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
installed (therefore it's a DSA master) and that there exists a .rcv
callback (everybody except DSA_TAG_PROTO_NONE has that). This is
understandable as there are many switch tags out there, and exhaustively
checking for all of them is far from ideal.

The solution lies in introducing a filtering function for each tagging
protocol. In the absence of a filtering function, all traffic is passed
to the .rcv DSA callback. The tagging protocol should see the filtering
function as a pre-validation that it can decode the incoming skb. The
traffic that doesn't match the filter will bypass the DSA .rcv callback
and be left on the master netdevice, which wasn't previously possible.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
  - None.

 include/net/dsa.h  | 15 +++++++++++++++
 net/dsa/dsa2.c     |  1 +
 net/ethernet/eth.c |  6 +++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 69f3714f42ba..c90ceeec7d1f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -69,6 +69,11 @@ struct dsa_device_ops {
 			       struct packet_type *pt);
 	int (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			    int *offset);
+	/* Used to determine which traffic should match the DSA filter in
+	 * eth_type_trans, and which, if any, should bypass it and be processed
+	 * as regular on the master net device.
+	 */
+	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int overhead;
 	const char *name;
 	enum dsa_tag_protocol proto;
@@ -148,6 +153,7 @@ struct dsa_port {
 	struct dsa_switch_tree *dst;
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
+	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
@@ -520,6 +526,15 @@ static inline bool netdev_uses_dsa(struct net_device *dev)
 	return false;
 }
 
+static inline bool dsa_can_decode(const struct sk_buff *skb,
+				  struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	return !dev->dsa_ptr->filter || dev->dsa_ptr->filter(skb, dev);
+#endif
+	return false;
+}
+
 struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n);
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f1ad80851616..3b5f434cad3f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -586,6 +586,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 	}
 
 	dp->type = DSA_PORT_TYPE_CPU;
+	dp->filter = tag_ops->filter;
 	dp->rcv = tag_ops->rcv;
 	dp->tag_ops = tag_ops;
 	dp->master = master;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 0f9863dc4d44..fddcee38c1da 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -185,8 +185,12 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	 * at all, so we check here whether one of those tagging
 	 * variants has been configured on the receiving interface,
 	 * and if so, set skb->protocol without looking at the packet.
+	 * The DSA tagging protocol may be able to decode some but not all
+	 * traffic (for example only for management). In that case give it the
+	 * option to filter the packets from which it can decode source port
+	 * information.
 	 */
-	if (unlikely(netdev_uses_dsa(dev)))
+	if (unlikely(netdev_uses_dsa(dev)) && dsa_can_decode(skb, dev))
 		return htons(ETH_P_XDSA);
 
 	if (likely(eth_proto_is_802_3(eth->h_proto)))
-- 
2.17.1


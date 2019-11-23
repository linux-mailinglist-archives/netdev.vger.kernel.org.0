Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E14010802B
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 20:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKWTtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 14:49:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55369 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWTtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 14:49:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so11051232wmb.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 11:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TjeaQ26xKL27La4jwC5rO/pHEKTUNkcEI+idKnUhFWE=;
        b=oEOxuNPx/2AI+iegOTaYge75r9Nb3+GBJTqC8ZTXqfVUKyXAFOLUm1FBxHSqwH4Bdf
         JlTD27zVPHVKznJKe/i/7g3Gf3Np91mhOcQbsTWXWKRrQ1l6l52SOReVrhWbL7rxIT5f
         SPovMhwHmjhhcMmo15lg/hMhU1h2mD1tGoeqkWNkHlJOeZMhrihlERDFvMFdhqn2CiO6
         EXFh+bBnoJjHTW9BTR7d4er+FSwCQhtmMIZ5ZOg46UlD14NFUF5x2WFC6lVIUOWy9kig
         s7IXWWYFrTT4DCh/OJtdeNaDIdDq7oPBzZmMGVVlcT0gmf8FGdr/pHJJbvYpwV2cEtSc
         fnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TjeaQ26xKL27La4jwC5rO/pHEKTUNkcEI+idKnUhFWE=;
        b=TkcOSV3wjJopvAE30SWSZpgSTzntwKA1qN1NFH6TX108uDT4FVeMCZnmd5MlrTtqr0
         eF34gJEyLgpVYWi9h8eikiT7FNxEr3RpPrK0oeTyIDhG903G0Ehc8pcml/i3O2FanT3P
         /uAvyQPIFO+ogPNBDAInnRVcMh3jCYWw3eOvceFHdfFPRHZa7cWTommGXg77KA0/t1Wt
         cCnG67cVeOOgXzLuuLBwbREOq8qx04lfosNmU+MAzqm0iHspjKvKpljxORCS0DUO9hIa
         2rcjbRiq7qvI+ihqYNm9SD0+sjIxSy7FqBFqamvpm8S4fpKbbIdioEQ1KtCc3pWnGrWK
         +ipg==
X-Gm-Message-State: APjAAAUPbHNjZ5+lEN5uoot8mqW9GSEtDMHdVwhZODX6ldr37CF+Es9w
        A4JSZcaKqbcEOZw3wofEnrlBnCXL
X-Google-Smtp-Source: APXvYqzOGoEgyndCOdLSJFIfTesgiDYwBS/fW9KOhZTQMiPSnlmPZ34ukfpTSqI+1fA6fMnNg3IkQg==
X-Received: by 2002:a1c:7e0e:: with SMTP id z14mr23339268wmc.52.1574538577208;
        Sat, 23 Nov 2019 11:49:37 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id j10sm3300569wrx.30.2019.11.23.11.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 11:49:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
Date:   Sat, 23 Nov 2019 21:48:42 +0200
Message-Id: <20191123194844.9508-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191123194844.9508-1-olteanv@gmail.com>
References: <20191123194844.9508-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is useful be able to configure port policers on a switch to accept
frames of various sizes:

- Increase the MTU for better throughput from the default of 1500 if it
  is known that there is no 10/100 Mbps device in the network.
- Decrease the MTU to limit the latency of high-priority frames under
  congestion.

For DSA slave ports, this is mostly a pass-through callback, called
through the regular ndo ops and at probe time (to ensure consistency
across all supported switches).

The CPU port is called with an MTU equal to the largest configured MTU
of the slave ports. The assumption is that the user might want to
sustain a bidirectional conversation with a partner over any switch
port.

The DSA master is configured the same as the CPU port, plus the tagger
overhead. Since the MTU is by definition L2 payload (sans Ethernet
header), it is up to each individual driver to figure out if it needs to
do anything special for its frame tags on the CPU port (it shouldn't
except in special cases). So the MTU does not contain the tagger
overhead on the CPU port.
However the MTU of the DSA master, minus the tagger overhead, is used as
a proxy for the MTU of the CPU port, which does not have a net device.
This is to avoid uselessly calling the .change_mtu function on the CPU
port when nothing should change.

So it is safe to assume that the DSA master and the CPU port MTUs are
apart by exactly the tagger's overhead in bytes.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h  |  2 ++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/master.c   | 13 +++++-----
 net/dsa/slave.c    | 64 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6767dc3f66c0..c25eec2b8cc0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -382,6 +382,8 @@ struct dsa_switch_ops {
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
+	int	(*change_mtu)(struct dsa_switch *ds, int port, int new_mtu);
+	int	(*get_max_mtu)(struct dsa_switch *ds, int port);
 
 	/*
 	 * Access to the switch's PHY registers.
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 53e7577896b6..1501f06643ca 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -98,6 +98,8 @@ int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
+int dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp,
+		       int mtu);
 
 static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 						       int device, int port)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 3255dfc97f86..7efcce6ef05d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -284,18 +284,19 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp)
+/* Needs to be called under rtnl_lock */
+int dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp,
+		       int mtu)
 {
-	unsigned int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
-	int err;
+	int err = -ERANGE;
 
-	rtnl_lock();
 	if (mtu <= dev->max_mtu) {
 		err = dev_set_mtu(dev, mtu);
 		if (err)
 			netdev_dbg(dev, "Unable to set MTU to include for DSA overheads\n");
 	}
-	rtnl_unlock();
+
+	return err;
 }
 
 static void dsa_master_reset_mtu(struct net_device *dev)
@@ -314,8 +315,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	int ret;
 
-	dsa_master_set_mtu(dev,  cpu_dp);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 78ffc87dc25e..acdeeee191d7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -149,6 +149,60 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 	}
 }
 
+static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->dp->ds;
+	struct dsa_port *cpu_dp;
+	int port = p->dp->index;
+	int max_mtu = 0;
+	int cpu_mtu;
+	int err, i;
+
+	if (!ds->ops->change_mtu)
+		return -EOPNOTSUPP;
+
+	err = ds->ops->change_mtu(ds, port, new_mtu);
+	if (err < 0)
+		return err;
+
+	dev->mtu = new_mtu;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		/* During probe, this function will be called for each slave
+		 * device, while not all of them have been allocated. That's
+		 * ok, it doesn't change what the maximum is, so ignore it.
+		 */
+		if (!dsa_to_port(ds, i)->slave)
+			continue;
+
+		if (max_mtu < dsa_to_port(ds, i)->slave->mtu)
+			max_mtu = dsa_to_port(ds, i)->slave->mtu;
+	}
+
+	cpu_dp = dsa_to_port(ds, port)->cpu_dp;
+
+	max_mtu += cpu_dp->tag_ops->overhead;
+	cpu_mtu = master->mtu;
+
+	if (max_mtu != cpu_mtu) {
+		err = ds->ops->change_mtu(ds, dsa_upstream_port(ds, port),
+					  max_mtu - cpu_dp->tag_ops->overhead);
+		if (err < 0)
+			return err;
+
+		err = dsa_master_set_mtu(master, cpu_dp, max_mtu);
+		if (err < 0)
+			return err;
+	}
+
+	return err;
+}
+
 static void dsa_slave_set_rx_mode(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
@@ -1248,6 +1302,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_stop		= dsa_slave_close,
 	.ndo_start_xmit		= dsa_slave_xmit,
 	.ndo_change_rx_flags	= dsa_slave_change_rx_flags,
+	.ndo_change_mtu		= dsa_slave_change_mtu,
 	.ndo_set_rx_mode	= dsa_slave_set_rx_mode,
 	.ndo_set_mac_address	= dsa_slave_set_mac_address,
 	.ndo_fdb_add		= dsa_legacy_fdb_add,
@@ -1440,7 +1495,10 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	slave_dev->min_mtu = 0;
-	slave_dev->max_mtu = ETH_MAX_MTU;
+	if (ds->ops->get_max_mtu)
+		slave_dev->max_mtu = ds->ops->get_max_mtu(ds, port->index);
+	else
+		slave_dev->max_mtu = ETH_MAX_MTU;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
@@ -1460,6 +1518,10 @@ int dsa_slave_create(struct dsa_port *port)
 	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
 
+	rtnl_lock();
+	dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
+	rtnl_unlock();
+
 	netif_carrier_off(slave_dev);
 
 	ret = dsa_slave_phy_setup(slave_dev);
-- 
2.17.1


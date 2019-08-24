Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A1E9BAF3
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 04:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfHXCnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 22:43:07 -0400
Received: from mail.nic.cz ([217.31.204.67]:37288 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfHXCnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 22:43:02 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id D9A45140D23;
        Sat, 24 Aug 2019 04:42:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566614580; bh=AC+PVQwA6Fix9qcvNMGUHHTWu5CWtzFdGlYjHQ3j5AQ=;
        h=From:To:Date;
        b=LOMQONxVq2PFB4CLqpcuBlTBtVaCwpHmEGDYOjWDWTq0PhBYF/GXGsjK8VHv+kbjj
         fQ9bsLsqog0Ln0Zi9M04t4krFY8xbQySLesWaQGbTjc2coKXUwCvsRH8Z70TLUuz8C
         sgnXbNcMR6nWd8S/InLWwiTOlkMeAz3jX0ZIw8NE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 3/3] net: dsa: implement ndo_set_netlink for chaning port's CPU port
Date:   Sat, 24 Aug 2019 04:42:50 +0200
Message-Id: <20190824024251.4542-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
References: <20190824024251.4542-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement ndo_set_iflink for DSA slave device. In multi-CPU port setup
this should be used to change to which CPU destination port a given port
should be connected.

This adds a new operation into the DSA switch operations structure,
port_change_cpu_port. A driver implementing this function has the
ability to change CPU destination port of a given port.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/slave.c   | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 64bd70608f2f..4f3f0032b886 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -545,6 +545,12 @@ struct dsa_switch_ops {
 	 */
 	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
 					  struct sk_buff *skb);
+
+	/*
+	 * Multi-CPU port support
+	 */
+	int	(*port_change_cpu_port)(struct dsa_switch *ds, int port,
+					struct dsa_port *new_cpu_dp);
 };
 
 struct dsa_switch_driver {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33f41178afcc..bafaadeca912 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -64,6 +64,40 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
 	return dsa_slave_to_master(dev)->ifindex;
 }
 
+static int dsa_slave_set_iflink(struct net_device *dev, int iflink)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct net_device *new_cpu_dev;
+	struct dsa_port *new_cpu_dp;
+	int err;
+
+	if (!dp->ds->ops->port_change_cpu_port)
+		return -EOPNOTSUPP;
+
+	new_cpu_dev = dev_get_by_index(dev_net(dev), iflink);
+	if (!new_cpu_dev)
+		return -ENODEV;
+
+	new_cpu_dp = new_cpu_dev->dsa_ptr;
+	if (!new_cpu_dp)
+		return -EINVAL;
+
+	/* new CPU port has to be on the same switch tree */
+	if (new_cpu_dp->dst != dp->dst)
+		return -EINVAL;
+
+	err = dp->ds->ops->port_change_cpu_port(dp->ds, dp->index, new_cpu_dp);
+	if (err)
+		return err;
+
+	/* should this be done atomically? */
+	dp->cpu_dp = new_cpu_dp;
+	p->xmit = new_cpu_dp->tag_ops->xmit;
+
+	return 0;
+}
+
 static int dsa_slave_open(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
@@ -1176,6 +1210,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_fdb_dump		= dsa_slave_fdb_dump,
 	.ndo_do_ioctl		= dsa_slave_ioctl,
 	.ndo_get_iflink		= dsa_slave_get_iflink,
+	.ndo_set_iflink		= dsa_slave_set_iflink,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_netpoll_setup	= dsa_slave_netpoll_setup,
 	.ndo_netpoll_cleanup	= dsa_slave_netpoll_cleanup,
-- 
2.21.0


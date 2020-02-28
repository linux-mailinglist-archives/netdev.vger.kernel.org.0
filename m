Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E934C173F00
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgB1SCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:02:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40147 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:02:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id t24so1893315pgj.7
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dh8cj01nYdUYJjeSSaiv1Lu2wcuphSMfktQi/Z4uiCE=;
        b=QjAzlG/UeFzn4WgN1RRQbdcjtoTrg69JQTU2JmXEKTVnokpr+zAIbtW7WZL9YkYw+s
         iSS79ibXstdhd0NdHBNLiW6txQgaMiY4/KWH/H3k1VICknXgYfg1vJOdzhJCAXvyqsI0
         87uPPNxgMvllETpHJxV3h7Y77UUWPYYK3VQMxzrGoAl37+2gbTPF99tA9ufflGURc3fV
         igMo51URoNASWptsjyHkB6IhibmNViy5BNQKretCv7H3JLb+qmKP2ZjdNzKIiBm6egct
         dRhdEu084tT6626twuKVK4EDxnKl/lL4PUIk11+xwdT5kWZuuzx/ILu4MJZ2jEUfEEQI
         ra4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dh8cj01nYdUYJjeSSaiv1Lu2wcuphSMfktQi/Z4uiCE=;
        b=Hj1M4xSFObZ12tJh+ASbk+baflt8xOMQx0VEHcPrclAYQ0FNEUHopn58jqRiicCl26
         dWk8nGdQ+xYNEtxlJuZsGgwzITDOdWlqyHCVzB2QRl/b1OPDXaaR0hdJEwPoYtL0veNJ
         MJm1ShrZZ7pRmnWRwqtaEY7hKgQFtKhcqlBu4kgoME+mZU5yteFXV4w1/gtBj1AKyzGQ
         5Y4p4UdMiguReEidOBvIsirKR/nXJdF5au36GakDyc2yHut7ReUPanth16nZHDE5lthf
         uBL3ehHGNgq/gs7O9A4WvwHrXLSfhwpHAljhfpIrnF2tQb0f07uGOdVZjqSDSP8/h3Ao
         J7ig==
X-Gm-Message-State: APjAAAVyp6wWRfhQlBT+MtGN+UtXSBPiE0se/ieChH/sBFFw8eemoUYX
        AKf4jQMeRYJJl0X3TO4eFd7Mvhzu8Ls=
X-Google-Smtp-Source: APXvYqy0qS3eCH4nmDW5cX+P629sHzyqmX/y+5cuH7Xh5VOZWlS5sgf86zGgwXDbI8YN1+mGfzbHGw==
X-Received: by 2002:a63:c30e:: with SMTP id c14mr6065559pgd.168.1582912937004;
        Fri, 28 Feb 2020 10:02:17 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e4sm3159457pfj.22.2020.02.28.10.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:02:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 5/5] hsr: use upper/lower device infrastructure
Date:   Fri, 28 Feb 2020 18:02:10 +0000
Message-Id: <20200228180210.27920-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_upper_dev_link() is useful to manage lower/upper interfaces.
And this function internally validates looping, maximum depth.
All or most virtual interfaces that could have a real interface
(e.g. macsec, macvlan, ipvlan etc.) use lower/upper infrastructure.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c | 32 ++++++++++++++++++++------------
 net/hsr/hsr_main.c   |  3 ++-
 net/hsr/hsr_slave.c  | 35 ++++++++++++++++++-----------------
 3 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 00532d14fc7c..fc7027314ad8 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -341,22 +341,33 @@ static void hsr_announce(struct timer_list *t)
 	rcu_read_unlock();
 }
 
+static void hsr_del_ports(struct hsr_priv *hsr)
+{
+	struct hsr_port *port;
+
+	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
+	if (port)
+		hsr_del_port(port);
+
+	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
+	if (port)
+		hsr_del_port(port);
+
+	port = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	if (port)
+		hsr_del_port(port);
+}
+
 /* This has to be called after all the readers are gone.
  * Otherwise we would have to check the return value of
  * hsr_port_get_hsr().
  */
 static void hsr_dev_destroy(struct net_device *hsr_dev)
 {
-	struct hsr_priv *hsr;
-	struct hsr_port *port;
-	struct hsr_port *tmp;
-
-	hsr = netdev_priv(hsr_dev);
+	struct hsr_priv *hsr = netdev_priv(hsr_dev);
 
 	hsr_debugfs_term(hsr);
-
-	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
-		hsr_del_port(port);
+	hsr_del_ports(hsr);
 
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
@@ -426,8 +437,6 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     struct netlink_ext_ack *extack)
 {
 	struct hsr_priv *hsr;
-	struct hsr_port *port;
-	struct hsr_port *tmp;
 	int res;
 
 	hsr = netdev_priv(hsr_dev);
@@ -494,8 +503,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 err_add_slaves:
 	unregister_netdevice(hsr_dev);
 err_unregister:
-	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
-		hsr_del_port(port);
+	hsr_del_ports(hsr);
 err_add_master:
 	hsr_del_self_node(hsr);
 
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 9e389accbfc7..26d6c39f24e1 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -85,7 +85,8 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		master->dev->mtu = mtu_max;
 		break;
 	case NETDEV_UNREGISTER:
-		hsr_del_port(port);
+		if (!is_hsr_master(dev))
+			hsr_del_port(port);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* HSR works only on Ethernet devices. Refuse slave to change
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 07edc7f626fe..123605cb5420 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -97,19 +97,25 @@ static int hsr_check_dev_ok(struct net_device *dev,
 }
 
 /* Setup device to be added to the HSR bridge. */
-static int hsr_portdev_setup(struct net_device *dev, struct hsr_port *port)
+static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
+			     struct hsr_port *port,
+			     struct netlink_ext_ack *extack)
+
 {
+	struct net_device *hsr_dev;
+	struct hsr_port *master;
 	int res;
 
-	dev_hold(dev);
 	res = dev_set_promiscuity(dev, 1);
 	if (res)
 		goto fail_promiscuity;
 
-	/* FIXME:
-	 * What does net device "adjacency" mean? Should we do
-	 * res = netdev_master_upper_dev_link(port->dev, port->hsr->dev); ?
-	 */
+	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	hsr_dev = master->dev;
+
+	res = netdev_upper_dev_link(dev, hsr_dev, extack);
+	if (res)
+		goto fail_upper_dev_link;
 
 	res = netdev_rx_handler_register(dev, hsr_handle_frame, port);
 	if (res)
@@ -119,6 +125,8 @@ static int hsr_portdev_setup(struct net_device *dev, struct hsr_port *port)
 	return 0;
 
 fail_rx_handler:
+	netdev_upper_dev_unlink(dev, hsr_dev);
+fail_upper_dev_link:
 	dev_set_promiscuity(dev, -1);
 fail_promiscuity:
 	dev_put(dev);
@@ -147,7 +155,7 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 		return -ENOMEM;
 
 	if (type != HSR_PT_MASTER) {
-		res = hsr_portdev_setup(dev, port);
+		res = hsr_portdev_setup(hsr, dev, port, extack);
 		if (res)
 			goto fail_dev_setup;
 	}
@@ -180,21 +188,14 @@ void hsr_del_port(struct hsr_port *port)
 	list_del_rcu(&port->port_list);
 
 	if (port != master) {
-		if (master) {
-			netdev_update_features(master->dev);
-			dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
-		}
+		netdev_update_features(master->dev);
+		dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
 		netdev_rx_handler_unregister(port->dev);
 		dev_set_promiscuity(port->dev, -1);
+		netdev_upper_dev_unlink(port->dev, master->dev);
 	}
 
-	/* FIXME?
-	 * netdev_upper_dev_unlink(port->dev, port->hsr->dev);
-	 */
-
 	synchronize_rcu();
 
-	if (port != master)
-		dev_put(port->dev);
 	kfree(port);
 }
-- 
2.17.1


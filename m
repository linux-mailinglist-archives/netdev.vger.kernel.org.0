Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2857E52E153
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344114AbiETApJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343921AbiETApH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:45:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258311312AC
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 17:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFE59B827DB
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2194DC385AA;
        Fri, 20 May 2022 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653007502;
        bh=LEvX7fCRTsWAI6qnnXkhANYgMy894HIAyhAkATUeXYg=;
        h=From:To:Cc:Subject:Date:From;
        b=Z8sSf1alq6CUajH6os2diQ/0Q9UGvMx3CW0TV01n6BSxnxfTOGliG/CkUFfuMlgka
         Sx8Hi31tzfUhcNROMiI3PSAXcCK/auQ+6WRSg7QZEXNYciuRlKzxXk0zV5x9eSY06C
         T3uIh/dG2LqxkzGx5DL0xZyzCMnt/a5Q7OmakYIiTXbUhrxnyEY8supW4YNzPrue81
         Ct4jNGc12fbGDDDIbiFeZ7bqOMGVp87yzUgF6fhzRJ1v7w8R4u9x3taHxDQlkfyyP4
         M5e8Xo0lrSDVaTRXVXX91XNMv4W2dpnlXtOex/HSIHNC+pNczYdHqLEJZJ/FREeyn2
         CLXEPi6SiIlCQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, olteanv@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next] net: track locally triggered link loss
Date:   Thu, 19 May 2022 17:45:00 -0700
Message-Id: <20220520004500.2250674-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A comment above carrier_up_count / carrier_down_count in netdevice.h
proudly states:

	/* Stats to monitor link on/off, flapping */

In reality datacenter NIC drivers introduce quite a bit of noise
into those statistics, making them less than ideal for link flap
detection.

There are 3 types of events counted as carrier changes today:
  (1) reconfiguration which requires pausing Tx and Rx but doesn't
      actually result in a link down for the remote end;
  (2) reconfiguration events which do take the link down;
 (3a) real PHY-detected link loss due to remote end's actions;
 (3b) real PHY-detected link loss due to signal integrity issues.

(3a and 3b are indistinguishable to local end so counting as one.)

Reconfigurations of type (1) are when drivers call netif_carrier_off()
/ netif_carrier_on() around changes to queues, IRQs, time stamping,
XDP enablement etc. In DC scenarios machine provisioning or
reallocation causes multiple settings to be changed in close
succession. This looks like a spike in link flaps to monitoring
systems.

Suppressing the fake carrier changes while maintaining the Rx/Tx
pause behavior seems hard, and can introduce a divergence in what
the kernel thinks about the device (paused) vs what user space
thinks (running).

Another option would be to expose a link loss statistic which
some devices (FW) already maintain. Unfortunately, such stats
are not very common (unless my grepping skills fail me).

Instead this patch tries to expose a new event count - number
of locally caused link changes. Only "down" events are counted
because the "up" events are not really in our control.
The "real" link flaps can be obtained by subtracting the new
counter from carrier_down_count.

In terms of API - drivers can use netif_carrier_admin_off()
when taking the link down. There's also an API for situations
where driver requests link reset but expects the down / up
reporting to come thru the usual, async path (subset of type (2)).

It may be worth pointing out that in case of datacenter NICs
even with the new statistic we will not be able to distinguish
between events (1) and (2), and what follows two Linux boxes
connected back-to-back won't be able to isolate events of type (3b).
The link may stay up even if the driver does not need it because
of NCSI or some other entity requiring it to stay up.
To solve that we'd need yet another counter -
carrier_down_local_link_was_really_reset - I think it's okay
to leave that as a future extension...

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Posting as an RFC for general feedback on whether this is a good
way of solving the "driver called carrier_off to pause Tx" problem.

 include/linux/netdevice.h    | 24 ++++++++++++++++++++++++
 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         |  6 ++++++
 net/sched/sch_generic.c      | 27 ++++++++++++++++++++++++---
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1ce91cb8074a..4206748fb4d8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -310,6 +310,7 @@ enum netdev_state_t {
 	__LINK_STATE_LINKWATCH_PENDING,
 	__LINK_STATE_DORMANT,
 	__LINK_STATE_TESTING,
+	__LINK_STATE_NOCARRIER_LOCAL,
 };
 
 struct gro_list {
@@ -1766,6 +1767,8 @@ enum netdev_ml_priv_type {
  *			do not use this in drivers
  *	@carrier_up_count:	Number of times the carrier has been up
  *	@carrier_down_count:	Number of times the carrier has been down
+ *	@carrier_down_local:	Number of times the carrier has been counted as
+ *				down due to local administrative actions
  *
  *	@wireless_handlers:	List of functions to handle Wireless Extensions,
  *				instead of ioctl,
@@ -2055,6 +2058,7 @@ struct net_device {
 	/* Stats to monitor link on/off, flapping */
 	atomic_t		carrier_up_count;
 	atomic_t		carrier_down_count;
+	atomic_t		carrier_down_local;
 
 #ifdef CONFIG_WIRELESS_EXT
 	const struct iw_handler_def *wireless_handlers;
@@ -2310,6 +2314,7 @@ struct net_device {
 	bool			proto_down;
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
+	unsigned		has_carrier_down_local:1;
 
 	struct list_head	net_notifier_list;
 
@@ -4059,8 +4064,27 @@ unsigned long dev_trans_start(struct net_device *dev);
 
 void __netdev_watchdog_up(struct net_device *dev);
 
+/**
+ * netif_carrier_local_changes_start() - enter local link reconfiguration
+ * @dev: network device
+ *
+ * Mark link as unstable due to local administrative actions. This will
+ * cause netif_carrier_off() to behave like netif_carrier_admin_off() until
+ * netif_carrier_local_changes_end() is called.
+ */
+static inline void netif_carrier_local_changes_start(struct net_device *dev)
+{
+	set_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
+}
+
+static inline void netif_carrier_local_changes_end(struct net_device *dev)
+{
+	clear_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
+}
+
 void netif_carrier_on(struct net_device *dev);
 void netif_carrier_off(struct net_device *dev);
+void netif_carrier_admin_off(struct net_device *dev);
 void netif_carrier_event(struct net_device *dev);
 
 /**
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f58dcfe2787..b53e17e6f2ea 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -370,6 +370,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
+	IFLA_CARRIER_DOWN_LOCAL,
 
 	__IFLA_MAX
 };
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f7..e5cbb798c17d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1092,6 +1092,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
 	       + rtnl_prop_list_size(dev)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
+	       + nla_total_size(4) /* IFLA_CARRIER_DOWN_LOCAL */
 	       + 0;
 }
 
@@ -1790,6 +1791,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			atomic_read(&dev->carrier_down_count)))
 		goto nla_put_failure;
 
+	if (dev->has_carrier_down_local &&
+	    nla_put_u32(skb, IFLA_CARRIER_DOWN_LOCAL,
+			atomic_read(&dev->carrier_down_local)))
+		goto nla_put_failure;
+
 	if (rtnl_fill_proto_down(skb, dev))
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index dba0b3e24af5..f2123670bfbf 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -589,22 +589,43 @@ void netif_carrier_on(struct net_device *dev)
 EXPORT_SYMBOL(netif_carrier_on);
 
 /**
- *	netif_carrier_off - clear carrier
- *	@dev: network device
+ * netif_carrier_off() - clear carrier in response to a true link state event
+ * @dev: network device
  *
- * Device has detected loss of carrier.
+ * Clear carrier and stop Tx, use when device has detected loss of carrier.
  */
 void netif_carrier_off(struct net_device *dev)
 {
+	bool admin = test_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
+
 	if (!test_and_set_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
 		if (dev->reg_state == NETREG_UNINITIALIZED)
 			return;
 		atomic_inc(&dev->carrier_down_count);
+		if (admin)
+			atomic_inc(&dev->carrier_down_local);
 		linkwatch_fire_event(dev);
 	}
 }
 EXPORT_SYMBOL(netif_carrier_off);
 
+/**
+ * netif_carrier_admin_off() - clear carrier to reconfigure the device
+ * @dev: network device
+ *
+ * Force the carrier down, e.g. to perform device reconfiguration,
+ * reset the device after an error etc. This function should be used
+ * instead of netif_carrier_off() any time carrier goes down for reasons
+ * other that an actual link layer connection loss.
+ */
+void netif_carrier_admin_off(struct net_device *dev)
+{
+	netif_carrier_local_changes_start(dev);
+	netif_carrier_off(dev);
+	netif_carrier_local_changes_end(dev);
+}
+EXPORT_SYMBOL(netif_carrier_admin_off);
+
 /**
  *	netif_carrier_event - report carrier state event
  *	@dev: network device
-- 
2.34.3


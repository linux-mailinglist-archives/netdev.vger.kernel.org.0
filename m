Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4DA437FD9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhJVVQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbhJVVQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:16:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27242C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 14:13:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so3584776plr.13
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 14:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4oXP5eC2c2iXx6DfnABpmJLQBXH8vK+/GefBJyZApAE=;
        b=QWH4Kzu+fjFOVsr68HYXisaFK+gJ8rlIMrY/FZJzomJhTIDV7C+fO/EDDwE4A8EJvf
         XEch9w5+eVY5P9cp8fSeGRsAB8GUl/GwVNgNF/lDHCoKmrhPfe5EtodfDTs5ReHowq+x
         uWtH2OaGEvNHtmzy/Rob8x8k2bV7lTNs7QJuh1mul4Gy/kRM+Y00AIbbG5puKf3k5/Cy
         YmLF9e/j0bK+/a2zZeU3qQVgvZjaSPMV+Iyoix3aN5rIZLvNYMSkGURoh2BcYegt04fl
         nMLz1D13lPrWGmaVO3SnR7QqsbJIySymbkltwXZfnjZtjPskd89iiWTuHPC6OkzkfMXL
         ay5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4oXP5eC2c2iXx6DfnABpmJLQBXH8vK+/GefBJyZApAE=;
        b=jBSI9iOFyWXYozS1l1Nf8o3Vtd9rr/vrNV0RipOKkThAGevm51jfcYvP85U7RETuVo
         OaOXbNXaRG559B/D+TxpqNthTENkdPTtsNd7/bRVVnt6ssEx3TvRZvOtx7Oh/ClaZ4oK
         u+52BflUhQ2114JzSY4YtzAg6rlWlLSoNVQQfrmof/qprM2p/dAa3BxqoQ9xkqyikFzw
         QQ2W7KBUMsCGK0vitIcyntakLW36MNw8Bx2azFL3Axp/lnJnNI4nSla0W4DPTiA7PyWM
         1IgltBdzUhFENTzIv8OAoEClcHu6R141gFhIALQyWAYxgsKHHps1MZRJlVcOWbx6vQdk
         hAew==
X-Gm-Message-State: AOAM531YlmGOHR55QA18p5+ASIRBtzxlIk3x0vIZ7ogXOJxT/WOoLfcT
        KM0TVtgp0ZsZTmTjKuXaOMbbaqOY6BQ=
X-Google-Smtp-Source: ABdhPJy1mTtUoFSDdQJ56N4j8VERtCYWYUeD8Ms0M75nSbmKYNVLcoKmX1DqochXWjjhR1mIFajwoQ==
X-Received: by 2002:a17:90a:de8f:: with SMTP id n15mr17446748pjv.155.1634937235225;
        Fri, 22 Oct 2021 14:13:55 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id k3sm13684899pjg.43.2021.10.22.14.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 14:13:54 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [PATCH v7 1/3] net: arp: introduce arp_evict_nocarrier sysctl parameter
Date:   Fri, 22 Oct 2021 14:08:16 -0700
Message-Id: <20211022210818.1088742-2-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022210818.1088742-1-prestwoj@gmail.com>
References: <20211022210818.1088742-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces a new sysctl parameter, arp_evict_nocarrier.
When set (default) the ARP cache will be cleared on a NOCARRIER event.
This new option has been defaulted to '1' which maintains existing
behavior.

Clearing the ARP cache on NOCARRIER is relatively new, introduced by:

commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
Author: David Ahern <dsahern@gmail.com>
Date:   Thu Oct 11 20:33:49 2018 -0700

    net: Evict neighbor entries on carrier down

The reason for this changes is to prevent the ARP cache from being
cleared when a wireless device roams. Specifically for wireless roams
the ARP cache should not be cleared because the underlying network has not
changed. Clearing the ARP cache in this case can introduce significant
delays sending out packets after a roam.

A user reported such a situation here:

https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/

After some investigation it was found that the kernel was holding onto
packets until ARP finished which resulted in this 1 second delay. It
was also found that the first ARP who-has was never responded to,
which is actually what caues the delay. This change is more or less
working around this behavior, but again, there is no reason to clear
the cache on a roam anyways.

As for the unanswered who-has, we know the packet made it OTA since
it was seen while monitoring. Why it never received a response is
unknown. In any case, since this is a problem on the AP side of things
all that can be done is to work around it until it is solved.

Some background on testing/reproducing the packet delay:

Hardware:
 - 2 access points configured for Fast BSS Transition (Though I don't
   see why regular reassociation wouldn't have the same behavior)
 - Wireless station running IWD as supplicant
 - A device on network able to respond to pings (I used one of the APs)

Procedure:
 - Connect to first AP
 - Ping once to establish an ARP entry
 - Start a tcpdump
 - Roam to second AP
 - Wait for operstate UP event, and note the timestamp
 - Start pinging

Results:

Below is the tcpdump after UP. It was recorded the interface went UP at
10:42:01.432875.

10:42:01.461871 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
10:42:02.497976 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
10:42:02.507162 ARP, Reply 192.168.254.1 is-at ac:86:74:55:b0:20, length 46
10:42:02.507185 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 1, length 64
10:42:02.507205 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 2, length 64
10:42:02.507212 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 3, length 64
10:42:02.507219 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 4, length 64
10:42:02.507225 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 5, length 64
10:42:02.507232 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 6, length 64
10:42:02.515373 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 1, length 64
10:42:02.521399 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 2, length 64
10:42:02.521612 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 3, length 64
10:42:02.521941 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 4, length 64
10:42:02.522419 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 5, length 64
10:42:02.523085 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 6, length 64

You can see the first ARP who-has went out very quickly after UP, but
was never responded to. Nearly a second later the kernel retries and
gets a response. Only then do the ping packets go out. If an ARP entry
is manually added prior to UP (after the cache is cleared) it is seen
that the first ping is never responded to, so its not only an issue with
ARP but with data packets in general.

As mentioned prior, the wireless interface was also monitored to verify
the ping/ARP packet made it OTA which was observed to be true.

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/linux/inetdevice.h             |  2 ++
 include/uapi/linux/ip.h                |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv4/arp.c                         | 11 ++++++++++-
 net/ipv4/devinet.c                     |  4 ++++
 6 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 16b8bf72feaf..18fde4ed7a5e 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1611,6 +1611,15 @@ arp_accept - BOOLEAN
 	gratuitous arp frame, the arp table will be updated regardless
 	if this setting is on or off.
 
+arp_evict_nocarrier - BOOLEAN
+	Clears the ARP cache on NOCARRIER events. This option is important for
+	wireless devices where the ARP cache should not be cleared when roaming
+	between access points on the same network. In most cases this should
+	remain as the default (1).
+
+	- 1 - (default): Clear the ARP cache on NOCARRIER events
+	- 0 - Do not clear ARP cache on NOCARRIER events
+
 mcast_solicit - INTEGER
 	The maximum number of multicast probes in INCOMPLETE state,
 	when the associated hardware address is unknown.  Defaults
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index a038feb63f23..518b484a7f07 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -133,6 +133,8 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 #define IN_DEV_ARP_ANNOUNCE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ANNOUNCE)
 #define IN_DEV_ARP_IGNORE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_IGNORE)
 #define IN_DEV_ARP_NOTIFY(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_NOTIFY)
+#define IN_DEV_ARP_EVICT_NOCARRIER(in_dev) IN_DEV_ANDCONF((in_dev), \
+							  ARP_EVICT_NOCARRIER)
 
 struct in_ifaddr {
 	struct hlist_node	hash;
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..e00bbb9c47bb 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -169,6 +169,7 @@ enum
 	IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST,
 	IPV4_DEVCONF_DROP_GRATUITOUS_ARP,
 	IPV4_DEVCONF_BC_FORWARDING,
+	IPV4_DEVCONF_ARP_EVICT_NOCARRIER,
 	__IPV4_DEVCONF_MAX
 };
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 1e05d3caa712..6a3b194c50fe 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -482,6 +482,7 @@ enum
 	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
 	NET_IPV4_CONF_ARP_ACCEPT=21,
 	NET_IPV4_CONF_ARP_NOTIFY=22,
+	NET_IPV4_CONF_ARP_EVICT_NOCARRIER=23,
 };
 
 /* /proc/sys/net/ipv4/netfilter */
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..857a144b1ea9 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1247,6 +1247,8 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_change_info *change_info;
+	struct in_device *in_dev;
+	bool evict_nocarrier;
 
 	switch (event) {
 	case NETDEV_CHANGEADDR:
@@ -1257,7 +1259,14 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
 		change_info = ptr;
 		if (change_info->flags_changed & IFF_NOARP)
 			neigh_changeaddr(&arp_tbl, dev);
-		if (!netif_carrier_ok(dev))
+
+		in_dev = __in_dev_get_rtnl(dev);
+		if (!in_dev)
+			evict_nocarrier = true;
+		else
+			evict_nocarrier = IN_DEV_ARP_EVICT_NOCARRIER(in_dev);
+
+		if (evict_nocarrier && !netif_carrier_ok(dev))
 			neigh_carrier_down(&arp_tbl, dev);
 		break;
 	default:
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index f4468980b675..ec73a0d52d3e 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -75,6 +75,7 @@ static struct ipv4_devconf ipv4_devconf = {
 		[IPV4_DEVCONF_SHARED_MEDIA - 1] = 1,
 		[IPV4_DEVCONF_IGMPV2_UNSOLICITED_REPORT_INTERVAL - 1] = 10000 /*ms*/,
 		[IPV4_DEVCONF_IGMPV3_UNSOLICITED_REPORT_INTERVAL - 1] =  1000 /*ms*/,
+		[IPV4_DEVCONF_ARP_EVICT_NOCARRIER - 1] = 1,
 	},
 };
 
@@ -87,6 +88,7 @@ static struct ipv4_devconf ipv4_devconf_dflt = {
 		[IPV4_DEVCONF_ACCEPT_SOURCE_ROUTE - 1] = 1,
 		[IPV4_DEVCONF_IGMPV2_UNSOLICITED_REPORT_INTERVAL - 1] = 10000 /*ms*/,
 		[IPV4_DEVCONF_IGMPV3_UNSOLICITED_REPORT_INTERVAL - 1] =  1000 /*ms*/,
+		[IPV4_DEVCONF_ARP_EVICT_NOCARRIER - 1] = 1,
 	},
 };
 
@@ -2532,6 +2534,8 @@ static struct devinet_sysctl_table {
 		DEVINET_SYSCTL_RW_ENTRY(ARP_IGNORE, "arp_ignore"),
 		DEVINET_SYSCTL_RW_ENTRY(ARP_ACCEPT, "arp_accept"),
 		DEVINET_SYSCTL_RW_ENTRY(ARP_NOTIFY, "arp_notify"),
+		DEVINET_SYSCTL_RW_ENTRY(ARP_EVICT_NOCARRIER,
+					"arp_evict_nocarrier"),
 		DEVINET_SYSCTL_RW_ENTRY(PROXY_ARP_PVLAN, "proxy_arp_pvlan"),
 		DEVINET_SYSCTL_RW_ENTRY(FORCE_IGMP_VERSION,
 					"force_igmp_version"),
-- 
2.31.1


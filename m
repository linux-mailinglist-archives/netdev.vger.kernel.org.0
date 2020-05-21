Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD31DD929
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgEUVLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbgEUVLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:05 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035A1C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:05 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so10539622ejd.8
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cvWXsQ7jwqJ+5wGrazkK/1Z+2D6k5GNrtr2FbBBt+yY=;
        b=UcROnpdM69lTWxOg2pEgMOJfybnFA7ITC28/tav5guwGrivEwg9wPSvirbwyi7tgLF
         5wbcEgYyUJQS8SalyQYNAeV4473pNs9A7gkhJgWaNmi6sGbLfjWyziE3d/bU9xI06kMi
         wG6MgE2e4M1nnTtBYcVKwwgh3tlNIcqjgKhPQ6dGRW750oIxegriQuImSZGfhNQf9dL/
         DWSWMIsKGBK70MCCPnGop3fw7haYGXHB22zx0j/IwjFg2pqxMNkPC3SxVmmJ5RfEjlUI
         mGofjlZubiMl72bKFHUCDjHwvayFtfDpcoPMfOaBeCib0y4/VPjE53ax2Tq7Q5r4mdeP
         yMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cvWXsQ7jwqJ+5wGrazkK/1Z+2D6k5GNrtr2FbBBt+yY=;
        b=PjVwgsH1VMh3WH5hXQbwT78PtvlGjIDBswOmu7lHUP6N1o7SlXVBILxLC0XdjUoWnJ
         jGukHm1LxEEbL3qISYalpIOBWn8mJQpLQH172XEB3q1sMYyDYPtbf75fwX/F7Chch4gw
         gPeI893Z59P8cMKhHHPwp6DEylPRLtCaUTjfwPzcoFjjrPO9gCXpnGlgKunG4vwpzJbz
         68Yw7NAZt1B27rv5+/a1eplbaTvcUyEK6Tp+PAUehoMS/p0GGvSarOfRvPofadx8rRnZ
         ey8HpnXOqyvgeIBqw0Eo7wtphhFFdYvWUbQqouT/jNMxRK8AXSBao1hbH9Rvjk2cfSFS
         fX6Q==
X-Gm-Message-State: AOAM5305PnVULpcIYTO8AUmJD/dFXzC5o0aDVP5JO7bHvme37vwy0sVM
        51vdruhwTOQGl6a7SAVhLbA=
X-Google-Smtp-Source: ABdhPJzWwfT8ZW3r2p8XjEbFxYtJKKQ97sKfUZkkyj50whp8Dg7QC7QXP2oz4BngEUgh9rYxfTiFIg==
X-Received: by 2002:a17:906:2b4f:: with SMTP id b15mr5140491ejg.64.1590095463687;
        Thu, 21 May 2020 14:11:03 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:11:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 10/13] net: bridge: add port flags for host flooding
Date:   Fri, 22 May 2020 00:10:33 +0300
Message-Id: <20200521211036.668624-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In cases where the bridge is offloaded by a switchdev, there are
situations where we can optimize RX filtering towards the host. To be
precise, the host only needs to do termination, which it can do by
responding at the MAC addresses of the slave ports and of the bridge
interface itself. But most notably, it doesn't need to do forwarding,
so there is no need to see packets with unknown destination address.

But there are, however, cases when a switchdev does need to flood to the
CPU. Such an example is when the switchdev is bridged with a foreign
interface, and since there is no offloaded datapath, packets need to
pass through the CPU. Currently this is the only identified case, but it
can be extended at any time.

So far, switchdev implementers made driver-level assumptions, such as:
this chip is never integrated in SoCs where it can be bridged with a
foreign interface, so I'll just disable host flooding and save some CPU
cycles. Or: I can never know what else can be bridged with this
switchdev port, so I must leave host flooding enabled in any case.

Let the bridge drive the host flooding decision, and pass it to
switchdev via the same mechanism as the external flooding flags.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |  3 +++
 net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
 net/bridge/br_switchdev.c |  4 +++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b3a8d3054af0..6891a432862d 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -49,6 +49,9 @@ struct br_ip_list {
 #define BR_ISOLATED		BIT(16)
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
+#define BR_HOST_FLOOD		BIT(19)
+#define BR_HOST_MCAST_FLOOD	BIT(20)
+#define BR_HOST_BCAST_FLOOD	BIT(21)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a0e9a7937412..aae59d1e619b 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
 	}
 }
 
+static int br_manage_host_flood(struct net_bridge *br)
+{
+	const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
+				   BR_HOST_BCAST_FLOOD;
+	struct net_bridge_port *p, *q;
+
+	list_for_each_entry(p, &br->port_list, list) {
+		unsigned long flags = p->flags;
+		bool sw_bridging = false;
+		int err;
+
+		list_for_each_entry(q, &br->port_list, list) {
+			if (p == q)
+				continue;
+
+			if (!netdev_port_same_parent_id(p->dev, q->dev)) {
+				sw_bridging = true;
+				break;
+			}
+		}
+
+		if (sw_bridging)
+			flags |= mask;
+		else
+			flags &= ~mask;
+
+		if (flags == p->flags)
+			continue;
+
+		err = br_switchdev_set_port_flag(p, flags, mask);
+		if (err)
+			return err;
+
+		p->flags = flags;
+	}
+
+	return 0;
+}
+
 int nbp_backup_change(struct net_bridge_port *p,
 		      struct net_device *backup_dev)
 {
@@ -231,6 +270,7 @@ static void nbp_update_port_count(struct net_bridge *br)
 		br->auto_cnt = cnt;
 		br_manage_promisc(br);
 	}
+	br_manage_host_flood(br);
 }
 
 static void nbp_delete_promisc(struct net_bridge_port *p)
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 015209bf44aa..360806ac7463 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -56,7 +56,9 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 /* Flags that can be offloaded to hardware */
 #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
+				  BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD | \
+				  BR_HOST_BCAST_FLOOD)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-- 
2.25.1


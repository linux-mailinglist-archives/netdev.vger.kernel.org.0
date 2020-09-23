Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B2D276263
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgIWUpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgIWUph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:45:37 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227CFC0613CE;
        Wed, 23 Sep 2020 13:45:37 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f1so329282plo.13;
        Wed, 23 Sep 2020 13:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/TNUKHzWCnsiW/eBfHTqlIT1VFLdr0mmgo2yHBZTEI=;
        b=kPHAQSydfql6Lw7fLdr/XUevIkEZC4o0CN5M5z5aLeaFNjl15GQ9YtQZM9vS4PiiTh
         99oWTqnDPssEwTkixCpV26LunidExipYzKCBtbNK3ZYEewDggiUkk6lWAryKZzGoWP+x
         tyvMzYrlXmZDII4XN6FQI0LRY+BtYL7oHus86wf0TKk6LDGmE4hIypr2yXeu8QENnREp
         Wcnva5KRSyGuo//cIqW7evxKam4uYEcHarSK4QUWu138md6gc9K/5Yb9RFdHVw+1HvZF
         G8xSUe/ErRP2/42wsCUY3w2pJbnrxKOkeVIhJ3DqXNq9CDvyvA1W2WoNtluawNdEggKf
         7wfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/TNUKHzWCnsiW/eBfHTqlIT1VFLdr0mmgo2yHBZTEI=;
        b=To5fvxZziMzqQH2ON6ocER+U0aReQTcdQDX/jsBdcgLHTWB8ZKS6kDEBF+mN3P0fkD
         IprpTYsU8ZBWQX7Ej7z3BTPLKEO4BDNthkwm90uf/sVKUngbJfKb7miXnpELkoI7K7Fq
         L91QmhCWN4JL6WEN+tv+m9PzXnHeZgSeZZgGVZIOsv2AHuAJvUEAF0MFRGXvtNmpLcm8
         GUlM/ab2/kbPl54DrBiiANbhlDj2SC+nN2DpfW9H0iCsJnthmBB8j9qrJZXGHwdBDHgz
         ZuTALHSsLeFfR1sMZTzITozSRnyps8JQMWCphbp0M0V8P6M5tqSZpLsCB1vtAqeHw8Hk
         eg6g==
X-Gm-Message-State: AOAM5330fXiSe+LxbG7ZrksWos0Le4jfqX8wwEH41r2lPpPUj8L4fa9s
        ORTCwg54hiNGnwAtuNxaSGkBItevqvxhvA==
X-Google-Smtp-Source: ABdhPJy4vMpFzOaC3HO2fGoWp0OOytUJ8TBZsuPTY8AOFeigsjY4LY+MLiUbnVglujYtkNy+JyGkrQ==
X-Received: by 2002:a17:90a:3d0e:: with SMTP id h14mr1055252pjc.34.1600893936094;
        Wed, 23 Sep 2020 13:45:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u6sm330776pjy.37.2020.09.23.13.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:45:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list), olteanv@gmail.com,
        nikolay@nvidia.com
Subject: [PATCH net-next v2 1/2] net: dsa: untag the bridge pvid from rx skbs
Date:   Wed, 23 Sep 2020 13:45:13 -0700
Message-Id: <20200923204514.3663635-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200923204514.3663635-1-f.fainelli@gmail.com>
References: <20200923204514.3663635-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently the bridge untags VLANs present in its VLAN groups in
__allowed_ingress() only when VLAN filtering is enabled.

But when a skb is seen on the RX path as tagged with the bridge's pvid,
and that bridge has vlan_filtering=0, and there isn't any 8021q upper
with that VLAN either, then we have a problem. The bridge will not untag
it (since it is supposed to remain VLAN-unaware), and pvid-tagged
communication will be broken.

There are 2 situations where we can end up like that:

1. When installing a pvid in egress-tagged mode, like this:

ip link add dev br0 type bridge vlan_filtering 0
ip link set swp0 master br0
bridge vlan del dev swp0 vid 1
bridge vlan add dev swp0 vid 1 pvid

This happens because DSA configures the VLAN membership of the CPU port
using the same flags as swp0 (in this case "pvid and not untagged"), in
an attempt to copy the frame as-is from ingress to the CPU.

However, in this case, the packet may arrive untagged on ingress, it
will be pvid-tagged by the ingress port, and will be sent as
egress-tagged towards the CPU. Otherwise stated, the CPU will see a VLAN
tag where there was none to speak of on ingress.

When vlan_filtering is 1, this is not a problem, as stated in the first
paragraph, because __allowed_ingress() will pop it. But currently, when
vlan_filtering is 0 and we have such a VLAN configuration, we need an
8021q upper (br0.1) to be able to ping over that VLAN, which is not
symmetrical with the vlan_filtering=1 case, and therefore, confusing for
users.

Basically what DSA attempts to do is simply an approximation: try to
copy the skb with (or without) the same VLAN all the way up to the CPU.
But DSA drivers treat CPU port VLAN membership in various ways (which is
a good segue into situation 2). And some of those drivers simply tell
the CPU port to copy the frame unmodified, which is the golden standard
when it comes to VLAN processing (therefore, any driver which can
configure the hardware to do that, should do that, and discard the VLAN
flags requested by DSA on the CPU port).

2. Some DSA drivers always configure the CPU port as egress-tagged, in
an attempt to recover the classified VLAN from the skb. These drivers
cannot work at all with untagged traffic when bridged in
vlan_filtering=0 mode. And they can't go for the easy "just keep the
pvid as egress-untagged towards the CPU" route, because each front port
can have its own pvid, and that might require conflicting VLAN
membership settings on the CPU port (swp1 is pvid for VID 1 and
egress-tagged for VID 2; swp2 is egress-taggeed for VID 1 and pvid for
VID 2; with this simplistic approach, the CPU port, which is really a
separate hardware entity and has its own VLAN membership settings, would
end up being egress-untagged in both VID 1 and VID 2, therefore losing
the VLAN tags of ingress traffic).

So the only thing we can do is to create a helper function for resolving
the problematic case (that is, a function which untags the bridge pvid
when that is in vlan_filtering=0 mode), which taggers in need should
call. It isn't called from the generic DSA receive path because there
are drivers that fall neither in the first nor second category.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa_priv.h | 66 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2da656d984ef..0348dbab4131 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -7,6 +7,7 @@
 #ifndef __DSA_PRIV_H
 #define __DSA_PRIV_H
 
+#include <linux/if_bridge.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
@@ -194,6 +195,71 @@ dsa_slave_to_master(const struct net_device *dev)
 	return dp->cpu_dp->master;
 }
 
+/* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
+ * frames as untagged, since the bridge will not untag them.
+ */
+static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+	struct net_device *br = dp->bridge_dev;
+	struct net_device *dev = skb->dev;
+	struct net_device *upper_dev;
+	struct list_head *iter;
+	u16 vid, pvid, proto;
+	int err;
+
+	if (!br || br_vlan_enabled(br))
+		return skb;
+
+	err = br_vlan_get_proto(br, &proto);
+	if (err)
+		return skb;
+
+	/* Move VLAN tag from data to hwaccel */
+	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto == htons(proto)) {
+		skb = skb_vlan_untag(skb);
+		if (!skb)
+			return NULL;
+	}
+
+	if (!skb_vlan_tag_present(skb))
+		return skb;
+
+	vid = skb_vlan_tag_get_id(skb);
+
+	/* We already run under an RCU read-side critical section since
+	 * we are called from netif_receive_skb_list_internal().
+	 */
+	err = br_vlan_get_pvid_rcu(dev, &pvid);
+	if (err)
+		return skb;
+
+	if (vid != pvid)
+		return skb;
+
+	/* The sad part about attempting to untag from DSA is that we
+	 * don't know, unless we check, if the skb will end up in
+	 * the bridge's data path - br_allowed_ingress() - or not.
+	 * For example, there might be an 8021q upper for the
+	 * default_pvid of the bridge, which will steal VLAN-tagged traffic
+	 * from the bridge's data path. This is a configuration that DSA
+	 * supports because vlan_filtering is 0. In that case, we should
+	 * definitely keep the tag, to make sure it keeps working.
+	 */
+	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		if (vid == vlan_dev_vlan_id(upper_dev))
+			return skb;
+	}
+
+	__vlan_hwaccel_clear_tag(skb);
+
+	return skb;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
-- 
2.25.1


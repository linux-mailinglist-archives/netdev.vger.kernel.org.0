Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF39276266
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgIWUpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgIWUpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:45:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA87BC0613D1;
        Wed, 23 Sep 2020 13:45:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u4so363928plr.4;
        Wed, 23 Sep 2020 13:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eXYv5X8tjs0NHlmzc9aivkeUDJvNkRf/+n+TLaTZCbU=;
        b=UQujlSywlGHQs7UvJ9utW/QwnTvMmtRJZIIF5N38H2nS+k83bInmuMY2yEhCHvmMzx
         xGqIZnQvEq6gQGlBvoadOK5YWnSgFf+rogzN+xa5sEEybpGPEMCj5scO1ospoq6Ae6ii
         D/Wu/QgU1FGgMbOtFjGmFr/knTV0SSGUCQpDUpHvRDrfvZrZtK+c1zNqPsJcd86t6ac1
         oEV/Dpfc+5KbnWhQdxhZsj/FjNIXZYfhFF5juQZnj89iFMo27Bx9UX52KcL4gK9Zt2AE
         c/fGdgHA+s3j/RyCDeTCZsvWgEo/erOtNlU5Dvj7YDn6GG3Zd6SQ/4DoaB3Zh9wsZlzu
         TnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eXYv5X8tjs0NHlmzc9aivkeUDJvNkRf/+n+TLaTZCbU=;
        b=bdF6U59himerP9jSun9eExtmNloaEAWlJO3F5aVkYBiqUmAi4Rb5fXk2OzLrkr41SW
         uBPv/fhSuVtciIyMv/GbSQ6XnujR2oweJhiN/yBRPNtbvg0eh7iO1SwETDzjSdtSxnTv
         PW4gTWQHuPiX9lq9tVeKU1f6jq6NvjcGubOsY/aqaV7MmvyTZiRMyiDQCPvrhlTv5Jg+
         6TPA79Qd7yOReOQ979mpwfgu4lsTXerYLAQAHvu4rjL+qQoVlLr9qNghMw4pC2hm2ts3
         SL8ZGvZEdsYk0a/l9VdAQa98qyASKu68LZXvrosUbLV4PYqQFi1cLL9XKxJIM8wUoKPA
         L6Lw==
X-Gm-Message-State: AOAM530ZOzrhocxhnuPaJpaaOUi51qzKUVbmke4lgSdlM/hREepjIFoy
        KXhZr14PeIBjcOgz46h4CC5rFdU3XDRIfw==
X-Google-Smtp-Source: ABdhPJycviktBl1RnSLgo0FFz9w43sHvciYRgW6i0PCmhUzU+pByVgVIxlOcDWdi+HC2dDlslBY8Gg==
X-Received: by 2002:a17:902:7281:b029:d2:2a0b:f050 with SMTP id d1-20020a1709027281b02900d22a0bf050mr1511614pll.42.1600893937956;
        Wed, 23 Sep 2020 13:45:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u6sm330776pjy.37.2020.09.23.13.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:45:37 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com, nikolay@nvidia.com
Subject: [PATCH net-next v2 2/2] net: dsa: b53: Configure VLANs while not filtering
Date:   Wed, 23 Sep 2020 13:45:14 -0700
Message-Id: <20200923204514.3663635-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200923204514.3663635-1-f.fainelli@gmail.com>
References: <20200923204514.3663635-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the B53 driver to support VLANs while not filtering. This
requires us to enable VLAN globally within the switch upon driver
initial configuration (dev->vlan_enabled).

We also need to remove the code that dealt with PVID re-configuration in
b53_vlan_filtering() since that function worked under the assumption
that it would only be called to make a bridge VLAN filtering, or not
filtering, and we would attempt to move the port's PVID accordingly.

Now that VLANs are programmed all the time, even in the case of a
non-VLAN filtering bridge, we would be programming a default_pvid for
the bridged switch ports.

We need the DSA receive path to pop the VLAN tag if it is the bridge's
default_pvid because the CPU port is always programmed tagged in the
programmed VLANs. In order to do so we utilize the
dsa_untag_bridge_pvid() helper introduced in the commit before by
setting ds->untag_bridge_pvid to true.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 19 ++-----------------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 net/dsa/tag_brcm.c               | 16 ++++++++++++++--
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6a5796c32721..73507cff3bc4 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1377,23 +1377,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
 	struct b53_device *dev = ds->priv;
-	u16 pvid, new_pvid;
-
-	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
-	if (!vlan_filtering) {
-		/* Filtering is currently enabled, use the default PVID since
-		 * the bridge does not expect tagging anymore
-		 */
-		dev->ports[port].pvid = pvid;
-		new_pvid = b53_default_pvid(dev);
-	} else {
-		/* Filtering is currently disabled, restore the previous PVID */
-		new_pvid = dev->ports[port].pvid;
-	}
-
-	if (pvid != new_pvid)
-		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
-			    new_pvid);
 
 	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
 
@@ -2619,6 +2602,8 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->priv = priv;
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
+	ds->configure_vlan_while_not_filtering = true;
+	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index c55c0a9f1b47..24893b592216 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -91,7 +91,6 @@ enum {
 struct b53_port {
 	u16		vlan_ctl_mask;
 	struct ethtool_eee eee;
-	u16		pvid;
 };
 
 struct b53_vlan {
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index cc8512b5f9e2..703770161738 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -7,6 +7,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/if_vlan.h>
 #include <linux/slab.h>
 
 #include "dsa_priv.h"
@@ -140,6 +141,11 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
+	/* Set the MAC header to where it should point for
+	 * dsa_untag_bridge_pvid() to parse the correct VLAN header.
+	 */
+	skb_set_mac_header(skb, -ETH_HLEN);
+
 	skb->offload_fwd_mark = 1;
 
 	return skb;
@@ -191,7 +197,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 		nskb->data - ETH_HLEN - BRCM_TAG_LEN,
 		2 * ETH_ALEN);
 
-	return nskb;
+	return dsa_untag_bridge_pvid(nskb);
 }
 
 static const struct dsa_device_ops brcm_netdev_ops = {
@@ -219,8 +225,14 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
 					    struct net_device *dev,
 					    struct packet_type *pt)
 {
+	struct sk_buff *nskb;
+
 	/* tag is prepended to the packet */
-	return brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
+	nskb = brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
+	if (!nskb)
+		return nskb;
+
+	return dsa_untag_bridge_pvid(nskb);
 }
 
 static const struct dsa_device_ops brcm_prepend_netdev_ops = {
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A3B3881DD
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352408AbhERVKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352390AbhERVKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 17:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621372158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVC1r939/JQx8mQNZjOgRyXe8/h7CYJeJrfHIrtd7Tc=;
        b=OJ1TBPkwetG1vcqtzbBKDlkugqLz/sA2+Nyr+kL8wlYYvEWDUlv5Seozl1Ca+zma6Yv1vZ
        Y6OXpSXuUVe/b3v/IOR0Lv2VpbyfHnBe8j36VXu8pPKAXuCqgUuWJ0pverU0xK7d2ug0GG
        BD30QJ7t8mzBJ091OtZZ6WQ9OcyMZBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-KRf3jJCXOUSRHXWaMrbaDQ-1; Tue, 18 May 2021 17:09:14 -0400
X-MC-Unique: KRf3jJCXOUSRHXWaMrbaDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49B9464162;
        Tue, 18 May 2021 21:09:12 +0000 (UTC)
Received: from f33vm.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5FFF5C1CF;
        Tue, 18 May 2021 21:09:10 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH 1/4] bonding: add pure source-mac-based tx hashing option
Date:   Tue, 18 May 2021 17:08:46 -0400
Message-Id: <20210518210849.1673577-2-jarod@redhat.com>
In-Reply-To: <20210518210849.1673577-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it turns out, a pure source-mac only tx hash has a place for some VM
setups. The previously added vlan+srcmac hash doesn't work as well for a
VM with a single MAC and multiple vlans -- these types of setups path
traffic more efficiently if the load is split by source mac alone.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 Documentation/networking/bonding.rst | 13 +++++++++++++
 drivers/net/bonding/bond_main.c      | 26 +++++++++++++++++---------
 drivers/net/bonding/bond_options.c   |  1 +
 include/linux/netdevice.h            |  1 +
 include/uapi/linux/if_bonding.h      |  1 +
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 62f2aab8eaec..66c3fa3a9040 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -964,6 +964,19 @@ xmit_hash_policy
 
 		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
 
+	srcmac
+
+		This policy uses a very rudimentary source mac hash to
+		load-balance traffic per-source-mac, with failover should
+		one leg fail. The intended use case is for a bond shared
+		by multiple virtual machines, each with their own virtual
+		mac address, keeping the VMs traffic all limited to the
+		same outbound interface.
+
+		The formula for the hash is simply
+
+		hash = (source MAC vendor) XOR (source MAC dev)
+
 	The default value is layer2.  This option was added in bonding
 	version 2.6.3.  In earlier versions of bonding, this parameter
 	does not exist, and the layer2 policy is the only policy.  The
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 20bbda1b36e1..d71e398642fb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -167,7 +167,8 @@ module_param(xmit_hash_policy, charp, 0);
 MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3ad hashing method; "
 				   "0 for layer 2 (default), 1 for layer 3+4, "
 				   "2 for layer 2+3, 3 for encap layer 2+3, "
-				   "4 for encap layer 3+4, 5 for vlan+srcmac");
+				   "4 for encap layer 3+4, 5 for vlan+srcmac, "
+				   "6 for srcmac");
 module_param(arp_interval, int, 0);
 MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
 module_param_array(arp_ip_target, charp, NULL, 0);
@@ -1459,6 +1460,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
 		return NETDEV_LAG_HASH_E34;
 	case BOND_XMIT_POLICY_VLAN_SRCMAC:
 		return NETDEV_LAG_HASH_VLAN_SRCMAC;
+	case BOND_XMIT_POLICY_SRCMAC:
+		return NETDEV_LAG_HASH_SRCMAC;
 	default:
 		return NETDEV_LAG_HASH_UNKNOWN;
 	}
@@ -3521,11 +3524,11 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
 	return true;
 }
 
-static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
+static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, bool with_vlan)
 {
-	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+	struct ethhdr *mac_hdr = eth_hdr(skb);
 	u32 srcmac_vendor = 0, srcmac_dev = 0;
-	u16 vlan;
+	u32 hash;
 	int i;
 
 	for (i = 0; i < 3; i++)
@@ -3534,12 +3537,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
 	for (i = 3; i < ETH_ALEN; i++)
 		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
 
-	if (!skb_vlan_tag_present(skb))
-		return srcmac_vendor ^ srcmac_dev;
+	hash = srcmac_vendor ^ srcmac_dev;
+
+	if (!with_vlan || !skb_vlan_tag_present(skb))
+		return hash;
 
-	vlan = skb_vlan_tag_get(skb);
+	hash ^= skb_vlan_tag_get(skb);
 
-	return vlan ^ srcmac_vendor ^ srcmac_dev;
+	return hash;
 }
 
 /* Extract the appropriate headers based on bond's xmit policy */
@@ -3618,8 +3623,11 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 	    skb->l4_hash)
 		return skb->hash;
 
+	if (bond->params.xmit_policy == BOND_XMIT_POLICY_SRCMAC)
+		return bond_vlan_srcmac_hash(skb, false);
+
 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
-		return bond_vlan_srcmac_hash(skb);
+		return bond_vlan_srcmac_hash(skb, true);
 
 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
 	    !bond_flow_dissect(bond, skb, &flow))
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index c9d3604ae129..ff68ad2589f0 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -102,6 +102,7 @@ static const struct bond_opt_value bond_xmit_hashtype_tbl[] = {
 	{ "encap2+3",    BOND_XMIT_POLICY_ENCAP23,     0},
 	{ "encap3+4",    BOND_XMIT_POLICY_ENCAP34,     0},
 	{ "vlan+srcmac", BOND_XMIT_POLICY_VLAN_SRCMAC, 0},
+	{ "srcmac",      BOND_XMIT_POLICY_SRCMAC,      0},
 	{ NULL,          -1,                           0},
 };
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..d88319fca1d3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2732,6 +2732,7 @@ enum netdev_lag_hash {
 	NETDEV_LAG_HASH_E23,
 	NETDEV_LAG_HASH_E34,
 	NETDEV_LAG_HASH_VLAN_SRCMAC,
+	NETDEV_LAG_HASH_SRCMAC,
 	NETDEV_LAG_HASH_UNKNOWN,
 };
 
diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index d174914a837d..f3b4d412a73f 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -95,6 +95,7 @@
 #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
 #define BOND_XMIT_POLICY_VLAN_SRCMAC	5 /* vlan + source MAC */
+#define BOND_XMIT_POLICY_SRCMAC		6 /* source MAC only */
 
 /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
 #define LACP_STATE_LACP_ACTIVITY   0x1
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5F62F54F7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 23:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbhAMWi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 17:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729392AbhAMWhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 17:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610577366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycBEbjbLq+tLyeVu0NWOFp9ta3mReqQWCGmpcvx63eY=;
        b=dwcwCfT2GswaVEhVNspQrIaRqklaXVzcBRHGnOaE17MtADG5qVvARx5o5seaCpR+7QbsiG
        6ZKH55wzStjsiFMf22jezdJrSqyNiiqqPz0e191j9UuPfBpTkLfTCFMLtw7ZFC84MqTZ3h
        A4qFpjdUhEcL5l7WLWrlI66qldg76qs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-Mp-x-NVuNYa1ow3d2d1scA-1; Wed, 13 Jan 2021 17:36:02 -0500
X-MC-Unique: Mp-x-NVuNYa1ow3d2d1scA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26DEC8144E1;
        Wed, 13 Jan 2021 22:36:01 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A0D36A252;
        Wed, 13 Jan 2021 22:35:55 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
Date:   Wed, 13 Jan 2021 17:35:48 -0500
Message-Id: <20210113223548.1171655-1-jarod@redhat.com>
In-Reply-To: <20201218193033.6138-1-jarod@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This comes from an end-user request, where they're running multiple VMs on
hosts with bonded interfaces connected to some interest switch topologies,
where 802.3ad isn't an option. They're currently running a proprietary
solution that effectively achieves load-balancing of VMs and bandwidth
utilization improvements with a similar form of transmission algorithm.

Basically, each VM has it's own vlan, so it always sends its traffic out
the same interface, unless that interface fails. Traffic gets split
between the interfaces, maintaining a consistent path, with failover still
available if an interface goes down.

This has been rudimetarily tested to provide similar results, suitable for
them to use to move off their current proprietary solution. A patch for
iproute2 is forthcoming as well, to properly support the new mode there as
well.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
v2: verified netlink interfaces working, added Documentation, changed
tx hash mode name to vlan+mac for consistency and clarity.

 Documentation/networking/bonding.rst | 13 +++++++++++++
 drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++--
 drivers/net/bonding/bond_options.c   |  1 +
 include/linux/netdevice.h            |  1 +
 include/uapi/linux/if_bonding.h      |  1 +
 5 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index adc314639085..c78ceb7630a0 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -951,6 +951,19 @@ xmit_hash_policy
 		packets will be distributed according to the encapsulated
 		flows.
 
+	vlan+mac
+
+		This policy uses a very rudimentary vland ID and source mac
+		ID hash to load-balance traffic per-vlan, with failover
+		should one leg fail. The intended use case is for a bond
+		shared by multiple virtual machines, all configured to
+		use their own vlan, to give lacp-like functionality
+		without requiring lacp-capable switching hardware.
+
+		The formula for the hash is simply
+
+		hash = (vlan ID) XOR (source MAC)
+
 	The default value is layer2.  This option was added in bonding
 	version 2.6.3.  In earlier versions of bonding, this parameter
 	does not exist, and the layer2 policy is the only policy.  The
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5fe5232cc3f3..766c09a553c1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -164,7 +164,7 @@ module_param(xmit_hash_policy, charp, 0);
 MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3ad hashing method; "
 				   "0 for layer 2 (default), 1 for layer 3+4, "
 				   "2 for layer 2+3, 3 for encap layer 2+3, "
-				   "4 for encap layer 3+4");
+				   "4 for encap layer 3+4, 5 for vlan+mac");
 module_param(arp_interval, int, 0);
 MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
 module_param_array(arp_ip_target, charp, NULL, 0);
@@ -1434,6 +1434,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
 		return NETDEV_LAG_HASH_E23;
 	case BOND_XMIT_POLICY_ENCAP34:
 		return NETDEV_LAG_HASH_E34;
+	case BOND_XMIT_POLICY_VLAN_SRCMAC:
+		return NETDEV_LAG_HASH_VLAN_SRCMAC;
 	default:
 		return NETDEV_LAG_HASH_UNKNOWN;
 	}
@@ -3494,6 +3496,20 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
 	return true;
 }
 
+static inline u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
+{
+	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+	u32 srcmac = mac_hdr->h_source[5];
+	u16 vlan;
+
+	if (!skb_vlan_tag_present(skb))
+		return srcmac;
+
+	vlan = skb_vlan_tag_get(skb);
+
+	return srcmac ^ vlan;
+}
+
 /* Extract the appropriate headers based on bond's xmit policy */
 static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 			      struct flow_keys *fk)
@@ -3501,10 +3517,14 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 	bool l34 = bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER34;
 	int noff, proto = -1;
 
-	if (bond->params.xmit_policy > BOND_XMIT_POLICY_LAYER23) {
+	switch (bond->params.xmit_policy) {
+	case BOND_XMIT_POLICY_ENCAP23:
+	case BOND_XMIT_POLICY_ENCAP34:
 		memset(fk, 0, sizeof(*fk));
 		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
 					  fk, NULL, 0, 0, 0, 0);
+	default:
+		break;
 	}
 
 	fk->ports.ports = 0;
@@ -3556,6 +3576,9 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 	    skb->l4_hash)
 		return skb->hash;
 
+	if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
+		return bond_vlan_srcmac_hash(skb);
+
 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
 	    !bond_flow_dissect(bond, skb, &flow))
 		return bond_eth_hash(skb);
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a4e4e15f574d..deafe3587c80 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -101,6 +101,7 @@ static const struct bond_opt_value bond_xmit_hashtype_tbl[] = {
 	{ "layer2+3", BOND_XMIT_POLICY_LAYER23, 0},
 	{ "encap2+3", BOND_XMIT_POLICY_ENCAP23, 0},
 	{ "encap3+4", BOND_XMIT_POLICY_ENCAP34, 0},
+	{ "vlan+mac", BOND_XMIT_POLICY_VLAN_SRCMAC,  0},
 	{ NULL,       -1,                       0},
 };
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b949076ed23..a94ce80a2fe1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2615,6 +2615,7 @@ enum netdev_lag_hash {
 	NETDEV_LAG_HASH_L23,
 	NETDEV_LAG_HASH_E23,
 	NETDEV_LAG_HASH_E34,
+	NETDEV_LAG_HASH_VLAN_SRCMAC,
 	NETDEV_LAG_HASH_UNKNOWN,
 };
 
diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index 45f3750aa861..e8eb4ad03cf1 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -94,6 +94,7 @@
 #define BOND_XMIT_POLICY_LAYER23	2 /* layer 2+3 (IP ^ MAC) */
 #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
+#define BOND_XMIT_POLICY_VLAN_SRCMAC	5 /* vlan + source MAC */
 
 /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
 #define LACP_STATE_LACP_ACTIVITY   0x1
-- 
2.29.2


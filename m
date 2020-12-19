Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4132DEC53
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgLSATu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 19:19:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47341 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgLSATt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:19:49 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kqPxd-0001IW-KG; Sat, 19 Dec 2020 00:19:01 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id AF11361DDA; Fri, 18 Dec 2020 16:18:59 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A7ADFA0409;
        Fri, 18 Dec 2020 16:18:59 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
In-reply-to: <20201218193033.6138-1-jarod@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Fri, 18 Dec 2020 14:30:33 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21783.1608337139.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 18 Dec 2020 16:18:59 -0800
Message-ID: <21784.1608337139@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>This comes from an end-user request, where they're running multiple VMs on
>hosts with bonded interfaces connected to some interest switch topologies,
>where 802.3ad isn't an option. They're currently running a proprietary
>solution that effectively achieves load-balancing of VMs and bandwidth
>utilization improvements with a similar form of transmission algorithm.
>
>Basically, each VM has it's own vlan, so it always sends its traffic out
>the same interface, unless that interface fails. Traffic gets split
>between the interfaces, maintaining a consistent path, with failover still
>available if an interface goes down.
>
>This has been rudimetarily tested to provide similar results, suitable for
>them to use to move off their current proprietary solution.
>
>Still on the TODO list, if these even looks sane to begin with, is
>fleshing out Documentation/networking/bonding.rst.

	I'm sure you're aware, but any final submission will also need
to include netlink and iproute2 support.

>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_main.c    | 27 +++++++++++++++++++++++++--
> drivers/net/bonding/bond_options.c |  1 +
> include/linux/netdevice.h          |  1 +
> include/uapi/linux/if_bonding.h    |  1 +
> 4 files changed, 28 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 5fe5232cc3f3..151ce8c7a56f 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -164,7 +164,7 @@ module_param(xmit_hash_policy, charp, 0);
> MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3ad hashing method; "
> 				   "0 for layer 2 (default), 1 for layer 3+4, "
> 				   "2 for layer 2+3, 3 for encap layer 2+3, "
>-				   "4 for encap layer 3+4");
>+				   "4 for encap layer 3+4, 5 for vlan+srcmac");
> module_param(arp_interval, int, 0);
> MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
> module_param_array(arp_ip_target, charp, NULL, 0);
>@@ -1434,6 +1434,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
> 		return NETDEV_LAG_HASH_E23;
> 	case BOND_XMIT_POLICY_ENCAP34:
> 		return NETDEV_LAG_HASH_E34;
>+	case BOND_XMIT_POLICY_VLAN_SRCMAC:
>+		return NETDEV_LAG_HASH_VLAN_SRCMAC;
> 	default:
> 		return NETDEV_LAG_HASH_UNKNOWN;
> 	}
>@@ -3494,6 +3496,20 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
> 	return true;
> }
> 
>+static inline u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>+{
>+	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>+	u32 srcmac = mac_hdr->h_source[5];
>+	u16 vlan;
>+
>+	if (!skb_vlan_tag_present(skb))
>+		return srcmac;
>+
>+	vlan = skb_vlan_tag_get(skb);
>+
>+	return srcmac ^ vlan;

	For the common configuration wherein multiple VLANs are
configured atop a single interface (and thus by default end up with the
same MAC address), this seems like a fairly weak hash.  The TCI is 16
bits (12 of which are the VID), but only 8 are used from the MAC, which
will be a constant.

	Is this algorithm copying the proprietary solution you mention?

	-J

>+}
>+
> /* Extract the appropriate headers based on bond's xmit policy */
> static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
> 			      struct flow_keys *fk)
>@@ -3501,10 +3517,14 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
> 	bool l34 = bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER34;
> 	int noff, proto = -1;
> 
>-	if (bond->params.xmit_policy > BOND_XMIT_POLICY_LAYER23) {
>+	switch (bond->params.xmit_policy) {
>+	case BOND_XMIT_POLICY_ENCAP23:
>+	case BOND_XMIT_POLICY_ENCAP34:
> 		memset(fk, 0, sizeof(*fk));
> 		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
> 					  fk, NULL, 0, 0, 0, 0);
>+	default:
>+		break;
> 	}
> 
> 	fk->ports.ports = 0;
>@@ -3556,6 +3576,9 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> 	    skb->l4_hash)
> 		return skb->hash;
> 
>+	if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
>+		return bond_vlan_srcmac_hash(skb);
>+
> 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
> 	    !bond_flow_dissect(bond, skb, &flow))
> 		return bond_eth_hash(skb);
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>index a4e4e15f574d..9826fe46fca1 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -101,6 +101,7 @@ static const struct bond_opt_value bond_xmit_hashtype_tbl[] = {
> 	{ "layer2+3", BOND_XMIT_POLICY_LAYER23, 0},
> 	{ "encap2+3", BOND_XMIT_POLICY_ENCAP23, 0},
> 	{ "encap3+4", BOND_XMIT_POLICY_ENCAP34, 0},
>+	{ "vlansrc",  BOND_XMIT_POLICY_VLAN_SRCMAC,  0},
> 	{ NULL,       -1,                       0},
> };
> 
>diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>index 7bf167993c05..551eac4ab747 100644
>--- a/include/linux/netdevice.h
>+++ b/include/linux/netdevice.h
>@@ -2633,6 +2633,7 @@ enum netdev_lag_hash {
> 	NETDEV_LAG_HASH_L23,
> 	NETDEV_LAG_HASH_E23,
> 	NETDEV_LAG_HASH_E34,
>+	NETDEV_LAG_HASH_VLAN_SRCMAC,
> 	NETDEV_LAG_HASH_UNKNOWN,
> };
> 
>diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
>index 45f3750aa861..e8eb4ad03cf1 100644
>--- a/include/uapi/linux/if_bonding.h
>+++ b/include/uapi/linux/if_bonding.h
>@@ -94,6 +94,7 @@
> #define BOND_XMIT_POLICY_LAYER23	2 /* layer 2+3 (IP ^ MAC) */
> #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
> #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
>+#define BOND_XMIT_POLICY_VLAN_SRCMAC	5 /* vlan + source MAC */
> 
> /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
> #define LACP_STATE_LACP_ACTIVITY   0x1
>-- 
>2.29.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B258124C982
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 03:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgHUBYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 21:24:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:57956 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgHUBYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 21:24:36 -0400
IronPort-SDR: gb/6YGYUiWA6G7D3ngJrafz5+ZdvmbpGa7cRowmivBqviW+P/TeW4J2QBXI688Q39zN+VAU/HT
 47pEzkuxgrXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="155422831"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="155422831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 18:24:32 -0700
IronPort-SDR: kH1GUFJI3GGFerxg7W5raFfN1gxnJoOWenFsroPpInHa/iknl87LvP3tgLeSGwlHC8R5fA+y/x
 SaRKcVDrPUhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="297781624"
Received: from cmw-fedora32-wp.jf.intel.com ([10.166.17.61])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2020 18:24:32 -0700
Subject: [RFC PATCH net-next 1/2] net:  Implement granular VF trust flags
From:   Carolyn Wyborny <carolyn.wyborny@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        tom.herbert@intel.com
Date:   Thu, 20 Aug 2020 21:17:39 -0400
Message-ID: <159797262419.773633.7781697568927646953.stgit@cmw-fedora32-wp.jf.intel.com>
In-Reply-To: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
References: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic VF privilege defines as trust flags, ifla_vf_trust_flags
struct and validation by the kernel of flags configured by drivers.
These are all for use with granular VF Trust flags feature.  See known
limitations and gaps in the cover message.

Signed-off-by: Carolyn Wyborny  <carolyn.wyborny@intel.com>
---
 include/linux/if_link.h            |    2 +
 include/linux/netdevice.h          |    4 +--
 include/uapi/linux/if_link.h       |   53 +++++++++++++++++++++++++++++++++++-
 net/core/rtnetlink.c               |   41 ++++++++++++++++++++++++++--
 tools/include/uapi/linux/if_link.h |   53 +++++++++++++++++++++++++++++++++++-
 5 files changed, 145 insertions(+), 8 deletions(-)

diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index 622658dfbf0a..7f0ec02b5c11 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -27,7 +27,7 @@ struct ifla_vf_info {
 	__u32 min_tx_rate;
 	__u32 max_tx_rate;
 	__u32 rss_query_en;
-	__u32 trusted;
+	vf_trust_flags_t trust_flags;
 	__be16 vlan_proto;
 };
 #endif /* _LINUX_IF_LINK_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..7081d47af18b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1080,7 +1080,7 @@ struct netdev_net_notifier {
  * int (*ndo_set_vf_rate)(struct net_device *dev, int vf, int min_tx_rate,
  *			  int max_tx_rate);
  * int (*ndo_set_vf_spoofchk)(struct net_device *dev, int vf, bool setting);
- * int (*ndo_set_vf_trust)(struct net_device *dev, int vf, bool setting);
+ * int (*ndo_set_vf_trust)(struct net_device *dev, int vf, vf_trust_flags_t flags);
  * int (*ndo_get_vf_config)(struct net_device *dev,
  *			    int vf, struct ifla_vf_info *ivf);
  * int (*ndo_set_vf_link_state)(struct net_device *dev, int vf, int link_state);
@@ -1345,7 +1345,7 @@ struct net_device_ops {
 	int			(*ndo_set_vf_spoofchk)(struct net_device *dev,
 						       int vf, bool setting);
 	int			(*ndo_set_vf_trust)(struct net_device *dev,
-						    int vf, bool setting);
+						    int vf, vf_trust_flags_t flags);
 	int			(*ndo_get_vf_config)(struct net_device *dev,
 						     int vf,
 						     struct ifla_vf_info *ivf);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 7fba4de511de..bfc69a1703dc 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -727,11 +727,12 @@ enum {
 				 * on/off switch
 				 */
 	IFLA_VF_STATS,		/* network device statistics */
-	IFLA_VF_TRUST,		/* Trust VF */
+	IFLA_VF_TRUST,		/* Trust VF all/nothing */
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
 	IFLA_VF_BROADCAST,	/* VF broadcast */
+	IFLA_VF_TRUST_FLAGS,	/* VF Trust flags */
 	__IFLA_VF_MAX,
 };
 
@@ -826,6 +827,56 @@ struct ifla_vf_trust {
 	__u32 setting;
 };
 
+/* Granular Trust via trust flags - similar to netdev feature flags */
+typedef u32 vf_trust_flags_t;
+
+enum {
+	VF_TRUST_F_LEGACY_BIT,		/* Original all or nothing */
+	VF_TRUST_F_ADV_FLOW_BIT,	/* Advanced traffic flow features */
+	VF_TRUST_F_MIRROR_BIT,		/* Mirroring */
+	VF_TRUST_F_UC_PROM_BIT,		/* Unicast promiscuous mode */
+	VF_TRUST_F_VLAN_PROM_BIT,	/* Vlan promiscuous mode */
+	VF_TRUST_F_MC_PROM_BIT,		/* Multicast promiscuous mode */
+	VF_TRUST_F_MACADDR_CHANGE_BIT,	/* MAC Address change */
+	VF_TRUST_F_MTU_CHANGE_BIT,	/* MTU Change */
+	VF_TRUST_F_MAC_SPFCHK_DIS_BIT,	/* MAC Spoofcheck Disable */
+	VF_TRUST_F_VLAN_SPFCHK_DIS_BIT,	/* VLAN Spoofcheck Disable */
+
+	/* Add new generic VF Trust features here */
+
+	VF_TRUST_F_COUNT
+};
+
+/* trust flag helpers - TODO: need to complete this, example only */
+#define VF_TRUST_BIT(bit)	((vf_trust_flags_t)1 << (bit))
+#define VF_TRUST(name)	VF_TRUST_BIT(VF_TRUST_F_##name##_BIT)
+
+#define VF_TRUST_F_LEGACY		VF_TRUST(LEGACY)
+#define VF_TRUST_F_ADV_FLOW		VF_TRUST(ADV_FLOW)
+#define VF_TRUST_F_MIRROR		VF_TRUST(MIRROR)
+#define VF_TRUST_F_UC_PROM		VF_TRUST(UC_PROM)
+#define VF_TRUST_F_VLAN_PROM		VF_TRUST(VLAN_PROM)
+#define VF_TRUST_F_MC_PROM		VF_TRUST(MC_PROM)
+#define VF_TRUST_F_MACADDR_CHANGE 	VF_TRUST(MACADDR_CHANGE)
+#define VF_TRUST_F_MTU_CHANGE 		VF_TRUST(MTU_CHANGE)
+#define VF_TRUST_F_MAC_SPFCHK_DIS 	VF_TRUST(MAC_SPFCHK_DIS
+#define VF_TRUST_F_VLAN_SPFCHK_DIS 	VF_TRUST(VLAN_SPFCHK_DIS
+
+#define VF_TRUST_F_ALL		(VF_TRUST_F_ADV_FLOW | \
+				 VF_TRUST_F_MIRROR | \
+				 VF_TRUST_F_UC_PROM | \
+				 VF_TRUST_F_VLAN_PROM | \
+				 VF_TRUST_F_MC_PROM | \
+				 VF_TRUST_F_MACADDR_CHANGE | \
+				 VF_TRUST_F_MTU_CHANGE | \
+				 VF_TRUST_F_MAC_SPFCHK_DIS | \
+				 VF_TRUST_F_VLAN_SPFCHK_DIS)
+
+struct ifla_vf_trust_flags {
+	__u32 vf;
+	nla_bitfield32 flags;
+};
+
 /* VF ports management section
  *
  *	Nested layout of set/get msg is:
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 68e0682450c6..bda25fec16a1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -946,7 +946,8 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 			 nla_total_size_64bit(sizeof(__u64)) +
 			 /* IFLA_VF_STATS_TX_DROPPED */
 			 nla_total_size_64bit(sizeof(__u64)) +
-			 nla_total_size(sizeof(struct ifla_vf_trust)));
+			 nla_total_size(sizeof(struct ifla_vf_trust)) +
+			 nla_total_size(sizeof(strucct ifla_vf_trust_flags)));
 		return size;
 	} else
 		return 0;
@@ -1226,6 +1227,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	struct ifla_vf_rss_query_en vf_rss_query_en;
 	struct nlattr *vf, *vfstats, *vfvlanlist;
 	struct ifla_vf_link_state vf_linkstate;
+	struct ifla_vf_trust_flags vf_trust_flags;
 	struct ifla_vf_vlan_info vf_vlan_info;
 	struct ifla_vf_spoofchk vf_spoofchk;
 	struct ifla_vf_tx_rate vf_tx_rate;
@@ -1249,6 +1251,10 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	ivi.spoofchk = -1;
 	ivi.rss_query_en = -1;
 	ivi.trusted = -1;
+
+	/* Setting trust flags to default untrusted */
+	ivi.trust_flags = 0;
+
 	/* The default value for VF link state is "auto"
 	 * IFLA_VF_LINK_STATE_AUTO which equals zero
 	 */
@@ -1271,6 +1277,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		vf_linkstate.vf =
 		vf_rss_query_en.vf =
 		vf_trust.vf =
+		vf_trust_flags.vf =
 		node_guid.vf =
 		port_guid.vf = ivi.vf;
 
@@ -1288,6 +1295,13 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	vf_linkstate.link_state = ivi.linkstate;
 	vf_rss_query_en.setting = ivi.rss_query_en;
 	vf_trust.setting = ivi.trusted;
+	/* TODO need to define privilege caps as well and best way to convert */
+	vf_trust_flags.flags = ivi.trust_flags;
+	if (ivi.trust_flags)
+		vf_trust_flags.flags |= VF_TRUST_F_LEGACY;
+		/* TODO set vf_trust.setting here too */
+	else
+		vf_trust_flags.flags = ivi.trust_flags;
 	vf = nla_nest_start_noflag(skb, IFLA_VF_INFO);
 	if (!vf)
 		goto nla_put_vfinfo_failure;
@@ -1306,7 +1320,9 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		    sizeof(vf_rss_query_en),
 		    &vf_rss_query_en) ||
 	    nla_put(skb, IFLA_VF_TRUST,
-		    sizeof(vf_trust), &vf_trust))
+		    sizeof(vf_trust), &vf_trust) ||
+	    nla_put(skb, IFLA_VF_TRUST_FLAGS,
+		    sizeof(vf_trust_flags), &vf_trust_flags))
 		goto nla_put_vf_failure;
 
 	if (dev->netdev_ops->ndo_get_vf_guid &&
@@ -1896,6 +1912,7 @@ static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
 	[IFLA_VF_RSS_QUERY_EN]	= { .len = sizeof(struct ifla_vf_rss_query_en) },
 	[IFLA_VF_STATS]		= { .type = NLA_NESTED },
 	[IFLA_VF_TRUST]		= { .len = sizeof(struct ifla_vf_trust) },
+	[IFLA_VF_TRUST_FLAGS]	= { .len = sizeof(struct ifla_vf_trust_flags) },
 	[IFLA_VF_IB_NODE_GUID]	= { .len = sizeof(struct ifla_vf_guid) },
 	[IFLA_VF_IB_PORT_GUID]	= { .len = sizeof(struct ifla_vf_guid) },
 };
@@ -2458,8 +2475,26 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 		if (ivt->vf >= INT_MAX)
 			return -EINVAL;
 		err = -EOPNOTSUPP;
+
+		if (ivt->setting >= 0)
+			ivtf->flags = VF_TRUST_F_LEGACY;
 		if (ops->ndo_set_vf_trust)
-			err = ops->ndo_set_vf_trust(dev, ivt->vf, ivt->setting);
+			err = ops->ndo_set_vf_trust(dev, ivt->vf, (vf_trust_flags_t)ivt->setting);
+		if (err < 0)
+			return err;
+	}
+
+	if (tb[IFLA_VF_TRUST_FLAGS]) {
+		struct ifla_vf_trust_flags *ivtf = nla_data(tb[IFLA_VF_TRUST_FLAGS]);
+
+		if (ivtf->vf >= INT_MAX)
+			return -EINVAL;
+		err = -EOPNOTSUPP;
+		if (ops->ndo_set_vf_trust) {
+			/* TODO need flag val and priv cap's check here */
+			err = ops->ndo_set_vf_trust(dev, ivtf->vf,
+						    ivtf->flags);
+			}
 		if (err < 0)
 			return err;
 	}
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 781e482dc499..32de860904ee 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -705,11 +705,12 @@ enum {
 				 * on/off switch
 				 */
 	IFLA_VF_STATS,		/* network device statistics */
-	IFLA_VF_TRUST,		/* Trust VF */
+	IFLA_VF_TRUST,		/* Trust VF all/nothing */
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
 	IFLA_VF_BROADCAST,	/* VF broadcast */
+	IFLA_VF_TRUST_FLAGS,	/* VF Trust flags */
 	__IFLA_VF_MAX,
 };
 
@@ -804,6 +805,56 @@ struct ifla_vf_trust {
 	__u32 setting;
 };
 
+/* Granular Trust via trust flags - similar to netdev feature flags */
+typedef u32 vf_trust_flags_t
+
+enum {
+	VF_TRUST_F_LEGACY_BIT,		/* Original all or nothing */
+	VF_TRUST_F_ADV_FLOW_BIT,	/* Advanced traffic flow features */
+	VF_TRUST_F_MIRROR_BIT,		/* Mirroring */
+	VF_TRUST_F_UC_PROM_BIT,		/* Unicast promiscuous mode */
+	VF_TRUST_F_VLAN_PROM_BIT,	/* Vlan promiscuous mode */
+	VF_TRUST_F_MC_PROM_BIT,		/* Multicast promiscuous mode */
+	VF_TRUST_F_MACADDR_CHANGE_BIT,	/* MAC Address change */
+	VF_TRUST_F_MTU_CHANGE_BIT,	/* MTU Change */
+	VF_TRUST_F_MAC_SPFCHK_DIS_BIT,	/* MAC Spoofcheck Disable */
+	VF_TRUST_F_VLAN_SPFCHK_DIS_BIT,	/* VLAN Spoofcheck Disable */
+
+	/* Add new generic VF Trust features here */
+
+	VF_TRUST_FLAGS_COUNT
+};
+
+/* trust flag helpers - TODO: need to finish this, example only */
+#define VF_TRUST_BIT(bit)	((vf_trust_flags_t)1 << (bit))
+#define VF_TRUST(name)	VF_TRUST_BIT(VF_TRUST_F_##name##_BIT)
+
+#define VF_TRUST_F_LEGACY		VF_TRUST(LEGACY)
+#define VF_TRUST_F_ADV_FLOW		VF_TRUST(ADV_FLOW)
+#define VF_TRUST_F_MIRROR		VF_TRUST(MIRROR)
+#define VF_TRUST_F_UC_PROM		VF_TRUST(UC_PROM)
+#define VF_TRUST_F_VLAN_PROM		VF_TRUST(VLAN_PROM)
+#define VF_TRUST_F_MC_PROM		VF_TRUST(MC_PROM)
+#define VF_TRUST_F_MACADDR_CHANGE 	VF_TRUST(MACADDR_CHANGE)
+#define VF_TRUST_F_MTU_CHANGE 		VF_TRUST(MTU_CHANGE)
+#define VF_TRUST_F_MAC_SPFCHK_DIS 	VF_TRUST(MAC_SPFCHK_DIS
+#define VF_TRUST_F_VLAN_SPFCHK_DIS 	VF_TRUST(VLAN_SPFCHK_DIS
+
+#define VF_TRUST_F_ALL		(VF_TRUST_F_ADV_FLOW | \
+				 VF_TRUST_F_MIRROR | \
+				 VF_TRUST_F_UC_PROM | \
+				 VF_TRUST_F_VLAN_PROM | \
+				 VF_TRUST_F_MC_PROM | \
+				 VF_TRUST_F_MACADDR_CHANGE | \
+				 VF_TRUST_F_MTU_CHANGE | \
+				 VF_TRUST_F_MAC_SPFCHK_DIS | \
+				 VF_TRUST_F_VLAN_SPFCHK_DIS)
+
+struct ifla_vf_trust_flags {
+	__u32 vf;
+	nla_bitfield32 flags;
+};
+
 /* VF ports management section
  *
  *	Nested layout of set/get msg is:



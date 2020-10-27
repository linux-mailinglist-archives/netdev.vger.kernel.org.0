Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559BE29C15F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900487AbgJ0OxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:53:25 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54741 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1773178AbgJ0Ovm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:51:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E869A1656;
        Tue, 27 Oct 2020 10:51:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 27 Oct 2020 10:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wJjmEBhu7dsa2rUUF
        4jDggpfFmPVjAP+xFKlL7JE8DE=; b=lfnvtWQjkh4fH4MUvTH4VzzPoXa+fnuw7
        LiVIcVYC2a3OoYZ+eOJeJ7Zfd1kzxTVWMwsHpB2xsR7GNBbh84umfGa7l6aRbVcD
        ijVDnR6udQ3afhFvOFOxDd4zmpDRXf2R2Etv/yiqfxpgMveVftj0rF3fyL+aGIud
        /Dqu5JQZyxbWh1LTsaOkVFef2X9TBxs7a6axqaVAodXreivY8PsjDdkwkfaebS9N
        vIDpn59N4HwuRvuM9bdb8N2Q+vmhMrn70ce7lYxjp/S2daikHaMI2w/SFElQgZp3
        E0/ugVe+x5KAwJubfS4vAsP9Ssh444GyZns/ElMfYE7Ak9mXKuE3A==
X-ME-Sender: <xms:-zOYXz-JA2UfyFsNITlzMKOzosGBgRs0EaqSLvyhVkmoHcEhc_9psg>
    <xme:-zOYX_sl2p9IuMoHDcQ5dD9d6bEoYH4m_YR6HpbY9-FFBi8MOQRjZN_sQPvAw_jP4
    HNHuymC5pDdm0M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeelgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdelnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhse
    hiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-zOYXxAGxrKOsImI2NSJ-RxvBqO2ZSAU2YTZilKJQ3dZxrPgy_lfPQ>
    <xmx:-zOYX_dgZsOOdYEMRlRxypKylrSh_T6oaEZ-YdOeJdPMenI20WVf6Q>
    <xmx:-zOYX4P3rP_pPyTuNvoE96zgjlaQ5-IxmUNibqm2KGc_70pmD5qBpg>
    <xmx:_DOYX32wAM2E8uDJVew9lvYiceErcMOGRmJafzCAAjCVMvunl0BPFg>
Received: from shredder.mtl.com (igld-84-229-153-9.inter.net.il [84.229.153.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6EB43280063;
        Tue, 27 Oct 2020 10:51:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, David.Laight@aculab.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v3] ethtool: Improve compatibility between netlink and ioctl interfaces
Date:   Tue, 27 Oct 2020 16:51:14 +0200
Message-Id: <20201027145114.226918-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

With the ioctl interface, when autoneg is enabled, but without
specifying speed, duplex or link modes, the advertised link modes are
set to the supported link modes by the ethtool user space utility.
Example:

# ethtool --version
ethtool version 5.4

# ethtool -s eth0 advertise 0xC autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no

# ethtool -s eth0 autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no

With the netlink interface, the same thing is done by the kernel, but
only if speed or duplex are specified. In which case, the advertised
link modes are set by traversing the supported link modes and picking
the ones matching the specified speed or duplex.

# ethtool --version
ethtool version 5.8

# ethtool -s eth0 advertise 0xC autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no

# ethtool -s eth0 autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no

Fix this incompatibility problem by introducing a new flag in the
ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
the flag is to indicate to the kernel that it needs to be compatible
with the legacy ioctl interface. A patch to the ethtool user space
utility will make sure the flag is set, when supported by the kernel.

The first use case for the flag is to have the kernel set the advertised
link modes to all supported link modes in case autoneg is enabled and no
other parameter is specified. Example with a patched kernel and ethtool:

# ethtool --version
ethtool version 5.8

# ethtool -s eth0 advertise 0xC autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no

# ethtool -s eth0 autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no

Changes since RFC v2:
* Reword commit message
* Rebase on top of Jakub's patches

Changes since RFC v1:
* Reword commit message
* Introduce 'ETHTOOL_FLAG_LEGACY' to explicitly indicate to the kernel
  that it needs to be compatible with legacy ioctl interface

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  9 +++++++--
 include/uapi/linux/ethtool_netlink.h         |  5 ++++-
 net/ethtool/linkmodes.c                      | 14 ++++++++------
 net/ethtool/netlink.c                        |  2 +-
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 30b98245979f..2993bcaa93ca 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -65,11 +65,12 @@ all devices providing it (each device in a separate message).
 types. The interpretation of these flags is the same for all request types but
 the flags may not apply to requests. Recognized flags are:
 
-  =================================  ===================================
+  =================================  =========================================
   ``ETHTOOL_FLAG_COMPACT_BITSETS``   use compact format bitsets in reply
   ``ETHTOOL_FLAG_OMIT_REPLY``        omit optional reply (_SET and _ACT)
   ``ETHTOOL_FLAG_STATS``             include optional device statistics
-  =================================  ===================================
+  ``ETHTOOL_FLAG_LEGACY``            be compatible with legacy ioctl interface
+  =================================  =========================================
 
 New request flags should follow the general idea that if the flag is not set,
 the behaviour is backward compatible, i.e. requests from old clients not aware
@@ -442,6 +443,10 @@ autoselection is done on ethtool side with ioctl interface, netlink interface
 is supposed to allow requesting changes without knowing what exactly kernel
 supports.
 
+If autonegotiation is on (either set now or kept from before), no other
+parameter is specified (e.g., speed) and ``ETHTOOL_FLAG_LEGACY`` flag is set,
+kernel adjusts advertised modes to all supported modes. This autoselection is
+done on ethtool side with ioctl interface.
 
 LINKSTATE_GET
 =============
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e2bf36e6964b..923c2379ade6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -94,10 +94,13 @@ enum {
 #define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
 /* request statistics, if supported by the driver */
 #define ETHTOOL_FLAG_STATS		(1 << 2)
+/* be compatible with legacy ioctl interface */
+#define ETHTOOL_FLAG_LEGACY		(1 << 3)
 
 #define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
 			  ETHTOOL_FLAG_OMIT_REPLY | \
-			  ETHTOOL_FLAG_STATS)
+			  ETHTOOL_FLAG_STATS | \
+			  ETHTOOL_FLAG_LEGACY)
 
 enum {
 	ETHTOOL_A_HEADER_UNSPEC,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..f6c0f1b54b45 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -277,9 +277,9 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
 };
 
 /* Set advertised link modes to all supported modes matching requested speed
- * and duplex values. Called when autonegotiation is on, speed or duplex is
- * requested but no link mode change. This is done in userspace with ioctl()
- * interface, move it into kernel for netlink.
+ * and duplex values, if specified. Called when autonegotiation is on, speed,
+ * duplex or legacy behavior is requested but no link mode change. This is done
+ * in userspace with ioctl() interface, move it into kernel for netlink.
  * Returns true if advertised modes bitmap was modified.
  */
 static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
@@ -327,7 +327,7 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
 
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 				  struct ethtool_link_ksettings *ksettings,
-				  bool *mod)
+				  bool req_legacy, bool *mod)
 {
 	struct ethtool_link_settings *lsettings = &ksettings->base;
 	bool req_speed, req_duplex;
@@ -370,7 +370,7 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
+	    (req_speed || req_duplex || req_legacy) &&
 	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
 		*mod = true;
 
@@ -384,6 +384,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod = false;
+	bool req_legacy;
 	int ret;
 
 	ret = ethnl_parse_header_dev_get(&req_info,
@@ -392,6 +393,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 					 true);
 	if (ret < 0)
 		return ret;
+	req_legacy = req_info.flags & ETHTOOL_FLAG_LEGACY;
 	dev = req_info.dev;
 	ret = -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_link_ksettings ||
@@ -409,7 +411,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	ret = ethnl_update_linkmodes(info, tb, &ksettings, req_legacy, &mod);
 	if (ret < 0)
 		goto out_ops;
 
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 50d3c8896f91..ca01205c5629 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -10,7 +10,7 @@ static bool ethnl_ok __read_mostly;
 static u32 ethnl_bcast_seq;
 
 #define ETHTOOL_FLAGS_BASIC (ETHTOOL_FLAG_COMPACT_BITSETS |	\
-			     ETHTOOL_FLAG_OMIT_REPLY)
+			     ETHTOOL_FLAG_OMIT_REPLY | ETHTOOL_FLAG_LEGACY)
 #define ETHTOOL_FLAGS_STATS (ETHTOOL_FLAGS_BASIC | ETHTOOL_FLAG_STATS)
 
 const struct nla_policy ethnl_header_policy[] = {
-- 
2.26.2


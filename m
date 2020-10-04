Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393AA282A2D
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 12:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgJDKRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 06:17:38 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37805 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDKRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 06:17:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 472D15C00C8;
        Sun,  4 Oct 2020 06:17:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 04 Oct 2020 06:17:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gfol2o61ZDl4istW0
        50vzVNqre5n8ALqFAk9Z6UNYnE=; b=JZyQX+hbh4zr93DW46A+euaU2Ra9d4Q5X
        RF8CE8C4LCZ1wYcOUcfFR9eEkIWbYTR4B29pD6f/0sNxkZfWt4rS4kRHNSdi8FbW
        oiJwOxpc7j9fpqUT/t+NAchcm+uB6cQrCQqV/LRaV2J8qUDu5cezmHi/9Dgs8i9L
        3pCf2EYGow1z7Opd5UXQXkloGP4sxoLjdJvAwio+rREeIDkEQ1Jguzf3C6xE/uib
        EZSpCWdbWEC02SZVXnA/nnYa7/pIVVxlYw1z8quNTkCAh+fSU5cTZX2SCTXo21Uc
        kzskgWyMCOVfKm7uhtGz4fggnlakFOI3iI+Q54vvlO44crgeZfQww==
X-ME-Sender: <xms:P6F5X3YcOHCI6eD-Tmr3TOwd4Z2jiwOgyHiW7Ci4ANiZR7_V14s_yg>
    <xme:P6F5X2Y-NAovNNuDwKNpCoehYDVGWrNwcMb4FjJGOh6Q14FQHToT1xNo3suPDvWmX
    lowJ6Ya_Uk7FC0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeekkefgteeguedvtdegffeitefgueeiiedute
    fhtdfhkeetteelgfevleetueeigeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecu
    kfhppeekgedrvddvledrfeejrddugeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:P6F5X5-NtjkoeB2GyTYg5hH2x4CS5HbSJcvePzITdhNrH_9HSfJyXw>
    <xmx:P6F5X9qSbktGclAIPSEecp0pCVRKRLWfzFZvg7ss6ztuaaf4H4QAqw>
    <xmx:P6F5XyonQB8adNJ2v0NPHEZ1NkXeMQbaOqKpG7_r4_ut89UL8_EejA>
    <xmx:QKF5XzeLXb9hrqEq0JPiF1rIVA279VmZF5AZkbaRxzmzM2N9PlsUbw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC9D83064610;
        Sun,  4 Oct 2020 06:17:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, saeedm@nvidia.com,
        ayal@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2] ethtool: Improve compatibility between netlink and ioctl interfaces
Date:   Sun,  4 Oct 2020 13:17:07 +0300
Message-Id: <20201004101707.2177320-1-idosch@idosch.org>
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
utility will make sure the flag is always set.

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

Changes since RFC v1:
* Reword commit message
* Introduce 'ETHTOOL_FLAG_LEGACY' to explicitly indicate to the kernel
  that it needs to be compatible with legacy ioctl interface

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: Michal Kubecek <mkubecek@suse.cz>
---
ethtool patches:
https://github.com/idosch/ethtool/tree/submit/ethtool_legacy

Targeting this at net-next since by the book it is not a regression. We
never had a different outcome for the same netlink request. Taking this
to 'net' would also cause conflicts with the recently introduced
'ETHTOOL_FLAG_STATS' flag.
---
 Documentation/networking/ethtool-netlink.rst |  9 +++++++--
 include/uapi/linux/ethtool_netlink.h         |  5 ++++-
 net/ethtool/linkmodes.c                      | 14 ++++++++------
 3 files changed, 19 insertions(+), 9 deletions(-)

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
index 29dcd675b65a..e5e70662cc8e 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -290,9 +290,9 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
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
@@ -340,7 +340,7 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
 
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 				  struct ethtool_link_ksettings *ksettings,
-				  bool *mod)
+				  bool req_legacy, bool *mod)
 {
 	struct ethtool_link_settings *lsettings = &ksettings->base;
 	bool req_speed, req_duplex;
@@ -383,7 +383,7 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
+	    (req_speed || req_duplex || req_legacy) &&
 	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
 		*mod = true;
 
@@ -397,6 +397,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 	struct ethnl_req_info req_info = {};
 	struct net_device *dev;
 	bool mod = false;
+	bool req_legacy;
 	int ret;
 
 	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
@@ -410,6 +411,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 					 true);
 	if (ret < 0)
 		return ret;
+	req_legacy = req_info.flags & ETHTOOL_FLAG_LEGACY;
 	dev = req_info.dev;
 	ret = -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_link_ksettings ||
@@ -427,7 +429,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	ret = ethnl_update_linkmodes(info, tb, &ksettings, req_legacy, &mod);
 	if (ret < 0)
 		goto out_ops;
 
-- 
2.26.2


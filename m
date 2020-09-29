Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E556027D348
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgI2QDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:03:32 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:44641 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgI2QDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 12:03:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 141741281;
        Tue, 29 Sep 2020 12:03:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 12:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IfWOGAh1lt+6lwNlb
        RS9GH5wKRPU5aCWwa2rofKjxjk=; b=lhwwCNiil4SbXB8a6Mb3WzYQMfoEzTj0l
        sxSEpOaDaBY8mPQCGrHasz13xKLV+OmSUG9W7m2gW/bjsLAPBvFDG6C3CNmtexF6
        isoxeDLhKGtjP5K0YLIWBeidEu3Hb+tzCrHXn3UcAvbM12KqfNeqYFt95qlwHO30
        Lv5wRcdpqZPdRmV1Tizlej0scJK2bbtmL9bBFLLtfHS9h4Nr+BVLUV67uvMEb3yy
        OHfK41FzzuIigBkuMdydY5w/LiRFivNqKQ1ZJFmXVErOmqYrf0YxnDuN4uXMLS+U
        5nnSTbDuUdFk7ico2NKjXxkSh9j+i8wykwx9T+vV1SA9366lWTyrg==
X-ME-Sender: <xms:z1pzX4n4xnRrvmro2NNNH8YObEoclGmYBa9rnHoVKAt_HsSKiAAX0g>
    <xme:z1pzX30ERbAzXCu0SC--pl-Z66Cmmf_h3ceFn3KhAZY3iv2w8Zuss_OBZRf_DFBGg
    6TRr8z_n4X2S74>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrudegkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:z1pzX2qPB5BltJgUDkdDgqZSBTCG4P9oGTWsVRrSL_iNbGoMBVMewg>
    <xmx:z1pzX0m4rIRMRMguht62Ymif-QTLVFOFPQNx992PgE1p5l4RLdyiGw>
    <xmx:z1pzX23RqxiA64QSE4SrTAebx3v2ZgKca3jSDbLTStTivxU4Zt8CqQ>
    <xmx:0VpzX_mnnCZR3Bu5ABNZ51t9V8N0yPtM9om9-4n-HWv2oAhIksWuaP4QONc>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id B98403280065;
        Tue, 29 Sep 2020 12:03:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, ayal@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net] ethtool: Fix incompatibility between netlink and ioctl interfaces
Date:   Tue, 29 Sep 2020 19:02:47 +0300
Message-Id: <20200929160247.1665922-1-idosch@idosch.org>
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

# ethtool -s swp3 speed 100000 autoneg off

# ethtool swp3
Settings for swp3:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 100000Mb/s
        Duplex: Full
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: off
        Link detected: yes

# ethtool -s swp3 autoneg on

# ethtool swp3
Settings for swp3:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 100000Mb/s
        Duplex: Full
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Link detected: yes

With the netlink interface, the same thing is done by the kernel, but
only if speed or duplex are specified. In which case, the advertised
link modes are set by traversing the supported link modes and picking
the ones matching the specified speed or duplex.

However, if speed nor duplex are specified, the driver is passed an
empty advertised link modes bitmap. This causes the mlxsw driver to
return an error. Other drivers might also be affected. Example:

# ethtool --version
ethtool version 5.8

# ethtool -s swp3 speed 100000 autoneg off

# ethtool swp3
Settings for swp3:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 100000Mb/s
        Duplex: Full
        Auto-negotiation: off
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: yes

# ethtool -s swp3 autoneg on
netlink error: link settings update failed
netlink error: Invalid argument

Fix this incompatibility problem by having the kernel set the advertised
link modes according to the supported link modes even if speed nor
duplex are specified. In which case, the advertised link modes are set
to the supported link modes. Example after this patch:

# ethtool --version
ethtool version 5.8

# ethtool -s swp3 speed 100000 autoneg off

# ethtool swp3
Settings for swp3:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 100000Mb/s
        Duplex: Full
        Auto-negotiation: off
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: yes

# ethtool -s swp3 autoneg on

# ethtool swp3
Settings for swp3:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 100000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: yes

Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
Sending as RFC as this patch has yet to be tested in our regression
---
 net/ethtool/linkmodes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 7044a2853886..a9458c76209e 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -288,9 +288,9 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 };
 
 /* Set advertised link modes to all supported modes matching requested speed
- * and duplex values. Called when autonegotiation is on, speed or duplex is
- * requested but no link mode change. This is done in userspace with ioctl()
- * interface, move it into kernel for netlink.
+ * and duplex values, if specified. Called when autonegotiation is on, but no
+ * link mode change. This is done in userspace with ioctl() interface, move it
+ * into kernel for netlink.
  * Returns true if advertised modes bitmap was modified.
  */
 static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
@@ -381,7 +381,6 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
 	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
 		*mod = true;
 
-- 
2.26.2


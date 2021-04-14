Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DA735FC8F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349789AbhDNUYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349673AbhDNUXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A64A6117A;
        Wed, 14 Apr 2021 20:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431809;
        bh=YCT7inORPvMuivPr0Ii47y6ei4pOtREVGikVNy8hF+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+cwvs64p/s/rQo1BhWDdsJTa5Q6QX/Lkv55reTe5eJB8WR9O46qOFV9yztxPJ1bL
         kCgW0HSYdX4pPFoEytjsjJ0J3HpUsggEQ/lK+DDmWfC4pzh2xBSHxIH9f4Mk0GK1ty
         u2FODWQOx0lZLFGub/rbYLS/Qc8Z7oXILtqAyOmYECWPMdJ+U3QaOEdAM+YQ2Rlhf6
         X1LMIa4Jhlhu8LZkgKBvD9MZ+wsDwBkUFX+MDXqnEbVgVtU2djWMfhPogLgkK3O9vE
         lI2DksmQgbDroJvxTmXXOICiAigT6DZiRU1YpqBZUvz3bfn67ZPjM3e6FCWbWBa2kJ
         2LerM1c5kjsog==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 2/6] docs: ethtool: document standard statistics
Date:   Wed, 14 Apr 2021 13:23:21 -0700
Message-Id: <20210414202325.2225774-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414202325.2225774-1-kuba@kernel.org>
References: <20210414202325.2225774-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for ETHTOOL_MSG_STATS_GET.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 74 ++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f8219e2f489e..086a80eb17be 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -210,6 +210,7 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
   ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
   ``ETHTOOL_MSG_FEC_GET``               get FEC settings
   ``ETHTOOL_MSG_FEC_SET``               set FEC settings
+  ``ETHTOOL_MSG_STATS_GET``             get standard statistics
   ===================================== ================================
 
 Kernel to userspace:
@@ -246,6 +247,7 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
   ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY`` tunnel offload info
   ``ETHTOOL_MSG_FEC_GET_REPLY``         FEC settings
   ``ETHTOOL_MSG_FEC_NTF``               FEC settings
+  ``ETHTOOL_MSG_STATS_GET_REPLY``       standard statistics
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1391,6 +1393,78 @@ accessible.
 ``ETHTOOL_A_MODULE_EEPROM_DATA`` has an attribute length equal to the amount of
 bytes driver actually read.
 
+STATS_GET
+=========
+
+Get standard statistics for the interface. Note that this is not
+a re-implementation of ``ETHTOOL_GSTATS`` which exposed driver-defined
+stats.
+
+Request contents:
+
+  =======================================  ======  ==========================
+  ``ETHTOOL_A_STATS_HEADER``               nested  request header
+  ``ETHTOOL_A_STATS_GROUPS``               bitset  requested groups of stats
+  =======================================  ======  ==========================
+
+Kernel response contents:
+
+ +---------------------------------+--------+----------------------------------+
+ | ``ETHTOOL_A_STATS_HEADER``      | nested | reply header                     |
+ +---------------------------------+--------+----------------------------------+
+ | ``ETHTOOL_A_STATS_GRP``         | nested | one or more groups of statistics |
+ +-+-------------------------------+--------+----------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_ID``    | u32    | group ID - ``ETHTOOL_STATS_*``   |
+ +-+-------------------------------+--------+----------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_SS_ID`` | u32    | string set ID for names          |
+ +-+-------------------------------+--------+----------------------------------+
+ | | ``ETHTOOL_A_STATS_*``         | u64    | actual statistics                |
+ +-+-------------------------------+--------+----------------------------------+
+
+Users specify which groups of statistics they are requesting via
+the ``ETHTOOL_A_STATS_GROUPS`` bitset. Currently defined values are:
+
+ ====================== ======== ===============================================
+ ETHTOOL_STATS_ETH_MAC  eth-mac  Basic IEEE 802.3 MAC statistics (30.3.1.1.*)
+ ETHTOOL_STATS_ETH_PHY  eth-phy  Basic IEEE 802.3 PHY statistics (30.3.2.1.*)
+ ETHTOOL_STATS_ETH_CTRL eth-ctrl Basic IEEE 802.3 MAC Ctrl statistics (30.3.3.*)
+ ETHTOOL_STATS_RMON     rmon     RMON (RFC 2819) statistics
+ ====================== ======== ===============================================
+
+Each group should have a corresponding ``ETHTOOL_A_STATS_GRP`` in the reply.
+``ETHTOOL_A_STATS_GRP_ID`` identifies which group's statistics nest contains.
+``ETHTOOL_A_STATS_GRP_SS_ID`` identifies the string set ID for the names of
+the statistics in the group, if available.
+
+Statistics are added directly to the ``ETHTOOL_A_STATS_GRP`` nest. Each group
+has its own interpretation of attribute IDs above
+``ETHTOOL_A_STATS_GRP_FIRST_ATTR``. Attribute IDs correspond to strings from
+the string set identified by ``ETHTOOL_A_STATS_GRP_SS_ID``. Complex statistics
+(such as RMON histogram entries) are also listed directly in
+``ETHTOOL_A_STATS_GRP`` and do not have a string defined in the string set.
+
+RMON "histogram" counters count number of packets within given size range.
+Because RFC does not specify the ranges beyond the standard 1518 MTU devices
+differ in definition of buckets. For this reason the definition of packet ranges
+is left to each driver.
+
+ ================================= ====== ===================================
+ ETHTOOL_A_STATS_RMON_HIST         nested contains the attributes below
+ ETHTOOL_A_STATS_RMON_HIST_BKT_LOW u32    low bound of the packet size bucket
+ ETHTOOL_A_STATS_RMON_HIST_BKT_HI  u32    high bound of the bucket
+ ETHTOOL_A_STATS_RMON_HIST_VAL     u64    packet counter
+ ETHTOOL_A_STATS_RMON_HIST_TX      nested same as HIST but counting Tx pkts
+ ================================= ====== ===================================
+
+Low and high bounds are inclusive, for example:
+
+ ============================= ==== ====
+ RFC statistic                 low  high
+ ============================= ==== ====
+ etherStatsPkts64Octets          0    64
+ etherStatsPkts512to1023Octets 512  1023
+ ============================= ==== ====
+
 Request translation
 ===================
 
-- 
2.30.2


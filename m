Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617F436289D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbhDPT2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243157AbhDPT2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C28613B4;
        Fri, 16 Apr 2021 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618601272;
        bh=60/+UH+4BfQ4JZ8y4uByHSRFBgYVoq+5f1Oy4dhJGiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eK2npWN9izknth+8MT61ehukJ4JUSqwRiwHGW6IKx0qit43hoAIZmgyrD6wBHBfJP
         Bv6KriHQTZkPmmmryYrdBT06cT7QlxsMzNa9OTLtj3rWMONrMEfjgrYLy3arhgX6Xc
         z7pRVJUExOYZl9BYyR3//sCLoQ3fK8ktm87k/I4b2fkNq2IT+XgNg85SYKmm1WoO/9
         oTx/Wy0PBZA0bEqaPPJryjLrjF8U7nsx+OgoAESuHQcC7ZcO2dFhR9bXwPjeajwjJX
         xl9oTxsculL82z18aJMoeAFidpMiSVKuvoqh1sOc0P2idcyhy7tTEMH8TugIvHDMen
         fxXfZ3K9dGfTw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/9] docs: ethtool: document standard statistics
Date:   Fri, 16 Apr 2021 12:27:38 -0700
Message-Id: <20210416192745.2851044-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416192745.2851044-1-kuba@kernel.org>
References: <20210416192745.2851044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for ETHTOOL_MSG_STATS_GET.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 82 ++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f8219e2f489e..48cad2fce147 100644
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
@@ -1391,6 +1393,86 @@ accessible.
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
+ +-----------------------------------+--------+--------------------------------+
+ | ``ETHTOOL_A_STATS_HEADER``        | nested | reply header                   |
+ +-----------------------------------+--------+--------------------------------+
+ | ``ETHTOOL_A_STATS_GRP``           | nested | one or more group of stats     |
+ +-+---------------------------------+--------+--------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_ID``      | u32    | group ID - ``ETHTOOL_STATS_*`` |
+ +-+---------------------------------+--------+--------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_SS_ID``   | u32    | string set ID for names        |
+ +-+---------------------------------+--------+--------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_STAT``    | nested | nest containing a statistic    |
+ +-+---------------------------------+--------+--------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_HIST_RX`` | nested | histogram statistic (Rx)       |
+ +-+---------------------------------+--------+--------------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_HIST_TX`` | nested | histogram statistic (Tx)       |
+ +-+---------------------------------+--------+--------------------------------+
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
+Statistics are added to the ``ETHTOOL_A_STATS_GRP`` nest under
+``ETHTOOL_A_STATS_GRP_STAT``. ``ETHTOOL_A_STATS_GRP_STAT`` should contain
+single 8 byte (u64) attribute inside - the type of that attribute is
+the statistic ID and the value is the value of the statistic.
+Each group has its own interpretation of statistic IDs.
+Attribute IDs correspond to strings from the string set identified
+by ``ETHTOOL_A_STATS_GRP_SS_ID``. Complex statistics (such as RMON histogram
+entries) are also listed inside ``ETHTOOL_A_STATS_GRP`` and do not have
+a string defined in the string set.
+
+RMON "histogram" counters count number of packets within given size range.
+Because RFC does not specify the ranges beyond the standard 1518 MTU devices
+differ in definition of buckets. For this reason the definition of packet ranges
+is left to each driver.
+
+``ETHTOOL_A_STATS_GRP_HIST_RX`` and ``ETHTOOL_A_STATS_GRP_HIST_TX`` nests
+contain the following attributes:
+
+ ================================= ====== ===================================
+ ETHTOOL_A_STATS_RMON_HIST_BKT_LOW u32    low bound of the packet size bucket
+ ETHTOOL_A_STATS_RMON_HIST_BKT_HI  u32    high bound of the bucket
+ ETHTOOL_A_STATS_RMON_HIST_VAL     u64    packet counter
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADA0361790
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhDPC2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238233AbhDPC2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBB74611AD;
        Fri, 16 Apr 2021 02:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540076;
        bh=60/+UH+4BfQ4JZ8y4uByHSRFBgYVoq+5f1Oy4dhJGiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iogIyvDiN+dK6zCUZIX/aC32bnj0iMcLy2qMCxsg1VK3NUDHzUcRB+mqAKxOu/91w
         otA1GVFZ2N3XFf2msA8Ulfd6sqpOVvrnyGcSzrhjVLZ5JaK6U0hvO8mAj+oTdXDHv5
         rwwEpo30UgDmUFhlhdzM99XUgr+JsMdKybUG/jZXvx2V5DhmKR6g3Nwm6eWYZH974d
         2OeGFxGrlwiWdGnqMlBCfy3dg9GDJK/+h5HwoNFOyqIB5fNEA8afElz+6bitRBJagq
         3eMPjrrPzS7C6kQm+nzDaquY8K7FygUPicK1AlNSfL43qeztkBOQzRAd1MBe7T79N8
         nQUqe6SPOTaew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/9] docs: ethtool: document standard statistics
Date:   Thu, 15 Apr 2021 19:27:45 -0700
Message-Id: <20210416022752.2814621-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
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


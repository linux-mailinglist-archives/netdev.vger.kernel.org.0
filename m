Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776B5269A3C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIOANx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgIOANK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 20:13:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4676321D7A;
        Tue, 15 Sep 2020 00:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600128789;
        bh=NWfN5hbHVckCw+VSVzPavjqr9ph54zq+tpKuv4Ib3nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJMowSR3+HrUmVtqD82C3odpSvHROfSGlRtvP4SENHAYAsl3kdbNnySTpVZZJfZWU
         qtmbkVol/YdLxXLnwwr+alflBdDZkytmF8+5R6jIsGINLXM/XJfMT5qZVnD3i5vn0K
         Ix5QW/Gjege9eJSkXXEmjFkeetTgaKUc9/ublwr4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, michael.chan@broadcom.com, saeedm@nvidia.com,
        tariqt@nvidia.com, andrew@lunn.ch, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/8] docs: net: include the new ethtool pause stats in the stats doc
Date:   Mon, 14 Sep 2020 17:11:53 -0700
Message-Id: <20200915001159.346469-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915001159.346469-1-kuba@kernel.org>
References: <20200915001159.346469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tell people that there now is an interface for querying pause frames.
A little bit of restructuring is needed given this is a first source
of such statistics.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/statistics.rst | 57 ++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index d490b535cd14..8e15bc98830b 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -4,16 +4,23 @@
 Interface statistics
 ====================
 
+Overview
+========
+
 This document is a guide to Linux network interface statistics.
 
-There are two main sources of interface statistics in Linux:
+There are three main sources of interface statistics in Linux:
 
  - standard interface statistics based on
-   :c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`; and
+   :c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`;
+ - protocol-specific statistics; and
  - driver-defined statistics available via ethtool.
 
-There are multiple interfaces to reach the former. Most commonly used
-is the `ip` command from `iproute2`::
+Standard interface statistics
+-----------------------------
+
+There are multiple interfaces to reach the standard statistics.
+Most commonly used is the `ip` command from `iproute2`::
 
   $ ip -s -s link show dev ens4u1u1
   6: ens4u1u1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
@@ -34,7 +41,26 @@ If `-s` is specified once the detailed errors won't be shown.
 
 `ip` supports JSON formatting via the `-j` option.
 
-Ethtool statistics can be dumped using `ethtool -S $ifc`, e.g.::
+Protocol-specific statistics
+----------------------------
+
+Some of the interfaces used for configuring devices are also able
+to report related statistics. For example ethtool interface used
+to configure pause frames can report corresponding hardware counters::
+
+  $ ethtool --include-statistics -a eth0
+  Pause parameters for eth0:
+  Autonegotiate:	on
+  RX:			on
+  TX:			on
+  Statistics:
+    tx_pause_frames: 1
+    rx_pause_frames: 1
+
+Driver-defined statistics
+-------------------------
+
+Driver-defined ethtool statistics can be dumped using `ethtool -S $ifc`, e.g.::
 
   $ ethtool -S ens4u1u1
   NIC statistics:
@@ -94,6 +120,17 @@ Identifiers via `ETHTOOL_GSTRINGS` with `string_set` set to `ETH_SS_STATS`,
 and values via `ETHTOOL_GSTATS`. User space should use `ETHTOOL_GDRVINFO`
 to retrieve the number of statistics (`.n_stats`).
 
+ethtool-netlink
+---------------
+
+Ethtool netlink is a replacement for the older IOCTL interface.
+
+Protocol-related statistics can be requested in get commands by setting
+the `ETHTOOL_FLAG_STATS` flag in `ETHTOOL_A_HEADER_FLAGS`. Currently
+statistics are supported in the following commands:
+
+  - `ETHTOOL_MSG_PAUSE_GET`
+
 debugfs
 -------
 
@@ -130,3 +167,13 @@ user space trying to read them.
 
 Statistics must persist across routine operations like bringing the interface
 down and up.
+
+Kernel-internal data structures
+-------------------------------
+
+The following structures are internal to the kernel, their members are
+translated to netlink attributes when dumped. Drivers must not overwrite
+the statistics they don't report with 0.
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_pause_stats
-- 
2.26.2


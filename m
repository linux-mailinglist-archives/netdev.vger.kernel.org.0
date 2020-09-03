Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFE25CE37
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgICXOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgICXOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 19:14:35 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10C1A206EF;
        Thu,  3 Sep 2020 23:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599174874;
        bh=rsTxBUMFoqSFEvyw0U+EH9er+17SUWR4hK9jjHNthsw=;
        h=From:To:Cc:Subject:Date:From;
        b=NzR4NbUEzfSpgvxo2hBM0p8hcEmBiapsY3aA/VTnSWPgT7HMi8T3Hodngzzpub4HB
         wDQDXEyF891ttBY8bTRYR7gu+lcO56yYlzS552bIYIC4mR8AlXJHVlKnnt6ZgAObxF
         oz1bHHd06iUwx/UsZownXIL3TAIPJcFQP5T/TaBg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jwi@linux.ibm.com, f.fainelli@gmail.com,
        andrew@lunn.ch, mkubecek@suse.cz, dsahern@gmail.com,
        edwin.peer@broadcom.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, rmk+kernel@armlinux.org.uk,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] net: tighten the definition of interface statistics
Date:   Thu,  3 Sep 2020 16:14:31 -0700
Message-Id: <20200903231431.2354702-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is born out of an investigation into which IEEE statistics
correspond to which struct rtnl_link_stats64 members. Turns out that
there seems to be reasonable consensus on the matter, among many drivers.
To save others the time (and it took more time than I'm comfortable
admitting) I'm adding comments referring to IEEE attributes to
struct rtnl_link_stats64.

Up until now we had two forms of documentation for stats - in
Documentation/ABI/testing/sysfs-class-net-statistics and the comments
on struct rtnl_link_stats64 itself. While the former is very cautious
in defining the expected behavior, the latter feel quite dated and
may not be easy to understand for modern day driver author
(e.g. rx_over_errors). At the same time modern systems are far more
complex and once obvious definitions lost their clarity. For example
- does rx_packet count at the MAC layer (aFramesReceivedOK)?
packets processed correctly by hardware? received by the driver?
or maybe received by the stack?

I tried to clarify the expectations, further clarifications from
others are very welcome.

The part hardest to untangle is rx_over_errors vs rx_fifo_errors
vs rx_missed_errors. After much deliberation I concluded that for
modern HW only two of the counters will make sense. The distinction
between internal FIFO overflow and packets dropped due to back-pressure
from the host is likely too implementation (driver and device) specific
to expose in the standard stats.

Now - which two of those counters we select to use is anyone's pick:

sysfs documentation suggests rx_over_errors counts packets which
did not fit into buffers due to MTU being too small, which I reused.
There don't seem to be many modern drivers using it (well, CAN drivers
seem to love this statistic).

Of the remaining two I picked rx_missed_errors to report device drops.
bnxt reports it and it's folded into "drop"s in procfs (while
rx_fifo_errors is an error, and modern devices usually receive the frame
OK, they just can't admit it into the pipeline).

Of the drivers I looked at only AMD Lance-like and NS8390-like use all
three of these counters. rx_missed_errors counts missed frames,
rx_over_errors counts overflow events, and rx_fifo_errors counts frames
which were truncated because they didn't fit into buffers. This suggests
that rx_fifo_errors may be the correct stat for truncated packets, but
I'd think a FIFO stat counting truncated packets would be very confusing
to a modern reader.

v2:
 - add driver developer notes about ethtool stat count and reset
 - replace Ethernet with IEEE 802.3 to better indicate source of attrs
 - mention byte counters don't count FCS
 - clarify RX counter is from device to host
 - drop "sightly" from sysfs paragraph
 - add examples of ethtool stats
 - s/incoming/received/ s/incoming/transmitted/

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/index.rst      |   1 +
 Documentation/networking/statistics.rst | 132 +++++++++++++++
 include/uapi/linux/if_link.h            | 204 ++++++++++++++++++++++--
 3 files changed, 320 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/networking/statistics.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index c29496fff81c..4167acc5c076 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -93,6 +93,7 @@ Linux Networking Documentation
    sctp
    secid
    seg6-sysctl
+   statistics
    strparser
    switchdev
    tc-actions-env-rules
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
new file mode 100644
index 000000000000..988c58851b10
--- /dev/null
+++ b/Documentation/networking/statistics.rst
@@ -0,0 +1,132 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Interface statistics
+====================
+
+This document is a guide to Linux network interface statistics.
+
+There are two main sources of interface statistics in Linux:
+
+ - standard interface statistics based on
+   :c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`; and
+ - driver-defined statistics available via ethtool.
+
+There are multiple interfaces to reach the former. Most commonly used
+is the `ip` command from `iproute2`::
+
+  $ ip -s -s link show dev ens4u1u1
+  6: ens4u1u1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
+    link/ether 48:2a:e3:4c:b1:d1 brd ff:ff:ff:ff:ff:ff
+    RX: bytes  packets  errors  dropped overrun mcast
+    74327665117 69016965 0       0       0       0
+    RX errors: length   crc     frame   fifo    missed
+               0        0       0       0       0
+    TX: bytes  packets  errors  dropped carrier collsns
+    21405556176 44608960 0       0       0       0
+    TX errors: aborted  fifo   window heartbeat transns
+               0        0       0       0       128
+    altname enp58s0u1u1
+
+Note that `-s` has been specified twice to see all members of
+:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`.
+If `-s` is specified once the detailed errors won't be shown.
+
+`ip` supports JSON formatting via the `-j` option.
+
+Ethtool statistics can be dumped using `ethtool -S $ifc`, e.g.::
+
+  $ ethtool -S ens4u1u1
+  NIC statistics:
+     tx_single_collisions: 0
+     tx_multi_collisions: 0
+
+uAPIs
+=====
+
+procfs
+------
+
+The historical `/proc/net/dev` text interface gives access to the list
+of interfaces as well as their statistics.
+
+Note that even though this interface is using
+:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`
+internally it combines some of the fields.
+
+sysfs
+-----
+
+Each device directory in sysfs contains a `statistics` directory (e.g.
+`/sys/class/net/lo/statistics/`) with files corresponding to
+members of :c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`.
+
+This simple interface is convenient especially in constrained/embedded
+environments without access to tools. However, it's inefficient when
+reading multiple stats as it internally performs a full dump of
+:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`
+and reports only the stat corresponding to the accessed file.
+
+Sysfs files are documented in
+`Documentation/ABI/testing/sysfs-class-net-statistics`.
+
+
+netlink
+-------
+
+`rtnetlink` (`NETLINK_ROUTE`) is the preferred method of accessing
+:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` stats.
+
+Statistics are reported both in the responses to link information
+requests (`RTM_GETLINK`) and statistic requests (`RTM_GETSTATS`,
+when `IFLA_STATS_LINK_64` bit is set in the `.filter_mask` of the request).
+
+ethtool
+-------
+
+Ethtool IOCTL interface allows drivers to report implementation
+specific statistics. Historically it has also been used to report
+statistics for which other APIs did not exist, like per-device-queue
+statistics, or standard-based statistics (e.g. RFC 2863).
+
+Statistics and their string identifiers are retrieved separately.
+Identifiers via `ETHTOOL_GSTRINGS` with `string_set` set to `ETH_SS_STATS`,
+and values via `ETHTOOL_GSTATS`. User space should use `ETHTOOL_GDRVINFO`
+to retrieve the number of statistics (`.n_stats`).
+
+debugfs
+-------
+
+Some drivers expose extra statistics via `debugfs`.
+
+struct rtnl_link_stats64
+========================
+
+.. kernel-doc:: include/uapi/linux/if_link.h
+    :identifiers: rtnl_link_stats64
+
+Notes for driver authors
+========================
+
+Drivers should report all statistics which have a matching member in
+:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` exclusively
+via `.ndo_get_stats64`. Reporting such standard stats via ethtool
+or debugfs will not be accepted.
+
+Drivers must ensure best possible compliance with
+:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`.
+Please note for example that detailed error statistics must be
+added into the general `rx_error` / `tx_error` counters.
+
+The `.ndo_get_stats64` callback can not sleep because of accesses
+via `/proc/net/dev`. If driver may sleep when retrieving the statistics
+from the device it should do so periodically asynchronously and only return
+a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
+allows setting the frequency of refreshing statistics, if needed.
+
+Retreiving ethtool statistics is a multi-syscall process, drivers are advised
+to keep the number of statistics constant to avoid race conditions with
+user space trying to read them.
+
+Statistics must persist across routine operations like bringing the interface
+down and up.
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 7fba4de511de..bf4667403cab 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -40,26 +40,197 @@ struct rtnl_link_stats {
 	__u32	rx_nohandler;		/* dropped, no handler found	*/
 };
 
-/* The main device statistics structure */
+/**
+ * struct rtnl_link_stats64 - The main device statistics structure.
+ *
+ * @rx_packets: Number of good packets received by the interface.
+ *   For hardware interfaces counts all good packets received from the device
+ *   by the host, including packets which host had to drop at various stages
+ *   of processing (even in the driver).
+ *
+ * @tx_packets: Number of packets successfully transmitted.
+ *   For hardware interfaces counts packets which host was able to successfully
+ *   hand over to the device, which does not necessarily mean that packets
+ *   had been successfully transmitted out of the device, only that device
+ *   acknowledged it copied them out of host memory.
+ *
+ * @rx_bytes: Number of good received bytes, corresponding to @rx_packets.
+ *
+ *   For IEEE 802.3 devices should count the length of Ethernet Frames
+ *   excluding the FCS.
+ *
+ * @tx_bytes: Number of good transmitted bytes, corresponding to @tx_packets.
+ *
+ *   For IEEE 802.3 devices should count the length of Ethernet Frames
+ *   excluding the FCS.
+ *
+ * @rx_errors: Total number of bad packets received on this network device.
+ *   This counter must include events counted by @rx_length_errors,
+ *   @rx_crc_errors, @rx_frame_errors and other errors not otherwise
+ *   counted.
+ *
+ * @tx_errors: Total number of transmit problems.
+ *   This counter must include events counter by @tx_aborted_errors,
+ *   @tx_carrier_errors, @tx_fifo_errors, @tx_heartbeat_errors,
+ *   @tx_window_errors and other errors not otherwise counted.
+ *
+ * @rx_dropped: Number of packets received but not processed,
+ *   e.g. due to lack of resources or unsupported protocol.
+ *   For hardware interfaces this counter should not include packets
+ *   dropped by the device which are counted separately in
+ *   @rx_missed_errors (since procfs folds those two counters together).
+ *
+ * @tx_dropped: Number of packets dropped on their way to transmission,
+ *   e.g. due to lack of resources.
+ *
+ * @multicast: Multicast packets received.
+ *   For hardware interfaces this statistic is commonly calculated
+ *   at the device level (unlike @rx_packets) and therefore may include
+ *   packets which did not reach the host.
+ *
+ *   For IEEE 802.3 devices this counter may be equivalent to:
+ *
+ *    - 30.3.1.1.21 aMulticastFramesReceivedOK
+ *
+ * @collisions: Number of collisions during packet transmissions.
+ *
+ * @rx_length_errors: Number of packets dropped due to invalid length.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter should be equivalent to a sum
+ *   of the following attributes:
+ *
+ *    - 30.3.1.1.23 aInRangeLengthErrors
+ *    - 30.3.1.1.24 aOutOfRangeLengthField
+ *    - 30.3.1.1.25 aFrameTooLongErrors
+ *
+ * @rx_over_errors: Receiver FIFO overflow event counter.
+ *
+ *   Historically the count of overflow events. Such events may be
+ *   reported in the receive descriptors or via interrupts, and may
+ *   not correspond one-to-one with dropped packets.
+ *
+ *   The recommended interpretation for high speed interfaces is -
+ *   number of packets dropped because they did not fit into buffers
+ *   provided by the host, e.g. packets larger than MTU or next buffer
+ *   in the ring was not available for a scatter transfer.
+ *
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   This statistics was historically used interchangeably with
+ *   @rx_fifo_errors.
+ *
+ *   This statistic corresponds to hardware events and is not commonly used
+ *   on software devices.
+ *
+ * @rx_crc_errors: Number of packets received with a CRC error.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.6 aFrameCheckSequenceErrors
+ *
+ * @rx_frame_errors: Receiver frame alignment errors.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter should be equivalent to:
+ *
+ *    - 30.3.1.1.7 aAlignmentErrors
+ *
+ * @rx_fifo_errors: Receiver FIFO error counter.
+ *
+ *   Historically the count of overflow events. Those events may be
+ *   reported in the receive descriptors or via interrupts, and may
+ *   not correspond one-to-one with dropped packets.
+ *
+ *   This statistics was used interchangeably with @rx_over_errors.
+ *   Not recommended for use in drivers for high speed interfaces.
+ *
+ *   This statistic is used on software devices, e.g. to count software
+ *   packet queue overflow (can) or sequencing errors (GRE).
+ *
+ * @rx_missed_errors: Count of packets missed by the host.
+ *   Folded into the "drop" counter in `/proc/net/dev`.
+ *
+ *   Counts number of packets dropped by the device due to lack
+ *   of buffer space. This usually indicates that the host interface
+ *   is slower than the network interface, or host is not keeping up
+ *   with the receive packet rate.
+ *
+ *   This statistic corresponds to hardware events and is not used
+ *   on software devices.
+ *
+ * @tx_aborted_errors:
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *   For IEEE 802.3 devices capable of half-duplex operation this counter
+ *   must be equivalent to:
+ *
+ *    - 30.3.1.1.11 aFramesAbortedDueToXSColls
+ *
+ *   High speed interfaces may use this counter as a general device
+ *   discard counter.
+ *
+ * @tx_carrier_errors: Number of frame transmission errors due to loss
+ *   of carrier during transmission.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.13 aCarrierSenseErrors
+ *
+ * @tx_fifo_errors: Number of frame transmission errors due to device
+ *   FIFO underrun / underflow. This condition occurs when the device
+ *   begins transmission of a frame but is unable to deliver the
+ *   entire frame to the transmitter in time for transmission.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ * @tx_heartbeat_errors: Number of Heartbeat / SQE Test errors for
+ *   old half-duplex Ethernet.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices possibly equivalent to:
+ *
+ *    - 30.3.2.1.4 aSQETestErrors
+ *
+ * @tx_window_errors: Number of frame transmission errors due
+ *   to late collisions (for Ethernet - after the first 64B of transmission).
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.10 aLateCollisions
+ *
+ * @rx_compressed: Number of correctly received compressed packets.
+ *   This counters is only meaningful for interfaces which support
+ *   packet compression (e.g. CSLIP, PPP).
+ *
+ * @tx_compressed: Number of transmitted compressed packets.
+ *   This counters is only meaningful for interfaces which support
+ *   packet compression (e.g. CSLIP, PPP).
+ *
+ * @rx_nohandler: Number of packets received on the interface
+ *   but dropped by the networking stack because the device is
+ *   not designated to receive packets (e.g. backup link in a bond).
+ */
 struct rtnl_link_stats64 {
-	__u64	rx_packets;		/* total packets received	*/
-	__u64	tx_packets;		/* total packets transmitted	*/
-	__u64	rx_bytes;		/* total bytes received 	*/
-	__u64	tx_bytes;		/* total bytes transmitted	*/
-	__u64	rx_errors;		/* bad packets received		*/
-	__u64	tx_errors;		/* packet transmit problems	*/
-	__u64	rx_dropped;		/* no space in linux buffers	*/
-	__u64	tx_dropped;		/* no space available in linux	*/
-	__u64	multicast;		/* multicast packets received	*/
+	__u64	rx_packets;
+	__u64	tx_packets;
+	__u64	rx_bytes;
+	__u64	tx_bytes;
+	__u64	rx_errors;
+	__u64	tx_errors;
+	__u64	rx_dropped;
+	__u64	tx_dropped;
+	__u64	multicast;
 	__u64	collisions;
 
 	/* detailed rx_errors: */
 	__u64	rx_length_errors;
-	__u64	rx_over_errors;		/* receiver ring buff overflow	*/
-	__u64	rx_crc_errors;		/* recved pkt with crc error	*/
-	__u64	rx_frame_errors;	/* recv'd frame alignment error */
-	__u64	rx_fifo_errors;		/* recv'r fifo overrun		*/
-	__u64	rx_missed_errors;	/* receiver missed packet	*/
+	__u64	rx_over_errors;
+	__u64	rx_crc_errors;
+	__u64	rx_frame_errors;
+	__u64	rx_fifo_errors;
+	__u64	rx_missed_errors;
 
 	/* detailed tx_errors */
 	__u64	tx_aborted_errors;
@@ -71,8 +242,7 @@ struct rtnl_link_stats64 {
 	/* for cslip etc */
 	__u64	rx_compressed;
 	__u64	tx_compressed;
-
-	__u64	rx_nohandler;		/* dropped, no handler found	*/
+	__u64	rx_nohandler;
 };
 
 /* The struct should be in sync with struct ifmap */
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8F936B09E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhDZJdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:33:09 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42628 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232601AbhDZJc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:32:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1078D1A3506;
        Mon, 26 Apr 2021 11:32:13 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C575C1A34E0;
        Mon, 26 Apr 2021 11:32:06 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id DB758402DA;
        Mon, 26 Apr 2021 11:31:58 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next, v2, 5/7] docs: networking: timestamping: update for DSA switches
Date:   Mon, 26 Apr 2021 17:38:00 +0800
Message-Id: <20210426093802.38652-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210426093802.38652-1-yangbo.lu@nxp.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update timestamping doc for DSA switches to describe current
implementation accurately. On TX, the skb cloning is no longer
in DSA generic code.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split from tx timestamp optimization big patch.
	- Updated the doc.
---
 Documentation/networking/timestamping.rst | 63 ++++++++++++++---------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index f682e88fa87e..7db3985359bc 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -630,30 +630,45 @@ hardware timestamping on it. This is because the SO_TIMESTAMPING API does not
 allow the delivery of multiple hardware timestamps for the same packet, so
 anybody else except for the DSA switch port must be prevented from doing so.
 
-In code, DSA provides for most of the infrastructure for timestamping already,
-in generic code: a BPF classifier (``ptp_classify_raw``) is used to identify
-PTP event messages (any other packets, including PTP general messages, are not
-timestamped), and provides two hooks to drivers:
-
-- ``.port_txtstamp()``: The driver is passed a clone of the timestampable skb
-  to be transmitted, before actually transmitting it. Typically, a switch will
-  have a PTP TX timestamp register (or sometimes a FIFO) where the timestamp
-  becomes available. There may be an IRQ that is raised upon this timestamp's
-  availability, or the driver might have to poll after invoking
-  ``dev_queue_xmit()`` towards the host interface. Either way, in the
-  ``.port_txtstamp()`` method, the driver only needs to save the clone for
-  later use (when the timestamp becomes available). Each skb is annotated with
-  a pointer to its clone, in ``DSA_SKB_CB(skb)->clone``, to ease the driver's
-  job of keeping track of which clone belongs to which skb.
-
-- ``.port_rxtstamp()``: The original (and only) timestampable skb is provided
-  to the driver, for it to annotate it with a timestamp, if that is immediately
-  available, or defer to later. On reception, timestamps might either be
-  available in-band (through metadata in the DSA header, or attached in other
-  ways to the packet), or out-of-band (through another RX timestamping FIFO).
-  Deferral on RX is typically necessary when retrieving the timestamp needs a
-  sleepable context. In that case, it is the responsibility of the DSA driver
-  to call ``netif_rx_ni()`` on the freshly timestamped skb.
+In the generic layer, DSA provides the following infrastructure for PTP
+timestamping:
+
+- ``.port_txtstamp()``: a hook called prior to the transmission of
+  packets with a hardware TX timestamping request from user space.
+  This is required for two-step timestamping, since the hardware
+  timestamp becomes available after the actual MAC transmission, so the
+  driver must be prepared to correlate the timestamp with the original
+  packet so that it can re-enqueue the packet back into the socket's
+  error queue. To save the packet for when the timestamp becomes
+  available, the driver can call ``skb_clone_sk`` , save the clone pointer
+  in skb->cb and enqueue a tx skb queue. Typically, a switch will have a
+  PTP TX timestamp register (or sometimes a FIFO) where the timestamp
+  becomes available. In case of a FIFO, the hardware might store
+  key-value pairs of PTP sequence ID/message type/domain number and the
+  actual timestamp. To perform the correlation correctly between the
+  packets in a queue waiting for timestamping and the actual timestamps,
+  drivers can use a BPF classifier (``ptp_classify_raw``) to identify
+  the PTP transport type, and ``ptp_parse_header`` to interpret the PTP
+  header fields. There may be an IRQ that is raised upon this
+  timestamp's availability, or the driver might have to poll after
+  invoking ``dev_queue_xmit()`` towards the host interface.
+  One-step TX timestamping do not require packet cloning, since there is
+  no follow-up message required by the PTP protocol (because the
+  TX timestamp is embedded into the packet by the MAC), and therefore
+  user space does not expect the packet annotated with the TX timestamp
+  to be re-enqueued into its socket's error queue.
+
+- ``.port_rxtstamp()``: On RX, the BPF classifier is run by DSA to
+  identify PTP event messages (any other packets, including PTP general
+  messages, are not timestamped). The original (and only) timestampable
+  skb is provided to the driver, for it to annotate it with a timestamp,
+  if that is immediately available, or defer to later. On reception,
+  timestamps might either be available in-band (through metadata in the
+  DSA header, or attached in other ways to the packet), or out-of-band
+  (through another RX timestamping FIFO). Deferral on RX is typically
+  necessary when retrieving the timestamp needs a sleepable context. In
+  that case, it is the responsibility of the DSA driver to call
+  ``netif_rx_ni()`` on the freshly timestamped skb.
 
 3.2.2 Ethernet PHYs
 ^^^^^^^^^^^^^^^^^^^
-- 
2.25.1


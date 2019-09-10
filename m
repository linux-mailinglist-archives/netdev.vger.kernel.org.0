Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D2BAEEC6
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436549AbfIJPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:45:09 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43836 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:45:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 0AF8F28DA1D
From:   Robert Beckett <bob.beckett@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH 7/7] dt-bindings: mv88e6xxx: add egress rate limiting
Date:   Tue, 10 Sep 2019 16:41:53 +0100
Message-Id: <20190910154238.9155-8-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document port egress rate limiting settings.
Add defines for specifying egress rate limiting mode.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 .../devicetree/bindings/net/dsa/marvell.txt   | 22 +++++++++++++++++++
 include/dt-bindings/net/dsa-mv88e6xxx.h       |  5 +++++
 2 files changed, 27 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 7de90929c3c9..d33c1958f420 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -62,6 +62,28 @@ Optional properties for ports:
 			  MV88E6XXX_PORT_SCHED_STRICT_ALL - All queues use
 			  strict priority, where queues drain in descending
 			  queue number order.
+- egress-limit-mode=<n>	: Set port egress rate limiting mode. Valid values are:
+			  MV88E6XXX_PORT_EGRESS_COUNT_MODE_FRAMES - Count layer
+			  2 frames (assumed to be 64kb).
+			  MV88E6XXX_PORT_EGRESS_COUNT_MODE_L1 - Count all layer
+			  1 bits
+			  MV88E6XXX_PORT_EGRESS_COUNT_MODE_L2 - Count all layer
+			  2 bits
+			  MV88E6XXX_PORT_EGRESS_COUNT_MODE_L3 - Count all layer
+			  3 bits
+			  Must also specify egress-limit-count.
+- egress-limit-count=<n>: Set port egress rate limiting count. If
+			  egress-limit-mode is FRAMES, this specifies the
+			  maximum number of ethernet frames to allow to egress
+			  from this port per second, otherwise it is number of
+			  bits as counted based on the mode allowed to egress
+			  from this port per second.
+			  The HW has limitations which the driver adheres to:
+			  between 64 Kbps to 1 Mbps in 16 Kbps increments
+			  between 1 Mbps to 100 Mbps in 1Mbps increments
+			  between 100 Mbps to 1 Gbps in 10 Mbps increments.
+			  Other values will be rounded down the previous
+			  increment.
 
 Example:
 
diff --git a/include/dt-bindings/net/dsa-mv88e6xxx.h b/include/dt-bindings/net/dsa-mv88e6xxx.h
index 3f62003841ce..33ecd94f5e22 100644
--- a/include/dt-bindings/net/dsa-mv88e6xxx.h
+++ b/include/dt-bindings/net/dsa-mv88e6xxx.h
@@ -9,6 +9,11 @@
 #ifndef _DT_BINDINGS_MV88E6XXX_H
 #define _DT_BINDINGS_MV88E6XXX_H
 
+#define MV88E6XXX_PORT_EGRESS_COUNT_MODE_FRAMES	0
+#define MV88E6XXX_PORT_EGRESS_COUNT_MODE_L1	1
+#define MV88E6XXX_PORT_EGRESS_COUNT_MODE_L2	2
+#define MV88E6XXX_PORT_EGRESS_COUNT_MODE_L3	3
+
 #define MV88E6XXX_PORT_SCHED_ROUND_ROBIN	0
 #define MV88E6XXX_PORT_SCHED_STRICT_3		1
 #define MV88E6XXX_PORT_SCHED_STRICT_3_2		2
-- 
2.18.0


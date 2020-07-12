Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87721C9B1
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgGLOJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:09:37 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17389 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbgGLOJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594562973; x=1626098973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KjQ2iHRIZX7SIVan+FkPjPmVkFfe4NagZdbP3cThDGA=;
  b=rVOv4fc1GfaqxlZS8+05Y19ESlIF/RJJ1RTtPl6RTGl0i/XgaRklFwmU
   dDkUNkdCLtHXGrUeAdPlMR7eBgIrZoLVuBVRkn0RosVaaU9T8VfUppiRp
   7zwxrEglA+HnJ1Yw+zOGh9lJ3uWNlQVeRoeZkfV/bBEWq14Qc7P7BOIS5
   JV2X9Z1jgX3Dd7KDPspFyHjfhg9zZKlajOvEk6qATc4qmhLtWDm4MqN/9
   Hi800HbEvorQE3kLcV1vBphDx9s+a1GPGoAWI2ACevfr8xMIde/J7x3Us
   C5RgOaDGinnE1KaklNSUY4/gA5PUBt0hN10AHWJFyrW2agDTcY7fq00xb
   g==;
IronPort-SDR: HLmm5GREKlNQrjtQRJjEmL0XbTNaUZY4kyFgLMTUUbqM351ffbKMHeG0sggGmOfUNk3tL4LFVv
 fTiioP9GcpuwDWNUx8FzuZ8W9hwkM4N7D29KnvVLGSpbdd++bRLodyVNLtZcbJdJggoCxo95LA
 1nHWEzaWkENGugWH788/WKCbQ4nYe/Ra9WDeAE0Kw0KjqrktkmCrk3L2FzaU2AhsH7NI+O8DnK
 Gno1nrtLs6WXfOvGCONMeZD+nph4YSco7TnUduG03llCGeDmouii4Tmkc1W+RU1xEk28tv263b
 Xt0=
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="79604253"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2020 07:09:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 07:09:32 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sun, 12 Jul 2020 07:09:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 04/12] bridge: mrp: Extend br_mrp for MRP interconnect
Date:   Sun, 12 Jul 2020 16:05:48 +0200
Message-ID: <20200712140556.1758725-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
References: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the 'struct br_mrp' to contain information regarding
the MRP interconnect. It contains the following:
- the interconnect port 'i_port', which is NULL if the node doesn't have
  a interconnect role
- the interconnect id, which is similar with the ring id, but this field
  is also part of the MRP_InTest frames.
- the interconnect role, which can be MIM or MIC.
- the interconnect state, which can be open or closed.
- the interconnect delayed_work for sending MRP_InTest frames and check
  for lost of continuity.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_private_mrp.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 315eb37d89f0f..8841ba847fb29 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -12,8 +12,10 @@ struct br_mrp {
 
 	struct net_bridge_port __rcu	*p_port;
 	struct net_bridge_port __rcu	*s_port;
+	struct net_bridge_port __rcu	*i_port;
 
 	u32				ring_id;
+	u16				in_id;
 	u16				prio;
 
 	enum br_mrp_ring_role_type	ring_role;
@@ -21,6 +23,11 @@ struct br_mrp {
 	enum br_mrp_ring_state_type	ring_state;
 	u32				ring_transitions;
 
+	enum br_mrp_in_role_type	in_role;
+	u8				in_role_offloaded;
+	enum br_mrp_in_state_type	in_state;
+	u32				in_transitions;
+
 	struct delayed_work		test_work;
 	u32				test_interval;
 	unsigned long			test_end;
@@ -28,6 +35,12 @@ struct br_mrp {
 	u32				test_max_miss;
 	bool				test_monitor;
 
+	struct delayed_work		in_test_work;
+	u32				in_test_interval;
+	unsigned long			in_test_end;
+	u32				in_test_count_miss;
+	u32				in_test_max_miss;
+
 	u32				seq_id;
 
 	struct rcu_head			rcu;
-- 
2.27.0


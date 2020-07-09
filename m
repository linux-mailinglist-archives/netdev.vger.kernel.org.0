Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A8219CE5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgGIKCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:02:53 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:27253 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgGIKBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594288906; x=1625824906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxV1KZrdzbJyskdAsZ/YrXLvu6nRz5FlWX+QDk+qvDg=;
  b=H7cCDw7RVanhqBflSsD2ocODU6e65I8nd+zSzX+fGGJcwQnNpijRtvKe
   gUFMbsROoh5T+7kBQ6vkr/71clvL2Bs6+rzHGUsekCPGdHwwaxiHe7Tsx
   IGaazRa3HspgePyLddeIkwPE4W071fRF5ApoQO7fKNJdz0/Jri3gq9Vga
   oCc0UPdca6MznIGarcwPXyokSLbwdv35L4xiHavRMEHwYPuVl0INl6Qws
   2vBbnTi/TaajawmC+3CHYImHZneKuCiM4cSwUmjnfRoCmCRTnfYZQSjki
   TFmjEKMI3Snp3yOaqbRYYuoQbkD0Xr+vTAlQ28XbHSE/zXmOxjk77hWDe
   w==;
IronPort-SDR: IuU8vM4aXGo+2co2tPKfuLcezOG/c91s+iafzl1SrdsJIfzmMA7q2W6qcA/3bRsl5gKyZr3kej
 PDU/dynUgWd3l2wAStiduWjTNyX69fYh9RtUw4pYhofcxKQdxaTCdowYyAOI1XOPey/0OSDx5b
 xNhkUGDvlLQyz4zIk103fXBvbc8DM/V7i4xDx72UGN/TGMzbcarI7dLikbkC521Oh4h1fv9Tdj
 hBw047xwVSS//HXkdXW17GSl0UVFYcgtxKu7YQB/cW5h8XvK1TEd6AkfZA2ZuNWEkB/IzZY1LC
 R14=
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="86823022"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jul 2020 03:01:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 03:01:45 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 9 Jul 2020 03:01:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 04/12] bridge: mrp: Extend br_mrp for MRP interconnect
Date:   Thu, 9 Jul 2020 12:00:32 +0200
Message-ID: <20200709100040.554623-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200709100040.554623-1-horatiu.vultur@microchip.com>
References: <20200709100040.554623-1-horatiu.vultur@microchip.com>
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
index 33b255e38ffec..5e612123c5605 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78403215490
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgGFJU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 05:20:56 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:58757 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbgGFJUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 05:20:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594027255; x=1625563255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxV1KZrdzbJyskdAsZ/YrXLvu6nRz5FlWX+QDk+qvDg=;
  b=rloXPBtvbg/4B8AOq9VyWoBc9OXnf0uyrAI6eQrkmc/GLRyy8iiqa739
   5N315/UmJcg7AUf0JOn65IGKavJmatF1hK9fDlqQXosX37Tiyp4BlwUBT
   NXG3b9uaA2HMrSkoTBKa3SBXYAH2NtFVDh4sBcwkbQqbokink3TviycsH
   uP8kaEIgh11qKJIilb0ipK1zN+6FRn3yOHtYzUTNwj1VFM9TxpC/naLi6
   e3JtXDQj0t2yjr+0BgrvsnTy1Kt5565qrKju3d+hzxGNSHSdb5Ue6kVyh
   qYTznYLx4ABFRwy9NatuWl9nGE6/gn/TT4pdtqzxn5mVAISQFoSADypBL
   Q==;
IronPort-SDR: Yb1JATRksNqLsq+D9oBRYugub2T8v0Wzlna1SnIAXhcFVCaj59tODyYPu7YRToz9ftrWFMqlIO
 tVUkUBfmcyrYIhpFqn0k2yQHRLAXQuPuRi8qFfzCxXbZg9fnraXHQq/78qcKsk2iYu4IWGO33s
 K6CRjGudWOOi5dnk3znM4uszZXuk6+9s2WimekpVZnuUmYx9GGge0EAfAiZvxo2Rx1mVIk2nfH
 psuRf3ru9E450XKHFCszDu+itUgZkhRtGnDoTxfCteMG1kStoW/Eg54eRVLOQXhe2ZBL/KEBWv
 E2E=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="81962430"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 02:20:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 02:20:53 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 6 Jul 2020 02:20:27 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 04/12] bridge: mrp: Extend br_mrp for MRP interconnect
Date:   Mon, 6 Jul 2020 11:18:34 +0200
Message-ID: <20200706091842.3324565-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
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


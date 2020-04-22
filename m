Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC881B4A4F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgDVQVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:21:54 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:23983 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgDVQVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587572510; x=1619108510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=PD8IUS1EdZAMiLoRRlRU8vrEN2R88F6dLZkoxx8iJGI=;
  b=1y/PUmYNc8x2qNnPAuuCV34h3zrvMUILvtyaUFP5nS1Cgopf2R0U6N+T
   jlSRsA6RbShV4tVQCLxm6E6mbAovM9BA7qk68Z3IrVDBksBR5Q1E51g1H
   ppiwbyiZCMTc2WOTgfpQQiWnoS2VAiWzgxH5Bh6/GIJ20PC1lXTDKgd9y
   Vi76TpOmgzOXz4tPp7dBZqCX0nO3686ThIVedtjViV2UNg2JmD0qs9xhQ
   Rcp5RCZuY3sR5/LJIB3J2Zux76uEVbpV9zS3taTxjJGMGodOb2xHlOWXM
   1XGiqSdlpSbboJT3TPSh3kvS6ctZO8AjJmadauaZJCEhoOiPrnwCvMiau
   Q==;
IronPort-SDR: balzNi6XcS3EdcDjIm7WHQ3S4KTxbweFy2PPSew945s3xWqdhVaWzcFCCAxfeCiLmL90EfzuA1
 59CVxW+EEitXgpsmZ6oE5Um3rFt6BqvaexKX0MEPGr1tzsSKnSHUzK7VX9yJrbue7ZO8nCifAO
 hGJQCRCV5tMIy4Iiy5crG2UL5qt4IFWHmR+2yRXPpejR11KOHn6OfrhqX19rOUQnqQqZLpioh8
 8wmE1fnINZw+FS+i81KBYax8mF3mawta4BxJllE88tBbaWCe4iSzaODjKpG5SB3uvbvlb5zOzK
 YVQ=
X-IronPort-AV: E=Sophos;i="5.73,304,1583218800"; 
   d="scan'208";a="76894561"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2020 09:21:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Apr 2020 09:21:49 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 22 Apr 2020 09:21:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 03/11] bridge: mrp: Extend bridge interface
Date:   Wed, 22 Apr 2020 18:18:25 +0200
Message-ID: <20200422161833.1123-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422161833.1123-1-horatiu.vultur@microchip.com>
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To integrate MRP into the bridge, first the bridge needs to be aware of ports
that are part of an MRP ring and which rings are on the bridge.
Therefore extend bridge interface with the following:
- add new flag(BR_MPP_AWARE) to the net bridge ports, this bit will be
  set when the port is added to an MRP instance. In this way it knows if
  the frame was received on MRP ring port
- add new flag(BR_MRP_LOST_CONT) to the net bridge ports, this bit will be set
  when the port lost the continuity of MRP Test frames.
- add a list of MRP instances

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/linux/if_bridge.h | 2 ++
 net/bridge/br_private.h   | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 9e57c4411734..b3a8d3054af0 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -47,6 +47,8 @@ struct br_ip_list {
 #define BR_BCAST_FLOOD		BIT(14)
 #define BR_NEIGH_SUPPRESS	BIT(15)
 #define BR_ISOLATED		BIT(16)
+#define BR_MRP_AWARE		BIT(17)
+#define BR_MRP_LOST_CONT	BIT(18)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1f97703a52ff..835a70f8d3ea 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -428,6 +428,10 @@ struct net_bridge {
 	int offload_fwd_mark;
 #endif
 	struct hlist_head		fdb_list;
+
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	struct list_head		__rcu mrp_list;
+#endif
 };
 
 struct br_input_skb_cb {
-- 
2.17.1


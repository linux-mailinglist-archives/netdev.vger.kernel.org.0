Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD9C22128E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGOQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:27 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43486 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgGOQkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:24 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeH7V021720;
        Wed, 15 Jul 2020 11:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594831217;
        bh=BuX2JcVEQqV62DWLE9gR2zCSbXY0NQedT0rYaZKFrdg=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=Haa/5XR2bKSvw86Yfu2C2eKRToy0xBTLSrFH774p7ABVxG5aganh45pqgUYfx9eqF
         0MKGtA3Ww5P4lckqlZBGrH9/DiYiW8N84R+Mtvx1YTJir2wHaRFV13Ff9Bt51X8miU
         x5gLAujhYrYaTbN0yWscW5yYkjAk0p95v2duTbTw=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06FGeHUR102690
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 11:40:17 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 11:40:17 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 11:40:17 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeCva081717;
        Wed, 15 Jul 2020 11:40:16 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next PATCH v2 2/9] net: hsr/prp: validate address B before copying to skb
Date:   Wed, 15 Jul 2020 12:40:03 -0400
Message-ID: <20200715164012.1222-3-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715164012.1222-1-m-karicheri2@ti.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate MAC address before copying the same to outgoing frame
skb destination address.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 net/hsr/hsr_framereg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 03b891904314..01331da28639 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -325,7 +325,10 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	if (port->type != node_dst->addr_B_port)
 		return;
 
-	ether_addr_copy(eth_hdr(skb)->h_dest, node_dst->macaddress_B);
+	if (is_valid_ether_addr(node_dst->macaddress_B))
+		ether_addr_copy(eth_hdr(skb)->h_dest, node_dst->macaddress_B);
+	else
+		WARN_ONCE(1, "%s: mac address B not valid\n", __func__);
 }
 
 void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
-- 
2.17.1


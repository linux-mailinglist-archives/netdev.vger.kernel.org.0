Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88737223ED0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 16:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgGQOwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 10:52:08 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44088 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgGQOwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 10:52:08 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HEq3Wf008551;
        Fri, 17 Jul 2020 09:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594997523;
        bh=ESax+3izdT/pNkUAEDmi/F9+EPvqKK0Feoy+SCzspGE=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=Jv4ubuD6RpjD+pUdhFVM1Pv+K8YTkHWQRJo2MhzCSD6V1uc6V1lqyjjqyHH/4D24m
         AmMjYyrzm565dY/s4f9igIJqPCr+Plr4maydVvkhyE0FKG8WhU9NWoU1/hPBz7gUkD
         n3j6puc4iAm0P+vKi91yU8Yy5aawmXUkTiVcgkIM=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06HEq3Aw067492
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 09:52:03 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 09:52:02 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 09:52:02 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HEq1id097948;
        Fri, 17 Jul 2020 09:52:02 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <grygorii.strashko@ti.com>, <vinicius.gomes@intel.com>
Subject: [PATCH 2/2] net: hsr/prp: validate address B before copying to skb
Date:   Fri, 17 Jul 2020 10:52:01 -0400
Message-ID: <20200717145201.30351-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200717145201.30351-1-m-karicheri2@ti.com>
References: <20200717145201.30351-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate MAC address before copying the same to outgoing frame
skb destination address. Since a node can have zero mac
address for Link B until a valid frame is received over
that link, this fix address the issue of a zero MAC address
being in the packet.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 Sending this bug fix ahead of PRP patch series as per comment
 net/hsr/hsr_framereg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 03b891904314..530de24b1fb5 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -325,7 +325,8 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	if (port->type != node_dst->addr_B_port)
 		return;
 
-	ether_addr_copy(eth_hdr(skb)->h_dest, node_dst->macaddress_B);
+	if (is_valid_ether_addr(node_dst->macaddress_B))
+		ether_addr_copy(eth_hdr(skb)->h_dest, node_dst->macaddress_B);
 }
 
 void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
-- 
2.17.1


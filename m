Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D773B223EDC
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgGQOzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 10:55:17 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60628 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgGQOzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 10:55:16 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HEtBZl006684;
        Fri, 17 Jul 2020 09:55:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594997711;
        bh=zA/6AiizyA2x66ZytfmSRMYHubOCr0hWqV9pw3bpcQA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=vF7uwz3R9b+Jtn4oEajY9b/D+bgQ74JIeAxCPrQnbIyUCGuBYKEvAlr9PfGx6Xypf
         9zpuy1k3bkFfAWaZughSMwHGu19sH3OnkpRtGIAr/M1tTt5YGmMbdychzEmAHmyhL/
         x4k29P66qV9dnBAjHIgy3MQgbI19U+48vOB9jU1c=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06HEtBbM072224
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 09:55:11 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 09:55:11 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 09:55:11 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HEtAg1090872;
        Fri, 17 Jul 2020 09:55:11 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <grygorii.strashko@ti.com>, <vinicius.gomes@intel.com>
Subject: [PATCH 2/2 v2] net: hsr: validate address B before copying to skb
Date:   Fri, 17 Jul 2020 10:55:10 -0400
Message-ID: <20200717145510.30433-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200717145510.30433-1-m-karicheri2@ti.com>
References: <20200717145510.30433-1-m-karicheri2@ti.com>
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
 Removing prp prefix from subject line.
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE66C2C03E5
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgKWLOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:14:35 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:6538 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgKWLOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606130074; x=1637666074;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=knfos+BqzH4dlo+fODl7yedIW3k3ViBBu3PBL+ng7bw=;
  b=PwY2tcUhaQb2ssFueb1uCxVgjVVXBXbSkt2N7MaFT1kt+WF/74xv7CCT
   iMQk0/oCRdm3ajMk905yrmzKmFCGpS7DkrZ8P2qHoaGl0I6fuPEA8UE21
   zTnocCra3qpAolF+CEZoMDklmFtPxULA773VepeANmqsMFznTbQFfp+P9
   c3HXZpMfUdzjkHz6c9m6Tp2Cl6k62pznQGlweGvjm7cddotvAsse4Ep+b
   nzxMyjraqTmhFfujQRxFAU4cNwPdI671sLHnGCL/filaEwi+KLWLKozSP
   YHbII2JAomeFphpAaz3hIGS/ZzlTmrVzZvcdxyAAK2rD+UbdTjCsRnN/f
   g==;
IronPort-SDR: /eekxxeuBa1IVo708k88MVQpPGekvM5vyIxrHB/2lJDG7EfQO3s0J2iEAItQ4wo/j30G4I1D0k
 2e7ojic+9xaY/Ou0wQufhDYf+rKec+4AisKMhDDq9hCT5bLGT5ibdB5MCIK9ATXsUJBENZ1iGl
 pl5i1elFijIHxFGIKxWl1yX3W6I4Y5xAuUBMvVQuIWnRUhf8JWMzYRYrmmLscs8LZZO43OW7DL
 +R8yzlIVorszjHvUNFJ/P2+3Xj59iO50ESoXE6lduo+R36ResBSXW4iVoSo6C0hiPlviFY4wun
 pl4=
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="34683043"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2020 04:14:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 23 Nov 2020 04:14:32 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 23 Nov 2020 04:14:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@nvidia.com>, <roopa@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
Date:   Mon, 23 Nov 2020 12:14:01 +0100
Message-ID: <20201123111401.136952-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend MRP to support LC mode(link check) for the interconnect port.
This applies only to the interconnect ring.

Opposite to RC mode(ring check) the LC mode is using CFM frames to
detect when the link goes up or down and based on that the userspace
will need to react.
One advantage of the LC mode over RC mode is that there will be fewer
frames in the normal rings. Because RC mode generates InTest on all
ports while LC mode sends CFM frame only on the interconnect port.

All 4 nodes part of the interconnect ring needs to have the same mode.
And it is not possible to have running LC and RC mode at the same time
on a node.

Whenever the MIM starts it needs to detect the status of the other 3
nodes in the interconnect ring so it would send a frame called
InLinkStatus, on which the clients needs to reply with their link
status.

This patch adds the frame header for the frame InLinkStatus and
extends existing rules on how to forward this frame.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/mrp_bridge.h |  7 +++++++
 net/bridge/br_mrp.c             | 18 +++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
index 6aeb13ef0b1e..450f6941a5a1 100644
--- a/include/uapi/linux/mrp_bridge.h
+++ b/include/uapi/linux/mrp_bridge.h
@@ -61,6 +61,7 @@ enum br_mrp_tlv_header_type {
 	BR_MRP_TLV_HEADER_IN_TOPO = 0x7,
 	BR_MRP_TLV_HEADER_IN_LINK_DOWN = 0x8,
 	BR_MRP_TLV_HEADER_IN_LINK_UP = 0x9,
+	BR_MRP_TLV_HEADER_IN_LINK_STATUS = 0xa,
 	BR_MRP_TLV_HEADER_OPTION = 0x7f,
 };
 
@@ -156,4 +157,10 @@ struct br_mrp_in_link_hdr {
 	__be16 interval;
 };
 
+struct br_mrp_in_link_status_hdr {
+	__u8 sa[ETH_ALEN];
+	__be16 port_role;
+	__be16 id;
+};
+
 #endif
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index bb12fbf9aaf2..cec2c4e4561d 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -858,7 +858,8 @@ static bool br_mrp_in_frame(struct sk_buff *skb)
 	if (hdr->type == BR_MRP_TLV_HEADER_IN_TEST ||
 	    hdr->type == BR_MRP_TLV_HEADER_IN_TOPO ||
 	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_DOWN ||
-	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_UP)
+	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_UP ||
+	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_STATUS)
 		return true;
 
 	return false;
@@ -1126,9 +1127,9 @@ static int br_mrp_rcv(struct net_bridge_port *p,
 						goto no_forward;
 				}
 			} else {
-				/* MIM should forward IntLinkChange and
+				/* MIM should forward IntLinkChange/Status and
 				 * IntTopoChange between ring ports but MIM
-				 * should not forward IntLinkChange and
+				 * should not forward IntLinkChange/Status and
 				 * IntTopoChange if the frame was received at
 				 * the interconnect port
 				 */
@@ -1155,6 +1156,17 @@ static int br_mrp_rcv(struct net_bridge_port *p,
 			     in_type == BR_MRP_TLV_HEADER_IN_LINK_DOWN))
 				goto forward;
 
+			/* MIC should forward IntLinkStatus frames only to
+			 * interconnect port if it was received on a ring port.
+			 * If it is received on interconnect port then, it
+			 * should be forward on both ring ports
+			 */
+			if (br_mrp_is_ring_port(p_port, s_port, p) &&
+			    in_type == BR_MRP_TLV_HEADER_IN_LINK_STATUS) {
+				p_dst = NULL;
+				s_dst = NULL;
+			}
+
 			/* Should forward the InTopo frames only between the
 			 * ring ports
 			 */
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AED72F39AB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393006AbhALTIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:08:35 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18485 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392985AbhALTIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:08:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffdf38a0002>; Tue, 12 Jan 2021 11:07:54 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Jan
 2021 19:07:42 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Jan 2021 19:07:38 +0000
From:   Eran Ben Elisha <eranbe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>
Subject: [PATCH net-next v4 2/2] net: flow_dissector: Parse PTP L2 packet header
Date:   Tue, 12 Jan 2021 21:07:13 +0200
Message-ID: <1610478433-7606-3-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1610478433-7606-1-git-send-email-eranbe@nvidia.com>
References: <1610478433-7606-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610478474; bh=eRHyyBkqspmw6dXadEu8VlOfyhY7EbksYThGhIPKQqQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=MRn1zcn0i/XnF07c3UtbgmpcC/4eSu8fmhtJ+3mX7ND7XKiWiWWyhBuoJmmaYE1H0
         0naRnszSac4zA7GNDxvPOqhoDv1/34/PpA1zJ1rPrwvKBgJ0P3xIfTChiRfJXPHPU+
         GDhvrbFRhY6boxHziwZW4xN1hsYIk/cyAdOrcwWUTXc4b4/dpEO/3Yxl4S8Ayap7Fq
         pKc0JT2KUjSHoaxaKQw+1ReAnl6YHR0oDKNaw9/MG4fhxN3jjqt2POBtNiRVSFpy0O
         RRURtvMp7BoP4s8WavoU/HRt62yZhgEWpX7jClQ+c5fJDP023XYioSaTanUa3YJ1c+
         fYo7ZrViEexKw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for parsing PTP L2 packet header. Such packet consists
of an L2 header (with ethertype of ETH_P_1588), PTP header, body
and an optional suffix.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/flow_dissector.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 6f1adba6695f..2d70ded389ae 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -23,6 +23,7 @@
 #include <linux/if_ether.h>
 #include <linux/mpls.h>
 #include <linux/tcp.h>
+#include <linux/ptp_classify.h>
 #include <net/flow_dissector.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <uapi/linux/batadv_packet.h>
@@ -1251,6 +1252,21 @@ bool __skb_flow_dissect(const struct net *net,
 						  &proto, &nhoff, hlen, flags);
 		break;
 
+	case htons(ETH_P_1588): {
+		struct ptp_header *hdr, _hdr;
+
+		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
+					   hlen, &_hdr);
+		if (!hdr) {
+			fdret = FLOW_DISSECT_RET_OUT_BAD;
+			break;
+		}
+
+		nhoff += ntohs(hdr->message_length);
+		fdret = FLOW_DISSECT_RET_OUT_GOOD;
+		break;
+	}
+
 	default:
 		fdret = FLOW_DISSECT_RET_OUT_BAD;
 		break;
-- 
2.17.1


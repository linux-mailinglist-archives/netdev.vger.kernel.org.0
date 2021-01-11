Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4382F0F6D
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbhAKJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:48:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1948 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbhAKJs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:48:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc1ec40002>; Mon, 11 Jan 2021 01:47:48 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 09:47:46 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 09:47:43 +0000
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
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next v2 2/2] net: flow_dissector: Parse PTP L2 packet header
Date:   Mon, 11 Jan 2021 11:46:52 +0200
Message-ID: <1610358412-25248-3-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
References: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610358468; bh=lObJbASHXKKjOEQYPTDuANV7rlY0GCChQO5bCNMDWcI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=RNmamHkbvJaZvpZ74dIBfhd8pa5qtzGIwssvpxvKJIG0AHrDmX9zXidudDH4DNygS
         PT1GdJbcUQKgOeCRxoG79c+PGsffiS7dltWwpfRk3Uvt/n7y5hpdQlXMTR+A6jtT5b
         hnboVPyxcY4WnpuVXMsfkApuWa5g98oRk1BVvIl6EUFWhO0RVhwnwq8hWI4VnfsDlX
         VM6jo6pPk+28YDYUviHg5Cyx9bTCN9PKGvfhQaPsZP/iVRohuErgLkb4DrObrGGDlx
         4UW1d2g0LYe1fiz5q7EeP5VgclchIOchFo6lbvfwF51BnofHrasRENsGnF4Yc2J0Sz
         OqoyyAukE2ciQ==
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
index 6f1adba6695f..fcaa223c7cdc 100644
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
+		if (!hdr || (hlen - nhoff) < sizeof(_hdr)) {
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


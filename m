Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE26A2ECFFB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 13:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbhAGMjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:39:49 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14884 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbhAGMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:39:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff700ec0000>; Thu, 07 Jan 2021 04:39:08 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 12:39:08 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 12:39:06 +0000
From:   Eran Ben Elisha <eranbe@nvidia.com>
To:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next 2/2] net: flow_dissector: Parse PTP L2 packet header
Date:   Thu, 7 Jan 2021 14:39:00 +0200
Message-ID: <1610023140-20256-3-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
References: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610023148; bh=lObJbASHXKKjOEQYPTDuANV7rlY0GCChQO5bCNMDWcI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=qXiIzSfCKaIlVmnOjMQQvlaVwVm7TLX/GiUXlvgz9pIgx/1jocBJJ4P8fTZfV1FCw
         yUIkNPxKbKgzqNCNrYo+C0lyIw02RROowiFAEfrVpiqO44pPKgV90B/P2ASP/pmbCs
         Zl5QfmdparxVVO4Mdf03wOBs6ltuEzCLNiCxXtqPh9sBS6vQ8EYyI0q5qCZQfTWueX
         PqPNz3xBAdk57p/1gzgV3G1LRqdXtr6PM6jYYXYCN5lHWgJ7NbNTh/uI2HOLIJgnMU
         F56XQPuEFPnXg0hBgXH2DCEbnARRECplweYTS4IaON2l/ZvdmEJez42S+duzCOMp33
         6fivd0x5Y/UIA==
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


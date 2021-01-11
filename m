Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6252F1DD5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390323AbhAKSS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:18:57 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7207 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390313AbhAKSS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:18:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc96670001>; Mon, 11 Jan 2021 10:18:15 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 18:18:13 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 18:18:10 +0000
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
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH net-next v3 2/2] net: flow_dissector: Parse PTP L2 packet header
Date:   Mon, 11 Jan 2021 20:17:48 +0200
Message-ID: <1610389068-2133-3-git-send-email-eranbe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1610389068-2133-1-git-send-email-eranbe@nvidia.com>
References: <1610389068-2133-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610389095; bh=lObJbASHXKKjOEQYPTDuANV7rlY0GCChQO5bCNMDWcI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type;
        b=HrkAm6M03K571ys+9/hUNL3NwLKW9d0BTXTO9ieyitxXy5z2kv7wslZWsxQnUj8Xd
         uluKfxKnNL6CpCc4NjHrYEyjOFPin2kfg8hVBkzw0YurQQgY2t+2OwHgCrlEjABQvY
         S0qKG1cElJt+QNuh5znqkIS0lwiO6iptbLVpTRuY3TTXaj7SaejI+8ZdiFnPn7jQOA
         AkcDNT9FD9bvGyFpbxXiByuN08Xcnd9My09eJE258o/quoOrhDKudmgLs3iMfZgq77
         soQWQe9mIpJb8WRn0LZkb3ldti8gEhvPtlsOnmpikUVP9uk8+I1GUrWL4/mLNl2iXh
         7jQrcS6NCmU4g==
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


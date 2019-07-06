Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7861130
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfGFOzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 10:55:44 -0400
Received: from mail-yw1-f48.google.com ([209.85.161.48]:34122 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfGFOzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 10:55:43 -0400
Received: by mail-yw1-f48.google.com with SMTP id q128so3469179ywc.1
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 07:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L2lnu0/zJWQ4oznV2r074DRPHDYnXLsbpeIU/l6oa2E=;
        b=MgJdeidyrdgA+63aG14sTUSvf0DUTgdVKugs+ioyRWEx9BxPDIJi+mCtfbJMaW/usU
         O3QJ4t5gEqyo4XMdaRH4UAdkJKJ2+TdgcErs30d+EX+/DwnErjSthc+i9i8bnSmKq26Y
         /3Q+zVkZDVjz04YWFl/zL6JX0r1G2M/AcBGM45SvKfHO/SltDLL+QfMeIoyZVSPR3PP3
         I07eR1u5u6Di58Z32jEE+OCqIbf0To0stlGVM6Ogz9GyIF5PoY6Nz58xjMl9Jj9SQCej
         LlXG2L0VGO/oP9Ont3rmOY2yR5vCi29Z/NqM9GemJwnafTmYVy6N7vufMj+X3tkpes/F
         zAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L2lnu0/zJWQ4oznV2r074DRPHDYnXLsbpeIU/l6oa2E=;
        b=S3bxIJ6v0j44s8KnaIKH3KtdMvn3u3DyQkm7MiPkS596mMGpHFCVJ9toLfpB/DLYCN
         sGZoXVzlgrj0JPDrWmP2hQhANqV0KP6dwc9XVTEk/lE7Lhv6K+AUPfKaHO/U0g6eCEhf
         CBhBICo4nvtIOqGwTzS+nMrX26TGifVDFaXRkAE/MZlWeTthCsq7ek+WFkRnG5caQ0Tp
         k1W9uulQCfCTXTV5r8OE36oocYnbFepXHWUuvWNKrJQLLI67LJC95BpSkGLmWUuIvHCW
         S7146WtZrjqEuPmLArTAIKApQ0nysyAs+NzRWVUZ/tG8eDu0MJq91HX+vn7yoSRm/2ug
         A0AA==
X-Gm-Message-State: APjAAAX2RfAyGq9KKG+YEEUwyETUM/Ih0kTQa8kllNDgARcAdgQnTP9r
        HTwXjOXUzg3PaBA+lLEFvmIG0fhzrw==
X-Google-Smtp-Source: APXvYqyQBNKWuyNaMOaZSMkKOq/ynn9Rub+xPFmhcDiAT9uHhtiv7eV/d4IywOINAcYrcHTmpz4sMQ==
X-Received: by 2002:a81:bd54:: with SMTP id n20mr6257835ywk.507.1562424942904;
        Sat, 06 Jul 2019 07:55:42 -0700 (PDT)
Received: from localhost.localdomain (75-58-56-234.lightspeed.rlghnc.sbcglobal.net. [75.58.56.234])
        by smtp.gmail.com with ESMTPSA id q63sm4586361ywq.17.2019.07.06.07.55.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 07:55:42 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next v2 2/3] ipv6: Support multipath hashing on inner IP pkts
Date:   Sat,  6 Jul 2019 10:55:18 -0400
Message-Id: <20190706145519.13488-3-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190706145519.13488-1-ssuryaextr@gmail.com>
References: <20190706145519.13488-1-ssuryaextr@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the same support as commit 363887a2cdfe ("ipv4: Support multipath
hashing on inner IP pkts for GRE tunnel") for outer IPv6. The hashing
considers both IPv4 and IPv6 pkts when they are tunneled by IPv6 GRE.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 Documentation/networking/ip-sysctl.txt |  1 +
 net/ipv6/route.c                       | 36 ++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index f0e6d1f53485..48c79e78817b 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1473,6 +1473,7 @@ fib_multipath_hash_policy - INTEGER
 	Possible values:
 	0 - Layer 3 (source and destination addresses plus flow label)
 	1 - Layer 4 (standard 5-tuple)
+	2 - Layer 3 or inner Layer 3 if present
 
 anycast_src_echo_reply - BOOLEAN
 	Controls the use of anycast addresses as source addresses for ICMPv6
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 39361f57351a..4d2e6b31a8d6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2370,6 +2370,42 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
 		break;
+	case 2:
+		memset(&hash_keys, 0, sizeof(hash_keys));
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		if (skb) {
+			struct flow_keys keys;
+
+			if (!flkeys) {
+				skb_flow_dissect_flow_keys(skb, &keys, 0);
+				flkeys = &keys;
+			}
+
+			/* Inner can be v4 or v6 */
+			if (flkeys->control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+				hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+				hash_keys.addrs.v4addrs.src = flkeys->addrs.v4addrs.src;
+				hash_keys.addrs.v4addrs.dst = flkeys->addrs.v4addrs.dst;
+			} else if (flkeys->control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+				hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+				hash_keys.addrs.v6addrs.src = flkeys->addrs.v6addrs.src;
+				hash_keys.addrs.v6addrs.dst = flkeys->addrs.v6addrs.dst;
+				hash_keys.tags.flow_label = flkeys->tags.flow_label;
+				hash_keys.basic.ip_proto = flkeys->basic.ip_proto;
+			} else {
+				/* Same as case 0 */
+				hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+				ip6_multipath_l3_keys(skb, &hash_keys, flkeys);
+			}
+		} else {
+			/* Same as case 0 */
+			hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+			hash_keys.addrs.v6addrs.src = fl6->saddr;
+			hash_keys.addrs.v6addrs.dst = fl6->daddr;
+			hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
+			hash_keys.basic.ip_proto = fl6->flowi6_proto;
+		}
+		break;
 	}
 	mhash = flow_hash_from_keys(&hash_keys);
 
-- 
2.17.1


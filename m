Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18205E7A3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfGCPUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:20:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34552 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:20:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so1623103qtu.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 08:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8WIVEWBVuVcGenXfntJ2ghJStUF/PzJ0C8/POtjJKas=;
        b=IOvc3m+EGl272/up8uj4ZeHg3GXLFjZ1gsxnCD7QLh7Lpacy3fk/kicN58N5ObAfPZ
         mectZK6pX9I5z2GGch6+HqDwuJIbVlKgVaaP+Ns2EamrHNSu+t9QfoTqZseyC1Ze2Fwb
         J+EvaAGsZzScVaZJHfVj/vyiiWQWN4RgKVSXDkoP3pEYAVRSgbtYuNvI/nXDNQKbNGZw
         aGu42YEkYVEZaCezw/DEz8WUCPmrGzPngqrWR1oL8u58VW4lWS2ZPApjTa9StkXxxxcH
         EIcXReVuO4Ck3D50MMXx1QFjz+3bhoX6xLoldz/uD8vhbjb7H9R+89Gux/+1aFjNVA2l
         p4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8WIVEWBVuVcGenXfntJ2ghJStUF/PzJ0C8/POtjJKas=;
        b=c5ubl7fJ/v0zJyywCHoxqvznNePRYZnUh4qc65RRyM3q4QLk9Q1+87S5MyKktGy9jv
         Ynx2oEuSqU1UD4/vt6D4hOZBEVM3ekTDm7pTKquGRjNDWNqT8zHzNuPBuR34JcS6MtQm
         HH27ogaxSusa1O+JL5fnHIVAx/xwrCt1gLEwrCJ5XL0lb8a7nRS3CZG3zB0lVSU95EqT
         qBVWi9xddIsd7d+j7GLTENTdvjSY5+SQRpLHoKG3tZwOEei/AWmzz1Fv3eGmXBk5UiUA
         pFrkJ/OYcFIV8m0jyeYEL8VihpxsC5w3N/8AjdsvJB53chMt7t62db3vGOvHYNjfM9gu
         oHUQ==
X-Gm-Message-State: APjAAAVB/MQav8BQiIqUIANEFs4lIITNVVftrDYe+nslRXw3peYg6zHS
        QfbQCPumGvfMc1tBVq6Fp6eWIGzTdA==
X-Google-Smtp-Source: APXvYqxKA+Bao7RK9bmh8zMjH5c1qncNspaX+BTQeEhOqxzbvkEKXkFWPA996c95bu4SxyGNK5E+7Q==
X-Received: by 2002:a25:be06:: with SMTP id h6mr15650992ybk.80.1562167203325;
        Wed, 03 Jul 2019 08:20:03 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id 73sm1243303ywd.88.2019.07.03.08.20.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 08:20:02 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next 1/3] ipv4: Multipath hashing on inner L3 needs to consider inner IPv6 pkts
Date:   Wed,  3 Jul 2019 11:19:32 -0400
Message-Id: <20190703151934.9567-2-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703151934.9567-1-ssuryaextr@gmail.com>
References: <20190703151934.9567-1-ssuryaextr@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 363887a2cdfe ("ipv4: Support multipath hashing on inner IP pkts
for GRE tunnel") supports multipath policy value of 2, Layer 3 or inner
Layer 3 if present, but it only considers inner IPv4. There is a use
case of IPv6 over GRE over IPv4, thus add the ability to hash on inner
IPv6 addresses.

Fixes: 363887a2cdfe ("ipv4: Support multipath hashing on inner IP pkts for GRE tunnel")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/ipv4/route.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dc1f510a7c81..abaa7f9371e5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1964,17 +1964,30 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		break;
 	case 2:
 		memset(&hash_keys, 0, sizeof(hash_keys));
-		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		/* skb is currently provided only when forwarding */
 		if (skb) {
 			struct flow_keys keys;
 
 			skb_flow_dissect_flow_keys(skb, &keys, 0);
-
-			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
-			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+			/* Inner can be v4 or v6 */
+			if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+				hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+				hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+				hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+			} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+				hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+				hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+				hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+				hash_keys.tags.flow_label = keys.tags.flow_label;
+				hash_keys.basic.ip_proto = keys.basic.ip_proto;
+			} else {
+				/* Same as case 0 */
+				hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+				ip_multipath_l3_keys(skb, &hash_keys);
+			}
 		} else {
 			/* Same as case 0 */
+			hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
 		}
-- 
2.17.1


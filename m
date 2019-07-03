Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA35E7A4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfGCPUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:20:07 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42250 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:20:07 -0400
Received: by mail-qt1-f195.google.com with SMTP id h18so1560125qtm.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 08:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6riZ+8nhdoBEaPPLXbxGihzxEoZANhk8fHj+pZxNhto=;
        b=aX4QUiGDeFdA0/j9TFcatYFc81cZGmhoXA8aN6MuamJ76YVn9iTJrk6+XzNrQUmXJt
         Xe0/fBMzMg8VqQqg/4Ycuon6PFWc2slfRmCwamLl8Ara+s8PQES7KY3faDW9v7VX4YxM
         3KEpkU4QZYngFb9my/EejEO3cTdnkQ5fcY6YZetoeXEsFfUzezzID2UYgstKnFCuXIYy
         r/T+rPbtybX07jWfEmw4NWbNr+eSZKGu9Nhyx5LogqpZk4cV7ts3dAu6Vva/cYdvD1lr
         Zu3hu4qJfsj4/5wdPG/GaIoydzsZWSmB5ZWzHj2gPyI2AlC/UJAL+XCqtwjs6DC6CzlB
         luSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6riZ+8nhdoBEaPPLXbxGihzxEoZANhk8fHj+pZxNhto=;
        b=aDASnWuJ7qM0jGrfJhxgHsjz+jFKM7xU/CZx19HtHgd8K54y5RLB5mpwqEB04rrhJO
         k/u+OJ7n3GCHERWt/Hv6ChaIB3Hy3SpSwALWr3W4V/JRWdzFiDr0c9cuRwfNaYqxlOYX
         MSuQSUivhHZ8zw6M+h6uszsjuG8RM9QRJ9rNkfpU1F0Md35YUKSQNe+0r/bSSThXY2Jk
         quOiyUBTVPlIoslrL8f9Srrum5hwflrRbW+Pjto+wOyE1wtd35+IiI5/W6szw1iKrxj9
         FOxvADd3qq+P2rVKKYLNmTzfvQCT1tZMVyRFCbz9xWbhSyd6wWnxyvTzCaYjbtz0NYCm
         JuBg==
X-Gm-Message-State: APjAAAW4oXqADNIKBPk0DBPt1KqIcJkQYQnXF842BRpM1nJN58XoTnVe
        qCxRkk3fgm7dap1ulaCW0oK5YNzuRg==
X-Google-Smtp-Source: APXvYqyXauzN+/8gfsoIfdUXUVGZHBm5o7VetpYURdzJPbKIVAubablttm3/+yoCk0Vcwc4A3UiZ5Q==
X-Received: by 2002:a81:308b:: with SMTP id w133mr23031191yww.12.1562167206315;
        Wed, 03 Jul 2019 08:20:06 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id 73sm1243303ywd.88.2019.07.03.08.20.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 08:20:05 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next 2/3] ipv6: Support multipath hashing on inner IP pkts
Date:   Wed,  3 Jul 2019 11:19:33 -0400
Message-Id: <20190703151934.9567-3-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703151934.9567-1-ssuryaextr@gmail.com>
References: <20190703151934.9567-1-ssuryaextr@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the same support as commit 363887a2cdfe ("ipv4: Support multipath
hashing on inner IP pkts for GRE tunnel") for outer IPv6. The hashing
considers both IPv4 and IPv6 inner pkts.

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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13896112F
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfGFOzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 10:55:42 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45581 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfGFOzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 10:55:42 -0400
Received: by mail-yw1-f68.google.com with SMTP id m16so3434388ywh.12
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 07:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FrcqR+x/T0FHnAvk5QuMcNg+0Qq9PIKhmvLXtxVB26w=;
        b=UFG2Oh0VSW/pDhzWdrzxtlTd6zCubSpcfEnnC9l25zYnRJuXxomd4e7K7n7IoZYgQr
         uFeVOWDTB6kRuRQIm+hiFqZT8ILVLvbGmJSDpGmJOTEVlZWQDKklWuutNRirtpJMEKKI
         5uOXrIhbPtRob59yepMJxA4M4VCP14hFYGU0yxG+PjSClxp9Nrh/ByzXYk8S3OFGkLYF
         Ed77rWiBvG4O/aZto0p7bF1v1CCmgSe9IpuzLCeyzaodYTNNaZWrdg38l2DqHmpnDC1e
         lwwtyk6ENEsirI0clbrkLSQJLSIAm/mWOW/9RO6gIjuOVh1dpeJrixVPGxvA3nd4OOtl
         bo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FrcqR+x/T0FHnAvk5QuMcNg+0Qq9PIKhmvLXtxVB26w=;
        b=iMIKFnJ3E0WS2RrppZ9Fdk0bvHFA0IsfnuQBTQbEMDRVRxnhw3oqr/xB5N5zf4T1BC
         MYDry+UGhErYvOa1uG5h2x7YkOK5xZEnaVYKwNROmFr4roPBWJmRe3BqLLOf+FE2Q4qx
         IK8W2LIaLBV8RZmpuCuDeLw1M3PZx55duwVPtvYbZcchcAuBCc/hHPFbIJ0sKYmSxqfg
         eqzxgbeiHCaYeVlplHQG5HZVVseMP8ZnoSvykjC3y6DRLyGSxQ9i8aCWTTZx3n7wNqTI
         rsHIYmE+yrqdcoTYsauv7y7DE7Rl7msGZqrG+EvRifMhTFeqJxa5PF7x47Cmk182gtVH
         4yOw==
X-Gm-Message-State: APjAAAXRZeM/rryVk/Y/zy076VQ2gYmAI+wDwQcsaZ+qAvXTc3dpq12R
        uZ6NMNrBv+X4CzcXyc1etIkec6QwoQ==
X-Google-Smtp-Source: APXvYqwORA+/KZtkS+BsoMQ41HRVoWMjStHhADlGv0aI096WTKh4/zdyVqsntjo0Xqt6216F5G0w5Q==
X-Received: by 2002:a81:9b83:: with SMTP id s125mr6176967ywg.249.1562424941247;
        Sat, 06 Jul 2019 07:55:41 -0700 (PDT)
Received: from localhost.localdomain (75-58-56-234.lightspeed.rlghnc.sbcglobal.net. [75.58.56.234])
        by smtp.gmail.com with ESMTPSA id q63sm4586361ywq.17.2019.07.06.07.55.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 07:55:40 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next v2 1/3] ipv4: Multipath hashing on inner L3 needs to consider inner IPv6 pkts
Date:   Sat,  6 Jul 2019 10:55:17 -0400
Message-Id: <20190706145519.13488-2-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190706145519.13488-1-ssuryaextr@gmail.com>
References: <20190706145519.13488-1-ssuryaextr@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 363887a2cdfe ("ipv4: Support multipath hashing on inner IP pkts
for GRE tunnel") supports multipath policy value of 2, Layer 3 or inner
Layer 3 if present, but it only considers inner IPv4. There is a use
case of IPv6 is tunneled by IPv4 GRE, thus add the ability to hash on
inner IPv6 addresses.

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


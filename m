Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FD74334F9
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJSLsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:48:39 -0400
Received: from smtp.skoda.cz ([185.50.127.80]:30765 "EHLO smtp.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhJSLsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenaugust2021; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1634643983; x=1635248783;
        h=From:Sender:Reply-To:Subject:Date:Message-Id:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BfUGf+csuep2R7t6ErvxRti5DnxQTWqxNrD3CjGmwMU=;
        b=UIWXH0N0bbzZbEq4ZZZ3RQBf/riAYWAWfs2kOsc1WnNSj+HbU/PxPoiD3nwAYZ4Y
        JNNuliBJPD6HSNf4dk81qoauQR0gu4PvMFX0ftT32eX3aErR9iFHR2aX0x6xH9CZ
        pWYjy8zjWFETbU4scKdcaENVZGqIYcYoUUByxxhrd03MwKyiIFWhLpf8wv5tzMbG
        5RStUhzJBwae+dlqJL8kXxHDMEUKQ4DkTmXJduEnyaOcb4aAhP9KL+ObGTY7N/+M
        pNDLefBxQm8Yd4uVkxor+xcNX0illKr5SJO/ZeCNXKB5dBlmIZzzrKu/uCdKS0sk
        1/bXO/II4KsQokkAY9d11A==;
X-AuditID: 0a2a0137-1666f70000011b28-20-616eb00f1158
Received: from trnn1532h.skoda.cz (Unknown_Domain [10.181.12.28])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp.skoda.cz (Mail Gateway) with SMTP id F2.80.06952.F00BE616; Tue, 19 Oct 2021 13:46:23 +0200 (CEST)
From:   Cyril Strejc <cyril.strejc@skoda.cz>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Cyril Strejc <cyril.strejc@skoda.cz>
Subject: [PATCH] net: multicast: calculate csum of looped-back and forwarded packets
Date:   Tue, 19 Oct 2021 13:44:41 +0200
Message-Id: <20211019114441.1943131-1-cyril.strejc@skoda.cz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsXCtZVHRpd/Q16iwaebahZ7X29lt5hzvoXF
        4sK2PlaLYwvEHFg8tqy8yeSxaVUnm8eLGxdZPT5vkgtgieKySUnNySxLLdK3S+DKWD7jAnPB
        CZGKplcHmRsYnwh0MXJySAiYSLxtf8raxcjFISQwm0li+bYpbCAJNgEtibmdk5lBbBGBAImu
        3e1MIDazgJPEtFnXgGwODmGBEImL9+VBwiwCqhLv5t5gBLF5BWwkVr6eywIxX15i5qXv7BBx
        QYmTM5+wQIyRl2jeOpt5AiP3LCSpWUhSCxiZVjHyFueWFOgVZ+enJOolV21iBAWGFqP5DsYb
        p9wOMTJxMB5ilOBgVhLhPdaelyjEm5JYWZValB9fVJqTWnyIUZqDRUmc132uTqKQQHpiSWp2
        ampBahFMlomDU6qBsWDfhYDFfFdUrIIlVm6w+Dq7fm3QoTz3nr3iG/4a2CdsWdQU96lIle07
        a+vMRcfiLh7q/HX9/M7Pplv3RU/Jis67eM4iUOvCk/caH0SmOxfI/V+5PO1sc0ixzeZtLWsZ
        HkxZfap59sKk3MQrRbyR5Z3pN+VsOGcKWH/l9rz72NOxdLGRVfz6W0osxRmJhlrMRcWJAIx6
        wJr6AQAA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During a testing of an user-space application which transmits UDP
multicast datagrams and utilizes multicast routing to send the UDP
datagrams out of defined network interfaces, I've found a multicast
router does not fill-in UDP checksum into locally produced, looped-back
and forwarded UDP datagrams, if an original output NIC the datagrams
are sent to has UDP TX checksum offload enabled.

The datagrams are sent malformed out of the NIC the datagrams have been
forwarded to.

It is because:

1. If TX checksum offload is enabled on an output NIC, UDP checksum
   is not calculated by kernel and is not filled into skb data.

2. dev_loopback_xmit(), which is called solely by
   ip_mc_finish_output(), sets skb->ip_summed = CHECKSUM_UNNECESSARY
   unconditionally.

3. Since 35fc92a9 ("[NET]: Allow forwarding of ip_summed except
   CHECKSUM_COMPLETE"), the ip_summed value is preserved during
   forwarding.

4. If ip_summed != CHECKSUM_PARTIAL, checksum is not calculated during
   a packet egress.

We could fix this as follows:

1. Not set CHECKSUM_UNNECESSARY in dev_loopback_xmit(), because it
   is just not true.

2. I assume, the original idea behind setting CHECKSUM_UNNECESSARY in
   dev_loopback_xmit() is to prevent checksum validation of looped-back
   local multicast packets. We can adjust
   __skb_checksum_validate_needed() to handle this as the special case.

Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>
---
 include/linux/skbuff.h | 4 +++-
 net/core/dev.c         | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 841e2f0f5240..95aa0014c3d6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4048,7 +4048,9 @@ static inline bool __skb_checksum_validate_needed(struct sk_buff *skb,
 						  bool zero_okay,
 						  __sum16 check)
 {
-	if (skb_csum_unnecessary(skb) || (zero_okay && !check)) {
+	if (skb_csum_unnecessary(skb) ||
+	    (zero_okay && !check) ||
+	    skb->pkt_type == PACKET_LOOPBACK) {
 		skb->csum_valid = 1;
 		__skb_decr_checksum_unnecessary(skb);
 		return false;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ee9fecd3aff..ba4a0994d97b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3906,7 +3906,6 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb_reset_mac_header(skb);
 	__skb_pull(skb, skb_network_offset(skb));
 	skb->pkt_type = PACKET_LOOPBACK;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	WARN_ON(!skb_dst(skb));
 	skb_dst_force(skb);
 	netif_rx_ni(skb);
-- 
2.25.1


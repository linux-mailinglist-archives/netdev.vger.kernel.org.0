Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369C049BE40
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiAYWMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiAYWMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:12:31 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683AEC06173B;
        Tue, 25 Jan 2022 14:12:31 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d12-20020a17090a628c00b001b4f47e2f51so3024574pjj.3;
        Tue, 25 Jan 2022 14:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Yoct/VPi8jO4D/aE/BTbIZHXj0319KiEEnpzVlWesc=;
        b=NdJsKEOryeOjv55P/Tg1skfzUozfpfJ96/zwSoGpshVNSf8710X9EeTECXaJzizESG
         NEynU3wFfTM8IeLHt1XIw0VxzJyPge2pKzMDApLeocReSiIDdySmrKoYyC79z24YdAbw
         DuQHLQaEVBQajp0juWw36libRC6KC8eErpRjoEpnLxhRD5xYfCP5p8Qbl1ipkpVft5in
         p7E6Ab/nYiiUziawFyQJ6EoOr0OxGkkqgu3DoORZ9gaC39YRA2tPBqt7FoE2xwDLxkmu
         aZeJMiOm0bEknBFJVo1YZwAoHPKoCQOBCUtAUPOqsGNIW5fEHvrYJ5qAg/I53mcx96K3
         ZbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Yoct/VPi8jO4D/aE/BTbIZHXj0319KiEEnpzVlWesc=;
        b=1Dy753UMtoErmR8QdZONaP4tBCPK2wrWuvbb2qy6KRhXk2vQgZ1sepfgAi9MbIklso
         3vNlfVpsT/CxeJNVRs5NNq9mwU8lqm3Qws86u1nMR+hwB/hROlIo/QDGXmJg9JcNXw3b
         Azq11w6WfTr1v6/40G5wB9YbLLKH2A/V5fULUheEJXnMcZyQB8YiV3zsyKjkVRviJZt8
         FBxd+UfJc7Tp1TZVN2K+OIDbg7BlObp9xPFzTaV9WeWY/Rmc3qF2Wsr8eRMNPtm/T1Vl
         cx5Kxi44jjYnxe1e+zxa2WmhGEPGA5k+nNdtXC7C5Posf0sNG1I+i3FrYG22YUahdqqv
         U9Lw==
X-Gm-Message-State: AOAM5315T5/4qiZL9HFkJB+TGXL206KLY7FgUc2ExM+x7s94xi641lZI
        d8abGLyC+jsOxWLt3f0iVmN66EBypvI=
X-Google-Smtp-Source: ABdhPJwFyyb6PnmCgIP2b2dxTy7MQtCoNk1TASRxCjYSPHT75cyJXbe/A/BcNx0Ffv3ulyFRvAAr3Q==
X-Received: by 2002:a17:902:ecca:b0:14b:4bef:a2c7 with SMTP id a10-20020a170902ecca00b0014b4befa2c7mr11637882plh.25.1643148750906;
        Tue, 25 Jan 2022 14:12:30 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id q13sm23811pfj.63.2022.01.25.14.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 14:12:30 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jeffreyji <jeffreyji@google.com>
Subject: [PATCH v3 net-next] net-core: add InMacErrors counter
Date:   Tue, 25 Jan 2022 22:12:14 +0000
Message-Id: <20220125221214.2480419-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jeffreyji <jeffreyji@google.com>

Increment InMacErrors counter when packet dropped due to incorrect dest
MAC addr.

An example when this drop can occur is when manually crafting raw
packets that will be consumed by a user space application via a tap
device. For testing purposes local traffic was generated using trafgen
for the client and netcat to start a server

example output from nstat:
\~# nstat -a | grep InMac
Ip6InMacErrors                  0                  0.0
IpExtInMacErrors                1                  0.0

Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
counter was incremented.

Change-Id: If820cc676807ba8438a9034873df3ef2e0b07213
Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 include/linux/skbuff.h    |  1 +
 include/uapi/linux/snmp.h |  1 +
 net/ipv4/ip_input.c       |  7 +++++--
 net/ipv4/proc.c           |  1 +
 net/ipv6/ip6_input.c      | 12 +++++++-----
 net/ipv6/proc.c           |  1 +
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf11e1fbd69b..04a36352f677 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_BAD_DEST_MAC,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..ac2fac12dd7d 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -57,6 +57,7 @@ enum
 	IPSTATS_MIB_ECT0PKTS,			/* InECT0Pkts */
 	IPSTATS_MIB_CEPKTS,			/* InCEPkts */
 	IPSTATS_MIB_REASM_OVERLAPS,		/* ReasmOverlaps */
+	IPSTATS_MIB_INMACERRORS,		/* InMacErrors */
 	__IPSTATS_MIB_MAX
 };
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..379ef6b46920 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -441,8 +441,11 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
-		goto drop;
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP_INC_STATS(net, IPSTATS_MIB_INMACERRORS);
+		kfree_skb_reason(skb, SKB_DROP_REASON_BAD_DEST_MAC);
+		return NULL;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f30273afb539..dfe0a1dbf8e9 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -117,6 +117,7 @@ static const struct snmp_mib snmp4_ipextstats_list[] = {
 	SNMP_MIB_ITEM("InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("InCEPkts", IPSTATS_MIB_CEPKTS),
 	SNMP_MIB_ITEM("ReasmOverlaps", IPSTATS_MIB_REASM_OVERLAPS),
+	SNMP_MIB_ITEM("InMacErrors", IPSTATS_MIB_INMACERRORS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..f6245fba7699 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -149,15 +149,17 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	u32 pkt_len;
 	struct inet6_dev *idev;
 
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
 	rcu_read_lock();
 
 	idev = __in6_dev_get(skb->dev);
 
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
+		rcu_read_unlock();
+		kfree_skb_reason(skb, SKB_DROP_REASON_BAD_DEST_MAC);
+		return NULL;
+	}
+
 	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1..76e6119ba558 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -84,6 +84,7 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
 	SNMP_MIB_ITEM("Ip6InECT1Pkts", IPSTATS_MIB_ECT1PKTS),
 	SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
+	SNMP_MIB_ITEM("Ip6InMacErrors", IPSTATS_MIB_INMACERRORS),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.35.0.rc0.227.g00780c9af4-goog


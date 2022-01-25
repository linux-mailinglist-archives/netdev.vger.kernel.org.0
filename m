Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0EE49BF7D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiAYXYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiAYXY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:24:29 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5E4C06161C;
        Tue, 25 Jan 2022 15:24:29 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y27so17004729pfa.0;
        Tue, 25 Jan 2022 15:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldrIHSuoitTmqDps+qlz0yStyba+Nz8DF584SMyBAIM=;
        b=o2FWsY8WcYyNXyDU/qOrKqlUJAtqP0eqYNaeBU3SwukiSbGzyMxs6Houlv/aKPHxGv
         n//EeosKvynf8nImBRk51dJsDuEHpCn1TrXWmL/yt+165edSJd1X2IPb8yDZZX+MnRKl
         RqBxysSTHRvcXdwcH86YPuMbfbuT3y/VU1xLrNLCWLlAL7yaUr7h8xBahGbgvnCJqA0u
         s4f9t6JlRHlyKqkS7aVKG4romKjwPw8D9l1WMi4/3S4TwYduBVx3hb+yuV/zPhnBBYZ4
         tVtj5EBBdgPJcKGC9+ML7z6BxqYjdIrU/YbYlv7rwMabo4SyYZgZFkYyBDlAvWPfakuo
         rtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldrIHSuoitTmqDps+qlz0yStyba+Nz8DF584SMyBAIM=;
        b=x1mc0Qv4WA5Ps975AGFyCVDxi3LCBGPyJ2n+ngaSss6iNH7y75t+UwRRroPzYcaHOV
         xCD54L6yHQI/XyfJUIY274RpD7RzA/VMKXvcXjuOMqV13CuUMkfBhAFLKYKyHbg+eb9w
         hLSoQKugjSpJItnN2PIMiPzPred+sU5wLZouGY+kRr9qL89/C5NzJgsIYJmjW8zfSRVP
         5Zu8106HmAKJh1LJicueyJHaLgo/7vWyMwCMkQ3NBAvHFTqAERESoHGbMG90ktAx2Xjm
         zdg7DZd2JqOU1aUZsSAJr2PbYarRkFBABztgf3ie9CxCDtvn9fd6XDuJbMZvWzu+M719
         UNPA==
X-Gm-Message-State: AOAM531We7qSN0grSK5uneFnaDMGxKp7ls8558/7IP0WtYvBCQpCIUDK
        jO+vi7UiTvzDWJ3+5yGSz+OHoRSfA/U=
X-Google-Smtp-Source: ABdhPJxYXlEwmZ1j9HgzDeUmGyPGrWIsPUqNl8QAcys2EX6MDQ7dlb6i2HwVEzA8u0ldQRcafpfB5A==
X-Received: by 2002:a63:7543:: with SMTP id f3mr16782370pgn.360.1643153069184;
        Tue, 25 Jan 2022 15:24:29 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id p20sm15725577pgm.88.2022.01.25.15.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 15:24:28 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jeffreyji <jeffreyji@google.com>
Subject: [PATCH v4 net-next] net-core: add InMacErrors counter
Date:   Tue, 25 Jan 2022 23:24:24 +0000
Message-Id: <20220125232424.2487391-1-jeffreyji@google.com>
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

Changelog:

v3-4:
Remove Change-Id

v2:
Use skb_free_reason() for tracing
Add real-life example in patch msg

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


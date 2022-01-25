Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9731B49BBC1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiAYTHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiAYTH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:07:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2A9C06173B;
        Tue, 25 Jan 2022 11:07:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h14so3441156plf.1;
        Tue, 25 Jan 2022 11:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IRE2e5mJ5IWCI8KpoKFdytUbHIOS9Xek3Lc4GKVdRv0=;
        b=mu8dDOVFvi6fLiMUGa7Jx/kf54Mh4RIhN9JIC9rt3tUuHUTpMKsE+c47zNVy275YT6
         JPlU7IJlWZUpOlTjW22Q/+l8B7L/zgAOxeKKPQdg+5PB+Fy51QZKm6XDJkAyIkJ747W5
         shoSPSixw1oA7HUcxjepg4p4icu6/HQor5sZds+kTle0hMscWHn2qqR+08PjWlLuNnf3
         RpmddLLuxVoMTEAOvYKGKTr0jZcPdz6hJpwdGiX3q7zAV5uJ5XVrfKGzkoGFKvJykUNr
         hT3/pFTYAVe4WASwCMB9hzu85k0bfcNpjB6bTyQ3L2uKNC1eyk9ujjQ4C7IaHYojm549
         TwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IRE2e5mJ5IWCI8KpoKFdytUbHIOS9Xek3Lc4GKVdRv0=;
        b=dzgNIYBQE7aZGKwI/+lxs8ylQ9TCEb7MaILQjOcRS9Oa74rXQthQPdKWpta8gFHuih
         0Cn7ml9y8a6o+bQinKQugU0mm1+YWbg9h3tte6jkCqppNiSsqqmSrpKtVJ1/WN4nzp7y
         zH1DdPHMQoYggK3d/w/GtXHaks8/khmFHx0oAfuVQvq5Z4o613ZXpD1tuxunDV+Y8EVX
         VBfArjYt7T+cSJOoqUDopcKLdE7vu5wpVvqpBog3r/9xnlZf95ma2JVVY665abvemgLl
         9FTQaXgn9Y9ugvrwL6549XWU0mj1fJT1DEM1U4YmHdCJQ1u4bcjnJuvyHHzJkhmsY+hl
         vZ6Q==
X-Gm-Message-State: AOAM532xkBqp2knLi/y+XnpPU3TTcwsp8j69MRaV5ZrzRCJHx/poQ7p5
        C3BFBdylnS8mGTs94+N1y8M=
X-Google-Smtp-Source: ABdhPJxhOZTdbMPRAIVzjvIRqnul//51XUahIzhC55Zd6M2vw03NCFfKAfoOeF/ApT106lXb6IyjVQ==
X-Received: by 2002:a17:90b:1d0e:: with SMTP id on14mr5033613pjb.202.1643137646088;
        Tue, 25 Jan 2022 11:07:26 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id t15sm7176659pgc.49.2022.01.25.11.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:07:25 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jeffreyjilinux@gmail.com,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH v2 net-next] net-core: add InMacErrors counter
Date:   Tue, 25 Jan 2022 19:07:17 +0000
Message-Id: <20220125190717.2459068-1-jeffreyji@google.com>
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

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/ip_input.c       | 4 +++-
 net/ipv4/proc.c           | 1 +
 net/ipv6/ip6_input.c      | 1 +
 net/ipv6/proc.c           | 1 +
 5 files changed, 7 insertions(+), 1 deletion(-)

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
index 3a025c011971..0961585f7c02 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -441,8 +441,10 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP_INC_STATS(net, IPSTATS_MIB_INMACERRORS);
 		goto drop;
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
index 80256717868e..2903869274ca 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	struct inet6_dev *idev;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
 		kfree_skb(skb);
 		return NULL;
 	}
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F69496871
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 01:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiAVADY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 19:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiAVADY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 19:03:24 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AFFC06173B;
        Fri, 21 Jan 2022 16:03:23 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id p37so10267733pfh.4;
        Fri, 21 Jan 2022 16:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SoODkvg29QOjrlEc+QRZ/3JpbdXvr3oJEsKIvnztj+w=;
        b=Bp1e5HFJZ0P/ZevhxHsnIFWycU39FbRyEE71B/BC4HDd6RzPOJkqr3y8JCo/a2Lkon
         IfLP+tpYOvJq3FPbYyuGz8qnxhkMiRsZGk3ToUWM8b1vxoPboG9vRrzW/K8ZQDP2ZIRo
         IV3GKw6HUrE29m/KTvUq4CG8iZmTf0s7j7DNP7hQB71mpzsyecXTNjRmiSjgkw1jbVwJ
         6dnt3dZfmR1PI6HGbGYcpmZ4Dbu/D/B737AJFtt4aZ1WHnmbgj5Jn5IIA5KKA0h8Kx4U
         meyckiALFzvA16QFxAhOnmnyqphpmYNYSjHrIxNv6mic/36td9FVytbO0Tp/WnNwiUk/
         TIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SoODkvg29QOjrlEc+QRZ/3JpbdXvr3oJEsKIvnztj+w=;
        b=5E9m1p5C/ABvh/ubkvxUn4vJLZ0Nu2UCQ2eugL6GqAzf2WGtAZ+cuBDhnnr/uvh4OZ
         0Kln0/vGsRnoNHcA/JbzxuLhxcmUq6DVPFnKy7oLudpqf2Fk3d7I4a/zsGIKDe1Z/aOf
         grudRvPLUpwzirmuux+oD7j8XjtEhuQNx+AlLQFGG03bpqYGQGNiQXmi1wMiTvxkMmZ4
         8XiBGDHPba9qZ5drO6muvnWNGFJ3vUDVXtwVNZUOzToSYo0NcdKCUG3Gf+pqMXe/C1+6
         qwnyad5x/BVB4Fc+unEclQzhKtip06g2yY+INAp3ra7w5VbZ0K/qqGMs0DLeuObEQIkT
         L1VA==
X-Gm-Message-State: AOAM530RqPmrcdQz9kfDQWeWNDoKxPpwE4jSe+an8kHqVVBwG18WMcrr
        IRYQWQ1a//1eThHLQN/TVXg=
X-Google-Smtp-Source: ABdhPJxYuxhM68m7P180z0opk/ItAUd6hc/qDx4X3RdsTQBzrhZNKxpj0PuEH0TEG2ZNPHxRJc4sTA==
X-Received: by 2002:a05:6a00:728:b0:4b0:b1c:6fd9 with SMTP id 8-20020a056a00072800b004b00b1c6fd9mr5454492pfm.27.1642809803416;
        Fri, 21 Jan 2022 16:03:23 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id rm7sm13695071pjb.50.2022.01.21.16.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 16:03:22 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jeffreyjilinux@gmail.com,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH net-next] net-core: add InMacErrors counter
Date:   Sat, 22 Jan 2022 00:03:01 +0000
Message-Id: <20220122000301.1872828-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jeffreyji <jeffreyji@google.com>

Increment InMacErrors counter when packet dropped due to incorrect dest
MAC addr.

example output from nstat:
\~# nstat -z "*InMac*"
\#kernel
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


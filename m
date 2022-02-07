Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF164ACDBF
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbiBHBGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbiBGX5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:57:20 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF83C061355;
        Mon,  7 Feb 2022 15:57:18 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id k17so12453414plk.0;
        Mon, 07 Feb 2022 15:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JiJGrwOcZzG4Zydhkiss9aQHM7qGmF/GV6KdejkkBE=;
        b=J5U0a537Z3Rhvx3IxxNuohZjRF42X4RNIcDdlF/wqJbmyUuha+uS98kOxtLxHftuIF
         YOQ7S3O5/AcgtE4mxdYzBFMYIJ8eYaADQN0yyE1r3crozCNBR7fhs1gbWWLea7accvIp
         UUAV6xHg1p/9c8p+Rn3Jl9Juq3JZ+NIGKNK9osWGduEPW33tCrKtovpjLdaB0qr1DNmq
         017JotGMDmjCLRn6Uz6gLFjMScd9n2HpQYiT9lLrlkg6Rw9uzzPNlkNqbU7m+xnnbBrV
         liT6cQi7FBttHS1p2vefmRgQJu2gkTsshp6YmZt1YY/+DQqdBNVumNFInUr5e4YyQv8W
         VacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JiJGrwOcZzG4Zydhkiss9aQHM7qGmF/GV6KdejkkBE=;
        b=DYGOAU8jpHCI78iFIfNS4LzE2GO+SC91v9DKTgZJ+QVDsR3bA5qW+xgQUS9DCMmo1j
         8SeKtlhZBHV76B8fUJdwrzNsOZK2fKFveHCTnR1FkC6Mr34r26eFxivG4qgfTwjrCJHM
         PnY6G+SNZvTFKL8DdOahmrcCYpmPAUFORG2lrmNhdmqaSj03FSn2V3yzhAzpdj+EsFcp
         lY6McS4x7rW0AO/3sseOOHWddVnni+RVqnrW63GUKv0QncK0PQFRVdaUuaMDSay4sr/A
         yn11YjEHSiwAzzJf0JVkZlaJuYeDnyAjMssfe9Ms7uFmd8dz9lJh8/Le7+o6WGWP6zb8
         ZJCA==
X-Gm-Message-State: AOAM5336UcEtu3dPG+MCONcthdUPfh5VQ4MFmJ/LHmWIYJkM+4reevGW
        o3LRNCo/9h1EMo8SZ8fL8PhJWkuox7A=
X-Google-Smtp-Source: ABdhPJyz0Xo6DpjMxKYlud1s2m7goA8SBDqHSv8cenMZH5i/q6YBg3Kr1IPcuiH8vcImLJMBm0jlpQ==
X-Received: by 2002:a17:902:ea12:: with SMTP id s18mr1666339plg.163.1644278237898;
        Mon, 07 Feb 2022 15:57:17 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id 207sm9250420pgh.32.2022.02.07.15.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:57:17 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, jeffreyjilinux@gmail.com,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH v7 net-next] net-core: add InDropOtherhost counter
Date:   Mon,  7 Feb 2022 23:57:14 +0000
Message-Id: <20220207235714.1050160-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jeffreyji <jeffreyji@google.com>

Increment InDropOtherhost counter when packet dropped due to incorrect dest
MAC addr.

An example when this drop can occur is when manually crafting raw
packets that will be consumed by a user space application via a tap
device. For testing purposes local traffic was generated using trafgen
for the client and netcat to start a server

example output from nstat:
\~# nstat -a | grep InMac
Ip6InDropOtherhost                  0                  0.0
IpExtInDropOtherhost                1                  0.0

Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
counter was incremented.

changelog:
v7: change InMacError -> InDropOtherhost

v6: rebase onto net-next

v5:
Change from SKB_DROP_REASON_BAD_DEST_MAC to SKB_DROP_REASON_OTHERHOST

v3-4:
Remove Change-Id

v2:
Use skb_free_reason() for tracing
Add real-life example in patch msg

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 Documentation/networking/snmp_counter.rst |  5 +++++
 include/uapi/linux/snmp.h                 |  1 +
 net/ipv4/ip_input.c                       |  5 +++--
 net/ipv4/proc.c                           |  1 +
 net/ipv6/ip6_input.c                      | 12 +++++++-----
 net/ipv6/proc.c                           |  1 +
 6 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/snmp_counter.rst b/Documentation/networking/snmp_counter.rst
index 423d138b5ff3..674f736e4e8b 100644
--- a/Documentation/networking/snmp_counter.rst
+++ b/Documentation/networking/snmp_counter.rst
@@ -214,6 +214,11 @@ wrong. Kernel verifies the checksum after updating the IcmpInMsgs and
 before updating IcmpMsgInType[N]. If a packet has bad checksum, the
 IcmpInMsgs would be updated but none of IcmpMsgInType[N] would be updated.
 
+* IcmpInDropOtherhost
+
+This counter indicates that the packet was dropped because the destination
+MAC address was incorrect.
+
 * IcmpInErrors and IcmpOutErrors
 
 Defined by `RFC1213 icmpInErrors`_ and `RFC1213 icmpOutErrors`_
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..4f247d406b1a 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -57,6 +57,7 @@ enum
 	IPSTATS_MIB_ECT0PKTS,			/* InECT0Pkts */
 	IPSTATS_MIB_CEPKTS,			/* InCEPkts */
 	IPSTATS_MIB_REASM_OVERLAPS,		/* ReasmOverlaps */
+	IPSTATS_MIB_INDROPOTHERHOST,		/* InDropOtherhost */
 	__IPSTATS_MIB_MAX
 };
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index d94f9f7e60c3..db4c36c008ff 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -450,8 +450,9 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	 * that it receives, do not try to analyse it.
 	 */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
-		drop_reason = SKB_DROP_REASON_OTHERHOST;
-		goto drop;
+		__IP_INC_STATS(net, IPSTATS_MIB_INDROPOTHERHOST);
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
+		return NULL;
 	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 28836071f0a6..2ffa43cff799 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -117,6 +117,7 @@ static const struct snmp_mib snmp4_ipextstats_list[] = {
 	SNMP_MIB_ITEM("InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("InCEPkts", IPSTATS_MIB_CEPKTS),
 	SNMP_MIB_ITEM("ReasmOverlaps", IPSTATS_MIB_REASM_OVERLAPS),
+	SNMP_MIB_ITEM("InDropOtherhost", IPSTATS_MIB_INDROPOTHERHOST),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d4b1e2c5aa76..480896e13041 100644
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
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDROPOTHERHOST);
+		rcu_read_unlock();
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
+		return NULL;
+	}
+
 	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1..c2d963122d1e 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -84,6 +84,7 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
 	SNMP_MIB_ITEM("Ip6InECT1Pkts", IPSTATS_MIB_ECT1PKTS),
 	SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
+	SNMP_MIB_ITEM("Ip6InDropOtherhost", IPSTATS_MIB_INDROPOTHERHOST),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.35.0.263.gb82422642f-goog


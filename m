Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070A8665E5F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjAKOvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbjAKOvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:19 -0500
X-Greylist: delayed 997 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 Jan 2023 06:51:13 PST
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40A2CF
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:13 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=kTgSB7DgSORMdgkcjBIUj3TpvFS2V7UMaqSf15PL+uM=; b=oKRNrPYmozm2NX2
        xjG1cfYOGPy53zdOFDuaPk5BURrKF72Au32W6SoB0M2EVZVi/HNUt16VUIf6aak2zLDgYDw==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=kTgSB7DgSORMdgkcjBIUj3TpvFS2V7UMaqSf15PL+uM=; b=QwsTzommlVhuB39
        EgI4EqaL+vlE9ZIT/mLEWgwZJDsnHVxd/tZRFiTEB2+zk5uS3rivbHJyaB41qEWVlghmW45Vcb8jW
        P36rkNO+zjBVGse0ra5iaWrLHnFuWxikeTNpoR8VdaS9LehnS4EgJUD9NsBkUb0ewZ/h3TEIE0MCw
        ZYfPSxx6Uu5Wl5Nk4llF1WCQ2qjXILfxm048ell8ESQtP7E5z4J0G6vHA7ahCUOccf629zlU2UOGx
        DYk7yP4///s0awzlRRovDdCgVgl7OvoVP1QZWSekQWSmLaO5Omyoqr7I6rqXop/sabxkjlK6IFOti
        5dsSBj3Tg8WjAT2leoA==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jFD-0u
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 2/7] net: NIC driver Rx ring ECN: stats counter
Date:   Wed, 11 Jan 2023 14:34:22 +0000
Message-Id: <20230111143427.1127174-3-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

Counters for IPv4 and IPv6 input packets for which skbs were
marked by NIC drivers, modelled on those for IP packet markings.

Signed-off-by: Jeremy Harris <jgh@redhat.com>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/ip_input.c       | 4 ++++
 net/ipv4/proc.c           | 1 +
 net/ipv6/ip6_input.c      | 5 +++++
 net/ipv6/proc.c           | 1 +
 5 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 6600cb0164c2..f8f763b6af28 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -57,6 +57,7 @@ enum
 	IPSTATS_MIB_ECT0PKTS,			/* InECT0Pkts */
 	IPSTATS_MIB_CEPKTS,			/* InCEPkts */
 	IPSTATS_MIB_REASM_OVERLAPS,		/* ReasmOverlaps */
+	IPSTATS_MIB_INCONGPKTS,			/* InCongestionPkts */
 	__IPSTATS_MIB_MAX
 };
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index e880ce77322a..fd0ec860a3f6 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -503,6 +503,10 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		       IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
 		       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
 
+	if (unlikely(skb->congestion_experienced))
+		__IP_ADD_STATS(net, IPSTATS_MIB_INCONGPKTS,
+			       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
+
 	if (!pskb_may_pull(skb, iph->ihl*4))
 		goto inhdr_error;
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f88daace9de3..fb6e82e86070 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -117,6 +117,7 @@ static const struct snmp_mib snmp4_ipextstats_list[] = {
 	SNMP_MIB_ITEM("InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("InCEPkts", IPSTATS_MIB_CEPKTS),
 	SNMP_MIB_ITEM("ReasmOverlaps", IPSTATS_MIB_REASM_OVERLAPS),
+	SNMP_MIB_ITEM("InCongestionPkts", IPSTATS_MIB_INCONGPKTS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e1ebf5e42ebe..f43d8af20831 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -203,6 +203,11 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 			IPSTATS_MIB_NOECTPKTS +
 				(ipv6_get_dsfield(hdr) & INET_ECN_MASK),
 			max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
+
+	if (unlikely(skb->congestion_experienced))
+		__IP6_ADD_STATS(net, idev, IPSTATS_MIB_INCONGPKTS,
+				max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
+
 	/*
 	 * RFC4291 2.5.3
 	 * The loopback address must not be used as the source address in IPv6
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1..635ab1f99900 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -84,6 +84,7 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
 	SNMP_MIB_ITEM("Ip6InECT1Pkts", IPSTATS_MIB_ECT1PKTS),
 	SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
+	SNMP_MIB_ITEM("Ip6InCongestionPkts", IPSTATS_MIB_INCONGPKTS),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.39.0


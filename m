Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CDB2AC927
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgKIXOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKIXN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:13:58 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85616C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 15:13:58 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e21so8442507pgr.11
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ZuOt1YUk8YzgrckG18G++ujRPzQJWo5wbeuOl9xQc4=;
        b=FWhlYmLgg2mkf28KMRxsyTBJQIniLPGRQHaW7ye+7fKD6b0t8pWDtuN6OwMHdFi7EG
         9vsDR1HkiDoHgUT9hgjllAFbvF2yoaJ1SiB2Mg0iIRLpaxO3kqFHwwp6++MdR35KlL6y
         bruz5rPOLyReg84N4sN5TyiR31TDr2q7WgTlHtNWwMHUYH+LbHbL5bHP2j4vIJMHWq3j
         AkD2rWcJu8VZb8T7PmSOGoIRmRIodsOh5O0Lvfyv7GHUN3GKJlQ/qfPBVrwasROf6Lf9
         jSpA5jzaPacv0Hvf3wNAzV6yWn2/7qL4yVGb3DgaNTVK87+fst3KorjURiL6zeV8w/tI
         paDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ZuOt1YUk8YzgrckG18G++ujRPzQJWo5wbeuOl9xQc4=;
        b=V1Mrwq3rjmSE5rUvboIek2TOU9f20V/EfcSNL4pomzdSzdq5IVVcc4q+R8+Yd1ePtb
         tyvFyXB4GPUDMFc5zabZBqWOHwL4dvoucvvkzAkpr1JeiCrm/cfmnR5Cy9vzvfGRfNU0
         KGOyTdckWggBAsU63p7+YcTAO6GpAfIpWyMUeyWBgjDESsIT+WOcPPH5JfRuiUUF7VpR
         YAhKzEqWxf5N2A5YsYthXNiDdIn2KYaEgwj9RqXfCGeF2CPLSQ4NppfacynI5Nis9xee
         CvayOdpzqrZw9eRjIG+M/+MP0OhpVXfnAEExjZBDtUnFCosuwumUgeCBM0ATgWhIeR24
         5L1Q==
X-Gm-Message-State: AOAM531Id0MeGn/LFtL/gG8DQlZd/itfmRcE9imWVe9XrjsspGPWB4C1
        pwG1/ETT+GmAS+6BFMVMBCs=
X-Google-Smtp-Source: ABdhPJxFn2XSIGeHwvOfpyfSqB01my4s4fQBlpHPHSTEqfq81vYQ+mEODq/evIpI8ebku5GeoMG1bg==
X-Received: by 2002:a17:90a:fa8c:: with SMTP id cu12mr1622575pjb.127.1604963638159;
        Mon, 09 Nov 2020 15:13:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id w16sm12375365pfn.45.2020.11.09.15.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 15:13:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 2/2] inet: udp{4|6}_lib_lookup_skb() skb argument is const
Date:   Mon,  9 Nov 2020 15:13:49 -0800
Message-Id: <20201109231349.20946-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201109231349.20946-1-eric.dumazet@gmail.com>
References: <20201109231349.20946-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

The skb is needed only to fetch the keys for the lookup.

Both functions are used from GRO stack, we do not want
accidental modification of the skb.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
---
 include/net/udp.h | 6 +++---
 net/ipv4/udp.c    | 2 +-
 net/ipv6/udp.c    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 295d52a73598277dc5071536f777d1a87e7df1d1..877832bed4713a011a514a2f6f522728c8c89e20 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -164,7 +164,7 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
 	UDP_SKB_CB(skb)->cscov -= sizeof(struct udphdr);
 }
 
-typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
+typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
 				     __be16 dport);
 
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
@@ -313,7 +313,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 			       __be32 daddr, __be16 dport, int dif, int sdif,
 			       struct udp_table *tbl, struct sk_buff *skb);
-struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
 struct sock *udp6_lib_lookup(struct net *net,
 			     const struct in6_addr *saddr, __be16 sport,
@@ -324,7 +324,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       const struct in6_addr *daddr, __be16 dport,
 			       int dif, int sdif, struct udp_table *tbl,
 			       struct sk_buff *skb);
-struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ca04a8a35e52dbcff50b03da2710726dc6ee98bd..8c9f08343e171ba9b78ebe7bfe22e6508ab15c42 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -541,7 +541,7 @@ static inline struct sock *__udp4_lib_lookup_skb(struct sk_buff *skb,
 				 inet_sdif(skb), udptable, skb);
 }
 
-struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp4_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
 	const struct iphdr *iph = ip_hdr(skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index cde9b8874d4bce4cdbee557d89a0be0ddf3f87df..c32f50d2a0694580426ea71e52a1cee23ed07045 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -276,7 +276,7 @@ static struct sock *__udp6_lib_lookup_skb(struct sk_buff *skb,
 				 inet6_sdif(skb), udptable, skb);
 }
 
-struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
+struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-- 
2.29.2.222.g5d2a92d10f8-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47E659D1D1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbiHWHLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbiHWHLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:11:11 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA59E61B17
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:11:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gb36so25560167ejc.10
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=2urUhqPHCHiFiF7lWAMLx9uuzbnZZ+Bjjkbpm3tr9G0=;
        b=jXhq1NP+itWAdG5tIvhGk8USwb1M8no0zv/q2EHw0EvHZuEGWBs2JAV6djfwDiNUc2
         orpmAcXRumjfGm+2b13F/LKf+wBLn6Anwg/Uq12oNnV9GNEo+czB0ZtHHTs42feDwQe2
         pev8su0zl42fKopNpkDLLaSUdG5af8XAkdT2CXJr/JUkTCxx1o1Cef3/cfhOWhk5PHQ0
         GmnJ0OF/nMFHL1hE49Uqqc2CBZjTke6X/oaswhcg0udyie4TgMhH2hTd96+StoNU3dUV
         JagkDbGtLbZT2enl0viBpo6SGeHL6rNUTnVFXZBNZexshHa5+Yi4ZHQYJJZtK7uU0CnT
         KgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=2urUhqPHCHiFiF7lWAMLx9uuzbnZZ+Bjjkbpm3tr9G0=;
        b=HLNcFxT1s32syJXeAiKcf+aZTPju76I8Iq1y5r9wY46Ok4qoHZwSvYy0bSSiJniOVi
         N1z1j1L/Net3pfVySH3ntdHtGCoOm4eeR/P/4gHRjFdaVopJEk9dwzn7aoGMon8pTsVy
         ZRHcZ6stCuSrLH6PswS8NwqOoWQe8/ri5ofOA4kYMtq8vLqMrZVNNyHKnj/j+RD948nc
         NoO2lBv7qNCoIAgDmCvuY0dtL0nXuNhAO9p13ZZeDvB4zJ/jywLBvcbV/d7iWGKAQbWw
         fBlnF6IX3lgOn9h5+0ZhmnQbLwZz0WPnBuc0TSyNZtkM+nXDaYktRb3BtCACMDLHjNt8
         onvg==
X-Gm-Message-State: ACgBeo19/rwAYOWFnpu0Eo2tUOU4sxq57TrqX3HhZfPV2nWxrSGzs/nW
        egsJbvqMKIcEc3n/Hfi9fg4=
X-Google-Smtp-Source: AA6agR7RCCd0fq/kwVASjO6gOJmpyD6BoLM4wX5nrDex9FJmMiOQ/trYyEFQ7bRIVLgZQ18dgs270g==
X-Received: by 2002:a17:907:9815:b0:73d:97f9:47f7 with SMTP id ji21-20020a170907981500b0073d97f947f7mr1854918ejc.338.1661238668285;
        Tue, 23 Aug 2022 00:11:08 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709063d3200b00730bfe6adc4sm6987416ejf.37.2022.08.23.00.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 00:11:07 -0700 (PDT)
Date:   Tue, 23 Aug 2022 09:10:49 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        xeb@mail.ru, roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, heikki.krogerus@linux.intel.com,
        gregkh@linuxfoundation.org, iwienand@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH V2] net: gro: skb_gro_header helper function
Message-ID: <20220823071034.GA56142@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a simple helper function to replace a common pattern.
When accessing the GRO header, we fetch the pointer from frag0,
then test its validity and fetch it from the skb when necessary.

This leads to the pattern
skb_gro_header_fast -> skb_gro_header_hard -> skb_gro_header_slow
recurring many times throughout GRO code.

This patch replaces these patterns with a single inlined function
call, improving code readability.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 drivers/net/geneve.c           |  9 +++------
 drivers/net/vxlan/vxlan_core.c |  9 +++------
 include/net/gro.h              | 33 ++++++++++++++++++---------------
 net/8021q/vlan_core.c          |  9 +++------
 net/ethernet/eth.c             |  9 +++------
 net/ipv4/af_inet.c             |  9 +++------
 net/ipv4/fou.c                 |  9 +++------
 net/ipv4/gre_offload.c         |  9 +++------
 net/ipv4/tcp_offload.c         |  9 +++------
 net/ipv6/ip6_offload.c         |  9 +++------
 10 files changed, 45 insertions(+), 69 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 7962c37b3f14..01aa94776ce3 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -503,12 +503,9 @@ static struct sk_buff *geneve_gro_receive(struct sock *sk,
 
 	off_gnv = skb_gro_offset(skb);
 	hlen = off_gnv + sizeof(*gh);
-	gh = skb_gro_header_fast(skb, off_gnv);
-	if (skb_gro_header_hard(skb, hlen)) {
-		gh = skb_gro_header_slow(skb, hlen, off_gnv);
-		if (unlikely(!gh))
-			goto out;
-	}
+	gh = skb_gro_header(skb, hlen, off_gnv);
+	if (unlikely(!gh))
+		goto out;
 
 	if (gh->ver != GENEVE_VER || gh->oam)
 		goto out;
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index c3285242f74f..1a47d04f5d1a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -713,12 +713,9 @@ static struct sk_buff *vxlan_gro_receive(struct sock *sk,
 
 	off_vx = skb_gro_offset(skb);
 	hlen = off_vx + sizeof(*vh);
-	vh   = skb_gro_header_fast(skb, off_vx);
-	if (skb_gro_header_hard(skb, hlen)) {
-		vh = skb_gro_header_slow(skb, hlen, off_vx);
-		if (unlikely(!vh))
-			goto out;
-	}
+	vh = skb_gro_header(skb, hlen, off_vx);
+	if (unlikely(!vh))
+		goto out;
 
 	skb_gro_postpull_rcsum(skb, vh, sizeof(struct vxlanhdr));
 
diff --git a/include/net/gro.h b/include/net/gro.h
index 867656b0739c..5bf15c212434 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -160,6 +160,17 @@ static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
 	return skb->data + offset;
 }
 
+static inline void *skb_gro_header(struct sk_buff *skb,
+					unsigned int hlen, unsigned int offset)
+{
+	void *ptr;
+
+	ptr = skb_gro_header_fast(skb, offset);
+	if (skb_gro_header_hard(skb, hlen))
+		ptr = skb_gro_header_slow(skb, hlen, offset);
+	return ptr;
+}
+
 static inline void *skb_gro_network_header(struct sk_buff *skb)
 {
 	return (NAPI_GRO_CB(skb)->frag0 ?: skb->data) +
@@ -301,12 +312,9 @@ static inline void *skb_gro_remcsum_process(struct sk_buff *skb, void *ptr,
 		return ptr;
 	}
 
-	ptr = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, off + plen)) {
-		ptr = skb_gro_header_slow(skb, off + plen, off);
-		if (!ptr)
-			return NULL;
-	}
+	ptr = skb_gro_header(skb, off + plen, off);
+	if (!ptr)
+		return NULL;
 
 	delta = remcsum_adjust(ptr + hdrlen, NAPI_GRO_CB(skb)->csum,
 			       start, offset);
@@ -329,12 +337,9 @@ static inline void skb_gro_remcsum_cleanup(struct sk_buff *skb,
 	if (!grc->delta)
 		return;
 
-	ptr = skb_gro_header_fast(skb, grc->offset);
-	if (skb_gro_header_hard(skb, grc->offset + sizeof(u16))) {
-		ptr = skb_gro_header_slow(skb, plen, grc->offset);
-		if (!ptr)
-			return;
-	}
+	ptr = skb_gro_header(skb, plen, grc->offset);
+	if (!ptr)
+		return;
 
 	remcsum_unadjust((__sum16 *)ptr, grc->delta);
 }
@@ -405,9 +410,7 @@ static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
 
 	off  = skb_gro_offset(skb);
 	hlen = off + sizeof(*uh);
-	uh   = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen))
-		uh = skb_gro_header_slow(skb, hlen, off);
+	uh   = skb_gro_header(skb, hlen, off);
 
 	return uh;
 }
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 5aa8144101dc..0beb44f2fe1f 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -467,12 +467,9 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 
 	off_vlan = skb_gro_offset(skb);
 	hlen = off_vlan + sizeof(*vhdr);
-	vhdr = skb_gro_header_fast(skb, off_vlan);
-	if (skb_gro_header_hard(skb, hlen)) {
-		vhdr = skb_gro_header_slow(skb, hlen, off_vlan);
-		if (unlikely(!vhdr))
-			goto out;
-	}
+	vhdr = skb_gro_header(skb, hlen, off_vlan);
+	if (unlikely(!vhdr))
+		goto out;
 
 	type = vhdr->h_vlan_encapsulated_proto;
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 62b89d6f54fd..e02daa74e833 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -414,12 +414,9 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	off_eth = skb_gro_offset(skb);
 	hlen = off_eth + sizeof(*eh);
-	eh = skb_gro_header_fast(skb, off_eth);
-	if (skb_gro_header_hard(skb, hlen)) {
-		eh = skb_gro_header_slow(skb, hlen, off_eth);
-		if (unlikely(!eh))
-			goto out;
-	}
+	eh = skb_gro_header(skb, hlen, off_eth);
+	if (unlikely(!eh))
+		goto out;
 
 	flush = 0;
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3ca0cc467886..1676e5b9e000 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1448,12 +1448,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*iph);
-	iph = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		iph = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!iph))
-			goto out;
-	}
+	iph = skb_gro_header(skb, hlen, off);
+	if (unlikely(!iph))
+		goto out;
 
 	proto = iph->protocol;
 
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 025a33c1b04d..cb5bfb77944c 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -323,12 +323,9 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 	off = skb_gro_offset(skb);
 	len = off + sizeof(*guehdr);
 
-	guehdr = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, len)) {
-		guehdr = skb_gro_header_slow(skb, len, off);
-		if (unlikely(!guehdr))
-			goto out;
-	}
+	guehdr = skb_gro_header(skb, len, off);
+	if (unlikely(!guehdr))
+		goto out;
 
 	switch (guehdr->version) {
 	case 0:
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 07073fa35205..2b9cb5398335 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -137,12 +137,9 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*greh);
-	greh = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		greh = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!greh))
-			goto out;
-	}
+	greh = skb_gro_header(skb, hlen, off);
+	if (unlikely(!greh))
+		goto out;
 
 	/* Only support version 0 and K (key), C (csum) flags. Note that
 	 * although the support for the S (seq#) flag can be added easily
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 30abde86db45..a844a0d38482 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -195,12 +195,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*th);
-	th = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		th = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!th))
-			goto out;
-	}
+	th = skb_gro_header(skb, hlen, off);
+	if (unlikely(!th))
+		goto out;
 
 	thlen = th->doff * 4;
 	if (thlen < sizeof(*th))
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d12dba2dd535..d37a8c97e6de 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -219,12 +219,9 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*iph);
-	iph = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		iph = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!iph))
-			goto out;
-	}
+	iph = skb_gro_header_slow(skb, hlen, off);
+	if (unlikely(!iph))
+		goto out;
 
 	skb_set_network_header(skb, off);
 	skb_gro_pull(skb, sizeof(*iph));
-- 
2.36.1


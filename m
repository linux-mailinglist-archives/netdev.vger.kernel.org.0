Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343E521DF08
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgGMRrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730423AbgGMRrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:12 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E50BC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:12 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s16so9556947lfp.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4adtaF+vh9ZCjhGrf1+RjNro+KhZMebp2/WL08RlLtc=;
        b=tetYQPuo1HNfbQu7YB33sGi0dcbFBATg/HeznsxFxVoA92dczroFy75rMBQv6SPA69
         DNRrA9E4KjSH8CDQP+/fghtq9rWIoRcehmYOs3JDLgee6cQuS52b8K8R+64WU3LsAQ1g
         2AhOVjbta5jKnsaj9fyifypGgKb+WDYZKFhZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4adtaF+vh9ZCjhGrf1+RjNro+KhZMebp2/WL08RlLtc=;
        b=eieYPaghYYXmthAhFettNLcxQfx4IRokJt/AFgC35x9ctdlF444yq24VTYlMjtQC1m
         Q1bcBW7obdkGHJKIDEbydij4D4cI0F9sxoznf4kswhtIB2Aur4w29eXDZVsRvOzFiYKZ
         vmROZz0dyunQW7vT3M9Hg0Mmdu91qtcXn2chm3OiwicfVtTtYWgckrbNhkrKLZ5P2SRM
         afvWFZQyu6QPQ/6VMl17MXo621tZQORiLYfH9VsJLnOWPa0G2gLJstJt3fcsF27Vlwvp
         FK99Ag6htHd0vwKp4Ja31pm4zu9qJrjuGRxjo2VaywQXIUDdXfRXzjRAt2wTDWbmLaWE
         ghMA==
X-Gm-Message-State: AOAM530Dmw1I6+wHzhltxtikn4RmXQImLBU463ZMU3bOGcbkGXh33xMm
        bAOeYcLe/0XzWyZNyb3f7HqWIw==
X-Google-Smtp-Source: ABdhPJyj9c5rR9UY+ckpPyOhrZ39eULC/Cyi0TZxxCaOU5hZjpnCZ9safKIrK4XOPvb9HIneCZk5Ng==
X-Received: by 2002:a19:22d6:: with SMTP id i205mr175738lfi.50.1594662430546;
        Mon, 13 Jul 2020 10:47:10 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a17sm4771942lfo.73.2020.07.13.10.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:09 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH bpf-next v4 08/16] udp: Run SK_LOOKUP BPF program on socket lookup
Date:   Mon, 13 Jul 2020 19:46:46 +0200
Message-Id: <20200713174654.642628-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following INET/TCP socket lookup changes, modify UDP socket lookup to let
BPF program select a receiving socket before searching for a socket by
destination address and port as usual.

Lookup of connected sockets that match packet 4-tuple is unaffected by this
change. BPF program runs, and potentially overrides the lookup result, only
if a 4-tuple match was not found.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v4:
    - Adapt to change in bpf_sk_lookup_run_v4 return value semantics.
    
    v3:
    - Use a static_key to minimize the hook overhead when not used. (Alexei)
    - Adapt for running an array of attached programs. (Alexei)
    - Adapt for optionally skipping reuseport selection. (Martin)

 net/ipv4/udp.c | 59 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 0d03e0277263..e82db3ab49d3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -456,6 +456,29 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 	return result;
 }
 
+static inline struct sock *udp4_lookup_run_bpf(struct net *net,
+					       struct udp_table *udptable,
+					       struct sk_buff *skb,
+					       __be32 saddr, __be16 sport,
+					       __be32 daddr, u16 hnum)
+{
+	struct sock *sk, *reuse_sk;
+	bool no_reuseport;
+
+	if (udptable != &udp_table)
+		return NULL; /* only UDP is supported */
+
+	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP,
+					    saddr, sport, daddr, hnum, &sk);
+	if (no_reuseport || IS_ERR_OR_NULL(sk))
+		return sk;
+
+	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
+	if (reuse_sk)
+		sk = reuse_sk;
+	return sk;
+}
+
 /* UDP is nearly always wildcards out the wazoo, it makes no sense to try
  * harder than this. -DaveM
  */
@@ -463,27 +486,45 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 		__be16 sport, __be32 daddr, __be16 dport, int dif,
 		int sdif, struct udp_table *udptable, struct sk_buff *skb)
 {
-	struct sock *result;
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
+	struct sock *result, *sk;
 
 	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
 	slot2 = hash2 & udptable->mask;
 	hslot2 = &udptable->hash2[slot2];
 
+	/* Lookup connected or non-wildcard socket */
 	result = udp4_lib_lookup2(net, saddr, sport,
 				  daddr, hnum, dif, sdif,
 				  hslot2, skb);
-	if (!result) {
-		hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum);
-		slot2 = hash2 & udptable->mask;
-		hslot2 = &udptable->hash2[slot2];
-
-		result = udp4_lib_lookup2(net, saddr, sport,
-					  htonl(INADDR_ANY), hnum, dif, sdif,
-					  hslot2, skb);
+	if (!IS_ERR_OR_NULL(result) && result->sk_state == TCP_ESTABLISHED)
+		goto done;
+
+	/* Lookup redirect from BPF */
+	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
+		sk = udp4_lookup_run_bpf(net, udptable, skb,
+					 saddr, sport, daddr, hnum);
+		if (sk) {
+			result = sk;
+			goto done;
+		}
 	}
+
+	/* Got non-wildcard socket or error on first lookup */
+	if (result)
+		goto done;
+
+	/* Lookup wildcard sockets */
+	hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum);
+	slot2 = hash2 & udptable->mask;
+	hslot2 = &udptable->hash2[slot2];
+
+	result = udp4_lib_lookup2(net, saddr, sport,
+				  htonl(INADDR_ANY), hnum, dif, sdif,
+				  hslot2, skb);
+done:
 	if (IS_ERR(result))
 		return NULL;
 	return result;
-- 
2.25.4


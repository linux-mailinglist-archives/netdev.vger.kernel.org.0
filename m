Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5DF1CE31F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbgEKSwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730999AbgEKSwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:52:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7040C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l11so6399340wru.0
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ojEd/q/k+ui/tdlTtnZjdQdevINffYnK0fnxcI6+4Y=;
        b=d2g/X9yvb3uYH8vthU94GD76YkA9Y8adNPjh1+vkkGoC8mh6S2pDUgwnUnA4tFvqTw
         UY2yB8jQFS4wqhOOoBGD/WrwoflNslZnrpGTG2a5SOiXALgJYDI3ADfwUJtXJ76b3CAj
         PcpGdlzfeTNHMYaczBzVbworPahN01JbMHnOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ojEd/q/k+ui/tdlTtnZjdQdevINffYnK0fnxcI6+4Y=;
        b=UdoIwzj55nqMADPh3BgZKrI3qWAY1dnFeKLiINcTbY0Zrlptu7/MLcBOHNwIe/ivv/
         sSSkHd5BHZ2+5Xa10p40urLV3TgOoNK04rWsXADtGj+T90YyxhiP4q63js7WgeQeodQs
         3ehy3RpC8DPkY9QynVfnai3zR250AuQaCDlU0h5agMqytBrCIC3toALC5ykKc7O6Co3N
         NxJbeENYk77rngTIhOZgjnoZ3aoemKwXaxKXCPPwOYGwYCCFiLAA5u2eOpQNMR/YOcQd
         S6GjpaGVseGrhkCVF3dS2Da+Mt7N1+F/91Zihy0dSuB2bt9jXuQyD+Z8NoQXP9ovv0UB
         2lDg==
X-Gm-Message-State: AGi0PuZ1Sx+DGAuHGjl7YpaVEk3+H1b2AVP+Y5hsgToVeMx1rB7sVQKG
        xz3H9abGXCQW9AVyuvy1/8qagQ+ydPE=
X-Google-Smtp-Source: APiQypJguhmqZWm6uwGU1Lvf+X7YeVMHhDzstvAlIJDTuvKaDfsIYwLPROaPVYOBgfXEfPfzTpb4FQ==
X-Received: by 2002:adf:ab09:: with SMTP id q9mr19761725wrc.240.1589223156180;
        Mon, 11 May 2020 11:52:36 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n7sm9896610wro.94.2020.05.11.11.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:52:35 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 10/17] udp: Run SK_LOOKUP BPF program on socket lookup
Date:   Mon, 11 May 2020 20:52:11 +0200
Message-Id: <20200511185218.1422406-11-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
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
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/udp.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d4842f29294a..18d8432f6551 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -460,7 +460,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 		__be16 sport, __be32 daddr, __be16 dport, int dif,
 		int sdif, struct udp_table *udptable, struct sk_buff *skb)
 {
-	struct sock *result;
+	struct sock *result, *sk, *reuse_sk;
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
@@ -469,18 +469,38 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
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
+	if (!IS_ERR_OR_NULL(result) && result->sk_state == TCP_ESTABLISHED)
+		goto done;
 
-		result = udp4_lib_lookup2(net, saddr, sport,
-					  htonl(INADDR_ANY), hnum, dif, sdif,
-					  hslot2, skb);
+	/* Lookup redirect from BPF */
+	sk = inet_lookup_run_bpf(net, udptable->protocol,
+				 saddr, sport, daddr, hnum);
+	if (IS_ERR(sk))
+		return NULL;
+	if (sk) {
+		reuse_sk = lookup_reuseport(net, sk, skb,
+					    saddr, sport, daddr, hnum);
+		result = reuse_sk ? : sk;
+		goto done;
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
2.25.3


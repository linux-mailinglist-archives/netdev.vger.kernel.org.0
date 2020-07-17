Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364F2223976
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgGQKf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgGQKfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:53 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF7FC08C5DC
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:52 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h22so12029434lji.9
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LPXPoxj9sk9RYPwMSCYR+PV+oV7CMuYMBBVgyyAlEyA=;
        b=De3AyfdBCd/kNvQAqMJMWG87C6e15az2OmmYDIXUUhfKw4ciqCBK+ymMzPynLRjM9r
         b0167rWcKYHLJm+8IEa4nJEC03I2uEfDrD4eqVz99ENqsH/Vy0VBTxQLS7RjvMvDo90+
         yLG5S4zfIccWOlswBNgMVnmCDJab7qZL6YLXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LPXPoxj9sk9RYPwMSCYR+PV+oV7CMuYMBBVgyyAlEyA=;
        b=q7ZiHf/liy/U6Q9nXCA/smyph7lDdqT2WAHLtbY6nUa2U+UlGb7mHSzZbuOZ4RO4Av
         oWVPT+8e3B00Zz41uhGTv5Dzn+QO2jCtSHUF6QXucOWZKVDTPlwTK91v0AjL/9PyXlP3
         25doZtSzqoyMYgdraYbQj4I2M5fz3jM9qXVtt1+hYS4BXVJo2BJfCjW7TMfFYB/mpRPb
         kv1YQsA+g0Dt4gDu6L+uaPZ2OFn8a4ibdATpqSeLMzrISXTcJyyuZme/x9sRy7IcDay2
         X3mvXK55SglrOjM5r6+bE9z6kLxRweAbUc24yVsTCtB1P94eHfd37qsS13Smou0YU5tz
         fNZg==
X-Gm-Message-State: AOAM5323ICUnXDO5wBpdI/aC1qTARaBmJ18TRWFMFekb44OErbS+Sgt9
        M/uSFgWHuSQgHw8ASPfRqh8kv4dNz5EGvA==
X-Google-Smtp-Source: ABdhPJy717iY5PK3LFbNDSGyiScNSrygHzIIL4465sTOE6iOtptBculw2TIerX7iQXcEsO0nZYHx8A==
X-Received: by 2002:a05:651c:305:: with SMTP id a5mr4011098ljp.387.1594982150831;
        Fri, 17 Jul 2020 03:35:50 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 193sm2122534lfa.90.2020.07.17.03.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:50 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v5 08/15] udp: Run SK_LOOKUP BPF program on socket lookup
Date:   Fri, 17 Jul 2020 12:35:29 +0200
Message-Id: <20200717103536.397595-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
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
index 9296faea3acf..b738c63d7a77 100644
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


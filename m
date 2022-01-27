Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E91C49D724
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiA0BKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiA0BKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:10:30 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5FCC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:10:30 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o11so1317917pjf.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VExHrWcJK7Mgx3PoLPlxYk+11GOP0EHex9zpvok9zSc=;
        b=XYUkcUoyHKRxCvtJmzdW1E0gnWCwiYfqfZCq00I6ujVvGFh+emYzQ0lLK7az/KQLHd
         wHbxAhwRMrzbrZvu1yEqhQZX8hCJkG+EvTEdFwZhZFREANBLD4hGGsCOPlaEGdy7LfzT
         xHruEvUkG/B/MrZODjidKRLYY2A2z5TPzLTYuxhWpLRNnQOqMxapQHY8dQ73C0U3E12M
         N+uECzpiqxSFPrf10nDpdrYvWlipxOvxnfhik4kjY8VimB6/g99GwO/BUQ1h+XWDLKEd
         WOCXvN47ACJKnvMyUPK8gFvupsjzIYP7B7T0Sbt2qyDv9PfqSYitudLVhBTtb7a5ViLX
         8SoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VExHrWcJK7Mgx3PoLPlxYk+11GOP0EHex9zpvok9zSc=;
        b=l2INYuzamk6wVqL5zwz5lPGGBw4fKcWFT/65FrajhxvIpi8e6xehFjBc8mYBYsjVRU
         49VUmRCgyESlVL7UmSP8HdhEbt6gUGJVxKxaqCGJ43HvQml1440dnjfvjUFFD6PBfbu3
         Fz/l4hqSXuuv9R4E1jGYqwplxtTl+utmLC5y9OaxfdUg21ltvkFTS2nvZLpwPstcyF82
         6t2LgJhhufthZcFH25W2O7YY/xSwR2EL7yPjIPZoh3v6SQKZXbmkIFiQrWFyyHJkAoQF
         SwBrEvGZXEh6McuTgpTrXZMWmd8xok8AZz9xKd0cwS30+ofkMo3dCleKjPNy1NmPlfhD
         pjfQ==
X-Gm-Message-State: AOAM531xoqB8yWHsUJ7Fn18EEZtAWo7A/V2QEdJpZbVKg/L9VSGOn0Tb
        RCjK1HtvHB5zesxt11Pa0qo=
X-Google-Smtp-Source: ABdhPJxp0frpZLuy3+2RVsP/vaK8ecNEPL5WWZEI22invgnqMLsGG3StDaTGs/to7+4GS3gtjPXUdQ==
X-Received: by 2002:a17:90a:a395:: with SMTP id x21mr11675520pjp.32.1643245830279;
        Wed, 26 Jan 2022 17:10:30 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id y42sm3563617pfa.5.2022.01.26.17.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 17:10:29 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ray Che <xijiache@gmail.com>,
        Geoff Alexander <alexandg@cs.unm.edu>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH v2 net 1/2] ipv4: tcp: send zero IPID in SYNACK messages
Date:   Wed, 26 Jan 2022 17:10:21 -0800
Message-Id: <20220127011022.1274803-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220127011022.1274803-1-eric.dumazet@gmail.com>
References: <20220127011022.1274803-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In commit 431280eebed9 ("ipv4: tcp: send zero IPID for RST and
ACK sent in SYN-RECV and TIME-WAIT state") we took care of some
ctl packets sent by TCP.

It turns out we need to use a similar strategy for SYNACK packets.

By default, they carry IP_DF and IPID==0, but there are ways
to ask them to use the hashed IP ident generator and thus
be used to build off-path attacks.
(Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)

One of this way is to force (before listener is started)
echo 1 >/proc/sys/net/ipv4/ip_no_pmtu_disc

Another way is using forged ICMP ICMP_FRAG_NEEDED
with a very small MTU (like 68) to force a false return from
ip_dont_fragment()

In this patch, ip_build_and_send_pkt() uses the following
heuristics.

1) Most SYNACK packets are smaller than IPV4_MIN_MTU and therefore
can use IP_DF regardless of the listener or route pmtu setting.

2) In case the SYNACK packet is bigger than IPV4_MIN_MTU,
we use prandom_u32() generator instead of the IPv4 hashed ident one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Ray Che <xijiache@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Cc: Geoff Alexander <alexandg@cs.unm.edu>
Cc: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/ip_output.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e331c8d4e6cfc4f2199a7877d8257b3b3b519561..139cec29ed06cd092ebdfd2bf0d13aaf67c5359d 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -162,12 +162,19 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	if (ip_dont_fragment(sk, &rt->dst)) {
+	/* Do not bother generating IPID for small packets (eg SYNACK) */
+	if (skb->len <= IPV4_MIN_MTU || ip_dont_fragment(sk, &rt->dst)) {
 		iph->frag_off = htons(IP_DF);
 		iph->id = 0;
 	} else {
 		iph->frag_off = 0;
-		__ip_select_ident(net, iph, 1);
+		/* TCP packets here are SYNACK with fat IPv4/TCP options.
+		 * Avoid using the hashed IP ident generator.
+		 */
+		if (sk->sk_protocol == IPPROTO_TCP)
+			iph->id = (__force __be16)prandom_u32();
+		else
+			__ip_select_ident(net, iph, 1);
 	}
 
 	if (opt && opt->opt.optlen) {
-- 
2.35.0.rc0.227.g00780c9af4-goog


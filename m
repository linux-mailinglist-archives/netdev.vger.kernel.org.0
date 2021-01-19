Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34632FBCE7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 17:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390097AbhASQuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 11:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389604AbhASQtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 11:49:46 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0661DC061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 08:49:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b5so252383pjl.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 08:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tW10kjvl17JnoXQo757FysJOAvIL2JAo5asqJu9kN+I=;
        b=XAvrvxBcUF0EoQTKMFjOO9MiXmgRw8tiBLha9k8WhioNCOp0e5L7/7OX0w37rWdKw4
         5Iumq6Pizu4zPs3EN8E3lhE53z6WgsUQv3vnvfNw4Q+7v+fn5DYYVmUcwOUd/2QJknFw
         11T6+z2FwfjZKlp45E8D1i8NWHo2X7/b7JqDSinF5izz+RQbqSfFn5aaR3EMfuarviva
         SAOZ3QVmvwL5sl3BFUS0tlLnfakfh8V1upi+fKIqf9qLD61sSfjYu6nzaaHHxPHs2gHB
         JvSDhkg71BzrFBiqgOiEiFQM99beviBVJp4yMF6apTwrw+MMixM12noaVLYp1pM2+FV2
         tNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tW10kjvl17JnoXQo757FysJOAvIL2JAo5asqJu9kN+I=;
        b=qxW7q45S5Qk4ylLvJ9NhZrE+Uc6og+93RaXLxbdBUQGbJJHsvUFRWHy5Uyl9rdsyL7
         PW3KxGT6Xl7Lsc6PRLfWrvCvq2tt8xW5bYOLIUfaXzQXPpsEY55Id783ziHDR3B9Xk8x
         3Y+pVnA3w4UXa6TDbIeI/u5Z24Z3eAGri0qTj8P70SVBVZ9NwE64ZNF/Is4AEKbS1EIZ
         cSHWLgmS6swArE/YHQnFnYb5Zr7jVwDU0SNUlb39kWhhI44TXAplmGtUtBt8FWvzwA5I
         +v60iR5+17lWT43wMIoAaE2kvvWXddTo6aP2QAJR7EKCQzVQYphEJ27hn5ZcznoJfPi5
         ENsg==
X-Gm-Message-State: AOAM532O9Z/OdUfmxP7d9Q+Rv/BCmGnu5HfBaazxYxTYgJf1MCfhvbUv
        ecEvWRU/UNCV3Pr+Q9APaI4=
X-Google-Smtp-Source: ABdhPJwDYyNWGKtT9sCVvNMt26PuU2Mt5kjYhvzlk7qMPOQIDp+VGGqCPauPuDyZsqq1A4uvKlgcrw==
X-Received: by 2002:a17:90a:f309:: with SMTP id ca9mr590011pjb.11.1611074945615;
        Tue, 19 Jan 2021 08:49:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id b5sm19152871pfi.1.2021.01.19.08.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:49:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Juerg Haefliger <juergh@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] tcp: do not mess with cloned skbs in tcp_add_backlog()
Date:   Tue, 19 Jan 2021 08:49:00 -0800
Message-Id: <20210119164900.766957-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Heiner Kallweit reported that some skbs were sent with
the following invalid GSO properties :
- gso_size > 0
- gso_type == 0

This was triggerring a WARN_ON_ONCE() in rtl8169_tso_csum_v2.

Juerg Haefliger was able to reproduce a similar issue using
a lan78xx NIC and a workload mixing TCP incoming traffic
and forwarded packets.

The problem is that tcp_add_backlog() is writing
over gso_segs and gso_size even if the incoming packet will not
be coalesced to the backlog tail packet.

While skb_try_coalesce() would bail out if tail packet is cloned,
this overwriting would lead to corruptions of other packets
cooked by lan78xx, sharing a common super-packet.

The strategy used by lan78xx is to use a big skb, and split
it into all received packets using skb_clone() to avoid copies.
The drawback of this strategy is that all the small skb share a common
struct skb_shared_info.

This patch rewrites TCP gso_size/gso_segs handling to only
happen on the tail skb, since skb_try_coalesce() made sure
it was not cloned.

Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-by: Juerg Haefliger <juergh@canonical.com>
Tested-by: Juerg Haefliger <juergh@canonical.com>
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209423
---
 net/ipv4/tcp_ipv4.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58207c7769d05693b650e3c93e4ef405a5d4b23a..4e82745d336fc3fb0d9ce8c92aaeb39702f64b8a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1760,6 +1760,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
 	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
+	u32 tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1767,6 +1768,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	unsigned int hdrlen;
 	bool fragstolen;
 	u32 gso_segs;
+	u32 gso_size;
 	int delta;
 
 	/* In case all data was pulled from skb frags (in __pskb_pull_tail()),
@@ -1792,13 +1794,6 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	 */
 	th = (const struct tcphdr *)skb->data;
 	hdrlen = th->doff * 4;
-	shinfo = skb_shinfo(skb);
-
-	if (!shinfo->gso_size)
-		shinfo->gso_size = skb->len - hdrlen;
-
-	if (!shinfo->gso_segs)
-		shinfo->gso_segs = 1;
 
 	tail = sk->sk_backlog.tail;
 	if (!tail)
@@ -1821,6 +1816,15 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 		goto no_coalesce;
 
 	__skb_pull(skb, hdrlen);
+
+	shinfo = skb_shinfo(skb);
+	gso_size = shinfo->gso_size ?: skb->len;
+	gso_segs = shinfo->gso_segs ?: 1;
+
+	shinfo = skb_shinfo(tail);
+	tail_gso_size = shinfo->gso_size ?: (tail->len - hdrlen);
+	tail_gso_segs = shinfo->gso_segs ?: 1;
+
 	if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
 		TCP_SKB_CB(tail)->end_seq = TCP_SKB_CB(skb)->end_seq;
 
@@ -1847,11 +1851,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 		}
 
 		/* Not as strict as GRO. We only need to carry mss max value */
-		skb_shinfo(tail)->gso_size = max(shinfo->gso_size,
-						 skb_shinfo(tail)->gso_size);
-
-		gso_segs = skb_shinfo(tail)->gso_segs + shinfo->gso_segs;
-		skb_shinfo(tail)->gso_segs = min_t(u32, gso_segs, 0xFFFF);
+		shinfo->gso_size = max(gso_size, tail_gso_size);
+		shinfo->gso_segs = min_t(u32, gso_segs + tail_gso_segs, 0xFFFF);
 
 		sk->sk_backlog.len += delta;
 		__NET_INC_STATS(sock_net(sk),
-- 
2.30.0.296.g2bfb1c46d8-goog


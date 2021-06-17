Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17A13AA7EE
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 02:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhFQAMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 20:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbhFQAMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 20:12:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD4BC061574;
        Wed, 16 Jun 2021 17:10:09 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso2800385pjp.2;
        Wed, 16 Jun 2021 17:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zf+Y9BbICR7uXIOjfsxq5dY5y3BEhQJ7HuObnjMRR8I=;
        b=afjGMf66GoysKxQYFQlbzLJML35lVDHt/lALOF4BdW4RO5GxSnBRzMFWtv/2m0odbk
         +facFjSuY43dJ8z9tnNmfR4GfLF6nD3wHjG7kOeaFeLTFQ7W0QREbV1GneSxoH0j+hdS
         GpHhpuxuIatPpPm98IPP3dzs/YC0SYxKAqfLMrx/aZLuWSvR8v+BUbuJP3lH9ROkdunC
         E8ovt1BWfYzzaXEqOWLWSo2nEcsw5oIW84BOiD/vQEIJhPYzen6gt4h3VsRUONMQM30E
         XfNSREarCSKyFApzKck70RYr8YNP/leNRBDrYVAB07Xzb6JoL+DPHTybA0XiTKv5HiHt
         1sLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zf+Y9BbICR7uXIOjfsxq5dY5y3BEhQJ7HuObnjMRR8I=;
        b=RpAILF5Y2emAnU1OYen8PQeV50zcIhfESRc5gtbHeW7qKRhOWqBkhsoL+0WXf3+SJL
         zpB7vIK9ZuoxggYs6qFxCWzZiGIzDglgjoxSApm4spv6E6LctKhi93UkYgvRsvPZPvQM
         XSS6VVxoFPLSmCa9ih+IlGero2+dE2MDvq1mxLlKPGFqnfsos94ImLvQBe38uG80OyYY
         1Qjjil22Dvx7ugtpq5ADf9G8PQUEx3yhZuLmDIq8YtQ1O2SY9ar5Cgf3W8woU7IB3JH7
         lb4/9I/l+NHGaNrgKfk0WPQfAA4NKipWPaxqeZAWJHMecMv2anHVc616DIJtD1qYPXrm
         bXbw==
X-Gm-Message-State: AOAM530hkttp2GfhNIrpZyyG5joBjG7MZW3kMLCXCIHwWUDVoNxthKC1
        uUgox/AEBuPBDHNG+jwPfBI=
X-Google-Smtp-Source: ABdhPJypFSqVrF7rFrHTbLNSGjci+IHB63c3QoCV4WSLAzUlfJ5KYPcssu3QkAQUo0jdlQATptafTA==
X-Received: by 2002:a17:90b:188c:: with SMTP id mn12mr6588649pjb.122.1623888609432;
        Wed, 16 Jun 2021 17:10:09 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:926a:e8dd:9095:3ddd])
        by smtp.gmail.com with ESMTPSA id r92sm6599633pja.6.2021.06.16.17.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 17:10:09 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next v2 3/4] bpf: support all gso types in bpf_skb_change_proto()
Date:   Wed, 16 Jun 2021 17:09:52 -0700
Message-Id: <20210617000953.2787453-3-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210617000953.2787453-1-zenczykowski@gmail.com>
References: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
 <20210617000953.2787453-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Since we no longer modify gso_size, it is now theoretically
safe to not set SKB_GSO_DODGY and reset gso_segs to zero.

This also means the skb_is_gso_tcp() check should no
longer be necessary.

Unfortunately we cannot remove the skb_{decrease,increase}_gso_size()
helpers, as they are still used elsewhere:
  bpf_skb_net_grow() without BPF_F_ADJ_ROOM_FIXED_GSO
  bpf_skb_net_shrink() without BPF_F_ADJ_ROOM_FIXED_GSO
and
  net/core/lwt_bpf.c's handle_gso_type()

Cc: Dongseok Yi <dseok.yi@samsung.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6541358a770b..8f05498f497e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3241,9 +3241,6 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
-	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
-		return -ENOTSUPP;
-
 	ret = skb_cow(skb, len_diff);
 	if (unlikely(ret < 0))
 		return ret;
@@ -3255,17 +3252,11 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		/* SKB_GSO_TCPV4 needs to be changed into
-		 * SKB_GSO_TCPV6.
-		 */
+		/* SKB_GSO_TCPV4 needs to be changed into SKB_GSO_TCPV6. */
 		if (shinfo->gso_type & SKB_GSO_TCPV4) {
 			shinfo->gso_type &= ~SKB_GSO_TCPV4;
 			shinfo->gso_type |=  SKB_GSO_TCPV6;
 		}
-
-		/* Header must be checked, and gso_segs recomputed. */
-		shinfo->gso_type |= SKB_GSO_DODGY;
-		shinfo->gso_segs = 0;
 	}
 
 	skb->protocol = htons(ETH_P_IPV6);
@@ -3280,9 +3271,6 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
-	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
-		return -ENOTSUPP;
-
 	ret = skb_unclone(skb, GFP_ATOMIC);
 	if (unlikely(ret < 0))
 		return ret;
@@ -3294,17 +3282,11 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		/* SKB_GSO_TCPV6 needs to be changed into
-		 * SKB_GSO_TCPV4.
-		 */
+		/* SKB_GSO_TCPV6 needs to be changed into SKB_GSO_TCPV4. */
 		if (shinfo->gso_type & SKB_GSO_TCPV6) {
 			shinfo->gso_type &= ~SKB_GSO_TCPV6;
 			shinfo->gso_type |=  SKB_GSO_TCPV4;
 		}
-
-		/* Header must be checked, and gso_segs recomputed. */
-		shinfo->gso_type |= SKB_GSO_DODGY;
-		shinfo->gso_segs = 0;
 	}
 
 	skb->protocol = htons(ETH_P_IP);
-- 
2.32.0.272.g935e593368-goog


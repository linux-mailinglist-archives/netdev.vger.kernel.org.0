Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB56C374B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCUQp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCUQpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:45:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AB22F793
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54463468d06so159090797b3.7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679417124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=540Q56UhNvjk+0udYRYTG39KVr8iIa8sVlLdy/wWOlU=;
        b=ju506B6Ah6KsQnnNRjR+/MgHW5YjnVFk2jeLUlCB5qxt4GLie63GbgniQQJ+Pozc6h
         MNrhLpOFFMAcSZ+fpgZdwO95NHdt+ukU2J9VngQ35yIn/5pf1BfAsol/EAVHcThSjVHx
         caTSgFPhNxR66Ak7bSdQQ+gtE2v2sEX5noo1ORdaRPFka4HG9/S3gZWly4XyVw0+Ka+I
         21f2OiHT9qQeq6KsdgEqaDoxrAW7BjktKhahoOC79R9Y7cPtI53rt0bluglqWPsFxjcI
         ZctsovrAvV5wzzqg38HQIEU93Dl+Xu2I1GkJ8Sc78apZ5wtPzVzGMH1Mx9dqDbcUe6qQ
         Wvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=540Q56UhNvjk+0udYRYTG39KVr8iIa8sVlLdy/wWOlU=;
        b=5d3uUMLevoaXzPJfnxld+Rdlcp+jpWsvRmOUQRBOIzh6V2B2UpO6ZclXui6WrQ81fJ
         6OcDFETz1Nrgno3QXEOWKv6cCDtGjrlGnhiQC1G81Mjzg+LoRpUbCe6BAWEqsIsF8NUd
         fy4P+o0xMJ4JBp81l7asZjDP1nnzJAB8nEB0n6XMmlVSx6wDSYYfXC0giFKTQKXvR6Jf
         tuj7NeNcP7JKY4pZRxkXvAi5lpacTXgXDRT7PXEqlfeflFGM2WyoqSmhwA7hx++RvMCZ
         W8SD62A5CszcDf+GdxgW3k3zjf4O5FAyYPuIuVIJfizFSD2zehhiFh+5oJ8qVScvblvP
         eeHg==
X-Gm-Message-State: AAQBX9dTV+I1YIFPyK/6RJpU/dR5O9EBaXEWEF6r9KAxJDnQXescUwal
        vLXP57b2FboyjVL+Y39h1Zv8XyUpizObWg==
X-Google-Smtp-Source: AKy350aXxJYSrbZqa2OxoitUCx0M5ny6qe/JlQqkyzmqhu1WDydaWe5T5KcR9xavKaHsPv2lCWDxK/HMrxwzmw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:154a:b0:b4c:9333:2a1 with SMTP
 id r10-20020a056902154a00b00b4c933302a1mr1882277ybu.10.1679417124714; Tue, 21
 Mar 2023 09:45:24 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:45:18 +0000
In-Reply-To: <20230321164519.1286357-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230321164519.1286357-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321164519.1286357-3-edumazet@google.com>
Subject: [PATCH net-next 2/3] sch_cake: do not use skb_mac_header() in cake_overhead()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to remove our use of skb_mac_header() in tx paths,
eg remove skb_reset_mac_header() from __dev_queue_xmit().

Idea is that ndo_start_xmit() can get the mac header
simply looking at skb->data.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_cake.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7970217b565a4ebbee3797ec0e5fb5667c5be795..891e007d5c0bf972a686b892c13d647e46b3274b 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1360,7 +1360,7 @@ static u32 cake_overhead(struct cake_sched_data *q, const struct sk_buff *skb)
 		return cake_calc_overhead(q, len, off);
 
 	/* borrowed from qdisc_pkt_len_init() */
-	hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
+	hdr_len = skb_transport_offset(skb);
 
 	/* + transport layer */
 	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 |
@@ -1368,14 +1368,14 @@ static u32 cake_overhead(struct cake_sched_data *q, const struct sk_buff *skb)
 		const struct tcphdr *th;
 		struct tcphdr _tcphdr;
 
-		th = skb_header_pointer(skb, skb_transport_offset(skb),
+		th = skb_header_pointer(skb, hdr_len,
 					sizeof(_tcphdr), &_tcphdr);
 		if (likely(th))
 			hdr_len += __tcp_hdrlen(th);
 	} else {
 		struct udphdr _udphdr;
 
-		if (skb_header_pointer(skb, skb_transport_offset(skb),
+		if (skb_header_pointer(skb, hdr_len,
 				       sizeof(_udphdr), &_udphdr))
 			hdr_len += sizeof(struct udphdr);
 	}
-- 
2.40.0.rc2.332.ga46443480c-goog


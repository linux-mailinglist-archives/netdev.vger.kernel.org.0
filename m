Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469902836D8
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 15:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJENsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 09:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgJENsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 09:48:19 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E082C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 06:48:18 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i3so5640519pjz.4
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 06:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AbMWngrDLVZ2m1L7tSwCryLRvupGsFR9BCcIm1c6i0k=;
        b=KIftgAPHZxvCg7VEYbJOpVLO8UR+DT0zWHpj+xgIRdse/r0kE0LzGSL568ULx69oYy
         ke05vnfsiBs9WuvZ9rbjoHpOe+XZpoFv5ffJDsBA394z5b84y6pg9kqCRKsjHO+rd92a
         t6Sp9n64KD22XJe9+opgzZRYOPlhWMzMoGG7k97Q/7ovoVAFGh6HWzEZ1MbODtUL7li+
         5pFJP8IAGetK9lKjFxFaft88YHti7cqlIvHkCXzuDCq+hlif/tZC4V1CpPstMZpVcq0W
         DlIKORS1Th7ckp9FNW8CTL7my8kbyTDO/bCkBYSNe0TTf5yrhZU4TVx9tZ2zs3/o0h8X
         QZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AbMWngrDLVZ2m1L7tSwCryLRvupGsFR9BCcIm1c6i0k=;
        b=JWvaLiwZo78wgmhJonnMNoh3bfTb7yRLj0+6jn9g67FkAJDukIoZ8dfXyGwFBIWhe4
         GudRHdjajs03TMUX+wJ4q0Z57EyR1/DeSTk3PiJs7WOgMh8tSG3W5+tPRaiRMDNiDTRA
         36brW8rhTARDTWAshvU+27gZAHeWQvs2qJiBuZ1k7SFfVk9ip5AeFLemMthUGgkIYK2D
         5BV3BGrap7KzMsSLFxHLZCfnkhIj0EJqnhPIOF0/m3evy6jDOOytqIdw75gsEJZoTNcX
         uyPVV3SVbtzzlEFYCqrrkqEOqiqpw7K16WNYeccwoPRzHgIzYpekQQC/j74mzStybmzQ
         5dJg==
X-Gm-Message-State: AOAM531ds4dWRC9+kOHBTe9HHaH9zEeQcmfLMhzR5YBPvDozEr6GkLHi
        YmiqsW2CRtQbV+Ji/66ZjWU=
X-Google-Smtp-Source: ABdhPJxwl0Fkm/jDgIPkQ3FDbjpdI960T07aaJzBu0mIfsHR5fFXloWGdJSYPabA8XAiaHstbZhMBg==
X-Received: by 2002:a17:90a:5c83:: with SMTP id r3mr17200718pji.112.1601905697556;
        Mon, 05 Oct 2020 06:48:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id e16sm11131893pgv.81.2020.10.05.06.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 06:48:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Subject: [PATCH net] tcp: fix receive window update in tcp_add_backlog()
Date:   Mon,  5 Oct 2020 06:48:13 -0700
Message-Id: <20201005134813.2051883-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We got reports from GKE customers flows being reset by netfilter
conntrack unless nf_conntrack_tcp_be_liberal is set to 1.

Traces seemed to suggest ACK packet being dropped by the
packet capture, or more likely that ACK were received in the
wrong order.

 wscale=7, SYN and SYNACK not shown here.

 This ACK allows the sender to send 1871*128 bytes from seq 51359321 :
 New right edge of the window -> 51359321+1871*128=51598809

 09:17:23.389210 IP A > B: Flags [.], ack 51359321, win 1871, options [nop,nop,TS val 10 ecr 999], length 0

 09:17:23.389212 IP B > A: Flags [.], seq 51422681:51424089, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 1408
 09:17:23.389214 IP A > B: Flags [.], ack 51422681, win 1376, options [nop,nop,TS val 10 ecr 999], length 0
 09:17:23.389253 IP B > A: Flags [.], seq 51424089:51488857, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 64768
 09:17:23.389272 IP A > B: Flags [.], ack 51488857, win 859, options [nop,nop,TS val 10 ecr 999], length 0
 09:17:23.389275 IP B > A: Flags [.], seq 51488857:51521241, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 32384

 Receiver now allows to send 606*128=77568 from seq 51521241 :
 New right edge of the window -> 51521241+606*128=51598809

 09:17:23.389296 IP A > B: Flags [.], ack 51521241, win 606, options [nop,nop,TS val 10 ecr 999], length 0

 09:17:23.389308 IP B > A: Flags [.], seq 51521241:51553625, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 32384

 It seems the sender exceeds RWIN allowance, since 51611353 > 51598809

 09:17:23.389346 IP B > A: Flags [.], seq 51553625:51611353, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 57728
 09:17:23.389356 IP B > A: Flags [.], seq 51611353:51618393, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 7040

 09:17:23.389367 IP A > B: Flags [.], ack 51611353, win 0, options [nop,nop,TS val 10 ecr 999], length 0

 netfilter conntrack is not happy and sends RST

 09:17:23.389389 IP A > B: Flags [R], seq 92176528, win 0, length 0
 09:17:23.389488 IP B > A: Flags [R], seq 174478967, win 0, length 0

 Now imagine ACK were delivered out of order and tcp_add_backlog() sets window based on wrong packet.
 New right edge of the window -> 51521241+859*128=51631193

Normally TCP stack handles OOO packets just fine, but it
turns out tcp_add_backlog() does not. It can update the window
field of the aggregated packet even if the ACK sequence
of the last received packet is too old.

Many thanks to Alexandre Ferrieux for independently reporting the issue
and suggesting a fix.

Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
---
 net/ipv4/tcp_ipv4.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5084333b5ab647ca8ed296235a1ed6573693b250..592c7396272315c864372c158a7bc8850c6ddc61 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1788,12 +1788,12 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 
 	__skb_pull(skb, hdrlen);
 	if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
-		thtail->window = th->window;
-
 		TCP_SKB_CB(tail)->end_seq = TCP_SKB_CB(skb)->end_seq;
 
-		if (after(TCP_SKB_CB(skb)->ack_seq, TCP_SKB_CB(tail)->ack_seq))
+		if (likely(!before(TCP_SKB_CB(skb)->ack_seq, TCP_SKB_CB(tail)->ack_seq))) {
 			TCP_SKB_CB(tail)->ack_seq = TCP_SKB_CB(skb)->ack_seq;
+			thtail->window = th->window;
+		}
 
 		/* We have to update both TCP_SKB_CB(tail)->tcp_flags and
 		 * thtail->fin, so that the fast path in tcp_rcv_established()
-- 
2.28.0.806.g8561365e88-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512352113B4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGATl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGATl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:41:28 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CACC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 12:41:28 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 124so9512108qko.8
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 12:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u1LsCCeTtWzUOL220SbBnqIDNoXhh7QqRlbt5kCx8QI=;
        b=fgTeXVrRr80NHV5aC1W5HUV7x3fyF++jBstWqP6ecpxgUmIu1bJhowaJyHT4GATr4C
         iIEviNYr0cTdqEIRAYJ47OqC4+T13n6kEplQOoO+adpTnaOwbt8nTyuiroC7UhlNGgT4
         Wid/ZbgDnx86JwtlBNX2LQwXuxlMzwFgyUWZR949jgOjz5wHW2dlmcC7SVsC5BMqbjX4
         6Y0dUpTtBCi+xU3bSchCBUBxyh1V1Ha/mEA1I9JB3KNS7UcrakaK/r8tuQqP3Pr4nBz5
         xeuwrqFdxAkI9vvEUKpY1/HBIiqbSizra7ER5jxRI3+S7sVZjLymPFnfjfzZX5QK+djA
         5XVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u1LsCCeTtWzUOL220SbBnqIDNoXhh7QqRlbt5kCx8QI=;
        b=JNn94fwtbpVDPXwiLHXZ+77fsR3ZOxKS/fZI+ZI4gh40Fhhr8TPNhZ/xXBv/a5aKxv
         sDRTuG0L3tygJvfZkkrXUU5wVOIVrMy50k9GSw+C/nDT+oSA6XqzIcnzLWCPK/uEVNtz
         DaO8cALma4X/jTZvHXjxOI/jj37FATzIT5MwlODw3HHB9swlC4yaOunYA3qq1WAS85JD
         nCfNPAmJwlSmB8UBIWLmy/oGI0NyEmpBbnVrVVBvMHAVAckoo0BVzf6qPU1C9JAVPrCq
         PXbASe5MW3N5omB4BXx7Lpb0tZqYmuZRRTbWim1WMmZgVTpy60TNVsl3iAuHrQeRnbfR
         r8QA==
X-Gm-Message-State: AOAM532XAQwBU2s9gcrfIopL9TmTqUZVqqVDqdC+9tZ5dtPN51gC6j90
        OkEQPxOzilW4E783QV7i/RoIfF4Lih9aKw==
X-Google-Smtp-Source: ABdhPJxkLSyJmxvKVqLypvdi5ZegGGXe99pkZdtEgJVo0ym72jiY9uKaryBrjOsz+gxLsnNotjIlWpnN4877VA==
X-Received: by 2002:ad4:58d0:: with SMTP id dh16mr26803833qvb.10.1593632487300;
 Wed, 01 Jul 2020 12:41:27 -0700 (PDT)
Date:   Wed,  1 Jul 2020 12:41:23 -0700
Message-Id: <20200701194123.3720996-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net] tcp: md5: do not send silly options in SYNCOOKIES
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Florian Westphal <fw@strlen.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever cookie_init_timestamp() has been used to encode
ECN,SACK,WSCALE options, we can not remove the TS option in the SYNACK.

Otherwise, tcp_synack_options() will still advertize options like WSCALE
that we can not deduce later when receiving the packet from the client
to complete 3WHS.

Note that modern linux TCP stacks wont use MD5+TS+SACK in a SYN packet,
but we can not know for sure that all TCP stacks have the same logic.

Before the fix a tcpdump would exhibit this wrong exchange :

10:12:15.464591 IP C > S: Flags [S], seq 4202415601, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 456965269 ecr 0,nop,wscale 8], length 0
10:12:15.464602 IP S > C: Flags [S.], seq 253516766, ack 4202415602, win 65535, options [nop,nop,md5 valid,mss 1400,nop,nop,sackOK,nop,wscale 8], length 0
10:12:15.464611 IP C > S: Flags [.], ack 1, win 256, options [nop,nop,md5 valid], length 0
10:12:15.464678 IP C > S: Flags [P.], seq 1:13, ack 1, win 256, options [nop,nop,md5 valid], length 12
10:12:15.464685 IP S > C: Flags [.], ack 13, win 65535, options [nop,nop,md5 valid], length 0

After this patch the exchange looks saner :

11:59:59.882990 IP C > S: Flags [S], seq 517075944, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 1751508483 ecr 0,nop,wscale 8], length 0
11:59:59.883002 IP S > C: Flags [S.], seq 1902939253, ack 517075945, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 1751508479 ecr 1751508483,nop,wscale 8], length 0
11:59:59.883012 IP C > S: Flags [.], ack 1, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508479], length 0
11:59:59.883114 IP C > S: Flags [P.], seq 1:13, ack 1, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508479], length 12
11:59:59.883122 IP S > C: Flags [.], ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508483], length 0
11:59:59.883152 IP S > C: Flags [P.], seq 1:13, ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508484 ecr 1751508483], length 12
11:59:59.883170 IP C > S: Flags [.], ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508484 ecr 1751508484], length 0

Of course, no SACK block will ever be added later, but nothing should break.
Technically, we could remove the 4 nops included in MD5+TS options,
but again some stacks could break seeing not conventional alignment.

Fixes: 4957faade11b ("TCPCT part 1g: Responder Cookie => Initiator")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 net/ipv4/tcp_output.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a50e1990a845a258d4cc6a2a989d09068ea3a973..5f5b2f0b0e606530e661ee8c5ad7a94e8efee74b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -700,7 +700,8 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 				       unsigned int mss, struct sk_buff *skb,
 				       struct tcp_out_options *opts,
 				       const struct tcp_md5sig_key *md5,
-				       struct tcp_fastopen_cookie *foc)
+				       struct tcp_fastopen_cookie *foc,
+				       enum tcp_synack_type synack_type)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
@@ -715,7 +716,8 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 		 * rather than TS in order to fit in better with old,
 		 * buggy kernels, but that was deemed to be unnecessary.
 		 */
-		ireq->tstamp_ok &= !ireq->sack_ok;
+		if (synack_type != TCP_SYNACK_COOKIE)
+			ireq->tstamp_ok &= !ireq->sack_ok;
 	}
 #endif
 
@@ -3394,7 +3396,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 #endif
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
-					     foc) + sizeof(*th);
+					     foc, synack_type) + sizeof(*th);
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
-- 
2.27.0.212.ge8ba1cc988-goog


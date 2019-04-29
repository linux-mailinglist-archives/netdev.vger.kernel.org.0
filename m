Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D4ECE8
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfD2Wqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:40 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:35327 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfD2Wqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:38 -0400
Received: by mail-qt1-f201.google.com with SMTP id d38so11729573qtb.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SsaVIdpmxOsoJtUbKm1tlZ5CzZ2C5YKxQwxyAKypJN0=;
        b=WftGa4uf7PoTH/Kc3x4fV/iPcM27Amu6XRlwn1XsVkyma59H/JnkjHIF2x+glgFCtF
         lkG1nZu60qNDFxReiGd0Pzgb7YqVx7mm+XyFbzsiPXCShvumeiOAgUvnMjtzIiqp+n0b
         o8gj68bobQodsZq0B1+X6HmTejPEeQBeyPdpGCXpN5oI0Jutqhl992/EheSFvHTjbL0F
         QDabXQfGsI9cLMaUxvJsIg1qEbA4qBE3UdaXnKTosaRgZIick7HbcdFbYFfBPZpnyooa
         zI1Bxjjzx13psBuoAIuAc4Ve8Qfr9yYfSSGxYAiCsBBvh+0cUVWUoXrq2RfWYi9zyZ8v
         e9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SsaVIdpmxOsoJtUbKm1tlZ5CzZ2C5YKxQwxyAKypJN0=;
        b=Ld0o+HFJX45TMLqc5TcsXV5/MxCdulmiCYOqH+GYQPoHdEonzeYRcly2QzdpVsT2sc
         I2BXbl3IaDxFDYNv9zDwLp/Xl7Ee3j41CtHoTGq1NTOIGKakLW3mEnYThH8gdBujNTxq
         Hq5eIYkEoXaH5Jsh04Dgv/F02d+JhxzO2WOkUbIlD/LvlG8U0Dxv8KVoIIlf2tMsUPVI
         HupK6/T5XVpGqQmvFKf/beBl+kBQTfRyiTY3DrzVqI9xJ8Ef4RGJC1n6Xjhv4FwpuRGp
         6btiIGtUoJc9sFPden/SjM6kmKx40RSjmcutYHtQunpUV5b+SKL87eJ7II9sXMrGS6B5
         Caew==
X-Gm-Message-State: APjAAAXfC038iMm1Pnlfst9L5Szaa+RaQ1Y8GEeGcTtqwc1z2JZLVzck
        bwYuELsmPTIIvCli8Pv58BTpX0SazS4=
X-Google-Smtp-Source: APXvYqyo0UShXG2eA/pVCPaxD+eRmvIXbH2AHdWowfkXIg0FrqT870QYWPmibIV6MEPLfQGn/ws2NFRDQMY=
X-Received: by 2002:a0c:d0b2:: with SMTP id z47mr10844276qvg.203.1556577997500;
 Mon, 29 Apr 2019 15:46:37 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:16 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-5-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 4/8] tcp: undo init congestion window on false SYNACK timeout
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux implements RFC6298 and use an initial congestion window
of 1 upon establishing the connection if the SYNACK packet is
retransmitted 2 or more times. In cellular networks SYNACK timeouts
are often spurious if the wireless radio was dormant or idle. Also
some network path is longer than the default SYNACK timeout. In
both cases falsely starting with a minimal cwnd are detrimental
to performance.

This patch avoids doing so when the final ACK's TCP timestamp
indicates the original SYNACK was delivered. It remembers the
original SYNACK timestamp when SYNACK timeout has occurred and
re-uses the function to detect spurious SYN timeout conveniently.

Note that a server may receives multiple SYNs from and immediately
retransmits SYNACKs without any SYNACK timeout. This often happens
on when the client SYNs have timed out due to wireless delay
above. In this case since the server will still use the default
initial congestion (e.g. 10) because tp->undo_marker is reset in
tcp_init_metrics(). This is an intentional design because packets
are not lost but delayed.

This patch only covers regular TCP passive open. Fast Open is
supported in the next patch.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c     | 2 ++
 net/ipv4/tcp_minisocks.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 30c6a42b1f5b..53b4c5a3113b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6101,6 +6101,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			tcp_rearm_rto(sk);
 		} else {
+			tcp_try_undo_spurious_syn(sk);
+			tp->retrans_stamp = 0;
 			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
 			tp->copied_seq = tp->rcv_nxt;
 		}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 79900f783e0d..9c2a0d36fb20 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -522,6 +522,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 		newtp->rx_opt.ts_recent_stamp = 0;
 		newtp->tcp_header_len = sizeof(struct tcphdr);
 	}
+	if (req->num_timeout) {
+		newtp->undo_marker = treq->snt_isn;
+		newtp->retrans_stamp = div_u64(treq->snt_synack,
+					       USEC_PER_SEC / TCP_TS_HZ);
+	}
 	newtp->tsoffset = treq->ts_off;
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
-- 
2.21.0.593.g511ec345e18-goog


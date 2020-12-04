Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6DA2CF3A6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgLDSJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:09:06 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:52661 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbgLDSJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607105346; x=1638641346;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=H2KlUOOlV6oaZh6r5D5fOhkr5QZB3/YPixXbdbQ+S2o=;
  b=c59pwaPVetAYFZYcjpNAcAo8/FBX2CwyqDyS8w7tu+bYs+D3GU6aoM/j
   dFFsLxgRn1QSL+Nh0v5eUDI0Bz6FRgEQaMrKth+P7Q1N7vpMJDRGV285M
   lATj+rVY0T12P+cruyWCcyJBM1gsf03Bu7Mfw4o32lUOyR7uvils0u2F/
   A=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="93582187"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 04 Dec 2020 18:08:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id BA78CA183A;
        Fri,  4 Dec 2020 18:08:18 +0000 (UTC)
Received: from EX13D21UWB003.ant.amazon.com (10.43.161.212) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:08:18 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D21UWB003.ant.amazon.com (10.43.161.212) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:08:18 +0000
Received: from dev-dsk-abuehaze-1c-926c8132.eu-west-1.amazon.com
 (10.15.10.116) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 18:08:17 +0000
Received: by dev-dsk-abuehaze-1c-926c8132.eu-west-1.amazon.com (Postfix, from userid 5005603)
        id 1EF9B88232; Fri,  4 Dec 2020 18:08:16 +0000 (UTC)
From:   Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <edumazet@google.com>,
        <ycheng@google.com>, <ncardwell@google.com>, <weiwan@google.com>,
        <astroh@amazon.com>, <benh@amazon.com>,
        Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Subject: [PATCH net-next] tcp: optimise  receiver buffer autotuning initialisation for high latency connections
Date:   Fri, 4 Dec 2020 18:06:22 +0000
Message-ID: <20201204180622.14285-1-abuehaze@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Previously receiver buffer auto-tuning starts after receiving
    one advertised window amount of data.After the initial
    receiver buffer was raised by
    commit a337531b942b ("tcp: up initial rmem to 128KB
    and SYN rwin to around 64KB"),the receiver buffer may
    take too long for TCP autotuning to start raising
    the receiver buffer size.
    commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
    tried to decrease the threshold at which TCP auto-tuning starts
    but it's doesn't work well in some environments
    where the receiver has large MTU (9001) configured
    specially within environments where RTT is high.
    To address this issue this patch is relying on RCV_MSS
    so auto-tuning can start early regardless
    the receiver configured MTU.

    Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
    Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")

Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 389d1b340248..f0ffac9e937b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -504,13 +504,14 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 static void tcp_init_buffer_space(struct sock *sk)
 {
 	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
 	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
 		tcp_sndbuf_expand(sk);
 
-	tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
+	tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * icsk->icsk_ack.rcv_mss);
 	tcp_mstamp_refresh(tp);
 	tp->rcvq_space.time = tp->tcp_mstamp;
 	tp->rcvq_space.seq = tp->copied_seq;
-- 
2.16.6




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705




Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EDE2D0F9A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgLGLlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:41:44 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:52949 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgLGLln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 06:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607341303; x=1638877303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DT8dfGvHCH2RcZ5XMyxNuf8g5vxxb2qMyJp3K1JoGJg=;
  b=b2/03PUMKdMHp+cpxeWCelnCrrVnHoULWoyd2xEbd256PUqKGBp0s31l
   7FRt11XUNUehORp3tI8NgfgwHjaRebwx9A6nI7AYl0GB/SkyDexLNR49O
   Qhx1R1zSHXvyYUiqA9Qv1VG8nXa2bAaVqzpJ836d8I8h8j/yI9aYLcV6i
   0=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="901101630"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 11:41:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id D7968A18C8;
        Mon,  7 Dec 2020 11:40:59 +0000 (UTC)
Received: from EX13D21UWB002.ant.amazon.com (10.43.161.177) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 11:40:59 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D21UWB002.ant.amazon.com (10.43.161.177) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 11:40:59 +0000
Received: from dev-dsk-abuehaze-1c-926c8132.eu-west-1.amazon.com
 (10.15.10.116) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 7 Dec 2020 11:40:57 +0000
Received: by dev-dsk-abuehaze-1c-926c8132.eu-west-1.amazon.com (Postfix, from userid 5005603)
        id 02A718846F; Mon,  7 Dec 2020 11:40:57 +0000 (UTC)
From:   Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <edumazet@google.com>,
        <ycheng@google.com>, <ncardwell@google.com>, <weiwan@google.com>,
        <astroh@amazon.com>, <benh@amazon.com>,
        Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Subject: [PATCH net] tcp: fix receive buffer autotuning to trigger for any valid advertised MSS
Date:   Mon, 7 Dec 2020 11:40:49 +0000
Message-ID: <20201207114049.7634-1-abuehaze@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <4ABEB85B-262F-4657-BB69-4F37ABC0AE3D@amazon.com>
References: <4ABEB85B-262F-4657-BB69-4F37ABC0AE3D@amazon.com>
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
    where the receiver has large MTU (9001) especially with high RTT
    connections as in these environments rcvq_space.space will be the same
    as rcv_wnd so TCP autotuning will never start because
    sender can't send more than rcv_wnd size in one round trip.
    To address this issue this patch is decreasing the initial
    rcvq_space.space so TCP autotuning kicks in whenever the sender is
    able to send more than 5360 bytes in one round trip regardless the
    receiver's configured MTU.

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




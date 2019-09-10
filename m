Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDEBAF2AF
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfIJVte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:49:34 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:43800 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJVtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 17:49:33 -0400
Received: by mail-pl1-f202.google.com with SMTP id y6so10629189plt.10
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 14:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=z94MmYK6uHXVXRc2VNDG+BQBt7iq7JdB7p0D6JqeVdk=;
        b=u8SFatFRsWwvjji0dJhEKLMc1lrIeDxu9Smn9B7s9HxQQkDJrF9etw1rpSfgQm0bJ6
         m9htemNYVM3mzIpj1mxOkW3L5H2XZrpodI9lXZBgouzkXOuqESUy90Z42cXMiqwsP1tn
         vps3yLZMqS92T/0wq1igpeWpsVWGUo6eCZ6TyAiHzZqmr9vhhxbM/jJhKjTEdi+VHX5r
         ouSqcUAgzDkxvAy1j5RQYICjMeY34g2cCV6IhOp0PA61DYv3slfkE80u4Lq0Gv02Jf64
         7YmBo6oD/m9nXsOcYIewwH6ERPt3jMXHuWUJTCBpgyccPaJtcaWvBAKwDyupFoPmVBAn
         U5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=z94MmYK6uHXVXRc2VNDG+BQBt7iq7JdB7p0D6JqeVdk=;
        b=DJ+qBTWpIRDo3Sinl1oeZZKlrmn2Cl8NSkprLwhiy4Uh+JabfUiMsWjn/V18WnquFk
         8navK8nyYMBQBjGe5W8HYfPZX45XIx8t2Mo9FMdHuDDNTJVW9rYJtZ/RzbH+TX95Ex9T
         HTP4pnopR8nDZBdbbMfNAJ72qn5k9lNxtiVyZNOjB9Gk1oPCTna/k4ReX2eCuEwaAaxw
         sIJJRgB3JqMdFdjogyt4oo3MNyk6WboZK17+NxMHGNx0xUd4x6w4g0qePvxs7tO42gXe
         azX0khkBDIqsnjrSJ3Yw29jMVLSFcXyA/pbe40FSuSroieuddldjz8iWxNqBNF2nIh33
         NVrA==
X-Gm-Message-State: APjAAAWKnGe1Dc6aI3iStQ1RL935eqNT4Qt6OwGgZ6iakSoKxzh4zThQ
        dvK5URvlrLdCf0OVOxuuegn43llNa3a/2w==
X-Google-Smtp-Source: APXvYqx3nANTaa4tp773CPFI6k0kLAamRwdxwElzH5pqD4kZ6FqoBPolJfijLKrPDM9gg1CDgyDFxIsvgrqGGw==
X-Received: by 2002:a63:7887:: with SMTP id t129mr30164608pgc.309.1568152172520;
 Tue, 10 Sep 2019 14:49:32 -0700 (PDT)
Date:   Tue, 10 Sep 2019 14:49:28 -0700
Message-Id: <20190910214928.220727-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [PATCH net-next] tcp: force a PSH flag on TSO packets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tcp sends a TSO packet, adding a PSH flag on it
reduces the sojourn time of GRO packet in GRO receivers.

This is particularly the case under pressure, since RX queues
receive packets for many concurrent flows.

A sender can give a hint to GRO engines when it is
appropriate to flush a super-packet, especially when pacing
is in the picture, since next packet is probably delayed by
one ms.

Having less packets in GRO engine reduces chance
of LRU eviction or inflated RTT, and reduces GRO cost.

We found recently that we must not set the PSH flag on
individual full-size MSS segments [1] :

 Under pressure (CWR state), we better let the packet sit
 for a small delay (depending on NAPI logic) so that the
 ACK packet is delayed, and thus next packet we send is
 also delayed a bit. Eventually the bottleneck queue can
 be drained. DCTCP flows with CWND=1 have demonstrated
 the issue.

This patch allows to slowdown the aggregate traffic without
involving high resolution timers on senders and/or
receivers.

It has been used at Google for about four years,
and has been discussed at various networking conferences.

[1] segments smaller than MSS already have PSH flag set
    by tcp_sendmsg() / tcp_mark_push(), unless MSG_MORE
    has been requested by the user.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Tariq Toukan <tariqt@mellanox.com>
---
 net/ipv4/tcp_output.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 42abc9bd687a5fea627cbc7cfa750d022f393d84..fec6d67bfd146dc78f0f25173fd71b8b8cc752fe 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1050,11 +1050,22 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	tcb = TCP_SKB_CB(skb);
 	memset(&opts, 0, sizeof(opts));
 
-	if (unlikely(tcb->tcp_flags & TCPHDR_SYN))
+	if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
 		tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5);
-	else
+	} else {
 		tcp_options_size = tcp_established_options(sk, skb, &opts,
 							   &md5);
+		/* Force a PSH flag on all (GSO) packets to expedite GRO flush
+		 * at receiver : This slightly improve GRO performance.
+		 * Note that we do not force the PSH flag for non GSO packets,
+		 * because they might be sent under high congestion events,
+		 * and in this case it is better to delay the delivery of 1-MSS
+		 * packets and thus the corresponding ACK packet that would
+		 * release the following packet.
+		 */
+		if (tcp_skb_pcount(skb) > 1)
+			tcb->tcp_flags |= TCPHDR_PSH;
+	}
 	tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
 
 	/* if no packet is in qdisc/device queue, then allow XPS to select
-- 
2.23.0.162.g0b9fbb3734-goog


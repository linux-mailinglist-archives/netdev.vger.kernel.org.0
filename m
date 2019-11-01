Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F58EC78F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfKARc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:32:26 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:47446 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfKARc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:32:26 -0400
Received: by mail-pl1-f201.google.com with SMTP id v2so6705423plp.14
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 10:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cgHsIsZTiO9GnwGhVEh0RrWTGDsayFQMUrZq6bTYQQY=;
        b=ffENwlONkouDhmd8wui0i06NWtACahX7TCvzA4E2PGz/gnSyWfV6EESg3YQ+rVgZx+
         fplDRmhKKmaOgVkwkzmLc3cVqfjV/vBxv0HFUVohMWJr/kK5MT1YgBiQYneMoynvqPLn
         QHp20NRV25tNoXcojjFxEgGqpIjuPBpY4k36xNfKj/LII2MOOZPWbgnM1sNjb11rR8iQ
         aD66k7gKTc9/w3y1uXBE/tYWCE0+MRLSA6WCzhEtwxGsgrb7nI2Ge1QMefIXVJfsUlJQ
         9lQbeAlkRvMyCDgRX8uORBTRDQEiuDjYnAUXy7hvCVVOCQ/auw2Sn6Sxw2RsVSSsoxy8
         52ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cgHsIsZTiO9GnwGhVEh0RrWTGDsayFQMUrZq6bTYQQY=;
        b=rshCzKTwJzbcaev/9lsPbpAIwQqv5sqmm/LNrcz+zBhztoAJz6t0T/lNis30IGl2Pm
         6DsEj09bfPOKDV8ob32yyXNXRo5BdpTf4Iqt+3moOjLr2wayFNEUngKnPn/mqEYelWuc
         pRIUlTNJK52F7B3hfaLOTx05uf60FoaR1SI1S87GgM5uAROfbOyR2grdGVYGl+yeWPfT
         /vgew6V32BCC2D8GPABXePwfLFDJOmzZYRMl+ESRY1Cs14QvE7AQxI20znPyroM07INB
         K2opz7CxIhVTM64sVBMISpy41s/lCU35osA59hnsISvM3lX3u1HaN5iq88lfnfWIK1AG
         5Fjg==
X-Gm-Message-State: APjAAAW5ntQIlIqSQ46XI11LfZdbcIFY5wJzY/QTPD0zWC8iJDvv13tO
        FcgKJbbWh3NcWQbd7MSGm5spXJMnas9VMg==
X-Google-Smtp-Source: APXvYqzMsmoGuEiuD7mDxkNhAFqsJ9UZodlPKTUpb8a+xmdrn3EhtT1qqj5LP4LNK1thZsfKAm0l7AxEOtkU8Q==
X-Received: by 2002:a65:6201:: with SMTP id d1mr14346802pgv.182.1572629543599;
 Fri, 01 Nov 2019 10:32:23 -0700 (PDT)
Date:   Fri,  1 Nov 2019 10:32:19 -0700
Message-Id: <20191101173219.18631-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net] inet: stop leaking jiffies on the wire
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thiemo Nagel <tnagel@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically linux tried to stick to RFC 791, 1122, 2003
for IPv4 ID field generation.

RFC 6864 made clear that no matter how hard we try,
we can not ensure unicity of IP ID within maximum
lifetime for all datagrams with a given source
address/destination address/protocol tuple.

Linux uses a per socket inet generator (inet_id), initialized
at connection startup with a XOR of 'jiffies' and other
fields that appear clear on the wire.

Thiemo Nagel pointed that this strategy is a privacy
concern as this provides 16 bits of entropy to fingerprint
devices.

Let's switch to a random starting point, this is just as
good as far as RFC 6864 is concerned and does not leak
anything critical.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thiemo Nagel <tnagel@google.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 2 +-
 net/dccp/ipv4.c                         | 2 +-
 net/ipv4/datagram.c                     | 2 +-
 net/ipv4/tcp_ipv4.c                     | 4 ++--
 net/sctp/socket.c                       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 774d991d7cca49011016d41c00914ad84059ccb8..aca75237bbcf83eb1d440bcdf1e4d3b702cff0a1 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1297,7 +1297,7 @@ static void make_established(struct sock *sk, u32 snd_isn, unsigned int opt)
 	tp->write_seq = snd_isn;
 	tp->snd_nxt = snd_isn;
 	tp->snd_una = snd_isn;
-	inet_sk(sk)->inet_id = tp->write_seq ^ jiffies;
+	inet_sk(sk)->inet_id = prandom_u32();
 	assign_rxopt(sk, opt);
 
 	if (tp->rcv_wnd > (RCV_BUFSIZ_M << 10))
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index d9b4200ed12df8ecc7ff7de26827207c5a290e37..0d8f782c25ccc031e5322beccb0242ee42b032b9 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -117,7 +117,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 						    inet->inet_daddr,
 						    inet->inet_sport,
 						    inet->inet_dport);
-	inet->inet_id = dp->dccps_iss ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	err = dccp_connect(sk);
 	rt = NULL;
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 9a0fe0c2fa02c9707e6fc8c02529a48e84f7d680..4a8550c49202db13b17d5cf4ed1e44dd8852c212 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -73,7 +73,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
-	inet->inet_id = jiffies;
+	inet->inet_id = prandom_u32();
 
 	sk_dst_set(sk, &rt->dst);
 	err = 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6be568334848c7841a4a09126937f71f60420103..7512c04f72103da9c25d25dfd91a7d39443d0f3e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -303,7 +303,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 						 inet->inet_daddr);
 	}
 
-	inet->inet_id = tp->write_seq ^ jiffies;
+	inet->inet_id = prandom_u32();
 
 	if (tcp_fastopen_defer_connect(sk, &err))
 		return err;
@@ -1450,7 +1450,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
 	if (inet_opt)
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
-	newinet->inet_id = newtp->write_seq ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	if (!dst) {
 		dst = inet_csk_route_child_sock(sk, newsk, req);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca81e06df1651f16ab332cd9fc880c21b89a5c6d..ffd3262b7a41eac2e3d825c3f0665066f376ea3c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9306,7 +9306,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
 	newinet->inet_dport = htons(asoc->peer.port);
 	newinet->pmtudisc = inet->pmtudisc;
-	newinet->inet_id = asoc->next_tsn ^ jiffies;
+	newinet->inet_id = prandom_u32();
 
 	newinet->uc_ttl = inet->uc_ttl;
 	newinet->mc_loop = 1;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog


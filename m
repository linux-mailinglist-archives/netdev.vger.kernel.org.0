Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC28B6472A
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfGJNkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:40:17 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40214 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJNkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:40:16 -0400
Received: by mail-pl1-f201.google.com with SMTP id 91so1318459pla.7
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 06:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2NyWKqXYF+r45CnDWvrExLBIkwiPou26mWjfWX3bPTc=;
        b=J1S5g20OwA3a77PJgPHWB0hdVwthzObEulojryxdMH/V/P6Qip4ewIdRS7DeLe/uZC
         F4Ahp0rtT7pPEexYqC1Z3rhwKmwjO3/zVV0Kf9WpMK7PF3BP6dGCizpY2MdJroNFusXo
         LBEwI+D6o4xW9eAxLRyHP+y3pio16LDvfmCOsVVLriqPqkYStwMavzHkpFpL4Uyov7bT
         +AaC7BFoXfK5kgQOnk2SKYbBsQ265x6l29XKYfGV1pTPFXMJJhFATgyYt7H7ZDczAJF/
         14WLIg7i0dzjUKlckcJfaSVjpK/cj3jCDsNlzHcBudcEUJAaL7Ez60l+fOcSaKD/iEmM
         tLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2NyWKqXYF+r45CnDWvrExLBIkwiPou26mWjfWX3bPTc=;
        b=AlKA8lxsOebmPV7tVID8jrAoudxdu6+tm0m7PYUu+TA1w62mN3PEQrn+eeYTJ5vZjZ
         Qd+S5JcwiYd8OMAZmwjnQJ3fp3h3x5cgtq+dLFR7h2MYm5KSToNZ13d5O3HRTKPADS+q
         2DCaIxDDea3JObWRup95o/wYPexUO/FA+ase8hKRElnTmDiSJr7IRLg1XyWYrfGc1BaF
         kEwMbxIpW3TcqNHJOf54iHHC/F7c3Wr0fiD/gne5Qv8qRGFemegEnBZJ/wOg8sbh5QUJ
         jLAFCfx32VwJnOFWXJujJ00+oMptZAJ7HK4l0UDT2o1Dm71SQ4K4vu+FhLynCOBvgUxd
         Xmcg==
X-Gm-Message-State: APjAAAXHyRPkd4OnrNcXVYzefz5YQVtgidIQg3crkntwUfNcNZv3kb8R
        yhLgXjGEDyLSPtZ3qaP1D067NkXbmBokGg==
X-Google-Smtp-Source: APXvYqzFcQM2XNZEYsaYjlZcAFhj6SlQdFKNaKskN8oRZ0hbzKbOlpD2EYE5Jpl9025ctFqm50WC8Mj2zde92g==
X-Received: by 2002:a63:f4e:: with SMTP id 14mr37578418pgp.58.1562766015185;
 Wed, 10 Jul 2019 06:40:15 -0700 (PDT)
Date:   Wed, 10 Jul 2019 06:40:09 -0700
Message-Id: <20190710134011.221210-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] ipv6: tcp: fix flowlabels reflection for RST packets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 323a53c41292 ("ipv6: tcp: enable flowlabel reflection in some RST packets")
and 50a8accf1062 ("ipv6: tcp: send consistent flowlabel in TIME_WAIT state")
we took care of IPv6 flowlabel reflections for two cases.

This patch takes care of the remaining case, when the RST packet
is sent on behalf of a 'full' socket.

In Marek use case, this was a socket in TCP_CLOSE state.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Marek Majkowski <marek@cloudflare.com>
Tested-by: Marek Majkowski <marek@cloudflare.com>
---
 net/ipv6/tcp_ipv6.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d56a9019a0feb5a34312ec353c555f44b8c09b3d..5da069e91cacca4e84a3e41dae4746c9d38fcc46 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -984,8 +984,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 	if (sk) {
 		oif = sk->sk_bound_dev_if;
-		if (sk_fullsock(sk))
+		if (sk_fullsock(sk)) {
+			const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
+
 			trace_tcp_send_reset(sk, skb);
+			if (np->repflow)
+				label = ip6_flowlabel(ipv6h);
+		}
 		if (sk->sk_state == TCP_TIME_WAIT)
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
 	} else {
-- 
2.22.0.410.gd8fdbe21b5-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10C129273C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgJSM03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgJSM03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091DCC0613D0;
        Mon, 19 Oct 2020 05:26:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p21so5246145pju.0;
        Mon, 19 Oct 2020 05:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ROdQSoNdZKqCAMjkxoMjfcJGDYgA7Iqly+Pb0MS2b4E=;
        b=IhKo//bg5gvtTrxhVc79Pchgx6vkEB6G6whzHAvTpoyVa9XQkKRMDyqXHsTOKEi4vs
         yHa1jPIav1RZWPC//QaprKCyA4SJoDc9e21ITrRzYcGW+0JxMjLNyYXc6N015XHVpShc
         yysmf3YyPzeDknAgj/kui+HSomO97ysDxS2wm1m4YMGW5QaKPeTDYMzCMgTTAfNbu6w8
         3CXht99/zKBSICIee/fB40KSrT+8xH8a8pRDi1XwM3iPB30hYZvtzQPHqVznmGd7DfWR
         sn2J9mV3NJbo/T355Awu2n1OTx4qfX1WpTKM/62MuADLj5G1eC0fNMHx6so8M7P5eafA
         jDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ROdQSoNdZKqCAMjkxoMjfcJGDYgA7Iqly+Pb0MS2b4E=;
        b=tLnqFpK1ic7vmqxpNeSeabQERUOYo0Ot0I5EDMfLp3okxesD7kOuAC/Uo5OAAtJBzv
         PD+zTukPHGFbRkWnnviDjx1FQcABY1Rn1581buf0DJN7W17udXs090o9IIc5NhHXywKK
         kUDC9VW03Rw7ikj9bhaNAM3rodVslF8tIeGs6NSUl8NhCCIA3xs3f0Cq2M5JhbxcEqua
         D9eWsSuC0ZCmPy7+3hoLEgt9ULxzTfXZ230SSPeXjnk7/uhmU4kqZl0gC3HBu4y/vv4b
         73LfwG3WK7S/97DDo8wtB807ntl8WdnZyNDn2IuMNO4g4MIR5TBu/ca8IYjhM1Y9dTJP
         Ibdg==
X-Gm-Message-State: AOAM531V1ydBD1vu/cdC2Sntt1VEXscfj+H50FQ2WkC2VlOGJe4WSBxO
        bT85PQfcMZZrFhCMht5+tziP9W8Vzwg=
X-Google-Smtp-Source: ABdhPJyBmgmjc9iEDLoNAh5naY+mu8McSk5dKSWwoqmSqqfDc/92ZpCCoAq0nDoJblExg7G2yP1YEA==
X-Received: by 2002:a17:90a:1c4:: with SMTP id 4mr1351830pjd.86.1603110387328;
        Mon, 19 Oct 2020 05:26:27 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j12sm11798653pjs.21.2020.10.19.05.26.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 06/16] sctp: add encap_err_lookup for udp encap socks
Date:   Mon, 19 Oct 2020 20:25:23 +0800
Message-Id: <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it says in rfc6951#section-5.5:

  "When receiving ICMP or ICMPv6 response packets, there might not be
   enough bytes in the payload to identify the SCTP association that the
   SCTP packet triggering the ICMP or ICMPv6 packet belongs to.  If a
   received ICMP or ICMPv6 packet cannot be related to a specific SCTP
   association or the verification tag cannot be verified, it MUST be
   discarded silently.  In particular, this means that the SCTP stack
   MUST NOT rely on receiving ICMP or ICMPv6 messages.  Implementation
   constraints could prevent processing received ICMP or ICMPv6
   messages."

ICMP or ICMPv6 packets need to be handled, and this is implemented by
udp encap sock .encap_err_lookup function.

The .encap_err_lookup function is called in __udp(6)_lib_err_encap()
to confirm this path does need to be updated. For sctp, what we can
do here is check if the corresponding asoc and transport exist.

Note that icmp packet process for sctp over udp is done by udp sock
.encap_err_lookup(), and it means for now we can't do as much as
sctp_v4/6_err() does. Also we can't do the two mappings mentioned
in rfc6951#section-5.5.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index e1501e7..aa8e5b2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -848,6 +848,23 @@ static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static int sctp_udp_err_lookup(struct sock *sk, struct sk_buff *skb)
+{
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	int family;
+
+	skb->transport_header += sizeof(struct udphdr);
+	family = (ip_hdr(skb)->version == 4) ? AF_INET : AF_INET6;
+	sk = sctp_err_lookup(dev_net(skb->dev), family, skb, sctp_hdr(skb),
+			     &asoc, &t);
+	if (!sk)
+		return -ENOENT;
+
+	sctp_err_finish(sk, t);
+	return 0;
+}
+
 int sctp_udp_sock_start(struct net *net)
 {
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
@@ -866,6 +883,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
+	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
@@ -887,6 +905,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
+	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp6_sock = sock->sk;
 #endif
-- 
2.1.0


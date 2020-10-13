Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53D128C946
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390183AbgJMH2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E30C0613D0;
        Tue, 13 Oct 2020 00:28:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o3so6974487pgr.11;
        Tue, 13 Oct 2020 00:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mddk0RPj5RANjKGN0DxBgjaZKh24JdfVj6LOwAP3f/8=;
        b=j4gxN2sMBKZi1Hp+ijuVwR+tO/CfPXTlygoK2MEcsuSI/YISv22AFnF4qKw/w2PVqz
         Odfn5CocQHNee/qLT6T5sZ+JbZ6XkwwlXGmqZDcj9s/+G82RGk+j4bFK6nfloLLRDydf
         lMtmG6YFoMWRFjv3anrey9vKNckKNrwJswNpLYFpkmV+IcTtYp2ZrAfUxfkc9+Jwh8Y3
         Jtn+TLPEu+em3ggf/ZtK1s78hsP7Ch4espTYihzfJTobadmzQnCQ7+zBAZXCUC1SUaAs
         tHKzAIAOEJ+jL25hyAkuxKCjQxsMONFOlAOkel4rEZasenljMS9N4nktQluSuGgYzo6H
         JYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mddk0RPj5RANjKGN0DxBgjaZKh24JdfVj6LOwAP3f/8=;
        b=T4Rh4K4/yzwwdiHkPiEYla3d1+UnTZgPL5SzG+hpRnOGB6w/dPgrXLafmNX6+3YdDC
         36dMtVg+pyDGhW7hFBTvFHPeG9ffDIoz0wihjxSCEzEM7sQj16CwyMl8rvCtsVKZ9rcW
         d5zmy7LbZlVE/U/XZ4fFNn/U3IIguE5oVTRGRGxmRdQDPxy1f6fDHSwfcSeG9xgP15tF
         JnGvBvp+a4gYUlSFBKcyS3Xsd2KAfzefjjbmYySRBse1sPAnVQpXt/DUI1bHRy1H7jRO
         sWp6WBs9avmd4cL01E0p5SJScixdRqcAEy6ZkDZ/5K01EXi7ZGcQfcomLUvuZZpgsvw9
         wwvQ==
X-Gm-Message-State: AOAM532VzcrF9Q/oncuohXxrkthzto21bkzujxm+LQkQ2OR2e+zbzijx
        B6gTnGLqruXmmmNCxMRKGn0/ArRKAXQ=
X-Google-Smtp-Source: ABdhPJx3RGGf/wDndy3+JimNOJCCTV4gcgYhKOqrezDH0+QnY1AbkdS493kicslpT9NmdPJ9EPq3oA==
X-Received: by 2002:a62:6347:0:b029:155:8201:c620 with SMTP id x68-20020a6263470000b02901558201c620mr19205182pfb.23.1602574115199;
        Tue, 13 Oct 2020 00:28:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f66sm7204921pfa.59.2020.10.13.00.28.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:34 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 06/16] sctp: add encap_err_lookup for udp encap socks
Date:   Tue, 13 Oct 2020 15:27:31 +0800
Message-Id: <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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
index 49b5d75..dd2d9c4 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70927CFE4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgI2Nus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729569AbgI2Nus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:48 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF2EC061755;
        Tue, 29 Sep 2020 06:50:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k8so4617336pfk.2;
        Tue, 29 Sep 2020 06:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=cgvlbVs7epFjvUB5WJ5L7B/v2IhQIlRIfyZ0mqeKKyg=;
        b=oAUrpyvYXeiZKm31WZUqeDG7yERUhPuHVXomoAPw29wGT+nTfdK6/s7iU/e6XE8Ox9
         hDt0/TmBM09VjK5q2GM3StlkwgkLaMlBJUQ476Cag9riX3ebikcG/OsRNtPsbu6TflWV
         EdXCtg/sNCAEXesG9cj0NDRI3H8y+4fwIxgsdiIQJmG6/0T+P62d4pdbFpiuhlFiC1pd
         NQPsTdy+T1NCip8LQzHEjBi+aCFp8McK69N0YYuSVA1So/Smyo6amYeoAdtXPZO2ekox
         6AZ7QvpdJLmiTLUGBCwyk9j8M6fK/BcmQctfqiLdGgqY4Vk0qJxnY1Q2CUK7HMTpg4Y7
         z6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=cgvlbVs7epFjvUB5WJ5L7B/v2IhQIlRIfyZ0mqeKKyg=;
        b=S8L4EQUa9dP36g8VsUPSzJ7F5UgFKrFlzF0yOY2pkjlhLZcEdfAJmQlojU0TCM4+gE
         JVcK6bwFtIQCrzxB8rpenUHSFhhoAx0I0MHS9qhxUUffS3phXfKzW2wH0Bizlk5OEGTT
         893F9i2s2/+zMsBvqsFihHYgqjR9NPzdbO4DMHdRZNPSNvjrVOZg0/l0mI9Lck7qzNCv
         Ts5fdYn8ybFaoVFhWBoxgOLHYmCkD8rl3u4CbJkPe7O+YsD6Z31ycD4Tu38MSXcradew
         949Ilkh7c9YkIv2Z0TK69Wt4PLa+OHF9nRV6egNEWPAx2BV1Rrg+D/3EkZAZigVx7DX7
         /JqA==
X-Gm-Message-State: AOAM531Lhxq4X2DgPK+jf0uGEsdjmrUZirmOscKyry4g5VG4KxBHebcC
        ztHr/14JWNp/6DNxBius+RS3O3laQRE=
X-Google-Smtp-Source: ABdhPJwqvKD/1UgOIsZc4WviCnIe7LoZuSlxs6EjsmSl/Kq9Wopw0Ehtr5oVfEvBK1UPk39b0OP3Lg==
X-Received: by 2002:a65:6685:: with SMTP id b5mr3338537pgw.385.1601387446404;
        Tue, 29 Sep 2020 06:50:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m12sm4742921pjs.34.2020.09.29.06.50.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:45 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 10/15] sctp: allow changing transport encap_port by peer packets
Date:   Tue, 29 Sep 2020 21:49:02 +0800
Message-Id: <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As rfc6951#section-5.4 says:

  "After finding the SCTP association (which
   includes checking the verification tag), the UDP source port MUST be
   stored as the encapsulation port for the destination address the SCTP
   packet is received from (see Section 5.1).

   When a non-encapsulated SCTP packet is received by the SCTP stack,
   the encapsulation of outgoing packets belonging to the same
   association and the corresponding destination address MUST be
   disabled."

transport encap_port should be updated by a validated incoming packet's
udp src port.

We save the udp src port in sctp_input_cb->encap_port, and then update
the transport in two places:

  1. right after vtag is verified, which is required by RFC, and this
     allows the existent transports to be updated by the chunks that
     can only be processed on an asoc.

  2. right before processing the 'init' where the transports are added,
     and this allows building a sctp over udp connection by client with
     the server not knowing the remote encap port.

  3. when processing ootb_pkt and creating the temparory transport for
     the reply pkt.

Note that sctp_input_cb->header is removed, as it's not used any more
in sctp.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sm.h      |  1 +
 include/net/sctp/structs.h |  7 +------
 net/sctp/ipv6.c            |  1 +
 net/sctp/protocol.c        | 11 ++++++++++-
 net/sctp/sm_make_chunk.c   |  1 +
 net/sctp/sm_statefuns.c    |  2 ++
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 5c491a3..a499341 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -380,6 +380,7 @@ sctp_vtag_verify(const struct sctp_chunk *chunk,
         if (ntohl(chunk->sctp_hdr->vtag) == asoc->c.my_vtag)
                 return 1;
 
+	chunk->transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
 	return 0;
 }
 
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index b6d0e58..8819214 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1120,14 +1120,9 @@ static inline void sctp_outq_cork(struct sctp_outq *q)
  * sctp_input_cb is currently used on rx and sock rx queue
  */
 struct sctp_input_cb {
-	union {
-		struct inet_skb_parm	h4;
-#if IS_ENABLED(CONFIG_IPV6)
-		struct inet6_skb_parm	h6;
-#endif
-	} header;
 	struct sctp_chunk *chunk;
 	struct sctp_af *af;
+	__u16 encap_port;
 };
 #define SCTP_INPUT_CB(__skb)	((struct sctp_input_cb *)&((__skb)->cb[0]))
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 8a58f42..a064bf2 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1053,6 +1053,7 @@ static struct inet_protosw sctpv6_stream_protosw = {
 
 static int sctp6_rcv(struct sk_buff *skb)
 {
+	memset(skb->cb, 0, sizeof(skb->cb));
 	return sctp_rcv(skb) ? -1 : 0;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8b788bd..c73fd5f 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -842,6 +842,9 @@ static int sctp_ctl_sock_init(struct net *net)
 
 static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	memset(skb->cb, 0, sizeof(skb->cb));
+	SCTP_INPUT_CB(skb)->encap_port = ntohs(udp_hdr(skb)->source);
+
 	skb_set_transport_header(skb, sizeof(struct udphdr));
 	sctp_rcv(skb);
 	return 0;
@@ -1133,9 +1136,15 @@ static struct inet_protosw sctp_stream_protosw = {
 	.flags      = SCTP_PROTOSW_FLAG
 };
 
+static int sctp4_rcv(struct sk_buff *skb)
+{
+	memset(skb->cb, 0, sizeof(skb->cb));
+	return sctp_rcv(skb);
+}
+
 /* Register with IP layer.  */
 static const struct net_protocol sctp_protocol = {
-	.handler     = sctp_rcv,
+	.handler     = sctp4_rcv,
 	.err_handler = sctp_v4_err,
 	.no_policy   = 1,
 	.netns_ok    = 1,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9a56ae2..21d0ff1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2321,6 +2321,7 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	 * added as the primary transport.  The source address seems to
 	 * be a better choice than any of the embedded addresses.
 	 */
+	asoc->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
 	if (!sctp_assoc_add_peer(asoc, peer_addr, gfp, SCTP_ACTIVE))
 		goto nomem;
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index c669f8b..8edab15 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6268,6 +6268,8 @@ static struct sctp_packet *sctp_ootb_pkt_new(
 	if (!transport)
 		goto nomem;
 
+	transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
+
 	/* Cache a route for the transport with the chunk's destination as
 	 * the source address.
 	 */
-- 
2.1.0


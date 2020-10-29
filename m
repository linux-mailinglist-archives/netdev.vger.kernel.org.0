Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB1929E447
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgJ2Hfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgJ2HY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A46FC08EA73;
        Thu, 29 Oct 2020 00:06:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x13so1563363pfa.9;
        Thu, 29 Oct 2020 00:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=IAXgr1XEtubq0mGk/5Z7Nhwu28HoWD2RMqBYQyNjOTY=;
        b=V/gr5oM0K9Rxl0QMOubXzHuw+HpWq/x6Z4zEJ+dKEemFIsM8nCjw5J0cNO8wTg7FgP
         OJ2x7n1YfR1e1ZxHIFIdf0qNGSuUAU95dRhoj61pxxgEM2nizKcH0xUQXgeWV8OcTIXS
         e+rcfWd6jhYpA+vUagZCUIE93ycDwn/1bssUoX1Vz6IHKwd4dM8Fd0uCSnja/+Lt8u/2
         Xxwxat1r6t25AwDTSVKFfw7RYwgwUMFVtAievPEEc715L2hRSkRrd2K73E0BM8aDPkMj
         o4hW02Bmc65CWisanIniSgePc2hCLVvmBNlfM7aFfFU4es26Tn9tqajaWr2/6eVVhas6
         nD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=IAXgr1XEtubq0mGk/5Z7Nhwu28HoWD2RMqBYQyNjOTY=;
        b=hII2C6GT4GnbQX6wFU1647OsifE3XoMjX03tCKESerQgZhR2MGHsFntI4k/7DfSz97
         joqXwUubbAimCL3vdvKGll2xuoGpYxwraI2QJjoSVHLdbyxh05w2UiiU5t31eVqFBX0C
         9Fg+ffzlxeBt1wKRXPIdGRuqL2WcM30ZiTj78if2Wcstc8OB3WsWYbHgQlxKHlHiqJHS
         ivPNgYSKm/YtbKuytrJfs8SFWZeKdPs+pkJ9MFHE1unWKc+ozcMVKHspg6SsOCw5hXAI
         pK6HXXzRm4Kp3CFbGjMn2nVqMylKpFV+ZPPfQhEcHhjAAWe6DbfnqMO1vxc6i9cre2df
         8H8g==
X-Gm-Message-State: AOAM533g2svu1lLoTH3JrkIkAz06oK9gU8FUI1M5q7frOJynYNokF4UU
        U31HUDGFhvbo/UFyvgTnH/Vh3kOx/X8=
X-Google-Smtp-Source: ABdhPJwR47QvP54Q9/sjyiRQq/SUaZ9d+QOAqVtVQ3cQ8I0yea/CsRW/hhS8+Ezzs0IV6CFtAF5dFw==
X-Received: by 2002:a62:1c92:0:b029:15c:aff1:b16f with SMTP id c140-20020a621c920000b029015caff1b16fmr2963750pfc.0.1603955191267;
        Thu, 29 Oct 2020 00:06:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m3sm1650725pjv.52.2020.10.29.00.06.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 09/16] sctp: allow changing transport encap_port by peer packets
Date:   Thu, 29 Oct 2020 15:05:03 +0800
Message-Id: <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
 <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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

  3. when processing ootb_pkt and creating the temporary transport for
     the reply pkt.

Note that sctp_input_cb->header is removed, as it's not used any more
in sctp.

v1->v2:
  - Change encap_port as __be16 for sctp_input_cb.

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
index aa98e7e..81464ae 100644
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
+	__be16 encap_port;
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
index 89dfd31..f3de8c0 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -843,6 +843,9 @@ static int sctp_ctl_sock_init(struct net *net)
 
 static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	memset(skb->cb, 0, sizeof(skb->cb));
+	SCTP_INPUT_CB(skb)->encap_port = udp_hdr(skb)->source;
+
 	skb_set_transport_header(skb, sizeof(struct udphdr));
 	sctp_rcv(skb);
 	return 0;
@@ -1139,9 +1142,15 @@ static struct inet_protosw sctp_stream_protosw = {
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


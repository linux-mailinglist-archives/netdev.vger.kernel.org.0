Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F151B292743
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgJSM0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgJSM0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A73BC0613CE;
        Mon, 19 Oct 2020 05:26:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id bf6so2881581plb.4;
        Mon, 19 Oct 2020 05:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=74nhfpPDT8w8i9g8WZ68a54psTdsS36MCxiNdbY0yzI=;
        b=n1yXf54sBp2PdAYVgRvsR72KS2TsqKD6lCua9j6XAakUZaZOH2Bs5NXjMNZQyDWGq1
         uyznU+kBwJoaiDwaD2BzOElUrY9fQEn2O3WNz8fLrrA7So39HUq+y0ESZa8zco6ckoUy
         nH5z1BsQPn40ZGGhECEdnwXNV5gSPpYn/QRMQrdUbB3Mt3zggvDPHgotGdm0DclZ6Izx
         PHdZz4m3dZyY76B6ud11TmF8k+P7ojxSl5AjZQYdErI59yubmzIrPqc3dQzy8YAXymoQ
         uvKq/K99/mrJ0A8NxXqGo6ANdmE+17P/PSsssiy522VkPoBBAjcmKz/0pM2R/2B4rjUd
         5J7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=74nhfpPDT8w8i9g8WZ68a54psTdsS36MCxiNdbY0yzI=;
        b=Ij3+ZobtXGFqHsqNCkrVh33K6NyUhlcjKXB6O2i2O4WPEi2Uie+Y7IOEqOJwC+Avp8
         x18rMNQpMQ3LzivzqU3fItS7oNIDmZUpQtoTigoWx6so6RkAfrJ9akMQF9xzX4/JfQxS
         ueyxxi0BzHRjRLOBn52a01MX3muUBUHNVYSOjf0sACB+vzSFnhfztgVHx6UR5CvTh1DE
         V8Sk/HOZcjCPaaBoNlsld7CvaaBf+yFMYr862ArFoR9s1jzQx0kde1NPQd6jN/1ROCVD
         65CGtj5R3gEW+Ak5d2D0aX2RJcrizCo5IDZxx2gVuUgfw3QFjz2YUb14+m5aOtLFDcmK
         UVRw==
X-Gm-Message-State: AOAM532UAFPe9qM+riwbqoX4bhypr1blfEPNH/nbaRmgORChWmsPGS2R
        TEsWZUf09dirc3cSGmxkb8oz+jM1qV0=
X-Google-Smtp-Source: ABdhPJxV9D7+MEZ9jLJgLIgYy4MhZAOCgVTy5UOTEBXDIgDmDfStfM4Z/48xtWerAuO+q7xOAnejiA==
X-Received: by 2002:a17:902:7fcd:b029:d3:f037:d9dc with SMTP id t13-20020a1709027fcdb02900d3f037d9dcmr16549470plb.79.1603110407577;
        Mon, 19 Oct 2020 05:26:47 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z5sm11585813pfn.20.2020.10.19.05.26.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:47 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 09/16] sctp: allow changing transport encap_port by peer packets
Date:   Mon, 19 Oct 2020 20:25:26 +0800
Message-Id: <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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
index 7c729d7..36f471d 100644
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


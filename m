Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FB72871E7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgJHJtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:49:42 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3C0C061755;
        Thu,  8 Oct 2020 02:49:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k8so3556418pfk.2;
        Thu, 08 Oct 2020 02:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=iNzHGEAnbQnBSq+cqEMlnX9SeC26Mbv1uc1rY7stx/g=;
        b=f2+h7L6z+QD8DwKOSIPaAsmej/MbXdTQM1WhaGQyYNSWT7OBYd542FRYBIjBqO0R1G
         //I/l4tXM+o/2fXAuqC+jSo1UJay7YRit9ns2Btx+c8XrvDmkDH7UrdY2ahOSngvkC8p
         lj1/BjHBsJztOstvWZpG+a9Ln/zFJr335CyI6bsuHBnQjkAqBoAC8U95Wo6DVHDx/NVo
         Fpu6LMPjCX354ze4+iy1pD4mnm5RfWuX8OAdqyL1U+HBVmy6SuCBgmLbSLH+ZeUPQeBE
         j6/FClmQmusFSCS4UNdTFOrz0KBE/JfebgDZLAnBUplbp+NbYkR77QEVJusc+ZDuMkJM
         sKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=iNzHGEAnbQnBSq+cqEMlnX9SeC26Mbv1uc1rY7stx/g=;
        b=kBzD4MzUrDfOXaLAZzOmTSNKMpqwccI6cT4AXBrHAjTHyv0oRFA9ceYRVni3JLk9dP
         V8zKuKdn9QpepUIuHZruF7WaHInNNhoHNZ6QfwZBasE1bgj70MMuOA40dynmCNXO4luK
         XfhdOjBoaJz68B9wLvKkG9wBYXnfEB11de6nivOCoLm9V4nehVQIzYU2q1/Y+JiyLyvf
         Hh1Q7whc9jpXLG8CykUS6u9fLgrXNnjwJVYkucYZK05+2kolzGv6r/69glUn90P9Mbis
         bRCq3TGaqzbFzcc8KI4wfx8fJ7aaXcJyYM/ZyylCtayK5uCHTj/WAqu2tGf99TdHa4N/
         vy8A==
X-Gm-Message-State: AOAM530jaNmZlCU/fUVLYA0JJpaFKRKmN7blWqH02+bGbHZHtvUgyAE8
        siA4sV0XL37/qxaTgfjVt9bywXnSzCk=
X-Google-Smtp-Source: ABdhPJyTDOXvLh/vXDU6awwUSXXXJxH+OtylhLhijgToPJbDRJpCjr3/tJ/IYdEsmgeWInHS+Me/fg==
X-Received: by 2002:a05:6a00:2bc:b029:155:5945:2eb2 with SMTP id q28-20020a056a0002bcb029015559452eb2mr1562233pfs.55.1602150581212;
        Thu, 08 Oct 2020 02:49:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p4sm3074853pjk.8.2020.10.08.02.49.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:49:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 10/17] sctp: allow changing transport encap_port by peer packets
Date:   Thu,  8 Oct 2020 17:48:06 +0800
Message-Id: <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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
index 5b74187..0d16e5e 100644
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


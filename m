Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280FB434A5A
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhJTLpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhJTLpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BA5C06161C;
        Wed, 20 Oct 2021 04:42:55 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o24-20020a05600c511800b0030d9da600aeso9508354wms.4;
        Wed, 20 Oct 2021 04:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUzAxMDByVqj5wFl9X8KfWxxe76Bsmq66lTbyCt/YlA=;
        b=M1/eRBtVpgMFMHSDP9nrUH2RA5+OGKRtNPtslkFtPgYRrH5WyXEt3LU3707UiuiFXD
         NzAvU4IqXA/9bEahyYywWln567A+4x2RjbI/cad5VCLKM8953IIr5UDwyOOuk31Geu+d
         vPNdjM91QU96ah0o4m/7tZACAoiVGGEg0rk3om/pvqkpbqyk/KtfOsHWfkgAfUaOVxix
         HcjHTN8Iz/3Wb2v4FKFyctg+QS3RYE4fnNtlbeVGtcmuaWP266oB4Dud18twi65WweMe
         3Fp3mbqKhyHX0m3xlTpMLVA9Cz0Dqos7QFobIORkvOzFZFKvC4qRkq9JXrZScjnopW41
         kE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUzAxMDByVqj5wFl9X8KfWxxe76Bsmq66lTbyCt/YlA=;
        b=5baKKDFvaFRpOb6pBOJr7BZxtOqnrFE1TWfnMgpbnwc1k2WhDUE9P/ePIPEGyuLdge
         XgBXSlKfMPjkd94tqk4FcKS1sQZ20u0xpKHVjBW2LV4VS+AakzX8OQqMlrCo7ZGh1ZDn
         3E8D+ntBz/TMe85mgbwaf9XGfENLHL890OpLEvltM4uun8z5yu2T4n35m2qa0mUZcPIN
         jZeU5jlNaTTPzEUMRB3rUC287UPuWHbIIERCxbg2bUffMClzB8GrTVGuLTYkupaSAD+n
         P0ysI398UC2+kYlekVzcqkro6dAF9yvELxR7CysD2UI403PmCutmI7ZvEp5NtxWza26u
         6Fag==
X-Gm-Message-State: AOAM531ECHi09Ps/HyrgEC0rJZfou6l6e6CvCjiVxGX90/bqcgRPiQRQ
        pVgNbHjOWF1OseMF5z3HvaZCDkupLlUPuA==
X-Google-Smtp-Source: ABdhPJyYlJYRSqZIrc60ZakiFK9gPm8XEuUMV+s+Y0JUjAZd42MgBDX57PN5fBWYAOks5FHk1mYLoQ==
X-Received: by 2002:a05:600c:21c4:: with SMTP id x4mr13164248wmj.111.1634730173522;
        Wed, 20 Oct 2021 04:42:53 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 2/7] sctp: fix the processing for INIT chunk
Date:   Wed, 20 Oct 2021 07:42:42 -0400
Message-Id: <1ce1168433f146de7aa03dbb27601b949ad8354e.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the problems below:

1. In non-shutdown_ack_sent states: in sctp_sf_do_5_1B_init() and
   sctp_sf_do_5_2_2_dupinit():

  chunk length check should be done before any checks that may cause
  to send abort, as making packet for abort will access the init_tag
  from init_hdr in sctp_ootb_pkt_new().

2. In shutdown_ack_sent state: in sctp_sf_do_9_2_reshutack():

  The same checks as does in sctp_sf_do_5_2_2_dupinit() is needed
  for sctp_sf_do_9_2_reshutack().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 72 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7f8306968c39..9bfa8cca9974 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -156,6 +156,12 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
 					void *arg,
 					struct sctp_cmd_seq *commands);
 
+static enum sctp_disposition
+__sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			   const struct sctp_association *asoc,
+			   const union sctp_subtype type, void *arg,
+			   struct sctp_cmd_seq *commands);
+
 /* Small helper function that checks if the chunk length
  * is of the appropriate length.  The 'required_length' argument
  * is set to be the size of a specific chunk we are testing.
@@ -337,6 +343,14 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (!chunk->singleton)
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Make sure that the INIT chunk has a valid length.
+	 * Normally, this would cause an ABORT with a Protocol Violation
+	 * error, but since we don't have an association, we'll
+	 * just discard the packet.
+	 */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -351,14 +365,6 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (chunk->sctp_hdr->vtag != 0)
 		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
 
-	/* Make sure that the INIT chunk has a valid length.
-	 * Normally, this would cause an ABORT with a Protocol Violation
-	 * error, but since we don't have an association, we'll
-	 * just discard the packet.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* If the INIT is coming toward a closing socket, we'll send back
 	 * and ABORT.  Essentially, this catches the race of INIT being
 	 * backloged to the socket at the same time as the user issues close().
@@ -1524,20 +1530,16 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	if (!chunk->singleton)
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Make sure that the INIT chunk has a valid length. */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 3.1 A packet containing an INIT chunk MUST have a zero Verification
 	 * Tag.
 	 */
 	if (chunk->sctp_hdr->vtag != 0)
 		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
 
-	/* Make sure that the INIT chunk has a valid length.
-	 * In this case, we generate a protocol violation since we have
-	 * an association established.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
-
 	if (SCTP_INPUT_CB(chunk->skb)->encap_port != chunk->transport->encap_port)
 		return sctp_sf_new_encap_port(net, ep, asoc, type, arg, commands);
 
@@ -1882,9 +1884,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 	 * its peer.
 	*/
 	if (sctp_state(asoc, SHUTDOWN_ACK_SENT)) {
-		disposition = sctp_sf_do_9_2_reshutack(net, ep, asoc,
-				SCTP_ST_CHUNK(chunk->chunk_hdr->type),
-				chunk, commands);
+		disposition = __sctp_sf_do_9_2_reshutack(net, ep, asoc,
+							 SCTP_ST_CHUNK(chunk->chunk_hdr->type),
+							 chunk, commands);
 		if (SCTP_DISPOSITION_NOMEM == disposition)
 			goto nomem;
 
@@ -2970,13 +2972,11 @@ enum sctp_disposition sctp_sf_do_9_2_shut_ctsn(
  * that belong to this association, it should discard the INIT chunk and
  * retransmit the SHUTDOWN ACK chunk.
  */
-enum sctp_disposition sctp_sf_do_9_2_reshutack(
-					struct net *net,
-					const struct sctp_endpoint *ep,
-					const struct sctp_association *asoc,
-					const union sctp_subtype type,
-					void *arg,
-					struct sctp_cmd_seq *commands)
+static enum sctp_disposition
+__sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			   const struct sctp_association *asoc,
+			   const union sctp_subtype type, void *arg,
+			   struct sctp_cmd_seq *commands)
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_chunk *reply;
@@ -3010,6 +3010,26 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
 	return SCTP_DISPOSITION_NOMEM;
 }
 
+enum sctp_disposition
+sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			 const struct sctp_association *asoc,
+			 const union sctp_subtype type, void *arg,
+			 struct sctp_cmd_seq *commands)
+{
+	struct sctp_chunk *chunk = arg;
+
+	if (!chunk->singleton)
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
+	if (chunk->sctp_hdr->vtag != 0)
+		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
+
+	return __sctp_sf_do_9_2_reshutack(net, ep, asoc, type, arg, commands);
+}
+
 /*
  * sctp_sf_do_ecn_cwr
  *
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC143701BE
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 22:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhD3UFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbhD3UEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 16:04:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D7CC06174A;
        Fri, 30 Apr 2021 13:03:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a11so6316124plh.3;
        Fri, 30 Apr 2021 13:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=NmbIxLEGHLoCgfVZwidcwUpoR40Q5FVw10EI41xuPb0=;
        b=GkiS1QzX54g08/yRcNhnlXwHK+T2B0F0ZnKy8uTWttpXBwmxy1HkMGA9s3zrvQc+dJ
         2Zj611qxzPcZEsZcLWY/wFgAheBJL+ddIRp5qjThrQ3PuPLBvnB7ThTaV2dTupPAwdgo
         xbNdtVVy7x9dWOHVt4ozkrwuBTIPTnEkLScg1oh2hF6TlybgO/ZOBr4IF3PeE57RSSZK
         fivckc6oa5Sj9kjZGMiArOfScIyzXsyNv5ofiZKeUOaUcaCIA0wt/+XoPCiwlzudSzod
         70w6gQ/XcnkWtBsvLqC1gDFapH9v808LHLxAFrX9xBi5gQiK2AR6u04jqqSlAlnnB9U8
         KNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=NmbIxLEGHLoCgfVZwidcwUpoR40Q5FVw10EI41xuPb0=;
        b=L4Cw0L0OMRYO50S57pbTXC0ojwX7xkK3a9Z0GKc/1kDmSd41ry7cLxErfnKBRZ2jcL
         2mEM1AEb0XY3oonCsdmeMYQX9eSKliCCKzab6V7myKQWHmw8grenI0OdK9lGOwLymaGu
         DBWGNaURzfF/s2DNrj3iQCOO4AI3ah4XenG7CfN377ywEZQeRsSxeV3YQIxgUyca0TSA
         6fiJURZlQoLKP789/4nDFAbR8UmBdGdbZPQIwCwzhd85ttPBvBUPPeq+ZD0kLitrYj5a
         Na9iSKQSQ9r2449R8wHMDFTwseIzU+B/wAdlMVVT+UWe79loNq5fClKffHszQE+T0+ux
         3uiQ==
X-Gm-Message-State: AOAM532NKoOW3m9UGRYXFXtQ6rg763zaC4RcJz+e0wyVXJFvFGHaTCkz
        M2LN8lmGJPK+oVwrpuf23nmNETf36m5BGwlg
X-Google-Smtp-Source: ABdhPJzeN6m4dUCSi+untEHGPX+QoEIXoOf7G57xKKyLWEwRHyMkiR10veCAfGM4AFBBZKhwRQLlnA==
X-Received: by 2002:a17:90a:5907:: with SMTP id k7mr17573981pji.197.1619813013977;
        Fri, 30 Apr 2021 13:03:33 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c129sm3040101pfb.141.2021.04.30.13.03.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 13:03:33 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCHv2 net 3/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_b
Date:   Sat,  1 May 2021 04:03:00 +0800
Message-Id: <371d885e4d50b379aff56babe77517f6ccc32651.1619812899.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a9f65034deb5ffa57ea704f99102fcefb9bff539.1619812899.git.lucien.xin@gmail.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
 <1a42d5e9ae45c01dbf0378fca0cb8cfd85ee454b.1619812899.git.lucien.xin@gmail.com>
 <a9f65034deb5ffa57ea704f99102fcefb9bff539.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619812899.git.lucien.xin@gmail.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same thing should be done for sctp_sf_do_dupcook_b().
Meanwhile, SCTP_CMD_UPDATE_ASSOC cmd can be removed.

v1->v2:
  - Fix the return value in sctp_sf_do_assoc_update().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/command.h |  1 -
 net/sctp/sm_sideeffect.c   | 26 -------------------------
 net/sctp/sm_statefuns.c    | 47 +++++++++++++++++++++++++++++-----------------
 3 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index e8df72e..5e84888 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -68,7 +68,6 @@ enum sctp_verb {
 	SCTP_CMD_ASSOC_FAILED,	 /* Handle association failure. */
 	SCTP_CMD_DISCARD_PACKET, /* Discard the whole packet. */
 	SCTP_CMD_GEN_SHUTDOWN,   /* Generate a SHUTDOWN chunk. */
-	SCTP_CMD_UPDATE_ASSOC,   /* Update association information. */
 	SCTP_CMD_PURGE_OUTQUEUE, /* Purge all data waiting to be sent. */
 	SCTP_CMD_SETUP_T2,       /* Hi-level, setup T2-shutdown parms.  */
 	SCTP_CMD_RTO_PENDING,	 /* Set transport's rto_pending. */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 0948f14..ce15d59 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -826,28 +826,6 @@ static void sctp_cmd_setup_t2(struct sctp_cmd_seq *cmds,
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;
 }
 
-static void sctp_cmd_assoc_update(struct sctp_cmd_seq *cmds,
-				  struct sctp_association *asoc,
-				  struct sctp_association *new)
-{
-	struct net *net = asoc->base.net;
-	struct sctp_chunk *abort;
-
-	if (!sctp_assoc_update(asoc, new))
-		return;
-
-	abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
-	if (abort) {
-		sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
-		sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
-	}
-	sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
-	sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,
-			SCTP_PERR(SCTP_ERROR_RSRC_LOW));
-	SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
-	SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
-}
-
 /* Helper function to change the state of an association. */
 static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
 			       struct sctp_association *asoc,
@@ -1301,10 +1279,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			sctp_endpoint_add_asoc(ep, asoc);
 			break;
 
-		case SCTP_CMD_UPDATE_ASSOC:
-		       sctp_cmd_assoc_update(commands, asoc, cmd->obj.asoc);
-		       break;
-
 		case SCTP_CMD_PURGE_OUTQUEUE:
 		       sctp_outq_teardown(&asoc->outqueue);
 		       break;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index e8ccc4e..a428449 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1773,6 +1773,30 @@ enum sctp_disposition sctp_sf_do_5_2_3_initack(
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 }
 
+static int sctp_sf_do_assoc_update(struct sctp_association *asoc,
+				   struct sctp_association *new,
+				   struct sctp_cmd_seq *cmds)
+{
+	struct net *net = asoc->base.net;
+	struct sctp_chunk *abort;
+
+	if (!sctp_assoc_update(asoc, new))
+		return 0;
+
+	abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
+	if (abort) {
+		sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
+		sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
+	}
+	sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
+	sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,
+			SCTP_PERR(SCTP_ERROR_RSRC_LOW));
+	SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
+	SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
+
+	return -ENOMEM;
+}
+
 /* Unexpected COOKIE-ECHO handler for peer restart (Table 2, action 'A')
  *
  * Section 5.2.4
@@ -1853,21 +1877,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 	sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL());
 
 	/* Update the content of current association. */
-	if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {
-		struct sctp_chunk *abort;
-
-		abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
-		if (abort) {
-			sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
-			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
-		}
-		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
-		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
-				SCTP_PERR(SCTP_ERROR_RSRC_LOW));
-		SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
+	if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
 		goto nomem;
-	}
 
 	repl = sctp_make_cookie_ack(asoc, chunk);
 	if (!repl)
@@ -1940,14 +1951,16 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
 	if (!sctp_auth_chunk_verify(net, chunk, new_asoc))
 		return SCTP_DISPOSITION_DISCARD;
 
-	/* Update the content of current association.  */
-	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_ESTABLISHED));
 	SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
 
-	repl = sctp_make_cookie_ack(new_asoc, chunk);
+	/* Update the content of current association.  */
+	if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
+		goto nomem;
+
+	repl = sctp_make_cookie_ack(asoc, chunk);
 	if (!repl)
 		goto nomem;
 
-- 
2.1.0


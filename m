Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CFB370052
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhD3SRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhD3SRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:17:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D74C06138D;
        Fri, 30 Apr 2021 11:16:31 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i13so2060770pfu.2;
        Fri, 30 Apr 2021 11:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=gWgou43N/REI3vCWovvIFRFe1+3L9BtJuzs8qkI4ZTc=;
        b=ailMLbDZGd+sJje0ND+2+t0LXkby5OkW8Lc6ClmcDV2Ds88XRpigvL5jiNke3Uyond
         2R8HedHBSTuOaoxPU+YjI9AKRRQltil75OIsWNfYQbkXYn66y9VPIT44FoGu60Lgavst
         vBaR35BILgcn4k+hG9ZcFSS1ImmaZe1ycUSkTR8oMF/NMPoRK9oAkl/WoYNf+dfvYtIT
         GrnEkKGpoZeP/BoXjgZt0+STdgp5eGb0kiqmDIpN4U/mKmpTX0gmROpES6XRbM4hWAzX
         tH2mkVzyx2OnJgqWNv9tGjDjYJiZUsQiS9pxblXigDjOFO7guh82E8w40s+lG6ITPar1
         PL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=gWgou43N/REI3vCWovvIFRFe1+3L9BtJuzs8qkI4ZTc=;
        b=Kpo5Vw5WumMS7wfvMwStysoMGZPzUsXBDwxqq1HM5boDAC+IQi+UD+ySZPYFtrOrdM
         ELhRakUfU5jMC+ipeuT3+EzON1DB+WXV0P1r6qUfT84Sa2dZm42FYQ+JslaxuBww9Nf9
         h3lKOmhm/29uL/nepgN6+qMvLVi6qBF8avmD1oAd58t60uk+R25Hnqx7v0cZ8tcwppbi
         bWjvd6EhGnLEHabKcISC/9eLVVtX18mUzJH1pWQWyx8FTZ3AH+9pKdcYBtVuFdsAgo91
         RZ5pDofC+FnODbw6OjUHc1va4ttsuXzUIiKUC2BHciPrG3jMZ8ntyMIW3Cg7TX1M4W+j
         9Q5g==
X-Gm-Message-State: AOAM531gbnutDUWT4IfCKf4+pTfNyoox3uYoKckJdTJVachmAiYXZTRM
        UWErs04D3KOWXN9jec1O0YZN2eiSCdcqEBF7
X-Google-Smtp-Source: ABdhPJx27g8WyJBH+3mJ17htb/uR8GvVii3tiHB+NJtJH2F4OhF4MvRh5x7wwBwni7gP/3JxlhktTA==
X-Received: by 2002:a63:e206:: with SMTP id q6mr5671196pgh.225.1619806590793;
        Fri, 30 Apr 2021 11:16:30 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g16sm3005839pfu.45.2021.04.30.11.16.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 11:16:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH net 3/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_b
Date:   Sat,  1 May 2021 02:15:57 +0800
Message-Id: <bfe29b3751cb5d0d65e79ba0fb5bbd897cd35a50.1619806333.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8a5afb3b24785e8837332dbec388ddf4f40c2297.1619806333.git.lucien.xin@gmail.com>
References: <cover.1619806333.git.lucien.xin@gmail.com>
 <ab7a35c9888202a34079baaa835294422bc3b5b3.1619806333.git.lucien.xin@gmail.com>
 <8a5afb3b24785e8837332dbec388ddf4f40c2297.1619806333.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619806333.git.lucien.xin@gmail.com>
References: <cover.1619806333.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same thing should be done for sctp_sf_do_dupcook_b().
Meanwhile, SCTP_CMD_UPDATE_ASSOC cmd can be removed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
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
index e8ccc4e..d0b6036 100644
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
+		return -ENOMEM;
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
+	return 0;
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


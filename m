Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4A83CE797
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350078AbhGSQ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbhGSQ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:27:03 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D052C04E2E9;
        Mon, 19 Jul 2021 09:31:52 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f17so22894016wrt.6;
        Mon, 19 Jul 2021 09:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/WDB9iBmTwQvIwKvnM6p7qqZQ9YfFoIlHFXmRdJ3Ho=;
        b=byASBA11wmWASSDuZVCYtTP1BL4/kUV443QQFoTmazmxOZDM/DpVp6bLVsgPpWIxt4
         Ka76b45DH+BCwt90C4j2thIrphs7ELkKUSX+7KGaQaw8niAlg9vn2ctjF/usNO8tMms8
         29m4fFq0A/aQe7PSfz562BtPnr4SwZvgmh71MDher6AwvgYGAb9JJcD8/c3YVKMR4Ap3
         YRQWJ5efOmaSFsnu370xcbQiLNISViqfO/JeE0rnPe3vm5XP95rwZd19m8y6kdYv1+Ug
         Urk6L3wpI6HLRjW7Jpen0h81j6sP4abeLLSPuvLY6GTfHAM5dkDsJGHnmr8HjP6rqyfq
         KedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/WDB9iBmTwQvIwKvnM6p7qqZQ9YfFoIlHFXmRdJ3Ho=;
        b=ZvUCKfpiDSObrzxJeDRV2+enL3fhTfL7aEziMWM/Xbhv9fIWQSqRzRMIDVyZQfJNUB
         F8Hm3Nq4GO6U7miTsxCy3JdKV9hcnW+QDfSj3O2K8c6bAxfwIPdat/02TMDHF4pGUDcW
         531oeM5ZXBgYSjeHZxM1NiYcKVxJfeHStnqQPJC36x+qYxwvqpbAM+23kKebl9yDr1mF
         Z4QVxlLVD/Qd0m+gqD4mtTd1wqMFcZFOpGbNDUlw0pTjxfos2JnzNoHe4XxSMOqF96Nc
         PuExboQRa0reA5Xu44GwOMdponx/Uhb5gOvhVHSt/I4bJRB+KZoaGpx2uOXhW52yEVwV
         GV9Q==
X-Gm-Message-State: AOAM530FUfdSJQQMAyerVmg3jNAlqqTdWlsEzbJT8mxzDqhLyPiGYCYZ
        rLIzmFEwuRITROu/ilGWM2ORLxN4HECGvw==
X-Google-Smtp-Source: ABdhPJxjzH8K7sarj4yoomrDryec/mJhw05MEMUvagF7Ek3oSnEbySSqdFId1bzoymnCDKOVQbDEjg==
X-Received: by 2002:adf:e581:: with SMTP id l1mr30392388wrm.116.1626713607659;
        Mon, 19 Jul 2021 09:53:27 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b20sm19290532wmj.7.2021.07.19.09.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 09:53:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        timo.voelker@fh-muenster.de
Subject: [PATCH net 1/2] sctp: improve the code for pmtu probe send and recv update
Date:   Mon, 19 Jul 2021 12:53:22 -0400
Message-Id: <89a15ea221a3c2aa94f3f0fcfc50c2005a134aab.1626713549.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1626713549.git.lucien.xin@gmail.com>
References: <cover.1626713549.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch does 3 things:

  - make sctp_transport_pl_send() and sctp_transport_pl_recv()
    return bool type to decide if more probe is needed to send.

  - pr_debug() only when probe is really needed to send.

  - count pl.raise_count in sctp_transport_pl_send() instead of
    sctp_transport_pl_recv(), and it's only incremented for the
    1st probe for the same size.

These are preparations for the next patch to make probes happen
only when there's packet loss in Search Complete state.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  4 ++--
 net/sctp/sm_statefuns.c    | 15 +++++++-------
 net/sctp/transport.c       | 41 +++++++++++++++++++++-----------------
 3 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 32fc4a309df5..f3d414ed208e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1024,8 +1024,8 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu);
 void sctp_transport_immediate_rtx(struct sctp_transport *);
 void sctp_transport_dst_release(struct sctp_transport *t);
 void sctp_transport_dst_confirm(struct sctp_transport *t);
-void sctp_transport_pl_send(struct sctp_transport *t);
-void sctp_transport_pl_recv(struct sctp_transport *t);
+bool sctp_transport_pl_send(struct sctp_transport *t);
+bool sctp_transport_pl_recv(struct sctp_transport *t);
 
 
 /* This is the structure we use to queue packets as they come into
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 09a8f23ec709..32df65f68c12 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1109,12 +1109,12 @@ enum sctp_disposition sctp_sf_send_probe(struct net *net,
 	if (!sctp_transport_pl_enabled(transport))
 		return SCTP_DISPOSITION_CONSUME;
 
-	sctp_transport_pl_send(transport);
-
-	reply = sctp_make_heartbeat(asoc, transport, transport->pl.probe_size);
-	if (!reply)
-		return SCTP_DISPOSITION_NOMEM;
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
+	if (sctp_transport_pl_send(transport)) {
+		reply = sctp_make_heartbeat(asoc, transport, transport->pl.probe_size);
+		if (!reply)
+			return SCTP_DISPOSITION_NOMEM;
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
+	}
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROBE_TIMER_UPDATE,
 			SCTP_TRANSPORT(transport));
 
@@ -1274,8 +1274,7 @@ enum sctp_disposition sctp_sf_backbeat_8_3(struct net *net,
 		    !sctp_transport_pl_enabled(link))
 			return SCTP_DISPOSITION_DISCARD;
 
-		sctp_transport_pl_recv(link);
-		if (link->pl.state == SCTP_PL_COMPLETE)
+		if (sctp_transport_pl_recv(link))
 			return SCTP_DISPOSITION_CONSUME;
 
 		return sctp_sf_send_probe(net, ep, asoc, type, link, commands);
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 397a6244dd97..23e7bd3e3bd4 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -258,16 +258,12 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 	sctp_transport_pl_update(transport);
 }
 
-void sctp_transport_pl_send(struct sctp_transport *t)
+bool sctp_transport_pl_send(struct sctp_transport *t)
 {
-	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
-		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
-
-	if (t->pl.probe_count < SCTP_MAX_PROBES) {
-		t->pl.probe_count++;
-		return;
-	}
+	if (t->pl.probe_count < SCTP_MAX_PROBES)
+		goto out;
 
+	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
 		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
 			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
@@ -299,10 +295,20 @@ void sctp_transport_pl_send(struct sctp_transport *t)
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
 	}
-	t->pl.probe_count = 1;
+
+out:
+	if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count < 30 &&
+	    !t->pl.probe_count)
+		t->pl.raise_count++;
+
+	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
+
+	t->pl.probe_count++;
+	return true;
 }
 
-void sctp_transport_pl_recv(struct sctp_transport *t)
+bool sctp_transport_pl_recv(struct sctp_transport *t)
 {
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
@@ -323,7 +329,7 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 		if (!t->pl.probe_high) {
 			t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
 					       SCTP_MAX_PLPMTU);
-			return;
+			return false;
 		}
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
@@ -335,14 +341,13 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
-	} else if (t->pl.state == SCTP_PL_COMPLETE) {
-		t->pl.raise_count++;
-		if (t->pl.raise_count == 30) {
-			/* Raise probe_size again after 30 * interval in Search Complete */
-			t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
-			t->pl.probe_size += SCTP_PL_MIN_STEP;
-		}
+	} else if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count == 30) {
+		/* Raise probe_size again after 30 * interval in Search Complete */
+		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
+		t->pl.probe_size += SCTP_PL_MIN_STEP;
 	}
+
+	return t->pl.state == SCTP_PL_COMPLETE;
 }
 
 static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
-- 
2.27.0


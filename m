Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D43D4F33
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 19:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhGYRCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGYRC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 13:02:28 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564CAC061757;
        Sun, 25 Jul 2021 10:42:57 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w12so8133061wro.13;
        Sun, 25 Jul 2021 10:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/WDB9iBmTwQvIwKvnM6p7qqZQ9YfFoIlHFXmRdJ3Ho=;
        b=YjGVxqvISpyIu4MwJaFDH+febidQRZEVw0q7aWPxBldCURqqgI22SbI48N1tdPkkih
         qvSiz6aeq8U/1bEHd8YOMRvk50/nXii5ZSM7grg7T1lqV71M1KiMa+g7jXJHCkq3Kdc7
         zBm6C/Rsw6txiJ3btwLHhLdIJiGLgqSSrr2q+EoUTuJUHw/p6o27lYCHVk2njYwLL9NW
         7dSL2ACQ9Qm/TOIfMRGYscBTG0vZuvj0aGxZu+0wRNe/uWsN/vUelCkNDVQEkFl6eSeg
         EQQwBqPdNC8CGzQJjleLFDzcmn0zbHRoritR8Dh++s8S0M07xJsgn3LQE51iXOvU099r
         Nc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/WDB9iBmTwQvIwKvnM6p7qqZQ9YfFoIlHFXmRdJ3Ho=;
        b=elLx1S+W5AyKiYVeUXb2L/hmgRWCOz4Nt064Ce4ub2K8zPZgsCWA5qSioT4e0mR3RG
         cjBdSKCJqZ/CylbYdIFdKV5azsV87w9GR56iLHUfmGy0npLUgPXkXuanxtyl7GTCDT/+
         6Qh8lep/mmkuPRE7o3Hv/CK6053V2T7e8tRtLvTt89hZXpO0azdUJF+n3u9Cwaulrht1
         npP83BlPHwKFcLi8BA5DKcf0mtq2rn0cjkhIsYh+TbcvEyRGnq3PYEkK4tpflTNgFo0D
         pufYT0sUKTSDy8LrnoPi12Tztvhc1+1F/IhJc2fChbOq+JmoTKPG0yozWP75I9gh2Cj4
         pITQ==
X-Gm-Message-State: AOAM531ZvrmgjXTZtnTt4Etivj8tjipJWL6fG9gVH76OrhoxXdF9iXKC
        7MEZaiGw9uIfDjasEar6i4mg+0gG54dc/Q==
X-Google-Smtp-Source: ABdhPJzOGke5SWoPaHgZICCabs/X9+nt/S+/5zW3ImlksrUrxjYMwDK/fjdxwoti2WctcE+1hgnYiQ==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr15114420wrt.331.1627234975888;
        Sun, 25 Jul 2021 10:42:55 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n18sm38201388wrt.89.2021.07.25.10.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 10:42:55 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCHv2 net 1/2] sctp: improve the code for pmtu probe send and recv update
Date:   Sun, 25 Jul 2021 13:42:50 -0400
Message-Id: <dc0739fe99347616c3b1bd8b70d7986b9899e827.1627234857.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1627234857.git.lucien.xin@gmail.com>
References: <cover.1627234857.git.lucien.xin@gmail.com>
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


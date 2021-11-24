Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E9C45CD2F
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 20:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbhKXT3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 14:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243875AbhKXT33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 14:29:29 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470ABC061746;
        Wed, 24 Nov 2021 11:26:19 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id a2so3761460qtx.11;
        Wed, 24 Nov 2021 11:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x3QagXDF00wm3+eHvCjD70mdpkJAyMFrOS7/w3O1o8U=;
        b=MnXn+ka8dEy9rhFw8YNteCryIEkmmLEfadpQFs9vxnSnyLDug4eqMkLXGgj2LVgTtc
         X4/JNi0yJo1FuvoRH2x771NQcameCP2rUY+l9FlV8yz7z9J85Gqoueez2JP/DBqr3G9d
         78Ohz4UG/gcaNLiF0yifQr85etY3c9BkO4+amNTgd+sNgZhd4yt/yeOmmT9cFJr2RCW/
         Zj4XTW8iy00xT7ADx7mXT49z+1VPE6KMUdzziPIfFa2LsvsoISavhgtrVFwNvdXWJGPV
         tVbknJQRduhCSmOqk4YcMzYnhTluW8w4565p6VcfXxvW05NcW7aj2ueneS522YRJoQUd
         49/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x3QagXDF00wm3+eHvCjD70mdpkJAyMFrOS7/w3O1o8U=;
        b=RAfOUILbERSiOdSqcnxTDCmWysVlJ+pKNyRwXvozKAg2w5wghHTWe7/itEaI1PbRai
         3oPopVajVKPctwD52bc8M9tYX+LBm9mQ8hPI0z9h9qwKBk0Xeactze2t9aP/yjF3rF/S
         05ugfV5ZKtuAHDa+yqP+cuyLm9CNl5vaL3frEzxzgYYBcWjI1US5OS4u7bSXoHG0lrNL
         egPoPhbhZSkIF+7eP0CD/XzsuSGqdTx+7+DJ1TUoTK6EOEao6lOVDidxbgLZIA2Go9/C
         ljbtqGCydDsqHK23BcAeVC5tRJn/RONjg6l3+pHy3l9WurV7MN2kRB76BQwq/bsfCVH3
         NRng==
X-Gm-Message-State: AOAM530tehs7BZRifEs/scRvCCQPfPbflwXqqw58L7zRO5ppwaekyzSs
        rLxwn+IkPCZxhcMpibg3GKWaAzjtvvTq5w==
X-Google-Smtp-Source: ABdhPJyOY7UvjMDFXa4yXF0Bpo/R9vzCDnyK240+vInn+AIp+Mvxuro3cab7EfbC0Vn8AHpIZlIKHA==
X-Received: by 2002:a05:622a:170d:: with SMTP id h13mr10379885qtk.99.1637781978245;
        Wed, 24 Nov 2021 11:26:18 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 15sm334706qtp.55.2021.11.24.11.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 11:26:17 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] sctp: make the raise timer more simple and accurate
Date:   Wed, 24 Nov 2021 14:26:14 -0500
Message-Id: <edb0e48988ea85997488478b705b11ddc1ba724a.1637781974.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the probe timer is reused as the raise timer when PLPMTUD is in
the Search Complete state. raise_count was introduced to count how many
times the probe timer has timed out. When raise_count reaches to 30, the
raise timer handler will be triggered.

During the whole processing above, the timer keeps timing out every probe_
interval. It is a waste for the Search Complete state, as the raise timer
only needs to time out after 30 * probe_interval.

Since the raise timer and probe timer are never used at the same time, it
is no need to keep probe timer 'alive' in the Search Complete state. This
patch to introduce sctp_transport_reset_raise_timer() to start the timer
as the raise timer when entering the Search Complete state. When entering
the other states, sctp_transport_reset_probe_timer() will still be called
to reset the timer to the probe timer.

raise_count can be removed from sctp_transport as no need to count probe
timer timeout for raise timer timeout. last_rtx_chunks can be removed as
sctp_transport_reset_probe_timer() can be called in the place where asoc
rtx_data_chunks is changed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  7 +++----
 net/sctp/outqueue.c        |  3 +++
 net/sctp/sm_statefuns.c    | 11 +++++------
 net/sctp/transport.c       | 26 +++++++++++---------------
 4 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 899c29c326ba..e7d1ed7a3dfb 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -984,12 +984,10 @@ struct sctp_transport {
 	} cacc;
 
 	struct {
-		__u32 last_rtx_chunks;
 		__u16 pmtu;
 		__u16 probe_size;
 		__u16 probe_high;
-		__u8 probe_count:3;
-		__u8 raise_count:5;
+		__u8 probe_count;
 		__u8 state;
 	} pl; /* plpmtud related */
 
@@ -1011,6 +1009,7 @@ void sctp_transport_reset_t3_rtx(struct sctp_transport *);
 void sctp_transport_reset_hb_timer(struct sctp_transport *);
 void sctp_transport_reset_reconf_timer(struct sctp_transport *transport);
 void sctp_transport_reset_probe_timer(struct sctp_transport *transport);
+void sctp_transport_reset_raise_timer(struct sctp_transport *transport);
 int sctp_transport_hold(struct sctp_transport *);
 void sctp_transport_put(struct sctp_transport *);
 void sctp_transport_update_rto(struct sctp_transport *, __u32);
@@ -1025,7 +1024,7 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu);
 void sctp_transport_immediate_rtx(struct sctp_transport *);
 void sctp_transport_dst_release(struct sctp_transport *t);
 void sctp_transport_dst_confirm(struct sctp_transport *t);
-bool sctp_transport_pl_send(struct sctp_transport *t);
+void sctp_transport_pl_send(struct sctp_transport *t);
 bool sctp_transport_pl_recv(struct sctp_transport *t);
 
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index ff47091c385e..a18609f608fb 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -547,6 +547,9 @@ void sctp_retransmit(struct sctp_outq *q, struct sctp_transport *transport,
 			sctp_assoc_update_retran_path(transport->asoc);
 		transport->asoc->rtx_data_chunks +=
 			transport->asoc->unack_data;
+		if (transport->pl.state == SCTP_PL_COMPLETE &&
+		    transport->asoc->unack_data)
+			sctp_transport_reset_probe_timer(transport);
 		break;
 	case SCTP_RTXR_FAST_RTX:
 		SCTP_INC_STATS(net, SCTP_MIB_FAST_RETRANSMITS);
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 354c1c4de19b..cc544a97c4af 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1124,12 +1124,11 @@ enum sctp_disposition sctp_sf_send_probe(struct net *net,
 	if (!sctp_transport_pl_enabled(transport))
 		return SCTP_DISPOSITION_CONSUME;
 
-	if (sctp_transport_pl_send(transport)) {
-		reply = sctp_make_heartbeat(asoc, transport, transport->pl.probe_size);
-		if (!reply)
-			return SCTP_DISPOSITION_NOMEM;
-		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
-	}
+	sctp_transport_pl_send(transport);
+	reply = sctp_make_heartbeat(asoc, transport, transport->pl.probe_size);
+	if (!reply)
+		return SCTP_DISPOSITION_NOMEM;
+	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROBE_TIMER_UPDATE,
 			SCTP_TRANSPORT(transport));
 
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 133f1719bf1b..f8fd98784977 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -213,13 +213,18 @@ void sctp_transport_reset_reconf_timer(struct sctp_transport *transport)
 
 void sctp_transport_reset_probe_timer(struct sctp_transport *transport)
 {
-	if (timer_pending(&transport->probe_timer))
-		return;
 	if (!mod_timer(&transport->probe_timer,
 		       jiffies + transport->probe_interval))
 		sctp_transport_hold(transport);
 }
 
+void sctp_transport_reset_raise_timer(struct sctp_transport *transport)
+{
+	if (!mod_timer(&transport->probe_timer,
+		       jiffies + transport->probe_interval * 30))
+		sctp_transport_hold(transport);
+}
+
 /* This transport has been assigned to an association.
  * Initialize fields from the association or from the sock itself.
  * Register the reference count in the association.
@@ -258,12 +263,11 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 	sctp_transport_pl_update(transport);
 }
 
-bool sctp_transport_pl_send(struct sctp_transport *t)
+void sctp_transport_pl_send(struct sctp_transport *t)
 {
 	if (t->pl.probe_count < SCTP_MAX_PROBES)
 		goto out;
 
-	t->pl.last_rtx_chunks = t->asoc->rtx_data_chunks;
 	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
 		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
@@ -298,17 +302,9 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 	}
 
 out:
-	if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count < 30 &&
-	    !t->pl.probe_count && t->pl.last_rtx_chunks == t->asoc->rtx_data_chunks) {
-		t->pl.raise_count++;
-		return false;
-	}
-
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
-
 	t->pl.probe_count++;
-	return true;
 }
 
 bool sctp_transport_pl_recv(struct sctp_transport *t)
@@ -316,7 +312,6 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
 
-	t->pl.last_rtx_chunks = t->asoc->rtx_data_chunks;
 	t->pl.pmtu = t->pl.probe_size;
 	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
@@ -338,14 +333,14 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
 			t->pl.probe_high = 0;
-			t->pl.raise_count = 0;
 			t->pl.state = SCTP_PL_COMPLETE; /* Search -> Search Complete */
 
 			t->pl.probe_size = t->pl.pmtu;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 			sctp_assoc_sync_pmtu(t->asoc);
+			sctp_transport_reset_raise_timer(t);
 		}
-	} else if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count == 30) {
+	} else if (t->pl.state == SCTP_PL_COMPLETE) {
 		/* Raise probe_size again after 30 * interval in Search Complete */
 		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
@@ -393,6 +388,7 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 			t->pl.probe_high = 0;
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			sctp_transport_reset_probe_timer(t);
 			return true;
 		}
 	}
-- 
2.27.0


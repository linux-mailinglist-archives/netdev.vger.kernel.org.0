Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6803AE166
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhFUBlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhFUBlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:12 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D64C061756;
        Sun, 20 Jun 2021 18:38:57 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id f5so6658570qvu.8;
        Sun, 20 Jun 2021 18:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bAQmrENiNrp58bre9YvmfbeN4DPsZXdLW3eWTgefn9Q=;
        b=kIKHKA7dtJHB/OQa+x0ekaxqKuVHKAki6ys3qXeWt6AKUFNiaj3MasL+j/gvgt0tTC
         CM/4XmFvrJZnbrkFYT4FWgKh11TwlcmX1EMlgkh8iFlU7DPohKeDVxXMDLsalHRCj3OF
         h9/sEJAQCA9rb/Oy283XHJfeeYTt1I4ij0ItpJiBeAjbQ4rw8RxATS6lQORvkmd2jPj4
         CotovU22zUZO+8XmFKxuWgUXS+RvyoNlsCyrvYKB0T1R+O4yvX461Y5Qkgmg9SXmgN+v
         RZqUz/090z+855+SLCyUMdv/sCP2sSF/2FaskOOgBgO86YHQO8uTfYgeecZSwHRITa3X
         LGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bAQmrENiNrp58bre9YvmfbeN4DPsZXdLW3eWTgefn9Q=;
        b=I09IKQoMQqQaI1NrJkU7A6eH97MaGeB0laJDSimXn9KgcLEBapRdzcwS3pfhPdBePB
         YHM1IVIfkMIXyYRO+4R9c1IGr7cD/j6s0QoGj2I/7vJez5p5gIcH6nkVvFKbtSCC+kNe
         gczcIswKFhP0Skyf31nU3iZjMpFacJ492skl0HitGqOdron9FR94/7ddIEDZagZ+U7fD
         heOrAWBrhx546RE2R5Kj2CwOgqRHamsNSF8GkxfR58tu4DpAYc8fHPkUYmswd00Epze9
         wBfGacaY3LrQs+uuZjsVh9bxIvvwUkBzLSKt4+4xwA1STrlHwL2RBOoI7pTjODVKWbRZ
         16vA==
X-Gm-Message-State: AOAM531ketScoTlLnLCCMZbRuA8a1LFJMJLMgrI/LEkV6248bBDEZnuZ
        /rIveeEumtaUUaxeZz/PKT1aU2upBY/0XQ==
X-Google-Smtp-Source: ABdhPJyG5ANXSlG8DZKGSTu4Hw5rC6cb9MHBM61DV/KI0YWSgc11RgF9Dt3b2OVtd/s8QeI3tj9h5A==
X-Received: by 2002:ad4:450b:: with SMTP id k11mr17564968qvu.0.1624239536575;
        Sun, 20 Jun 2021 18:38:56 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y18sm9662693qtj.53.2021.06.20.18.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 05/14] sctp: add the probe timer in transport for PLPMTUD
Date:   Sun, 20 Jun 2021 21:38:40 -0400
Message-Id: <4b813e5bcf8ae5ce1865a1c75e73eb2e5e8d2ac7.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 3 timers described in rfc8899#section-5.1.1:

  PROBE_TIMER, PMTU_RAISE_TIMER, CONFIRMATION_TIMER

This patches adds a 'probe_timer' in transport, and it works as either
PROBE_TIMER or PMTU_RAISE_TIMER. At most time, it works as PROBE_TIMER
and expires every a 'probe_interval' time to send the HB probe packet.
When transport pl enters COMPLETE state, it works as PMTU_RAISE_TIMER
and expires in 'probe_interval * 30' time to go back to SEARCH state
and do searching again.

SCTP HB is an acknowledged packet, CONFIRMATION_TIMER is not needed.

The timer will start when transport pl enters BASE state and stop
when it enters DISABLED state.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/command.h   |  1 +
 include/net/sctp/constants.h |  1 +
 include/net/sctp/sctp.h      |  9 ++++++++-
 include/net/sctp/sm.h        |  2 ++
 include/net/sctp/structs.h   |  4 ++++
 net/sctp/debug.c             |  1 +
 net/sctp/sm_sideeffect.c     | 37 ++++++++++++++++++++++++++++++++++++
 net/sctp/sm_statefuns.c      | 17 +++++++++++++++++
 net/sctp/sm_statetable.c     | 20 +++++++++++++++++++
 net/sctp/transport.c         | 18 ++++++++++++++++++
 10 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 5e848884ff61..2058fabffbf6 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -59,6 +59,7 @@ enum sctp_verb {
 	SCTP_CMD_HB_TIMERS_START,    /* Start the heartbeat timers. */
 	SCTP_CMD_HB_TIMER_UPDATE,    /* Update a heartbeat timers.  */
 	SCTP_CMD_HB_TIMERS_STOP,     /* Stop the heartbeat timers.  */
+	SCTP_CMD_PROBE_TIMER_UPDATE, /* Update a probe timer.  */
 	SCTP_CMD_TRANSPORT_HB_SENT,  /* Reset the status of a transport. */
 	SCTP_CMD_TRANSPORT_IDLE,     /* Do manipulations on idle transport */
 	SCTP_CMD_TRANSPORT_ON,       /* Mark the transport as active. */
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 85f6a105c59d..265fffa33dad 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -77,6 +77,7 @@ enum sctp_event_timeout {
 	SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD,
 	SCTP_EVENT_TIMEOUT_HEARTBEAT,
 	SCTP_EVENT_TIMEOUT_RECONF,
+	SCTP_EVENT_TIMEOUT_PROBE,
 	SCTP_EVENT_TIMEOUT_SACK,
 	SCTP_EVENT_TIMEOUT_AUTOCLOSE,
 };
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 08347d3f004f..f7e083602c10 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -635,10 +635,14 @@ static inline void sctp_transport_pl_reset(struct sctp_transport *t)
 			t->pl.state = SCTP_PL_BASE;
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pl.probe_size = SCTP_BASE_PLPMTU;
+			sctp_transport_reset_probe_timer(t);
 		}
 	} else {
-		if (t->pl.state != SCTP_PL_DISABLED)
+		if (t->pl.state != SCTP_PL_DISABLED) {
+			if (del_timer(&t->probe_timer))
+				sctp_transport_put(t);
 			t->pl.state = SCTP_PL_DISABLED;
+		}
 	}
 }
 
@@ -647,6 +651,9 @@ static inline void sctp_transport_pl_update(struct sctp_transport *t)
 	if (t->pl.state == SCTP_PL_DISABLED)
 		return;
 
+	if (del_timer(&t->probe_timer))
+		sctp_transport_put(t);
+
 	t->pl.state = SCTP_PL_BASE;
 	t->pl.pmtu = SCTP_BASE_PLPMTU;
 	t->pl.probe_size = SCTP_BASE_PLPMTU;
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 09c59154634d..45542e2bac93 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -151,6 +151,7 @@ sctp_state_fn_t sctp_sf_cookie_wait_icmp_abort;
 /* Prototypes for timeout event state functions.  */
 sctp_state_fn_t sctp_sf_do_6_3_3_rtx;
 sctp_state_fn_t sctp_sf_send_reconf;
+sctp_state_fn_t sctp_sf_send_probe;
 sctp_state_fn_t sctp_sf_do_6_2_sack;
 sctp_state_fn_t sctp_sf_autoclose_timer_expire;
 
@@ -311,6 +312,7 @@ int sctp_do_sm(struct net *net, enum sctp_event_type event_type,
 void sctp_generate_t3_rtx_event(struct timer_list *t);
 void sctp_generate_heartbeat_event(struct timer_list *t);
 void sctp_generate_reconf_event(struct timer_list *t);
+void sctp_generate_probe_event(struct timer_list *t);
 void sctp_generate_proto_unreach_event(struct timer_list *t);
 
 void sctp_ootb_pkt_free(struct sctp_packet *packet);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 85d3566c2227..a3772f8ee7f6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -936,6 +936,9 @@ struct sctp_transport {
 	/* Timer to handler reconf chunk rtx */
 	struct timer_list reconf_timer;
 
+	/* Timer to send a probe HB packet for PLPMTUD */
+	struct timer_list probe_timer;
+
 	/* Since we're using per-destination retransmission timers
 	 * (see above), we're also using per-destination "transmitted"
 	 * queues.  This probably ought to be a private struct
@@ -1003,6 +1006,7 @@ void sctp_transport_free(struct sctp_transport *);
 void sctp_transport_reset_t3_rtx(struct sctp_transport *);
 void sctp_transport_reset_hb_timer(struct sctp_transport *);
 void sctp_transport_reset_reconf_timer(struct sctp_transport *transport);
+void sctp_transport_reset_probe_timer(struct sctp_transport *transport);
 int sctp_transport_hold(struct sctp_transport *);
 void sctp_transport_put(struct sctp_transport *);
 void sctp_transport_update_rto(struct sctp_transport *, __u32);
diff --git a/net/sctp/debug.c b/net/sctp/debug.c
index c4d9c7feffb9..ccd773e4c371 100644
--- a/net/sctp/debug.c
+++ b/net/sctp/debug.c
@@ -154,6 +154,7 @@ static const char *const sctp_timer_tbl[] = {
 	"TIMEOUT_T5_SHUTDOWN_GUARD",
 	"TIMEOUT_HEARTBEAT",
 	"TIMEOUT_RECONF",
+	"TIMEOUT_PROBE",
 	"TIMEOUT_SACK",
 	"TIMEOUT_AUTOCLOSE",
 };
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index ce15d590a615..b3815b568e8e 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -471,6 +471,38 @@ void sctp_generate_reconf_event(struct timer_list *t)
 	sctp_transport_put(transport);
 }
 
+/* Handle the timeout of the probe timer. */
+void sctp_generate_probe_event(struct timer_list *t)
+{
+	struct sctp_transport *transport = from_timer(transport, t, probe_timer);
+	struct sctp_association *asoc = transport->asoc;
+	struct sock *sk = asoc->base.sk;
+	struct net *net = sock_net(sk);
+	int error = 0;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		pr_debug("%s: sock is busy\n", __func__);
+
+		/* Try again later.  */
+		if (!mod_timer(&transport->probe_timer, jiffies + (HZ / 20)))
+			sctp_transport_hold(transport);
+		goto out_unlock;
+	}
+
+	error = sctp_do_sm(net, SCTP_EVENT_T_TIMEOUT,
+			   SCTP_ST_TIMEOUT(SCTP_EVENT_TIMEOUT_PROBE),
+			   asoc->state, asoc->ep, asoc,
+			   transport, GFP_ATOMIC);
+
+	if (error)
+		sk->sk_err = -error;
+
+out_unlock:
+	bh_unlock_sock(sk);
+	sctp_transport_put(transport);
+}
+
 /* Inject a SACK Timeout event into the state machine.  */
 static void sctp_generate_sack_event(struct timer_list *t)
 {
@@ -1641,6 +1673,11 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			sctp_cmd_hb_timers_stop(commands, asoc);
 			break;
 
+		case SCTP_CMD_PROBE_TIMER_UPDATE:
+			t = cmd->obj.transport;
+			sctp_transport_reset_probe_timer(t);
+			break;
+
 		case SCTP_CMD_REPORT_ERROR:
 			error = cmd->obj.error;
 			break;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4f30388a0dd0..3b99eda50618 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1095,6 +1095,23 @@ enum sctp_disposition sctp_sf_send_reconf(struct net *net,
 	return SCTP_DISPOSITION_CONSUME;
 }
 
+/* send hb chunk with padding for PLPMUTD.  */
+enum sctp_disposition sctp_sf_send_probe(struct net *net,
+					 const struct sctp_endpoint *ep,
+					 const struct sctp_association *asoc,
+					 const union sctp_subtype type,
+					 void *arg,
+					 struct sctp_cmd_seq *commands)
+{
+	struct sctp_transport *transport = (struct sctp_transport *)arg;
+
+	/* The actual handling will be performed here in a later patch. */
+	sctp_add_cmd_sf(commands, SCTP_CMD_PROBE_TIMER_UPDATE,
+			SCTP_TRANSPORT(transport));
+
+	return SCTP_DISPOSITION_CONSUME;
+}
+
 /*
  * Process an heartbeat request.
  *
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index c82c4233ec6b..1816a4410b2b 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -967,6 +967,25 @@ other_event_table[SCTP_NUM_OTHER_TYPES][SCTP_STATE_NUM_STATES] = {
 	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
 }
 
+#define TYPE_SCTP_EVENT_TIMEOUT_PROBE { \
+	/* SCTP_STATE_CLOSED */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_COOKIE_WAIT */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_COOKIE_ECHOED */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_ESTABLISHED */ \
+	TYPE_SCTP_FUNC(sctp_sf_send_probe), \
+	/* SCTP_STATE_SHUTDOWN_PENDING */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_SHUTDOWN_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_SHUTDOWN_RECEIVED */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_SHUTDOWN_ACK_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+}
+
 static const struct sctp_sm_table_entry
 timeout_event_table[SCTP_NUM_TIMEOUT_TYPES][SCTP_STATE_NUM_STATES] = {
 	TYPE_SCTP_EVENT_TIMEOUT_NONE,
@@ -978,6 +997,7 @@ timeout_event_table[SCTP_NUM_TIMEOUT_TYPES][SCTP_STATE_NUM_STATES] = {
 	TYPE_SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD,
 	TYPE_SCTP_EVENT_TIMEOUT_HEARTBEAT,
 	TYPE_SCTP_EVENT_TIMEOUT_RECONF,
+	TYPE_SCTP_EVENT_TIMEOUT_PROBE,
 	TYPE_SCTP_EVENT_TIMEOUT_SACK,
 	TYPE_SCTP_EVENT_TIMEOUT_AUTOCLOSE,
 };
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index bf0ac467e757..ca3343c2c80e 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -75,6 +75,7 @@ static struct sctp_transport *sctp_transport_init(struct net *net,
 	timer_setup(&peer->T3_rtx_timer, sctp_generate_t3_rtx_event, 0);
 	timer_setup(&peer->hb_timer, sctp_generate_heartbeat_event, 0);
 	timer_setup(&peer->reconf_timer, sctp_generate_reconf_event, 0);
+	timer_setup(&peer->probe_timer, sctp_generate_probe_event, 0);
 	timer_setup(&peer->proto_unreach_timer,
 		    sctp_generate_proto_unreach_event, 0);
 
@@ -131,6 +132,9 @@ void sctp_transport_free(struct sctp_transport *transport)
 	if (del_timer(&transport->reconf_timer))
 		sctp_transport_put(transport);
 
+	if (del_timer(&transport->probe_timer))
+		sctp_transport_put(transport);
+
 	/* Delete the ICMP proto unreachable timer if it's active. */
 	if (del_timer(&transport->proto_unreach_timer))
 		sctp_transport_put(transport);
@@ -207,6 +211,20 @@ void sctp_transport_reset_reconf_timer(struct sctp_transport *transport)
 			sctp_transport_hold(transport);
 }
 
+void sctp_transport_reset_probe_timer(struct sctp_transport *transport)
+{
+	int scale = 1;
+
+	if (timer_pending(&transport->probe_timer))
+		return;
+	if (transport->pl.state == SCTP_PL_COMPLETE &&
+	    transport->pl.probe_count == 1)
+		scale = 30; /* works as PMTU_RAISE_TIMER */
+	if (!mod_timer(&transport->probe_timer,
+		       jiffies + transport->probe_interval * scale))
+		sctp_transport_hold(transport);
+}
+
 /* This transport has been assigned to an association.
  * Initialize fields from the association or from the sock itself.
  * Register the reference count in the association.
-- 
2.27.0


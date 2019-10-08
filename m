Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D4CCF824
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbfJHL2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:28:17 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44813 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730496AbfJHL2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:28:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id q15so8310900pll.11;
        Tue, 08 Oct 2019 04:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qn7Ms1aEVz0rqBnc3O8j3wVCNjaej9ZbF6BI34tUgzw=;
        b=Kj4pl7xRZgTpQdEvb2GtoZcZjrUFp4tn4QtSZur1qIdfjOwV+MoESdbimmtsVRSW/k
         eANV2QxuWvJcUAq6LkXgaCTik9AKC98JmukBdhQCumxK+v4E0M9kgzMkCRqHpzErXN9O
         /EdN7/7TUnUsHb93nE5oTChEnGYjtyc5bH/A/IR5mxcvl0qrcTlqGVFLbuz5rMB2Ya0r
         8w8pgr0x+P0bpdQfaMIR44zGfQT20RDnXwq+TJBAYkTJoR5nZ7mOZ1yLomMR2Udt4gfX
         4UdlwhLeG83/lgM7+VEzKEuOux9QPHuCFeKvSsUBOZ/q4FKJI/9fensKx2Rz+dEz6xv3
         kG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qn7Ms1aEVz0rqBnc3O8j3wVCNjaej9ZbF6BI34tUgzw=;
        b=VF7RDHHaSj5XZ3C/s9ibvvRzqXLy+jF96F22+trFYw8ivN5Y47kE3Dgmz2fp7iuppN
         fJxyhlPOWnhG0y474ZbZsnEBu+5VRQu6lY9JbKuQiQOdO1O2lfOAcdmDtasxgmjnraxJ
         N6slXlFEFp8IOXISIs2eqWMfNNrv0doVE+7OupVok1+RoTaygC1IpThaTHbpsuPw3klZ
         FEDbSqX9dJSYFJJR878GngGLqEms/v65i4xEl63lGu+u8GA9IGHTnN8x2PYZEnKmTkeE
         4Jw8ygJbRBuL5CnOHtnLZGCUrOsS0ZgHNT2mkyYnxjtxNmlZkaRiP6WLFuErf2eFvcEw
         dwWg==
X-Gm-Message-State: APjAAAUkA4uJaFEtyfI+WxNufXUGce+nS7qUrLdq2gGuWsKrmOW8RQAi
        xTVkaSc4w+JwRpbdih0m1B6K+jx3
X-Google-Smtp-Source: APXvYqzhKrlcVoWXTPUNz9GwVNXfLcywx8ctxZrQUXa/ichyaDjy8HDkMseej9fIaSjeXd93CFHhLQ==
X-Received: by 2002:a17:902:b60d:: with SMTP id b13mr34135101pls.331.1570534096107;
        Tue, 08 Oct 2019 04:28:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q88sm1933933pjq.9.2019.10.08.04.28.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:28:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 4/4] sctp: add SCTP_SEND_FAILED_EVENT event
Date:   Tue,  8 Oct 2019 19:27:36 +0800
Message-Id: <4cdd67f27f91d040190b486b2871a3410d7e8c0e.1570534014.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <52fca36c494e075b2d40781ada8669252125521b.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
 <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
 <52fca36c494e075b2d40781ada8669252125521b.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add a new event SCTP_SEND_FAILED_EVENT described in
rfc6458#section-6.1.11. It's a update of SCTP_SEND_FAILED event:

  struct sctp_sndrcvinfo ssf_info is replaced with
  struct sctp_sndinfo ssfe_info in struct sctp_send_failed_event.

SCTP_SEND_FAILED is being deprecated, but we don't remove it in this
patch. Both are being processed in sctp_datamsg_destroy() when the
corresp event flag is set.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/ulpevent.h |  7 +++++++
 include/uapi/linux/sctp.h   | 16 +++++++++++++++-
 net/sctp/chunk.c            | 40 +++++++++++++++++++---------------------
 net/sctp/ulpevent.c         | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+), 22 deletions(-)

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index e6ead1e..0b032b9 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -95,6 +95,13 @@ struct sctp_ulpevent *sctp_ulpevent_make_send_failed(
 	__u32 error,
 	gfp_t gfp);
 
+struct sctp_ulpevent *sctp_ulpevent_make_send_failed_event(
+	const struct sctp_association *asoc,
+	struct sctp_chunk *chunk,
+	__u16 flags,
+	__u32 error,
+	gfp_t gfp);
+
 struct sctp_ulpevent *sctp_ulpevent_make_shutdown_event(
 	const struct sctp_association *asoc,
 	__u16 flags,
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6d5b164..6bce7f9 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -449,6 +449,16 @@ struct sctp_send_failed {
 	__u8 ssf_data[0];
 };
 
+struct sctp_send_failed_event {
+	__u16 ssf_type;
+	__u16 ssf_flags;
+	__u32 ssf_length;
+	__u32 ssf_error;
+	struct sctp_sndinfo ssfe_info;
+	sctp_assoc_t ssf_assoc_id;
+	__u8 ssf_data[0];
+};
+
 /*
  *   ssf_flags: 16 bits (unsigned integer)
  *
@@ -605,6 +615,7 @@ struct sctp_event_subscribe {
 	__u8 sctp_stream_reset_event;
 	__u8 sctp_assoc_reset_event;
 	__u8 sctp_stream_change_event;
+	__u8 sctp_send_failure_event_event;
 };
 
 /*
@@ -632,6 +643,7 @@ union sctp_notification {
 	struct sctp_stream_reset_event sn_strreset_event;
 	struct sctp_assoc_reset_event sn_assocreset_event;
 	struct sctp_stream_change_event sn_strchange_event;
+	struct sctp_send_failed_event sn_send_failed_event;
 };
 
 /* Section 5.3.1
@@ -667,7 +679,9 @@ enum sctp_sn_type {
 #define SCTP_ASSOC_RESET_EVENT		SCTP_ASSOC_RESET_EVENT
 	SCTP_STREAM_CHANGE_EVENT,
 #define SCTP_STREAM_CHANGE_EVENT	SCTP_STREAM_CHANGE_EVENT
-	SCTP_SN_TYPE_MAX	= SCTP_STREAM_CHANGE_EVENT,
+	SCTP_SEND_FAILED_EVENT,
+#define SCTP_SEND_FAILED_EVENT		SCTP_SEND_FAILED_EVENT
+	SCTP_SN_TYPE_MAX	= SCTP_SEND_FAILED_EVENT,
 #define SCTP_SN_TYPE_MAX		SCTP_SN_TYPE_MAX
 };
 
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index cc0405c..cc3ce5d 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -75,41 +75,39 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 	struct list_head *pos, *temp;
 	struct sctp_chunk *chunk;
 	struct sctp_ulpevent *ev;
-	int error = 0, notify;
-
-	/* If we failed, we may need to notify. */
-	notify = msg->send_failed ? -1 : 0;
+	int error, sent;
 
 	/* Release all references. */
 	list_for_each_safe(pos, temp, &msg->chunks) {
 		list_del_init(pos);
 		chunk = list_entry(pos, struct sctp_chunk, frag_list);
-		/* Check whether we _really_ need to notify. */
-		if (notify < 0) {
-			asoc = chunk->asoc;
-			if (msg->send_error)
-				error = msg->send_error;
-			else
-				error = asoc->outqueue.error;
-
-			notify = sctp_ulpevent_type_enabled(asoc->subscribe,
-							    SCTP_SEND_FAILED);
+
+		if (!msg->send_failed) {
+			sctp_chunk_put(chunk);
+			continue;
 		}
 
-		/* Generate a SEND FAILED event only if enabled. */
-		if (notify > 0) {
-			int sent;
-			if (chunk->has_tsn)
-				sent = SCTP_DATA_SENT;
-			else
-				sent = SCTP_DATA_UNSENT;
+		asoc = chunk->asoc;
+		error = msg->send_error ?: asoc->outqueue.error;
+		sent = chunk->has_tsn ? SCTP_DATA_SENT : SCTP_DATA_UNSENT;
 
+		if (sctp_ulpevent_type_enabled(asoc->subscribe,
+					       SCTP_SEND_FAILED)) {
 			ev = sctp_ulpevent_make_send_failed(asoc, chunk, sent,
 							    error, GFP_ATOMIC);
 			if (ev)
 				asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
 		}
 
+		if (sctp_ulpevent_type_enabled(asoc->subscribe,
+					       SCTP_SEND_FAILED_EVENT)) {
+			ev = sctp_ulpevent_make_send_failed_event(asoc, chunk,
+								  sent, error,
+								  GFP_ATOMIC);
+			if (ev)
+				asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
+		}
+
 		sctp_chunk_put(chunk);
 	}
 
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index f07b986..c82dbdc 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -527,6 +527,45 @@ struct sctp_ulpevent *sctp_ulpevent_make_send_failed(
 	return NULL;
 }
 
+struct sctp_ulpevent *sctp_ulpevent_make_send_failed_event(
+	const struct sctp_association *asoc, struct sctp_chunk *chunk,
+	__u16 flags, __u32 error, gfp_t gfp)
+{
+	struct sctp_send_failed_event *ssf;
+	struct sctp_ulpevent *event;
+	struct sk_buff *skb;
+	int len;
+
+	skb = skb_copy_expand(chunk->skb, sizeof(*ssf), 0, gfp);
+	if (!skb)
+		return NULL;
+
+	len = ntohs(chunk->chunk_hdr->length);
+	len -= sctp_datachk_len(&asoc->stream);
+
+	skb_pull(skb, sctp_datachk_len(&asoc->stream));
+	event = sctp_skb2event(skb);
+	sctp_ulpevent_init(event, MSG_NOTIFICATION, skb->truesize);
+
+	ssf = skb_push(skb, sizeof(*ssf));
+	ssf->ssf_type = SCTP_SEND_FAILED_EVENT;
+	ssf->ssf_flags = flags;
+	ssf->ssf_length = sizeof(*ssf) + len;
+	skb_trim(skb, ssf->ssf_length);
+	ssf->ssf_error = error;
+
+	ssf->ssfe_info.snd_sid = chunk->sinfo.sinfo_stream;
+	ssf->ssfe_info.snd_ppid = chunk->sinfo.sinfo_ppid;
+	ssf->ssfe_info.snd_context = chunk->sinfo.sinfo_context;
+	ssf->ssfe_info.snd_assoc_id = chunk->sinfo.sinfo_assoc_id;
+	ssf->ssfe_info.snd_flags = chunk->chunk_hdr->flags;
+
+	sctp_ulpevent_set_owner(event, asoc);
+	ssf->ssf_assoc_id = sctp_assoc2id(asoc);
+
+	return event;
+}
+
 /* Create and initialize a SCTP_SHUTDOWN_EVENT notification.
  *
  * Socket Extensions for SCTP - draft-01
-- 
2.1.0


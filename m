Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47BCF81E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbfJHL1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:27:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35477 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfJHL1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:27:54 -0400
Received: by mail-pg1-f196.google.com with SMTP id p30so8007554pgl.2;
        Tue, 08 Oct 2019 04:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qnqSkiMAEjJ47hvA1bRRd8gvLRbItJ6n8FBPVmq3Fwg=;
        b=Z8aB1V35739djB2WZf40f2FpgVu5q22/w//Wx+Vr08uKyIaSRd7f7/Ijx4aPerdWFX
         qVWLd7Qeg8KOtwqRFN6pq9Q9D1vu2QUptJUfLjOWRT21Ms2UjYkP+iM0MP4oJRIle1i8
         5afY6XgYioPGVC0zV5yqAKdIYS0KPSmwUYFQ2opWz3XjYfeij9Mqk02RWnVdQOuJ/tJR
         kwim0VFpM74rl/xMmxG2zmiklezxbykOmAlI+q0jxldiVL6VonsaGZ2hB2MwXGYIUwVN
         ZQL93M7MeBRJyYfUezUmzgo5GRQllh0BhfMFze5rjiAjXGOISYYN9kaR7mt/PoHkb0tt
         rE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qnqSkiMAEjJ47hvA1bRRd8gvLRbItJ6n8FBPVmq3Fwg=;
        b=JupexDk3oTOdTi/7rQSz2fcVAQk9qF14TwdyI/HhqmjOPq91HD5ngpPXl6HxBG2FqG
         LVslLm4B/Wkcg371rV8NCQavHATWziV+qMwcysZ4ltHG7Vm9GPmkf+hERezb3LzLsYaf
         ETaaytmk4aTIFnO11Q4sMCok+Qnv9ojUN9b7miisF4GGk2cw+YqUjQIT9Ekdk9Y+DpUH
         lv5sRfRX/lfwmUCNn4KDZxnfa5JbpIVtfiCRuuxh5H4s+DHv6mjsLwCBVZLQckxcK1wi
         6sbsGcRbhE4eKu22gbUOalXKqdiDXqVEK4o8ykFiytFsrwubMXLBZrlt1Nv45PStglig
         /Suw==
X-Gm-Message-State: APjAAAWecsdVOOHzgbbgAA6B4sJ7mDyVHKYHDnvdnXKw+ApBeb9GV4EM
        Y/JAOXxcZT8f5zNO2g3EUj79cDKt
X-Google-Smtp-Source: APXvYqx+kceqmIFcmtwBYYeqUQTzoJbq7ula4bJhMjAr1uHWouDW2ohrNC4S1q7b4f9KOgSxKQElpQ==
X-Received: by 2002:a62:8142:: with SMTP id t63mr38968042pfd.246.1570534073290;
        Tue, 08 Oct 2019 04:27:53 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d20sm22418968pfq.88.2019.10.08.04.27.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:27:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 1/4] sctp: add SCTP_ADDR_ADDED event
Date:   Tue,  8 Oct 2019 19:27:33 +0800
Message-Id: <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper sctp_ulpevent_nofity_peer_addr_change() will be extracted
to make peer_addr_change event and enqueue it, and the helper will
be called in sctp_assoc_add_peer() to send SCTP_ADDR_ADDED event.

This event is described in rfc6458#section-6.1.2:

  SCTP_ADDR_ADDED:  The address is now part of the association.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/ulpevent.h |  9 ++-------
 net/sctp/associola.c        | 19 ++++++-------------
 net/sctp/ulpevent.c         | 18 +++++++++++++++++-
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index e1a92c4..e6ead1e 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -80,13 +80,8 @@ struct sctp_ulpevent *sctp_ulpevent_make_assoc_change(
 	struct sctp_chunk *chunk,
 	gfp_t gfp);
 
-struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
-	const struct sctp_association *asoc,
-	const struct sockaddr_storage *aaddr,
-	int flags,
-	int state,
-	int error,
-	gfp_t gfp);
+void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+					   int state, int error);
 
 struct sctp_ulpevent *sctp_ulpevent_make_remote_error(
 	const struct sctp_association *asoc,
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2ffc9a..55aad70 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -707,6 +707,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
 	asoc->peer.transport_count++;
 
+	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
+
 	/* If we do not yet have a primary path, set one.  */
 	if (!asoc->peer.primary_path) {
 		sctp_assoc_set_primary(asoc, peer);
@@ -781,10 +783,8 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 				  enum sctp_transport_cmd command,
 				  sctp_sn_error_t error)
 {
-	struct sctp_ulpevent *event;
-	struct sockaddr_storage addr;
-	int spc_state = 0;
 	bool ulp_notify = true;
+	int spc_state = 0;
 
 	/* Record the transition on the transport.  */
 	switch (command) {
@@ -836,16 +836,9 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 	/* Generate and send a SCTP_PEER_ADDR_CHANGE notification
 	 * to the user.
 	 */
-	if (ulp_notify) {
-		memset(&addr, 0, sizeof(struct sockaddr_storage));
-		memcpy(&addr, &transport->ipaddr,
-		       transport->af_specific->sockaddr_len);
-
-		event = sctp_ulpevent_make_peer_addr_change(asoc, &addr,
-					0, spc_state, error, GFP_ATOMIC);
-		if (event)
-			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
-	}
+	if (ulp_notify)
+		sctp_ulpevent_nofity_peer_addr_change(transport,
+						      spc_state, error);
 
 	/* Select new active and retran paths. */
 	sctp_select_active_and_retran_path(asoc);
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index e0cc1ed..f07b986 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -238,7 +238,7 @@ struct sctp_ulpevent  *sctp_ulpevent_make_assoc_change(
  * When a destination address on a multi-homed peer encounters a change
  * an interface details event is sent.
  */
-struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
+static struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
 	const struct sctp_association *asoc,
 	const struct sockaddr_storage *aaddr,
 	int flags, int state, int error, gfp_t gfp)
@@ -336,6 +336,22 @@ struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
 	return NULL;
 }
 
+void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+					   int state, int error)
+{
+	struct sctp_association *asoc = transport->asoc;
+	struct sockaddr_storage addr;
+	struct sctp_ulpevent *event;
+
+	memset(&addr, 0, sizeof(struct sockaddr_storage));
+	memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
+
+	event = sctp_ulpevent_make_peer_addr_change(asoc, &addr, 0, state,
+						    error, GFP_ATOMIC);
+	if (event)
+		asoc->stream.si->enqueue_event(&asoc->ulpq, event);
+}
+
 /* Create and initialize an SCTP_REMOTE_ERROR notification.
  *
  * Note: This assumes that the chunk->skb->data already points to the
-- 
2.1.0


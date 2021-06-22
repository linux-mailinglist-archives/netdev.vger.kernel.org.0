Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09613B0C8B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhFVSLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D94DC09B091;
        Tue, 22 Jun 2021 11:05:13 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id g14so108449qtv.4;
        Tue, 22 Jun 2021 11:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RLfm16BlGkwYSNUChRREQ50QVtT26SW6wBwlBHFg1CE=;
        b=Xd29rAo2RtQrz7+05vzhemNHyWzJaVfmsNhUBVexvHRAkOpXGw3YwRfbjYFOuwa3g4
         rW5swpVrKLNhIVeiuZ4l+8bFgre1LC4VtmQYmjk7Szr++YncOFv83ILGkdhcFuydypzS
         J5IGagsOz8MBS7Nnw8KKYJOYX3mrwvZNr0Z+LbNxXNTnN1IkErmEyl8W/16eU4aCJ479
         4fSJ7cj+khuiJqU3WQPNeKmoLdYhUa5LK1mq8DOcBNndKpq6dztosb409JqaELgAYvaK
         K8fHDFnbss4fOepyGfxiKFklSTZ2/yWIJqG2VUT416nJYE1k6/i/4++d1zvWGMiJ21Q/
         VbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLfm16BlGkwYSNUChRREQ50QVtT26SW6wBwlBHFg1CE=;
        b=E6TzDayLUC8mGD8Bngl8EHO63iSzbziyIrqEivzJZGJdmlPLG7XKLSV48lr5TxCcqF
         EsTirAzVYFwAcuauxvPiks26CD9R4CexUJhJc7kzYkxzSWxTwafF94s/Sa8NS7F0PeJC
         fpLJq3318GYGCoRNN3CqkiS8ShsracT2XFXcbtcDdDDnCZnbxiH5ODxqWch5CqFC+rPY
         ePwiQBUipIAnO2pmggs2zM+1wKfrW+xRGP66eSE3RyPihMqohbKznd+zcPAG5LPvKAZF
         UDzpI3lr2PbVve8OyL4IPR7+lQ3s9xxxGDHD/Z9tSxWJSYaof79GgJcYdh3WAgSNhIu/
         VvDA==
X-Gm-Message-State: AOAM5317gl8FKmJl7aiU+POdq/vNk1iT1bbuShpJzP5Pw5rFOer8G+R1
        b11pDlk9ZKHWYjAzmkWL1DIF0AKv1bXhhQ==
X-Google-Smtp-Source: ABdhPJycm44C8rKY38a1JVWEf/vYyMZQo4sCM+bNh6q49kXiqssDcreBxtUpllYakQ9B7REjvXhzAg==
X-Received: by 2002:ac8:4b65:: with SMTP id g5mr51835qts.152.1624385112593;
        Tue, 22 Jun 2021 11:05:12 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w28sm2250620qtt.88.2021.06.22.11.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 10/14] sctp: enable PLPMTUD when the transport is ready
Date:   Tue, 22 Jun 2021 14:04:56 -0400
Message-Id: <da579e81811a2c9b8dff7c64f8801e6ad1ee3912.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_transport_pl_reset() is called whenever any of these 3 members in
transport is changed:

  - probe_interval
  - param_flags & SPP_PMTUD_ENABLE
  - state == ACTIVE

If all are true, start the PLPMTUD when it's not yet started. If any of
these is false, stop the PLPMTUD when it's already running.

sctp_transport_pl_update() is called when the transport dst has changed.
It will restart the PLPMTUD probe. Again, the pathmtu won't change but
use the dst's mtu until the Search phase is done.

Note that after using PLPMTUD, the pathmtu is only initialized with the
dst mtu when the transport dst changes. At other time it is updated by
pl.pmtu. So sctp_transport_pmtu_check() will be called only when PLPMTUD
is disabled in sctp_packet_config().

After this patch, the PLPMTUD feature from RFC8899 will be activated
and can be used by users.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/associola.c | 4 ++++
 net/sctp/output.c    | 3 ++-
 net/sctp/socket.c    | 6 +++++-
 net/sctp/transport.c | 2 ++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index e01895edd3a4..be29da09cc7a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -716,6 +716,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 		return NULL;
 	}
 
+	sctp_transport_pl_reset(peer);
+
 	/* Attach the remote transport to our asoc.  */
 	list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
 	asoc->peer.transport_count++;
@@ -814,6 +816,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 			spc_state = SCTP_ADDR_CONFIRMED;
 
 		transport->state = SCTP_ACTIVE;
+		sctp_transport_pl_reset(transport);
 		break;
 
 	case SCTP_TRANSPORT_DOWN:
@@ -823,6 +826,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 */
 		if (transport->state != SCTP_UNCONFIRMED) {
 			transport->state = SCTP_INACTIVE;
+			sctp_transport_pl_reset(transport);
 			spc_state = SCTP_ADDR_UNREACHABLE;
 		} else {
 			sctp_transport_dst_release(transport);
diff --git a/net/sctp/output.c b/net/sctp/output.c
index ceefb0616d9d..9032ce60d50e 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -103,7 +103,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		sctp_transport_route(tp, NULL, sp);
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
-	} else if (!sctp_transport_pmtu_check(tp)) {
+	} else if (!sctp_transport_pl_enabled(tp) &&
+		   !sctp_transport_pmtu_check(tp)) {
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
 	}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aba576f53458..e64e01f61b11 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2496,6 +2496,7 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 				sctp_transport_pmtu(trans, sctp_opt2sk(sp));
 				sctp_assoc_sync_pmtu(asoc);
 			}
+			sctp_transport_pl_reset(trans);
 		} else if (asoc) {
 			asoc->param_flags =
 				(asoc->param_flags & ~SPP_PMTUD) | pmtud_change;
@@ -4506,6 +4507,7 @@ static int sctp_setsockopt_probe_interval(struct sock *sk,
 			return -EINVAL;
 
 		t->probe_interval = msecs_to_jiffies(probe_interval);
+		sctp_transport_pl_reset(t);
 		return 0;
 	}
 
@@ -4522,8 +4524,10 @@ static int sctp_setsockopt_probe_interval(struct sock *sk,
 	 * each transport.
 	 */
 	if (asoc) {
-		list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
+		list_for_each_entry(t, &asoc->peer.transport_addr_list, transports) {
 			t->probe_interval = msecs_to_jiffies(probe_interval);
+			sctp_transport_pl_reset(t);
+		}
 
 		asoc->probe_interval = msecs_to_jiffies(probe_interval);
 		return 0;
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 5cefb4eab8a0..f27b856ea8ce 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -259,6 +259,8 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 		transport->pathmtu = sctp_dst_mtu(transport->dst);
 	else
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
+
+	sctp_transport_pl_update(transport);
 }
 
 void sctp_transport_pl_send(struct sctp_transport *t)
-- 
2.27.0


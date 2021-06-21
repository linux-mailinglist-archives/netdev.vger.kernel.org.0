Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C703AE172
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhFUBl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFUBlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:16 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7622C061756;
        Sun, 20 Jun 2021 18:39:02 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r7so12247745qta.12;
        Sun, 20 Jun 2021 18:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=52C1D8Mi7vrn3Fr5v+AnDQW3rLlj6O4hVJCDN9ikfoM=;
        b=cmSRkCVbqFlzqbMoIgRED841XLSlcXQImnq6EiCqFVFET8nJRYBWUBEPiHfsB7pCaO
         +k07Cse1m/ehFI2/Mil5hmMNxmI5X1CBBN96kbF5nvbtxidHHWm8QhbDTBxJcDCwcTo9
         e/Qy3MwVoBtHA80GfhEozKfGhlvYBSMLKfzFlJqwDvQWJr8EMtq+v0Cn7IRNER6NFrJ8
         ZW0tn9Dc6Cdlo8B4lcg2nk9d4rT3Tg0yCQ1ni9G89EDe00bI6DTo1F3tcejZinmYDPNX
         uTfjX56C938vvrdsdb2IFbhdPpTAVQzSD0DSlUzx2ntQUB+mLEdJG8RTIC9hgYWvzhAH
         jMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52C1D8Mi7vrn3Fr5v+AnDQW3rLlj6O4hVJCDN9ikfoM=;
        b=ZTWdWB0mtEC3SxBBllENX5PmTNiE41Dz02yxEvr3WeBjAgkBe64DNqBMvy2HBOPhWP
         dIvhk4PzHOs9hv6SwkZy3HYAElkrLDNOC009BvMM0EQTA7m3NjzQ6z9d3iZxD0wJ/HvD
         Yqj7siskSifZJS4INFW7Ff6Mszr2fimCnYOSnmNoyXpgPLqCk7cznH/g4cl0aOuW++il
         pABbBUlY0UVhqRoNdnquBoqhvuAjyf66Ych79VzyhOAj6VWbbfvE1bMM9xxWy3yTPMv/
         1jstA67qTBDaC3napjQDVGBIibQXWoCIuzocHiOoNeMQmD8nQK8Us+qhHdE7Sw72mqWV
         fnHw==
X-Gm-Message-State: AOAM530mjOxxHN79qwxopqYUopx4SlQZ6F5r2b5adNk9JBf21vhDAdcl
        YT5N+dFWu3AfPgMr7CNXbWyvuxK+1806cA==
X-Google-Smtp-Source: ABdhPJzNLxefkYqSZV+HkAAqU8/7xOIeYGUQ+kjmftWlB+acD1kEPBz/dvYrRUMlLrEI8VPOOiAYlA==
X-Received: by 2002:ac8:12c7:: with SMTP id b7mr20993602qtj.243.1624239541910;
        Sun, 20 Jun 2021 18:39:01 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bm15sm8429875qkb.76.2021.06.20.18.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:39:01 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 10/14] sctp: enable PLPMTUD when the transport is ready
Date:   Sun, 20 Jun 2021 21:38:45 -0400
Message-Id: <9b0baa8879804160bb1bb623d4dea5de201fbd7f.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
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
index b78d978de0e5..79a14f74aedc 100644
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


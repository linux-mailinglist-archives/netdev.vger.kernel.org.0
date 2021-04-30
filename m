Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F53701B9
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhD3UF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 16:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbhD3UEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 16:04:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC81CC06174A;
        Fri, 30 Apr 2021 13:03:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so2333432pjh.1;
        Fri, 30 Apr 2021 13:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6b7BJcbm6D1aqgi/VtytZ9fDai8Xsd4OeDiV8zlCTyo=;
        b=nOBNtyeOp2fuLuMM9GK8LbncYm3z2091EopGUaIWJmwSzienTXA9jELM4wO6YshoeI
         F6jm/8UjadFSA4wY05P32hUL2pepBDb3Tlsxnp6uShYgtCg3ovGMxpmsRCfz1J08LpKT
         Exvw+dyQdKm6F/KEr/xAfWe0/Y4LpzQWTAk+ASK/FpW2bzz1TauR1Las7NQapkwL3AFS
         p88UEd97hK+ev8NICoIDGlvA6/dVMQcm+7LLCM+tZQSm40wD1pFZ2ep7D/bFJFJUvWP7
         8mWyt+kCcbmZf+hckTrVVm3wL5fr9S0/vOLjT5mhl+Hf4VNYAhocszc55EvEshklbv4P
         LU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6b7BJcbm6D1aqgi/VtytZ9fDai8Xsd4OeDiV8zlCTyo=;
        b=KdlQkzTv0loFFBLeFnkfX7vXughl7ZLmDcY1qjbbMfxPTeCJ5tXMm7GwNlzjvLfSTj
         lhFCCwF9zUViHH5pq+gyD96vN6KZTMdgB95B/lPP9jgA/ZBQ0Wq9yN1k+k12xl67Mz10
         nYtnVob0GXbO4ci6PpD7KJTRRGZvWVtk7E9UeOL0F0Pu86fb0khaDFItcc+tnavQBXiA
         cA6ABHWE9RWYZfIApR9DcX2rWp2sj7ov5hNUoasYw6riVqmvXQhJnSv40JaYc5Dia/cJ
         dZWK91oAQPuh52G/ebgtimZrbIIwY2rb7iLMCWDdSV6RLrUCp7TFmxBbBqZ1hdN68mmX
         4r8g==
X-Gm-Message-State: AOAM532quCI6qZVcRpCIWSPVMuULmumIGIxmVIL7K/xQ6q8xdXNOMbLA
        ibyeL1kNZhrxZdbgM2NUsuRRuT5obqWTNRtD
X-Google-Smtp-Source: ABdhPJyLUYzf4I9o77xashEdRLjt1T6w7/d5E4ClO3Adr3bKwyLsiRQLD8kr6qTi7Tb7+UwzPMxXrw==
X-Received: by 2002:a17:90a:cf8a:: with SMTP id i10mr7025466pju.188.1619812996993;
        Fri, 30 Apr 2021 13:03:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ml19sm15040003pjb.2.2021.04.30.13.03.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 13:03:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCHv2 net 1/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_a
Date:   Sat,  1 May 2021 04:02:58 +0800
Message-Id: <1a42d5e9ae45c01dbf0378fca0cb8cfd85ee454b.1619812899.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1619812899.git.lucien.xin@gmail.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619812899.git.lucien.xin@gmail.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a panic that occurs in a few of envs, the call trace is as below:

  [] general protection fault, ... 0x29acd70f1000a: 0000 [#1] SMP PTI
  [] RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0x4b/0x1fa [sctp]
  []  sctp_assoc_control_transport+0x1b9/0x210 [sctp]
  []  sctp_do_8_2_transport_strike.isra.16+0x15c/0x220 [sctp]
  []  sctp_cmd_interpreter.isra.21+0x1231/0x1a10 [sctp]
  []  sctp_do_sm+0xc3/0x2a0 [sctp]
  []  sctp_generate_timeout_event+0x81/0xf0 [sctp]

This is caused by a transport use-after-free issue. When processing a
duplicate COOKIE-ECHO chunk in sctp_sf_do_dupcook_a(), both COOKIE-ACK
and SHUTDOWN chunks are allocated with the transort from the new asoc.
However, later in the sideeffect machine, the old asoc is used to send
them out and old asoc's shutdown_last_sent_to is set to the transport
that SHUTDOWN chunk attached to in sctp_cmd_setup_t2(), which actually
belongs to the new asoc. After the new_asoc is freed and the old asoc
T2 timeout, the old asoc's shutdown_last_sent_to that is already freed
would be accessed in sctp_sf_t2_timer_expire().

Thanks Alexander and Jere for helping dig into this issue.

To fix it, this patch is to do the asoc update first, then allocate
the COOKIE-ACK and SHUTDOWN chunks with the 'updated' old asoc. This
would make more sense, as a chunk from an asoc shouldn't be sent out
with another asoc. We had fixed quite a few issues caused by this.

Fixes: 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with COOKIE-ACK")
Reported-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Reported-by: syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com
Reported-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_statefuns.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7632714..30cb946 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1852,20 +1852,35 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 	sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL());
 
-	repl = sctp_make_cookie_ack(new_asoc, chunk);
+	/* Update the content of current association. */
+	if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {
+		struct sctp_chunk *abort;
+
+		abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
+		if (abort) {
+			sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
+			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
+		}
+		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
+		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
+				SCTP_PERR(SCTP_ERROR_RSRC_LOW));
+		SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
+		SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
+		goto nomem;
+	}
+
+	repl = sctp_make_cookie_ack(asoc, chunk);
 	if (!repl)
 		goto nomem;
 
 	/* Report association restart to upper layer. */
 	ev = sctp_ulpevent_make_assoc_change(asoc, 0, SCTP_RESTART, 0,
-					     new_asoc->c.sinit_num_ostreams,
-					     new_asoc->c.sinit_max_instreams,
+					     asoc->c.sinit_num_ostreams,
+					     asoc->c.sinit_max_instreams,
 					     NULL, GFP_ATOMIC);
 	if (!ev)
 		goto nomem_ev;
 
-	/* Update the content of current association. */
-	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
 	     sctp_state(asoc, SHUTDOWN_SENT)) &&
-- 
2.1.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138D3161805
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgBQQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:35:05 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44753 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbgBQQfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:35:03 -0500
Received: by mail-pg1-f196.google.com with SMTP id g3so9329356pgs.11;
        Mon, 17 Feb 2020 08:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YrIogMAzNjDoho/ZMU6x1lezaGjyCZgCFRA4k/XFA2Q=;
        b=aXgx9FuIkeYKessQtQzklWhRed4jxOnavjhebJk8qxFqotlinaiVCYCk9oJYu7YW58
         gE55ReQ6tAr5DE6hchYO+4+STqMfXLl700fgujDLdPKXRYMhUFHY/WFDFxmf9wuYPaK/
         XrQgQaGivi9aO3xhZ4tC2oWJbDEWMDQF0Jvp4RIc8kD0ri6Tq3e8bnXsK2mOjGpZo9QH
         O0vJozOBSNIOg7dsM86py2lI0LJieWnmw7A7EpM2+Qwqjn6lmuo1aBqwCRckWbSfpLn0
         hHFihs3ga6m4FjlXEmLo65qmWVypS1yq7RbE79ska5OatKQK8LZ1YhMPelfMNYQQg0Z1
         uBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YrIogMAzNjDoho/ZMU6x1lezaGjyCZgCFRA4k/XFA2Q=;
        b=dlVhztOs8sw3mztTOxVqP0gpco8E3nAt/KiC8TZZwUgLv9F+T2SUYvIWCXBSOk7d2N
         Kb1E8r4NpMZXbUV6Q86aMbgvPk3Yytz/oYJa0dVRBpShaih/XCaJG0nBHDI/b+X9ALGO
         rhsmgkxml0bPxDXj5RlMrodztx46fFylwFzlm0ZcByhNDaMsrGzicwnTrXAtD2cegHUX
         9xIgCIDbXrTtsT6dWZoGNV9HvUaduzS8nLvkU2++yYPen2DGbEP1PdIPO/rVTQQ8b8nU
         c4YyuqaqglghpQQQjta+7tTI5pUZOzCK6YV2jzLCKgbv5pf/QynpAzSKWr5sZcKqDw1Q
         fKPw==
X-Gm-Message-State: APjAAAXSXrgbVeFnnYrIEkAnkxqvVX1U77pLTjBXqrfhXhb7WrIuR/qO
        ZzYsVdxIbrivddBOpZNLgkxRu7fQ
X-Google-Smtp-Source: APXvYqydvjkI9S+SrpEeWISB9MlWmSQ3HxruBrrg/IpEMPCedHSOfzWlJhjNx2aOmtrEeyu91UG0LQ==
X-Received: by 2002:a63:5c0e:: with SMTP id q14mr18826292pgb.313.1581957301149;
        Mon, 17 Feb 2020 08:35:01 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w26sm952373pfj.119.2020.02.17.08.34.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 08:35:00 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] sctp: move the format error check out of __sctp_sf_do_9_1_abort
Date:   Tue, 18 Feb 2020 00:34:52 +0800
Message-Id: <1833bf6abc2610393666b930fe629534cd21e0fa.1581957292.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When T2 timer is to be stopped, the asoc should also be deleted,
otherwise, there will be no chance to call sctp_association_free
and the asoc could last in memory forever.

However, in sctp_sf_shutdown_sent_abort(), after adding the cmd
SCTP_CMD_TIMER_STOP for T2 timer, it may return error due to the
format error from __sctp_sf_do_9_1_abort() and miss adding
SCTP_CMD_ASSOC_FAILED where the asoc will be deleted.

This patch is to fix it by moving the format error check out of
__sctp_sf_do_9_1_abort(), and do it before adding the cmd
SCTP_CMD_TIMER_STOP for T2 timer.

Thanks Hangbin for reporting this issue by the fuzz testing.

Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 748e3b1..e2b2b41 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -170,6 +170,16 @@ static inline bool sctp_chunk_length_valid(struct sctp_chunk *chunk,
 	return true;
 }
 
+/* Check for the format error in an ABORT chunk */
+static inline bool sctp_err_chunk_valid(struct sctp_chunk *chunk)
+{
+	struct sctp_errhdr *err;
+
+	sctp_walk_errors(err, chunk->chunk_hdr);
+
+	return (void *)err == (void *)chunk->chunk_end;
+}
+
 /**********************************************************
  * These are the state functions for handling chunk events.
  **********************************************************/
@@ -2255,6 +2265,9 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
 }
 
@@ -2298,6 +2311,9 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Stop the T2-shutdown timer. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T2_SHUTDOWN));
@@ -2565,6 +2581,9 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
 }
 
@@ -2582,16 +2601,8 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
 
 	/* See if we have an error cause code in the chunk.  */
 	len = ntohs(chunk->chunk_hdr->length);
-	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr)) {
-		struct sctp_errhdr *err;
-
-		sctp_walk_errors(err, chunk->chunk_hdr);
-		if ((void *)err != (void *)chunk->chunk_end)
-			return sctp_sf_pdiscard(net, ep, asoc, type, arg,
-						commands);
-
+	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr))
 		error = ((struct sctp_errhdr *)chunk->skb->data)->cause;
-	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNRESET));
 	/* ASSOC_FAILED will DELETE_TCB. */
-- 
2.1.0


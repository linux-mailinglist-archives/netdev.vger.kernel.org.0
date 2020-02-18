Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1579161FBD
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 05:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgBREIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 23:08:02 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34018 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgBREIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 23:08:02 -0500
Received: by mail-pg1-f193.google.com with SMTP id j4so10284853pgi.1;
        Mon, 17 Feb 2020 20:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6I29+OkcvhYhAunZjeEp0E/Cn3jozgYBeUqo/R46mdw=;
        b=la7p82wQz4UMVc5tjC4/j0uIXT6+JiWEO3kmvcQydjxh7SXG9EyQhWtVwOjqURbHC/
         cvysQ7wMgg+wBHqWpp3RPDUdPhHr3WZeKm7eXqIK03m2gP4xYfuqo5NePAud9vfLPNHr
         ZNjh5WKsAO5wx6GeSQmEHhzabBXVjRHdjJFEvmBjpdHUSQElfmKEsNXS8UoDJXj2m3et
         rdxeiNYHRl6Iy2DNY4cCG6gwr4Njzkdv+uXBjeIEkjU9UwP+CUgaC4sBf2oP+R632gIM
         BMb+4DcP1YwIOMwRFGDrvVd1WKXmJUxDs2RazgahNwa9DdC1JL6MAhc8gJuaWojOzcN+
         BgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6I29+OkcvhYhAunZjeEp0E/Cn3jozgYBeUqo/R46mdw=;
        b=kDUv3I9GXW2x3iFTJzNnfAVVJwJILNIokE2beBHSfxvA2Ycd0iti1mzhD8/UcP6wB9
         +XGNd3Q8VDwHZimBtIlwG05JpnZyI9q3uboHxWIYik5frPmfLtj6hX/wcdOKCSiRNDDV
         ZAbxxZS64lh8EmBQuh3+0vwAXnpfViSpbvGQNSCsj9ouhVo+fm16f12HlFeYx5s8xSj5
         9NPjHaDo3yYSHu9CPf7ejqy4HXj5JB5dTHrQAKK76lzm2zzuuFeif1mKdlkue1a4XZ47
         DPCyJ08SfF4Yt0V5Rl/ZOocTv0kcN+1Mp4OtrBRrqLyVlHpNS+KctdP72Zwse9d5GYOM
         2asQ==
X-Gm-Message-State: APjAAAUfnWH/iZquL0Mvq+Te9Ga/CLSXkGEpLTVqJ78voYu14bT2aZZw
        6nqv4EzlU0ayEnAxLxGh7H+h8S9Hq2c=
X-Google-Smtp-Source: APXvYqw48CPmn3Vjm4lcJQ+FczYuioHh+tmdzb44jORTY1Ugfwr3ohwsoTY/sZj2V6MMH4b0EW7G3A==
X-Received: by 2002:a65:4d0d:: with SMTP id i13mr20599229pgt.346.1581998881349;
        Mon, 17 Feb 2020 20:08:01 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a36sm2333121pga.32.2020.02.17.20.08.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 20:08:00 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] sctp: move the format error check out of __sctp_sf_do_9_1_abort
Date:   Tue, 18 Feb 2020 12:07:53 +0800
Message-Id: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
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

v1->v2:
  - improve the comment in the code as Marcelo's suggestion.

Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 748e3b1..6a16af4 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -170,6 +170,16 @@ static inline bool sctp_chunk_length_valid(struct sctp_chunk *chunk,
 	return true;
 }
 
+/* Check for format error in an ABORT chunk */
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


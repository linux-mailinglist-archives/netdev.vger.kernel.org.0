Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3C6229BD5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732918AbgGVPwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGVPwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:52:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29F6C0619DC;
        Wed, 22 Jul 2020 08:52:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id q17so1191693pls.9;
        Wed, 22 Jul 2020 08:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=n46Ldv3YCoVjAqAm1P4xCezKoJ2R94OtYBCuyRUdESA=;
        b=XM7xfwn1KSunWPGqai0kPae8nB+Mj16nlGlRRJKtiovPAhFqg0x6eC+i7cxrmRdLZ+
         Bvu2iCeKeIt2dpj++l/fnLowFlRfZmKbIoGot7UreiWbszRQRrusPPTCwziNHf+gSThO
         T0juoY8qPJk7JkdFGzo2Q/wztF9okeh/kKyMO6TbBnbChWK/GAPPAHobGGP0Y6NdN6un
         +WmENx/OA3uAOJGWlJAmCtKGhf/71opXVqgNVbRqA/bq7EcUa1AkSclAZdVQAtD/2ST5
         Z6jfakrNyMXg3upSRV25209+udJKYAIRrUc50j+CBywbFzKmGNMTZecvoaK55SW0FaKi
         IdWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=n46Ldv3YCoVjAqAm1P4xCezKoJ2R94OtYBCuyRUdESA=;
        b=EPcl0YwUHkUuKssLMyYVnhyBc/oy3wqci8sj3t2u7eUxcNNQEj9obQvSz3KsetGgro
         7n1MhWEOcvJDlcy2vmBBiA+YXROuHxWYNd2WOtOeLaXKrrD2awD0aInsVwUc1FD/nCoy
         pwgrYkT5qJOZxngnEtRnNPIBNBD8ftV7PhymZyiFJVBquMjxvmo273RjO4PsbtxF94g0
         +7NRI0mONVi8G1hjJiP/Fh8Oia/Iqgg+ezm7CGTI7m8OZ1PvNg0P/qzoKKyNS2L9ZsL8
         MFGc4p6JDOjwV8bPx+EQwMOsmwkXNrv5GJUBIp/GvFN70zyffyB7L/BXTMnNPVPlN42K
         2ZWg==
X-Gm-Message-State: AOAM532ceALHbHwldh24d9ExV6vieArJLHNHvzwNRsHg1y4vUNkon0EA
        99NSzlrl3ouoFbu8DibzFOCfFgO5
X-Google-Smtp-Source: ABdhPJw2C3ivdYeEWczPSk9txPuBDemikzHBWS+5odPXAI+ypXUxuttceKy0t3LPDITV2VFPX7+kxQ==
X-Received: by 2002:a17:90a:8e:: with SMTP id a14mr65913pja.206.1595433150278;
        Wed, 22 Jul 2020 08:52:30 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id io3sm101701pjb.22.2020.07.22.08.52.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 08:52:29 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 1/2] sctp: shrink stream outq only when new outcnt < old outcnt
Date:   Wed, 22 Jul 2020 23:52:11 +0800
Message-Id: <ceb8b4f32a9235e0a846e4f8e0537fcb362edf04.1595433039.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1595433039.git.lucien.xin@gmail.com>
References: <cover.1595433039.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1595433039.git.lucien.xin@gmail.com>
References: <cover.1595433039.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not necessary to go list_for_each for outq->out_chunk_list
when new outcnt >= old outcnt, as no chunk with higher sid than
new (outcnt - 1) exists in the outqueue.

While at it, also move the list_for_each code in a new function
sctp_stream_shrink_out(), which will be used in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 67f7e71..4f87693 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -22,17 +22,11 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
-/* Migrates chunks from stream queues to new stream queues if needed,
- * but not across associations. Also, removes those chunks to streams
- * higher than the new max.
- */
-static void sctp_stream_outq_migrate(struct sctp_stream *stream,
-				     struct sctp_stream *new, __u16 outcnt)
+static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 {
 	struct sctp_association *asoc;
 	struct sctp_chunk *ch, *temp;
 	struct sctp_outq *outq;
-	int i;
 
 	asoc = container_of(stream, struct sctp_association, stream);
 	outq = &asoc->outqueue;
@@ -56,6 +50,19 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 
 		sctp_chunk_free(ch);
 	}
+}
+
+/* Migrates chunks from stream queues to new stream queues if needed,
+ * but not across associations. Also, removes those chunks to streams
+ * higher than the new max.
+ */
+static void sctp_stream_outq_migrate(struct sctp_stream *stream,
+				     struct sctp_stream *new, __u16 outcnt)
+{
+	int i;
+
+	if (stream->outcnt > outcnt)
+		sctp_stream_shrink_out(stream, outcnt);
 
 	if (new) {
 		/* Here we actually move the old ext stuff into the new
-- 
2.1.0


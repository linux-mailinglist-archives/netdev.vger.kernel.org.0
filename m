Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E593CE792
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349945AbhGSQ2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbhGSQ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:27:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C42CC07882B;
        Mon, 19 Jul 2021 09:31:54 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so408549wmc.2;
        Mon, 19 Jul 2021 09:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UBaAsG4vENEyOeo1xreKIy/33mSOL4sVGzODYq93NPQ=;
        b=vG9IOhA45CzA48A157sFYBUc71XFXOJX0HOgYNV09vyUPhRmJNIgJH/jdJfOZCWAPO
         AuBFxZRcBYjMIj/Cu4IJdltPFXro+SAKmM6ADpIkQ5N/JBJ9IxW8dHDUS0c/kUUBqTM1
         Vq/XhHnf0fn6NVZJl4HUQ+6WppRBdXG4c2LJBSexwVsK4Mxk1xQykltKFrDC6nEev2Sh
         k4cUevpz8WlNXuvtF5McUk1Oo+bUHzkY6J4TgIqOyDJdJ3iNtDsinCXlra5vVgc/Qt5l
         bAjiInsduW6JEBlo/0bwfd7k3LfHgjJfVk13hhebg6fD4OiHQNjQTPzAl3ti3hMujFJ/
         xPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UBaAsG4vENEyOeo1xreKIy/33mSOL4sVGzODYq93NPQ=;
        b=RPJN4TC3oJwvvTf7JxQ2wZRpIsbfsvf49o/1Thb+cV1lAw5W3qwrD6DKkJE9IsfZbA
         no0vBccDT/XfnwtFNhN4jNWUW/rFVmpJgz/ueS+8CiHK81C5jjVsY3nU9sCFwlNYfY8l
         TGxUf8KxqFhM+yi475YTvF9EPGd1ZUKyVDC1gME1UYrym+R5CT+kvEwldQLzHQS2dJC8
         ZZ9yWiy94zP73KzpDbNeS1BTW+kJK26t7F7uUOIU3Td92go1psE5GjVrKhodgzd2cBCa
         4RxxJe8YrkniB43Bp9oU85etI7QSwZytGo1dQfg3IhEVCFkG8yg8Ja7/mSDYGWfoy0OE
         UQXw==
X-Gm-Message-State: AOAM53100l3V7ocmJxMjRloobql71Fv+z6FnuE7+2lk37jxyZBdhMm/Z
        BYHObFOln0mde3F3Rp0aTqshkvjd2+lPRg==
X-Google-Smtp-Source: ABdhPJwgrKaiCNeqqUtjucCqd4u83xwmd7XD9dlWY/zzyD8bQEHH5axXa+/eEeiEw0XYintO+UJcLw==
X-Received: by 2002:a7b:c452:: with SMTP id l18mr32771860wmi.164.1626713609502;
        Mon, 19 Jul 2021 09:53:29 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d15sm21020260wri.39.2021.07.19.09.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 09:53:29 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        timo.voelker@fh-muenster.de
Subject: [PATCH net 2/2] sctp: send pmtu probe only if packet loss in Search Complete state
Date:   Mon, 19 Jul 2021 12:53:23 -0400
Message-Id: <b27420c3db63969d3faf00a2e866126dae3b870c.1626713549.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1626713549.git.lucien.xin@gmail.com>
References: <cover.1626713549.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to introduce last_rtx_chunks into sctp_transport to detect
if there's any packet retransmission/loss happened by checking against
asoc's rtx_data_chunks in sctp_transport_pl_send().

If there is, namely, transport->last_rtx_chunks != asoc->rtx_data_chunks,
the pmtu probe will be sent out. Otherwise, increment the pl.raise_count
and return when it's in Search Complete state.

With this patch, if in Search Complete state, which is a long period, it
doesn't need to keep probing the current pmtu unless there's data packet
loss. This will save quite some traffic.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 1 +
 net/sctp/transport.c       | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index f3d414ed208e..651bba654d77 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -984,6 +984,7 @@ struct sctp_transport {
 	} cacc;
 
 	struct {
+		__u32 last_rtx_chunks;
 		__u16 pmtu;
 		__u16 probe_size;
 		__u16 probe_high;
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 23e7bd3e3bd4..a3d3ca6dd63d 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -263,6 +263,7 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 	if (t->pl.probe_count < SCTP_MAX_PROBES)
 		goto out;
 
+	t->pl.last_rtx_chunks = t->asoc->rtx_data_chunks;
 	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
 		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
@@ -298,8 +299,10 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 
 out:
 	if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count < 30 &&
-	    !t->pl.probe_count)
+	    !t->pl.probe_count && t->pl.last_rtx_chunks == t->asoc->rtx_data_chunks) {
 		t->pl.raise_count++;
+		return false;
+	}
 
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
@@ -313,6 +316,7 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
 
+	t->pl.last_rtx_chunks = t->asoc->rtx_data_chunks;
 	t->pl.pmtu = t->pl.probe_size;
 	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
-- 
2.27.0


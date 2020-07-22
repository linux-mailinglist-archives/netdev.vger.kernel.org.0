Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1548229BD8
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732860AbgGVPwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGVPwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:52:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D0DC0619DC;
        Wed, 22 Jul 2020 08:52:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id md7so1603463pjb.1;
        Wed, 22 Jul 2020 08:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=m/cYP1eQph22ytwTJ/NPXtyFmzXiUNEDby7xn4T3haM=;
        b=HDRA28TZ8B6C+ViEANmpG5Q0l3Kz7/o5tcy955Sr/5HLZbHuJGvc67GxURLEMmselX
         waBHDf+Mo3bK+GoWqpkcp28RK9oOybNRlKyle95h6SXwv+Kgt10lU5StgRSmDZuaS4tO
         jYITCJk1Fbqiq2VIxo3LgJ20crFO7Ku9xmDx083IbeLjX8Rkhv34KozYeFm+6+P29CJB
         66ToNWFB7ut//lC0RCzmE2UE8aFhwPV0hn2AJKVmNywRzBmETcCG6TSBeEFCwFETVeOT
         BHXRTgfe4OBKBhy3yRpSSdE6thJdzM9TdtGKNbRFdi0CH6ku9qyVQiN8lCQ+gKFoZvtF
         WjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=m/cYP1eQph22ytwTJ/NPXtyFmzXiUNEDby7xn4T3haM=;
        b=c79EF8LZKo+PuuGc30hID78yPyPkddtJpSZj6N15LBhlDXl00gQgOPy5qSl76lwpgP
         8E0LkVfGes6MjR1C9f31Xak1kTvXB67BxaqpDIxeno8sOZ136XlSbK/PgQZwr+OSEwsc
         8i4HN6PWFyQJkx8GWj7Sp1NhkT0PocBpWp2iJkX0h6Cp9c5UPKdF4GSz+dTjrI+mI5Jo
         dPKXfRSIK4oS3I63aGhLJkeR41uqeGXgI/+2jjh28Hthb3Bu/FGzKG+F2jxP1Iff6xo+
         efU1Xx2AEEC1jKnPoTwQXLfD1PE9jAOTces8JbkcJ5EbrMT/ttLqNgvm9BgUef6pnbWY
         SNPQ==
X-Gm-Message-State: AOAM533KRtb1DcfgzPl4Jv6D2jnspzgFkphATqOj+n0+x618naUfT1P6
        rAPkQrNjeRA+kVr20ypdskF03Gp7
X-Google-Smtp-Source: ABdhPJwp14HUNRLo2ppsqUgB6ltqgrvBasryk8qhuhdMu7aPMnGFJPu4TqI/WK0+lvswF0ZsIpgr3Q==
X-Received: by 2002:a17:90a:7103:: with SMTP id h3mr99556pjk.34.1595433158741;
        Wed, 22 Jul 2020 08:52:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z62sm14290pfb.47.2020.07.22.08.52.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 08:52:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 2/2] sctp: shrink stream outq when fails to do addstream reconf
Date:   Wed, 22 Jul 2020 23:52:12 +0800
Message-Id: <b4172cd23a6369c12a483e58f14619640aaf24ae.1595433039.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ceb8b4f32a9235e0a846e4f8e0537fcb362edf04.1595433039.git.lucien.xin@gmail.com>
References: <cover.1595433039.git.lucien.xin@gmail.com>
 <ceb8b4f32a9235e0a846e4f8e0537fcb362edf04.1595433039.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1595433039.git.lucien.xin@gmail.com>
References: <cover.1595433039.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding a stream with stream reconf, the new stream firstly is in
CLOSED state but new out chunks can still be enqueued. Then once gets
the confirmation from the peer, the state will change to OPEN.

However, if the peer denies, it needs to roll back the stream. But when
doing that, it only sets the stream outcnt back, and the chunks already
in the new stream don't get purged. It caused these chunks can still be
dequeued in sctp_outq_dequeue_data().

As its stream is still in CLOSE, the chunk will be enqueued to the head
again by sctp_outq_head_data(). This chunk will never be sent out, and
the chunks after it can never be dequeued. The assoc will be 'hung' in
a dead loop of sending this chunk.

To fix it, this patch is to purge these chunks already in the new
stream by calling sctp_stream_shrink_out() when failing to do the
addstream reconf.

Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Reconf Response Parameter")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 4f87693..bda2536 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -1044,11 +1044,13 @@ struct sctp_chunk *sctp_process_strreset_resp(
 		nums = ntohs(addstrm->number_of_streams);
 		number = stream->outcnt - nums;
 
-		if (result == SCTP_STRRESET_PERFORMED)
+		if (result == SCTP_STRRESET_PERFORMED) {
 			for (i = number; i < stream->outcnt; i++)
 				SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
-		else
+		} else {
+			sctp_stream_shrink_out(stream, number);
 			stream->outcnt = number;
+		}
 
 		*evp = sctp_ulpevent_make_stream_change_event(asoc, flags,
 			0, nums, GFP_ATOMIC);
-- 
2.1.0


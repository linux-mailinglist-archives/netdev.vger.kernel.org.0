Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647D620795D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404372AbgFXQmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404068AbgFXQmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:42:08 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BE8C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e8so1927314qtq.22
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nDNaDo9WaAm7Xmda9j3RYXyD53H8zh12lLElsYlvR84=;
        b=F0pqX8sXoA33Y9H8FK9e9fkxHjwWBKgvgVwieuO8YkwmXTnHBMnwp9UgH4J1YjhCf8
         RxJQyfgzeALOLeYCTe9OshHLwfLUah/zN3cbF4bC2/Sl39vmNpGFnMbKbfLOKovxyo6o
         Yc1s+o6A3G8UokoJ+dQmyJ9tl9DbiUD9/kTRRaHh8PcZRWydxLzfD76hHAzYbLzsl4fX
         pUIDAV/FEHtq2OSQ/zMkO/wXOX6WGUiNDvPypjt698l2N7nupFelRv6RaQf7pVK/MZ6G
         sVQxCIfMlYs4JPYHzem+1bOCv6Yxnxq3Msj4/s31Pvu5JJX8985J9OPaAa0e8TgjlY1k
         iaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nDNaDo9WaAm7Xmda9j3RYXyD53H8zh12lLElsYlvR84=;
        b=gPogOMPhNtF9AOwbY63meoXDNmHvICMjQGRmYBaw4VEs7EJQ7MLE6+J+4/bXlNrMo9
         xIcRyUlJayZTYW9L/V3bMpsoLX2IH9tyngZusYlI53NOqhZyrbs7WaqtERXDhxskxbO0
         9Z893tPHNcx3hThVprIndQ1aggcpTUTx0Mh78VHrM/yHnar10/WTmB3TnyatbPiQxUvI
         hr8X51S59FqeKQyl/JxtxNQwHs/0w1i7MEy/nsOTuAcZecAURrjATh6JsUSPrdTEn1HU
         RgZ6MUJaSDsCLswEtcqArjYsu53e31tAu/4QqKFJvWtw+LYOGXl2S/v5QXPmw3DO+TNT
         Q2Ag==
X-Gm-Message-State: AOAM530CfaR7iG+OxrRuhFa5rtGGTZmNHdv8/SQfL++vhEDukAUfepgf
        QxUCN3Z0HvGS6W9vd4Gv7s6AbdzzHULRE/0=
X-Google-Smtp-Source: ABdhPJxATcQCIBto4C+MWJ/CfqmTLCjUuhftGDNsM6Uawdm4gi6YOaurftobDyY3o5eL1DHpIvQW0+76w2GyNHY=
X-Received: by 2002:a0c:85a3:: with SMTP id o32mr7146815qva.189.1593016927185;
 Wed, 24 Jun 2020 09:42:07 -0700 (PDT)
Date:   Wed, 24 Jun 2020 12:42:02 -0400
In-Reply-To: <20200624164203.183122-1-ncardwell@google.com>
Message-Id: <20200624164203.183122-2-ncardwell@google.com>
Mime-Version: 1.0
References: <20200624164203.183122-1-ncardwell@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net 1/2] tcp_cubic: fix spurious HYSTART_DELAY exit upon drop
 in min RTT
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mirja Kuehlewind reported a bug in Linux TCP CUBIC Hystart, where
Hystart HYSTART_DELAY mechanism can exit Slow Start spuriously on an
ACK when the minimum rtt of a connection goes down. From inspection it
is clear from the existing code that this could happen in an example
like the following:

o The first 8 RTT samples in a round trip are 150ms, resulting in a
  curr_rtt of 150ms and a delay_min of 150ms.

o The 9th RTT sample is 100ms. The curr_rtt does not change after the
  first 8 samples, so curr_rtt remains 150ms. But delay_min can be
  lowered at any time, so delay_min falls to 100ms. The code executes
  the HYSTART_DELAY comparison between curr_rtt of 150ms and delay_min
  of 100ms, and the curr_rtt is declared far enough above delay_min to
  force a (spurious) exit of Slow start.

The fix here is simple: allow every RTT sample in a round trip to
lower the curr_rtt.

Fixes: ae27e98a5152 ("[TCP] CUBIC v2.3")
Reported-by: Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_cubic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 8f8eefd3a3ce..c7bf5b26bf0c 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -432,10 +432,9 @@ static void hystart_update(struct sock *sk, u32 delay)
 
 	if (hystart_detect & HYSTART_DELAY) {
 		/* obtain the minimum delay of more than sampling packets */
+		if (ca->curr_rtt > delay)
+			ca->curr_rtt = delay;
 		if (ca->sample_cnt < HYSTART_MIN_SAMPLES) {
-			if (ca->curr_rtt > delay)
-				ca->curr_rtt = delay;
-
 			ca->sample_cnt++;
 		} else {
 			if (ca->curr_rtt > ca->delay_min +
-- 
2.27.0.111.gc72c7da667-goog


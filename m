Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFBF20795E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391218AbgFXQmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404068AbgFXQmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:42:10 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BECDC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:09 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id e8so1927356qtq.22
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oWcef13FMKTYdZ36D7f94zx5u7+RmoEi6q070EuSMhg=;
        b=cK1mUbH6e1+ghkhOQtxAZAb2OSeF0KHKai9pr4OsPFFbcyvm/c4t3EW25JTg+CfpIO
         6Bs8zbgFB6l6gLUN4k2bpwisXijf43DpryCq0uIEVenuXliwiti7SXBdDdMa3pVKQA1I
         vK0XUGx0BKw7nERQxwJ50W3RTZGC+JR09IT4elBlF1n/kErxPN2WY5eMF113pdIdDgat
         n/qwcouxoOONcFlW2kmdmC+Lt0iH8H84t+/tr/NgPrAoBTlOVadlmjfJZs1+5wpZpmJm
         n5d16hhU4QRsg/b7t7Dm2T1BZTJDZ51ANHQj77dFgs0lWl3rmkBK+ezID3fEPTYpF0fd
         A80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oWcef13FMKTYdZ36D7f94zx5u7+RmoEi6q070EuSMhg=;
        b=CqOrYYcnN61nd5rqzul0RQ95THohlhf/6JHfJPiA4mtkKFU7eSP/g27bWynLa6PYo6
         QrOgtIKYLpz5UXx95FqTzv6/aNuCcHn/8n/ldZOKoWmVv2AAQYljg8i+V8NH4/lu+53u
         QAk3k1zrhS2nZITMovQeLiGfzXOf9YxvJseIxpJ6uiZq6yZEv+MPnGK1IrwCwVbUjie3
         I9mtJhiOzZVOfgXXUccWvANXRqc+vOGneBCoWdijj2U1PWLvEyhi8QRDGHwJIrslOgL1
         Xyp1/uJ90bMptNtvcUHMZgrokusYtzzXrtA1byXRryVAZ8f+CvOxu3TUbW3//Xfpu9tr
         4I5Q==
X-Gm-Message-State: AOAM5315Ad9XDY2ru4mz87ScTQ/XsdWrChUOz2vLQCIh46G7Y6L7gA6p
        aDNTpqimHAvzpy3EVEvOtr1lVVTFQALOQZ4=
X-Google-Smtp-Source: ABdhPJzNhbhVaAKYThzFMWsFUbFNAbMuR8ZWvRNq56GFRTT3tQelgKoT0+2x1up67PfPQ5eX0o6jvDWnosaNs0U=
X-Received: by 2002:ad4:4526:: with SMTP id l6mr7844913qvu.16.1593016928637;
 Wed, 24 Jun 2020 09:42:08 -0700 (PDT)
Date:   Wed, 24 Jun 2020 12:42:03 -0400
In-Reply-To: <20200624164203.183122-1-ncardwell@google.com>
Message-Id: <20200624164203.183122-3-ncardwell@google.com>
Mime-Version: 1.0
References: <20200624164203.183122-1-ncardwell@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net 2/2] bpf: tcp: bpf_cubic: fix spurious HYSTART_DELAY exit
 upon drop in min RTT
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

Apply the fix from:
 "tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT"
to the BPF implementation of TCP CUBIC congestion control.

Repeating the commit description here for completeness:

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

Fixes: 6de4a9c430b5 ("bpf: tcp: Add bpf_cubic example")
Reported-by: Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_cubic.c b/tools/testing/selftests/bpf/progs/bpf_cubic.c
index 7897c8f4d363..ef574087f1e1 100644
--- a/tools/testing/selftests/bpf/progs/bpf_cubic.c
+++ b/tools/testing/selftests/bpf/progs/bpf_cubic.c
@@ -480,10 +480,9 @@ static __always_inline void hystart_update(struct sock *sk, __u32 delay)
 
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


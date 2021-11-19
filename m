Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F37457632
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbhKSSRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbhKSSRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 13:17:52 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79465C061574;
        Fri, 19 Nov 2021 10:14:50 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id x10so13860386ioj.9;
        Fri, 19 Nov 2021 10:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=renhUr+LiQY8+c1z3rh49SP/WDk5lGrKdDTYeC8KgPo=;
        b=XR2KXB4oSG0czTERIh04BI7G+/JELud4mwlyhXOcipIxCwVMcL6S5mUmqO7Q9iQMk8
         d0+u/AWosxwiWyUXAKHJJRbBJIk1x90+hPpR7LfdTN7EWKdQY46dqEwbtykF0137qRTh
         /JETBdXy65Rrxe1j2HpO02MsZya3snIM7LBwjSnXvGLLYZdzl1Fyt6SU/GznnqK/E5Is
         W/bFOWUBt0GitL1nyaXjQaBMCuPXce1m6bA9/lniWtVPjrCix8EhDLIWuANjw/wc5BAU
         hVapqE7z30/gshMpLrbil/kevp3RJ5bgXJclweCtkb6kXIKe+lhU/cbAoXudrvSfIvGo
         bOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=renhUr+LiQY8+c1z3rh49SP/WDk5lGrKdDTYeC8KgPo=;
        b=KJP49rVw2V8a4QCKHnpK9sEi4ql+6rQryZHyfC0MCUonH1beOBuprTqquMkStBlyma
         kYlzHeT2z/hRIFZPvyjr3TTXGk7UNoZg1G4erTCfPIQQOV2YdkHQI+UM92uzLkN2iycK
         VoWefOFgq5wm9k1UTNgyVAhH4fkvWQooJehGGyy0IusAl8d3GdT1PpB8ZHb8U/BFLsfg
         7/xiVI2CP8RPBUmedjzR3xyKFIKTZ5jnYVCZf5IebrhJ+wOX3pmosglluq7wEh66zjZO
         5Dj2U7S0xMqWAhop7jBNqMQPUrDKoV9uZviY/q57j9Q0krQwcsU1EW52kUoT2QdTUMG+
         1vPw==
X-Gm-Message-State: AOAM531L6ZuwQhUGSkywZwf+ykpXNxdecl/u6AR6TBRaB8D/FnYtvUYk
        4d9Pl4GWsF3Ogol8AUGUNQnmuoB6vdk=
X-Google-Smtp-Source: ABdhPJwVffZz/r0qP50CoDW6fvsBOgO7KEytSG9bBF0RBidgi5QJcZra/XrrheXqzxV06Ehei9nMFQ==
X-Received: by 2002:a05:6602:2c85:: with SMTP id i5mr6931512iow.89.1637345689913;
        Fri, 19 Nov 2021 10:14:49 -0800 (PST)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id d2sm374505ilg.77.2021.11.19.10.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 10:14:49 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 2/2] bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap
Date:   Fri, 19 Nov 2021 10:14:18 -0800
Message-Id: <20211119181418.353932-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211119181418.353932-1-john.fastabend@gmail.com>
References: <20211119181418.353932-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a sock is added to a sock map we evaluate what proto op hooks need
to be used. However, when the program is removed from the sock map
we have not been evaluating if that changes the required program layout.

Before the patch listed in the 'fixes' tag this was not causing failures
because the base program set handles all cases. Specifically, the case
with a stream parser and the case with out a stream parser are both
handled. With the fix below we identified a race when running with a
proto op that attempts to read skbs off both the stream parser and the
skb->receive_queue. Namely, that a race existed where when the stream
parser is empty checking the skb->reqceive_queue from recvmsg at the
precies moment when the parser is paused and the receive_queue is not
empty could result in skipping the stream parser. This may break a
RX policy depending on the parser to run.

The fix tag then loads a specific proto ops that resolved this race.
But, we missed removing that proto ops recv hook when the sock is
removed from the sockmap. The result is the stream parser is stopped
so no more skbs will be aggregated there, but the hook and BPF program
continues to be attached on the psock. User space will then get an
EBUSY when trying to read the socket because the recvmsg() handler
is now waiting on a stopped stream parser.

To fix we rerun the proto ops init() function which will look at the
new set of progs attached to the psock and rest the proto ops hook
to the correct handlers. And in the above case where we remove the
sock from the sock map the RX prog will no longer be listed so the
proto ops is removed.

Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c    | 5 +++++
 net/core/sock_map.c | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1ae52ac943f6..8eb671c827f9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1124,6 +1124,8 @@ void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 {
+	psock_set_prog(&psock->progs.stream_parser, NULL);
+
 	if (!psock->saved_data_ready)
 		return;
 
@@ -1212,6 +1214,9 @@ void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 {
+	psock_set_prog(&psock->progs.stream_verdict, NULL);
+	psock_set_prog(&psock->progs.skb_verdict, NULL);
+
 	if (!psock->saved_data_ready)
 		return;
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 9b528c644fb7..4ca4b11f4e5f 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -167,8 +167,11 @@ static void sock_map_del_link(struct sock *sk,
 		write_lock_bh(&sk->sk_callback_lock);
 		if (strp_stop)
 			sk_psock_stop_strp(sk, psock);
-		else
+		if (verdict_stop)
 			sk_psock_stop_verdict(sk, psock);
+
+		if (psock->psock_update_sk_prot)
+			psock->psock_update_sk_prot(sk, psock, false);
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
 }
-- 
2.33.0


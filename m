Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39101137BD1
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgAKGNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:13:37 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36066 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgAKGNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:13:37 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so4446899iog.3;
        Fri, 10 Jan 2020 22:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aWJKRDY8MhSXF1Y5+iELc/XyQ+wGJ0meS4Z9ad1oV9M=;
        b=vFyRz6U+rGU8ISXQDQVjwoEofji3TT+I/BRePEbhMMmourl6enq3raY2UWAZ0g41FF
         v6kdR4ky6wSl2epx2eCQ4r5e7IUxsJRHa5fXxVv1gM9iL3WYfyB7MqWbin1gACaPAX8+
         joNlQDl60SgMCDD19gfnWCf6NQmNq8tlZAI9jlBmiXkLjqgov1dDRvC+SbMOq5JBhoZ0
         6U/GpEVV1dBp+tkftWvzAtWZFtFQAmjpMhpVBopeP5O/xmtzD7T/iXMFkbEKmYPAZQ/I
         4yNXmR6mLu4FDM2j4mLHvVo5gK3w+KXO8yg5EJhD5btGJiGOe0HKuCfrSS9RmcYBajrM
         41OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aWJKRDY8MhSXF1Y5+iELc/XyQ+wGJ0meS4Z9ad1oV9M=;
        b=JWdKizMo4gRf5bsTCViQq4LR8UXqb+kUo2voSrfpNjUgu46dWp4mnqP2V4BzhANSfx
         7QkkTuXo8ja2znS547vj0T7+PCCqNYLozTMpgernUjff9VVMODXP1FFaQF8N4g5VF/P2
         ZxJHNi6M38RqKpcb+LaVRNtHwqp4/W4+bsJSvOmDqhSXNFfDGpGy5ObdZ0I217PrdirT
         OHQ4MUaqENebGltygJf4IBRjYeWSAMiibC9CYg1+v12fnV9B4vQVsAv1HJsavZFAFQuY
         b+a6JHZPyHvjKBYPXw4UXr3yxZXMbU0GUEvm9oAmo8ethmD1tT7odNNoM90lM55umHVJ
         qLlQ==
X-Gm-Message-State: APjAAAVw1Y9m5vMr3Qepuiusa2G9FKndNrKwNKzeVJMA3bWG0g+jn3/4
        ZtW2eGjXrH5euJOv9z9eutF6nt/d
X-Google-Smtp-Source: APXvYqzUw18RYIIqv8OG3R4jSuqIeeiVxMsBROc/KQyYmSYT+zcbuZwy/A8Iexcn74GPb9cktjeTVA==
X-Received: by 2002:a5e:8b03:: with SMTP id g3mr5495370iok.279.1578723216530;
        Fri, 10 Jan 2020 22:13:36 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:13:36 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 8/8] bpf: sockmap/tls, fix pop data with SK_DROP return code
Date:   Sat, 11 Jan 2020 06:12:06 +0000
Message-Id: <20200111061206.8028-9-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user returns SK_DROP we need to reset the number of copied bytes
to indicate to the user the bytes were dropped and not sent. If we
don't reset the copied arg sendmsg will return as if those bytes were
copied giving the user a positive return value.

This works as expected today except in the case where the user also
pops bytes. In the pop case the sg.size is reduced but we don't correctly
account for this when copied bytes is reset. The popped bytes are not
accounted for and we return a small positive value potentially confusing
the user.

The reason this happens is due to a typo where we do the wrong comparison
when accounting for pop bytes. In this fix notice the if/else is not
needed and that we have a similar problem if we push data except its not
visible to the user because if delta is larger the sg.size we return a
negative value so it appears as an error regardless.

Cc: stable@vger.kernel.org
Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 5 +----
 net/tls/tls_sw.c   | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e6b08b5a0895..8a01428f80c1 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -315,10 +315,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		 */
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
-		if (msg->sg.size < delta)
-			delta -= msg->sg.size;
-		else
-			delta = 0;
+		delta -= msg->sg.size;
 	}
 
 	if (msg->cork_bytes &&
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 21c7725d17ca..159d49dab403 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -809,10 +809,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	if (psock->eval == __SK_NONE) {
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
-		if (delta < msg->sg.size)
-			delta -= msg->sg.size;
-		else
-			delta = 0;
+		delta -= msg->sg.size;
 	}
 	if (msg->cork_bytes && msg->cork_bytes > msg->sg.size &&
 	    !enospc && !full_record) {
-- 
2.17.1


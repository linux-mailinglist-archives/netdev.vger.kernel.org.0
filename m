Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6970738D723
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhEVTPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhEVTPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:53 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FB6C0613ED;
        Sat, 22 May 2021 12:14:28 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 29so5864710pgu.11;
        Sat, 22 May 2021 12:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2SXBq0RQ1G77Xbs0xalfygk3bDY+dvdl+rT4iV6EI+0=;
        b=T83V5ESLM8NUisbiZnuKbKvdK/SGDei4HMI4n/CIqWYECkZk6w238Cnzr80SwYrf2J
         RbJEIKOWc8lOuOv3TYbalnMQH7JRWtYto3rTxjFzAo9e9eH/BnmFnGJvjEswBGPqBOYc
         uyp6HUnmqDli8Qj1AMthe6C9Heb5ugbO9LJxyK43CXwEhmmDk5TGBRMBhihuTRjVC9B0
         1ZZ9YECN6qtRlF7+q4TN+gCQEeEO1QmnvEcjSsJ4mJO+MzrmMY7g3hT85jgLv2s5Z1vw
         5Jd1vcuKgpgZsxeNvGDL258zbGba/Z9CA/kyhyIclK28b7p6EOLWrQ55B0PMY80qVAHV
         0erA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2SXBq0RQ1G77Xbs0xalfygk3bDY+dvdl+rT4iV6EI+0=;
        b=AFg/yYHC6UsVI484AZe1/8PODx0UK9HrhS05Hhpc3KCBGSjDpBLxdiAPGBaRzxYKni
         5IW9w/ZarBxnG2BOli/fSscMl7KsQhVbEy/wqTjC3c7MPl8vmbVY4EBFAaDyvNe2fDoH
         gLYgeAn0chYVkoQKi/xaGNDxHJhfYqmFnHZGl9RIx1w8jEf5sxZ4srZbJNHs/dDai8qi
         b+cIJXfyZZhr3Y1Lz9LUqNyBeZmND+ZLzjsUOLWELLZfPLX8ba6EK4x85EyJFBeZqZOz
         uyez3S6lcoWhLjs3C1/aDOG2LIW1gdBP4sRWxSAxhx0L/l5jIhgb9DdTwozb9UeXncoZ
         Fp+Q==
X-Gm-Message-State: AOAM531XT0x8CSrE3pfND7NYuclnZR1/SMJVCw51GTQcpg0tVV/jW86S
        QRoUdyl3IEnMASt00P1hjoMAxrr5ZcKAQA==
X-Google-Smtp-Source: ABdhPJzuYP5w2sWMMa3ZoM5sZp/MSGUKffcG20L7YSWdFeLIjERyJMXd4Sj2SZz77+l3yC8puS5LmA==
X-Received: by 2002:a05:6a00:170c:b029:2dc:dd8f:e083 with SMTP id h12-20020a056a00170cb02902dcdd8fe083mr16265036pfc.77.1621710868301;
        Sat, 22 May 2021 12:14:28 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 2/7] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
Date:   Sat, 22 May 2021 12:14:06 -0700
Message-Id: <20210522191411.21446-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We use non-blocking sockets for testing sockmap redirections,
and got some random EAGAIN errors from UDP tests.

There is no guarantee the packet would be immediately available
to receive as soon as it is sent out, even on the local host.
For UDP, this is especially true because it does not lock the
sock during BH (unlike the TCP path). This is probably why we
only saw this error in UDP cases.

No matter how hard we try to make the queue empty check accurate,
it is always possible for recvmsg() to beat ->sk_data_ready().
Therefore, we should just retry in case of EAGAIN.

Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 648d9ae898d2..01ab11259809 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1610,6 +1610,7 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	struct sockaddr_storage addr;
 	int c0, c1, p0, p1;
 	unsigned int pass;
+	int retries = 100;
 	socklen_t len;
 	int err, n;
 	u64 value;
@@ -1686,9 +1687,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
+again:
 	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0)
+	if (n < 0) {
+		if (errno == EAGAIN && retries--)
+			goto again;
 		FAIL_ERRNO("%s: read", log_prefix);
+	}
 	if (n == 0)
 		FAIL("%s: incomplete read", log_prefix);
 
-- 
2.25.1


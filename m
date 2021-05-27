Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4280E392424
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhE0BNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbhE0BNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087F6C061574;
        Wed, 26 May 2021 18:12:12 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f22so2423683pgb.9;
        Wed, 26 May 2021 18:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2SXBq0RQ1G77Xbs0xalfygk3bDY+dvdl+rT4iV6EI+0=;
        b=EuSyGTEGZVCnji5SZUYMTYHW6mQPtXZiYeTUeI60qy6hjaQS2/8WmKJdSXeRBfFvCX
         BjK1PLsN7gCa/ovLsc5sJgqyy3Cwwq2RXR/PuRJDidoeDYQERVaA0zKXbMyB+g/T4S7C
         dixjILnEO7imLCpuTmbLWIgZGD9XJlqAC6cjXdOMTlupGPVLAbJCdmTeQUQja7+w0uQE
         mVC28O3hEaAxCSEEkgIHimxEuGXnDwQIqVbve03IhHpkEmiFb/m1MVddgEpIwABeuT6W
         U/wL41nQHfa1ymAiSZfAj4wvOu9h1o5Ire7gjSbnZCdSV8BrdG3X56Y5bfxpBoXXyTQQ
         W1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2SXBq0RQ1G77Xbs0xalfygk3bDY+dvdl+rT4iV6EI+0=;
        b=d8gOiRZJVzsKVIeXZMcrwT6kRrMCTk2jFw7gmNIlqOR6GxP3ggiJJQKP5OhIhUFoAY
         UAhWnpu2zW0MF6fOP4dpsTJMRRIE+4KStx8rmtIcOwW2lYwpELtIr3tQnSWeO7WBmP4P
         rU/mCvSyU+okQG8gVk125eHTvct2nWgZEps/3RS1rqE5qw0qD0F70ygtPIRCskzL59fe
         nzCHOC4xJtZHbZVzg5S2QaFAz05Q/Nj1OKFEk2Jl/fMZCN/CPy78cQm8ydOdXUbv2sOr
         dOZkLqXY/RntVyTesvCaRJGVAJosJVVGBEIhH/+8p6VTDAju+We9DNJVuFefZSWTJs48
         ivmQ==
X-Gm-Message-State: AOAM533jfOHiqF08SHnGhd8goaGrc4yq0SBp3EPs4brFK8tjcsWZfApT
        ouJzgc+eGdSCTSnksJCk0NpzuIdhuxoYCg==
X-Google-Smtp-Source: ABdhPJzKrD3Rqhly9lRnDkqcZXaDjkCH4/nHGilG14qMp4nxD0pOy1L5+bm+Vmp5soTLYaHq4Teqlg==
X-Received: by 2002:a62:8013:0:b029:2de:93c6:1358 with SMTP id j19-20020a6280130000b02902de93c61358mr1203976pfd.55.1622077931474;
        Wed, 26 May 2021 18:12:11 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 2/8] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
Date:   Wed, 26 May 2021 18:11:49 -0700
Message-Id: <20210527011155.10097-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
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


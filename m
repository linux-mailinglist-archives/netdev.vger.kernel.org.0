Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0633A7418
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFOCif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhFOCie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:38:34 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB307C061574;
        Mon, 14 Jun 2021 19:36:29 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id z7so8986061vso.3;
        Mon, 14 Jun 2021 19:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2SXBq0RQ1G77Xbs0xalfygk3bDY+dvdl+rT4iV6EI+0=;
        b=bxVDKKcXNafEjM4mLf7H3nuwdyzdavUzpqZjeLaXS5m2kYa3bcwr7elPIXYY38MjDa
         lNddy/t5+cjgoFAd3x6EtatKTSaGmGDLoafCvakRSgGltJy1O1hvu2T64YhvjfpsR2FQ
         hFnUhmiVsJQG9NFP9AFLU7vGEbI02oBjhNECbkRKo9VQs03o04+xyhlbKG1/IIJjVMm9
         M95+7N0dPiNsi+H9DNKZtLjUJ+9UPdyyrmuPk88wtzSFEMjFO0l7d0UeHwgKSjCfg9gQ
         W8nvWo+6kGhiSlN+h6nUjEJNV2qKc6QZJqvg90D1eAvzPRJuQUcFtpnQDlZMo0IBqfbR
         /BVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2SXBq0RQ1G77Xbs0xalfygk3bDY+dvdl+rT4iV6EI+0=;
        b=tKmH5r+q9bE2RinbT8uoEcIbbDEI0OUzv8ExPRPkfMVMrVYDmichyxKRvHLuqeB6aR
         pNj+QlqiQEgNxM4+2DDuACfe4fhLuT9HRmQeZXC3oiK3JnYeXs8IaKP6qX8JzVSyOEG1
         oKtwU2BCc4Y5xTi4rV3oLN/D/lHnLangnjyyn7kDDZ6HmAnBapqJ/gpjdQEu61qtrZCB
         Q97H8UKO8RaVWjZhHYQY6VxyxYJs5PpyUoC8kEyCVSZk3k0FSuE7DAjZlM/1/Y8siy3/
         +fqj02e52QnmhtepVpJGrDbdWR1Bb9iriHpzBgECLFxpVeP0d4Xc5CPsVwXIm/OgPzKI
         Pf/Q==
X-Gm-Message-State: AOAM5335MkRwmFzI+bhrRGZJ0gjMPh7W1XGGc0QviZ4ImEjDxXJiZUcn
        X2JPSkc+fDfVzPDuk5PAaxCtBeEoz0lPeA==
X-Google-Smtp-Source: ABdhPJxDDTdlywr/kBTcgM2ePG32jKdGTzVkMGbYphir8fgFGZRXEUdtvc8rk8sQrv8/COrfFvZgSw==
X-Received: by 2002:a05:6214:20e3:: with SMTP id 3mr2458849qvk.53.1623723237701;
        Mon, 14 Jun 2021 19:13:57 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:13:57 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 2/8] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
Date:   Mon, 14 Jun 2021 19:13:36 -0700
Message-Id: <20210615021342.7416-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
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


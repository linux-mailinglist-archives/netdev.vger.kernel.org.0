Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658E3C3EC5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbfJARh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:37:59 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:47135 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731299AbfJARh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:37:58 -0400
Received: by mail-pg1-f201.google.com with SMTP id x8so11656419pgq.14
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 10:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wk/kSRiVr2+hsdRYwtEFf1vJ/Djbn8eKotL+Cap8me8=;
        b=R43ESF1qMXL4EzulkwPKBST9Dj9BWXUYzOA79YIBN3gl1tGYXc1vwhGctIq6E00cZs
         0/UjG2x1/oKDfi/3K/19NhvRkp+8lpVt4QD0EcW517r04E6T7md9G8OFfYeCb54cqRWW
         hFzCDuhmXbM62ySyLJzRaOr8xImhDdNMYqte9P8E99uDPTcvk6k5/o8SMaET/DQYIhiC
         XBqvzzqPoNyK4Qj5QBDw8DtSrRxTw1H6QgF/Iotstr3P/bwVSwEGLYWQC1svmAanmuSl
         Q08tr61T61IwMcGoYYyaD9N3u7i2s7GkmserM6YQ7yqFmj1awCGslVtUNUWbgxD3gDC2
         hRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wk/kSRiVr2+hsdRYwtEFf1vJ/Djbn8eKotL+Cap8me8=;
        b=r7X+TfGAUh7j6s6V2OZCa8cwGiuSBSWWp/cy2IFANErj+zmefNXGsPax56Og0uYpyU
         pf5qfonFpJ0N/T+fT8i4+n1JhPQnD7F9QqIktRwRTNAPM8R155L9yZdIVEQdaZD4oYsg
         V7EoDQVUaEwkz5376aer5AiVzGnpwtnvnKsVUKjh3qMjqY667sDllwClErLtW+A3wu0W
         o1JbrNn/F6VkyUFuo96y2e+EviCmk8Xc0z9ezHuFsA1/VabFaDZH+hM4n3sXDwweXBxM
         ZmG4hS5Ac3rVUvgKIpI5O6NziKNNN8H5KKqSUkOVgWwiH1A/LZImN9j4b6WfXo7l1iiO
         1s2Q==
X-Gm-Message-State: APjAAAV+6UlM3Sxpfci+ht73TALAQRLjWKt6EwS7v/KpAq49SFpO9Vox
        KPLBCFxy0scKQZU2huk+V7dNtUdAbjNb
X-Google-Smtp-Source: APXvYqypaHVZ+jWEwbZaptMaWnugEpNBCtzVp1uSABDkv7TEphW8RK4IYnhKiUDvh2qs9s1LSN74jWoUUaM1
X-Received: by 2002:a65:6252:: with SMTP id q18mr32002268pgv.111.1569951475681;
 Tue, 01 Oct 2019 10:37:55 -0700 (PDT)
Date:   Tue,  1 Oct 2019 10:37:28 -0700
In-Reply-To: <20191001173728.149786-1-brianvv@google.com>
Message-Id: <20191001173728.149786-3-brianvv@google.com>
Mime-Version: 1.0
References: <20191001173728.149786-1-brianvv@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH bpf 2/2] selftests/bpf: test_progs: don't leak server_fd in test_sockopt_inherit
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

server_fd needs to be close if pthread can't be created.

Fixes: e3e02e1d9c24 ("selftests/bpf: test_progs: convert test_sockopt_inherit")
Cc: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
index 6cbeea7b4bf16..8547ecbdc61ff 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
@@ -195,7 +195,7 @@ static void run_test(int cgroup_fd)
 
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
 				      (void *)&server_fd)))
-		goto close_bpf_object;
+		goto close_server_fd;
 
 	pthread_mutex_lock(&server_started_mtx);
 	pthread_cond_wait(&server_started, &server_started_mtx);
-- 
2.23.0.444.g18eeb5a265-goog


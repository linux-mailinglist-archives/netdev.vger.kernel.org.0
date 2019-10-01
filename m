Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E03C3EC0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfJARhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:37:52 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:57293 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbfJARhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:37:52 -0400
Received: by mail-pf1-f201.google.com with SMTP id b17so10537801pfo.23
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 10:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N9RFaaUyKsxWingVv0Hbs7K3osgkOr8SsFI9Tp5Z20k=;
        b=pkUaCWUsUNn5GOGIGsw9ewd3WuO5fY7ACvpKIOrqGyJIGOpRMoiSevDRoraYlU3g1E
         MRQok2xDgzcgI/rR/T5km2Yh4E9uF2eul+yE6YGP9ayIfhNL40yFgBmiJU0Vre7wkx/m
         J8bSPFKjN3JqL5FJ2V7Iqq7fL1qCfDYM6rXNgdNXU5/uekhj5e/DizKb7wzQtZhqvjgP
         +iRdatoeZwIjcN5DI5ClBFP7tc6oCcFI1Pws3TfQ3tBJEvM6iWD3qeWJCoMRUvSj2aqC
         Y1WKkR8aHva576d8/Yuys12+opTnZ4IJSPGffybI3W7ot7aQoZFS0AYOq1b73DtAPkVQ
         f+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N9RFaaUyKsxWingVv0Hbs7K3osgkOr8SsFI9Tp5Z20k=;
        b=GjpWHNa2J5tyJBvB8czEGeUTYYJak6r9wznuPBUBcb7UmEE3fWISyljL+6UIWDdwn/
         xTLtYMMfd6eEAgVCuMIwQiV5+XehcrHvAFIgP+LhitlggjGeAmNqNWB/5wpkDREWFlNp
         G1G9sYmZ8n/BUbcm6ovXWv2U0ht7J57agvX2sakQjwz3kYG2G4jVzH5dpfj9awVpc9DS
         D0aKQaJxtqOnkPwwL8PijdmKyI0oUtpKY3Ar1Fy6J4OqsTptQ5rYR5l8v9DDXTqdNEab
         GXJ8QQnH4PvS2Lxdur7WXORP22lCUzbH32Z+SNNIQMaYCZhjsadnWhCoZNSxKyUWTlGr
         RabA==
X-Gm-Message-State: APjAAAX0F21HHWtPSauNm2vQj7rHvyfJ4I8KTjGYFo35WP48gAUxW/nq
        YlTLm2HwZWGwu9o7s3drcvWBPbPgunlM
X-Google-Smtp-Source: APXvYqzVpPUbmcD+5G95ld1l74Kl0q1JKw4guiKi0Cn9su/VfVfZUXHpnnxGewNd71ggaNYtdoEFjanI20ey
X-Received: by 2002:a63:d30f:: with SMTP id b15mr30940913pgg.341.1569951470992;
 Tue, 01 Oct 2019 10:37:50 -0700 (PDT)
Date:   Tue,  1 Oct 2019 10:37:27 -0700
In-Reply-To: <20191001173728.149786-1-brianvv@google.com>
Message-Id: <20191001173728.149786-2-brianvv@google.com>
Mime-Version: 1.0
References: <20191001173728.149786-1-brianvv@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH bpf 1/2] selftests/bpf: test_progs: don't leak server_fd in tcp_rtt
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

server_fd needs to be closed if pthread can't be created.

Fixes: 8a03222f508b ("selftests/bpf: test_progs: fix client/server race
in tcp_rtt")
Cc: Stanislav Fomichev <sdf@google.com>

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index a82da555b1b02..f4cd60d6fba2e 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -260,13 +260,14 @@ void test_tcp_rtt(void)
 
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
 				      (void *)&server_fd)))
-		goto close_cgroup_fd;
+		goto close_server_fd;
 
 	pthread_mutex_lock(&server_started_mtx);
 	pthread_cond_wait(&server_started, &server_started_mtx);
 	pthread_mutex_unlock(&server_started_mtx);
 
 	CHECK_FAIL(run_test(cgroup_fd, server_fd));
+close_server_fd:
 	close(server_fd);
 close_cgroup_fd:
 	close(cgroup_fd);
-- 
2.23.0.444.g18eeb5a265-goog


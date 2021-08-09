Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9CB3E4D51
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbhHITsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbhHITsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:48:31 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2258EC06179C
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 12:48:11 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z3so17713094plg.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 12:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MtJ8xI/B+EIULIghvMhd6tf0lsFMRQDGP/UDMzZQQ5Q=;
        b=Ui/6FZ83W9KyEJwruJpq0UCLWdQzFreH54F3luj+g/igOs/cO5R17acqa6oWu4oKr/
         G1LFo8kMXvVdIuergqG/BvCDdETLwmjeTyPl/d3Jm00kVrVpRD5LLkzSPfJIXNkEMxbA
         furyVFwqBBZYvn01iV8BxXdBOueJBVySK08u3dt36ka8YvekYVuA4H91pqE0OB0AqrFQ
         PJhEnSy8MHWlHzhSdvZtnNk0zN6WIKkr1RGW6QpNDJYuIVgu9aG6D9x57KkyY4Hc6N+J
         7+kWKBs21z/bqVHME5JkqvT8r5R6V2X7gStOS38s/bUHpS1FOErDoIfwXRUdaTYB8nyT
         Up+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MtJ8xI/B+EIULIghvMhd6tf0lsFMRQDGP/UDMzZQQ5Q=;
        b=SO0s09KWcRgRZ/7Be2LK/v2aJOLlKwjowfS0LXvZJMXpq0SaaJ2tmJKfep44bJWrof
         LEf8tjL69lBdE2CmmgnIDGBKTo32P2tQDdLMHQLPKjs1SLQK6CXiq29tMlmKtNxafUg4
         IoIOYjLhKJxjfg8MsImEVE91snxjiSah+UTrPUuqZaf3CrocEHThu2F/u7ixjvEnaMg1
         uLk4L3mNtGUHFlZPJ9ofOXXkX9fiyWaWwEEi5ncQ5TWBfjxNC1Pps51qJDJGqw3sC8Nr
         nCzDFj/V9qe3gH5xDxCEjvOURG0NU95xxE6blTuaIZHQ/Ftd5cwpyAydgcj1WR2Qacvl
         0k5A==
X-Gm-Message-State: AOAM531vFjMAfGJfhegQSs89hzqJJZiYnGZIaRIGa9H/pkbeTVoJ/2O4
        65l6DovX5FmhCXMzqlmd6JtVjgtPdsZ5NQ==
X-Google-Smtp-Source: ABdhPJx6tQsZIJV0OltH8VEYk43qX0H8P/3TYhRw41TGcQcUsLl6JfFYteGTrlqDTe2l1GfJASvF5A==
X-Received: by 2002:a65:6787:: with SMTP id e7mr329251pgr.345.1628538490599;
        Mon, 09 Aug 2021 12:48:10 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id x19sm21372291pfa.104.2021.08.09.12.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:48:10 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v6 3/5] selftest/bpf: add tests for sockmap with unix stream type.
Date:   Mon,  9 Aug 2021 19:47:36 +0000
Message-Id: <20210809194742.1489985-4-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210809194742.1489985-1-jiang.wang@bytedance.com>
References: <20210809194742.1489985-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two tests for unix stream to unix stream redirection
in sockmap tests.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index a9f1bf9d5dff..7a976d43281a 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -2020,11 +2020,13 @@ void test_sockmap_listen(void)
 	run_tests(skel, skel->maps.sock_map, AF_INET);
 	run_tests(skel, skel->maps.sock_map, AF_INET6);
 	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
+	test_unix_redir(skel, skel->maps.sock_map, SOCK_STREAM);
 
 	skel->bss->test_sockmap = false;
 	run_tests(skel, skel->maps.sock_hash, AF_INET);
 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
+	test_unix_redir(skel, skel->maps.sock_hash, SOCK_STREAM);
 
 	test_sockmap_listen__destroy(skel);
 }
-- 
2.20.1


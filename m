Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83E146ED6
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgAWQ7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:59:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35864 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729801AbgAWQ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:59:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so3928447wru.3
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lzJSOoo0RY3SkOVg99jXaD0hCIShOjvh87S5WEoUKHA=;
        b=rmcV1F+uEgQl1C9Bw8jxZiHVIX5+T5T3sxYSgR7I6GG/JUWe0M8tWN2DUqqzWdoYgX
         N2B0KivXpJcrI72myxxmd5mlC6uuOjeJuGV48CFZb+1C4xJ7slk65KxrEZJDZHcr+vJB
         gTkFp0ARrz5plhGXPSwjmnDPxsDwOS9CKDuE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lzJSOoo0RY3SkOVg99jXaD0hCIShOjvh87S5WEoUKHA=;
        b=PMkiAbQP2dXc3Z/KuvmyA94e8WBvygq9lzJLWbMcb4tCGJJZp3tIA2YY5e4etkXRHl
         5d+9TdMVKW8Eido7GdM7bLLFl1QCMUqZE/MdRcjZ1abXWCkcsChFvIU645Mqe5BQRMCX
         8HYCZGswHNOI3hDF4qiy0BsJaRdpVGNGfqC9iFT7KVBKz7OJGT6T5oUABEmOcbLBkVGg
         Whzk3L+/jnqzUJdctSVh3YZ/DP75h5bvExWrdA8EhAc0iKArOcnJOKOaC+Dfh0dTa8rp
         Poh7uilrNlBiau/0Y0alFBEBMH1kFD7TB4uuyvA8ovbZL9g+TfX5KGHbND4Mcrh4/FPP
         2BfQ==
X-Gm-Message-State: APjAAAU0zvv4QyVw/D8jnH+pFK2mnTylb/HdpU0AveSyWqlbNA2dYVE+
        aGNngBL109xnswgtPbzzPzEZZg==
X-Google-Smtp-Source: APXvYqznD+zC0q/A4MhGzomvxakH4li9R6cnks1twXRbQNsnspUm7dxAarVtPVqc3Z3Kl1zIo2bzig==
X-Received: by 2002:adf:fc03:: with SMTP id i3mr18956626wrr.306.1579798787004;
        Thu, 23 Jan 2020 08:59:47 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:d0a9:6cca:1210:a574])
        by smtp.gmail.com with ESMTPSA id u1sm3217698wmc.5.2020.01.23.08.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 08:59:46 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf 4/4] selftests: bpf: reset global state between reuseport test runs
Date:   Thu, 23 Jan 2020 16:59:33 +0000
Message-Id: <20200123165934.9584-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123165934.9584-1-lmb@cloudflare.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is a lot of false positives if a single reuseport test
fails. This is because expected_results and the result map are not cleared.

Zero both after individual test runs, which fixes the mentioned false
positives.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/select_reuseport.c    | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 09a536af139a..0bab8b1ca1c3 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -699,7 +699,19 @@ static void setup_per_test(int type, sa_family_t family, bool inany,
 
 static void cleanup_per_test(bool no_inner_map)
 {
-	int i, err;
+	int i, err, zero = 0;
+
+	memset(expected_results, 0, sizeof(expected_results));
+
+	for (i = 0; i < NR_RESULTS; i++) {
+		err = bpf_map_update_elem(result_map, &i, &zero, BPF_ANY);
+		RET_IF(err, "reset elem in result_map",
+		       "i:%u err:%d errno:%d\n", i, err, errno);
+	}
+
+	err = bpf_map_update_elem(linum_map, &zero, &zero, BPF_ANY);
+	RET_IF(err, "reset line number in linum_map", "err:%d errno:%d\n",
+	       err, errno);
 
 	for (i = 0; i < REUSEPORT_ARRAY_SIZE; i++)
 		close(sk_fds[i]);
-- 
2.20.1


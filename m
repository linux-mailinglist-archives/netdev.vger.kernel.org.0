Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13F3442B3C
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhKBKC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 06:02:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14697 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhKBKCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 06:02:55 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hk51y5qHqzZcTn;
        Tue,  2 Nov 2021 17:58:14 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 18:00:18 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 2 Nov
 2021 18:00:17 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v3 1/2] bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
Date:   Tue, 2 Nov 2021 18:15:35 +0800
Message-ID: <20211102101536.2958763-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211102101536.2958763-1-houtao1@huawei.com>
References: <20211102101536.2958763-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
as shown below:

[   52.095704] BPF:The function test_3 has 12 arguments. Too many.
[   52.095704]
[   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops

Now all bpf_log() are ended by newline, but not all btf_verifier_log()
are ended by newline, so checking whether or not the log message
has the trailing newline and adding a newline if not.

Also there is no need to calculate the left userspace buffer size
for kernel log output and to truncate the output by '\0' which
has already been done by vscnprintf(), so only do these for
userspace log output.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 kernel/bpf/verifier.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a4b48bd4e3ca..77beaa46329a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -299,13 +299,15 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
 	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
 		  "verifier log line truncated - local buffer too short\n");
 
-	n = min(log->len_total - log->len_used - 1, n);
-	log->kbuf[n] = '\0';
-
 	if (log->level == BPF_LOG_KERNEL) {
-		pr_err("BPF:%s\n", log->kbuf);
+		bool newline = n > 0 && log->kbuf[n - 1] == '\n';
+
+		pr_err("BPF: %s%s", log->kbuf, newline ? "" : "\n");
 		return;
 	}
+
+	n = min(log->len_total - log->len_used - 1, n);
+	log->kbuf[n] = '\0';
 	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
 		log->len_used += n;
 	else
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626BA4647D4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347212AbhLAHXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:23:04 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16330 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347208AbhLAHXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:23:03 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3r7165kqz91V7;
        Wed,  1 Dec 2021 15:19:09 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 1 Dec
 2021 15:19:42 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v4 1/2] bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
Date:   Wed, 1 Dec 2021 15:34:57 +0800
Message-ID: <20211201073458.2731595-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211201073458.2731595-1-houtao1@huawei.com>
References: <20211201073458.2731595-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6cfd628ae3e4..722aea00d44e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -293,13 +293,15 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
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


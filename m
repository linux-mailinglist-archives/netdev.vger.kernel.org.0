Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029E543FD6F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhJ2Nkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:40:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30880 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhJ2Nke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 09:40:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hgk026415zbnV7;
        Fri, 29 Oct 2021 21:33:22 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 21:38:03 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 29 Oct
 2021 21:38:02 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 1/2] bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
Date:   Fri, 29 Oct 2021 21:53:20 +0800
Message-ID: <20211029135321.94065-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211029135321.94065-1-houtao1@huawei.com>
References: <20211029135321.94065-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
index 3c8aa7df1773..22f0d2292c2c 100644
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
+		pr_err("BPF:%s%s", log->kbuf, newline ? "" : "\n");
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CA643B320
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhJZNZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:25:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14865 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhJZNZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 09:25:30 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HdsvQ5xF7z90RM;
        Tue, 26 Oct 2021 21:22:58 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 21:23:01 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 26 Oct
 2021 21:23:00 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next] bpf: bpf_log() clean-up for kernel log output
Date:   Tue, 26 Oct 2021 21:38:19 +0800
Message-ID: <20211026133819.4138245-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
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

Now all bpf_log() are ended by newline, so just remove the extra newline.

Also there is no need to calculate the left userspace buffer size
for kernel log output and to truncate the output by '\0' which
has already been done by vscnprintf(), so only do these for
userspace log output.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 kernel/bpf/verifier.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c6616e325803..7d4a313da86e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -299,13 +299,13 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
 	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
 		  "verifier log line truncated - local buffer too short\n");
 
-	n = min(log->len_total - log->len_used - 1, n);
-	log->kbuf[n] = '\0';
-
 	if (log->level == BPF_LOG_KERNEL) {
-		pr_err("BPF:%s\n", log->kbuf);
+		pr_err("BPF:%s", log->kbuf);
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


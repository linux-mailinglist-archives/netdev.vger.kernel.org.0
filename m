Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9931467163
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 06:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhLCFSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 00:18:10 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27338 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhLCFSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 00:18:10 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J51GM6m5GzbjLJ;
        Fri,  3 Dec 2021 13:14:35 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 3 Dec
 2021 13:14:44 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v5] bpf: disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
Date:   Fri, 3 Dec 2021 13:30:01 +0800
Message-ID: <20211203053001.740945-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
to set log level as BPF_LOG_KERNEL. The same checking has already
been done in bpf_check(), so factor out a helper to check the
validity of log attributes and use it in both places.

Fixes: 8580ac9404f6 ("bpf: Process in-kernel BTF")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
v5:
  * rebased on bpf-next
  * patch #1 "bpf: Clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level"
    has been merged, so drop it
  * doesn't pass max_total to bpf_verifier_log_attr_valid() because
    now the max log buffer size of btf and verifier are the same.

v4: https://www.spinics.net/lists/bpf/msg50807.html
  * rebased on bpf-next
  * add Acked-by tags

v3: https://www.spinics.net/lists/bpf/msg48992.html
  * rebased on bpf-next
  * address comments from Daniel Borkmann:
    patch #1: add prefix "BPF: " instead of "BPF:" for error message
    patch #2: remove uncessary parenthesis, keep the max buffer length
              setting of btf verifier, and add Fixes tag.

v2: https://www.spinics.net/lists/bpf/msg48809.html
  * rebased on bpf-next
  * patch #1: add a trailing newline if needed (suggested by Martin)
  * add patch #2

v1: https://www.spinics.net/lists/bpf/msg48550.html
---
 include/linux/bpf_verifier.h | 7 +++++++
 kernel/bpf/btf.c             | 3 +--
 kernel/bpf/verifier.c        | 6 +++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c8a78e830fca..182b16a91084 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -396,6 +396,13 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 		 log->level == BPF_LOG_KERNEL);
 }
 
+static inline bool
+bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
+{
+	return log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
+	       log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK);
+}
+
 #define BPF_MAX_SUBPROGS 256
 
 struct bpf_subprog_info {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ed4258cb0832..d442dc07a8a1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4473,8 +4473,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
-		    !log->level || !log->ubuf) {
+		if (!bpf_verifier_log_attr_valid(log)) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6522ffdea487..1126b75fe650 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14050,11 +14050,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 		log->ubuf = (char __user *) (unsigned long) attr->log_buf;
 		log->len_total = attr->log_size;
 
-		ret = -EINVAL;
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
-		    !log->level || !log->ubuf || log->level & ~BPF_LOG_MASK)
+		if (!bpf_verifier_log_attr_valid(log)) {
+			ret = -EINVAL;
 			goto err_unlock;
+		}
 	}
 
 	if (IS_ERR(btf_vmlinux)) {
-- 
2.29.2


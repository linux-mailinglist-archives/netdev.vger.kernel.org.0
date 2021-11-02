Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A815442B3E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhKBKC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 06:02:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:27096 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhKBKC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 06:02:57 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hk5202dJZz1DJ6Q;
        Tue,  2 Nov 2021 17:58:16 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 18:00:18 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 2 Nov
 2021 18:00:18 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v3 2/2] bpf: disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
Date:   Tue, 2 Nov 2021 18:15:36 +0800
Message-ID: <20211102101536.2958763-3-houtao1@huawei.com>
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

BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
to set log level as BPF_LOG_KERNEL. The same checking has already
been done in bpf_check(), so factor out a helper to check the
validity of log attributes and use it in both places.

Fixes: 8580ac9404f6 ("bpf: Process in-kernel BTF")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf_verifier.h | 7 +++++++
 kernel/bpf/btf.c             | 3 +--
 kernel/bpf/verifier.c        | 6 +++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c8a78e830fca..a3d17601a5a7 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -396,6 +396,13 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 		 log->level == BPF_LOG_KERNEL);
 }
 
+static inline bool
+bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log, u32 max_total)
+{
+	return log->len_total >= 128 && log->len_total <= max_total &&
+	       log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK);
+}
+
 #define BPF_MAX_SUBPROGS 256
 
 struct bpf_subprog_info {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dbc3ad07e21b..657c6b48c616 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4460,8 +4460,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
-		    !log->level || !log->ubuf) {
+		if (!bpf_verifier_log_attr_valid(log, UINT_MAX >> 8)) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 77beaa46329a..19a52ff384ec 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13935,11 +13935,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 		log->ubuf = (char __user *) (unsigned long) attr->log_buf;
 		log->len_total = attr->log_size;
 
-		ret = -EINVAL;
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
-		    !log->level || !log->ubuf || log->level & ~BPF_LOG_MASK)
+		if (!bpf_verifier_log_attr_valid(log, UINT_MAX >> 2)) {
+			ret = -EINVAL;
 			goto err_unlock;
+		}
 	}
 
 	if (IS_ERR(btf_vmlinux)) {
-- 
2.29.2


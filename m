Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7217643FD71
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJ2Nkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:40:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25325 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJ2Nkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 09:40:37 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hgk0313G1zbhK0;
        Fri, 29 Oct 2021 21:33:23 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 21:38:03 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 29 Oct
 2021 21:38:03 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 2/2] bpf: disallow BPF_LOG_KERNEL log level for sys(BPF_BTF_LOAD)
Date:   Fri, 29 Oct 2021 21:53:21 +0800
Message-ID: <20211029135321.94065-3-houtao1@huawei.com>
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

BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
to set log level as BPF_LOG_KERNEL. The same checking has already
been done in bpf_check(), so factor out a helper to check the
validity of log attributes and use it in both places.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf_verifier.h | 6 ++++++
 kernel/bpf/btf.c             | 3 +--
 kernel/bpf/verifier.c        | 6 +++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c8a78e830fca..b36a0da8d5cf 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -396,6 +396,12 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 		 log->level == BPF_LOG_KERNEL);
 }
 
+static inline bool bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
+{
+	return (log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
+		log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK));
+}
+
 #define BPF_MAX_SUBPROGS 256
 
 struct bpf_subprog_info {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dbc3ad07e21b..ea8874eaedac 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4460,8 +4460,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
-		    !log->level || !log->ubuf) {
+		if (!bpf_verifier_log_attr_valid(log)) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 22f0d2292c2c..47ad91cea7e9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13935,11 +13935,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
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


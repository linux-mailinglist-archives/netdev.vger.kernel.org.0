Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0963BE19F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 05:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhGGDzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 23:55:31 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:10322 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhGGDzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 23:55:31 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GKQPm6cHZz76m8;
        Wed,  7 Jul 2021 11:48:28 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 7 Jul 2021 11:52:49 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [bpf-next 1/3] bpf: Move bpf_prog_clone_free into filter.h file
Date:   Wed, 7 Jul 2021 04:38:09 +0000
Message-ID: <20210707043811.5349-2-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707043811.5349-1-hefengqing@huawei.com>
References: <20210707043811.5349-1-hefengqing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bpf_prog_clone_free function into filter.h, so we can use
it in other file.

Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 include/linux/filter.h | 15 +++++++++++++++
 kernel/bpf/core.c      | 20 +-------------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 472f97074da0..f39e008a377d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -884,6 +884,21 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 				  gfp_t gfp_extra_flags);
 void __bpf_prog_free(struct bpf_prog *fp);
 
+static inline void bpf_prog_clone_free(struct bpf_prog *fp)
+{
+	/* aux was stolen by the other clone, so we cannot free
+	 * it from this path! It will be freed eventually by the
+	 * other program on release.
+	 *
+	 * At this point, we don't need a deferred release since
+	 * clone is guaranteed to not be locked.
+	 */
+	fp->aux = NULL;
+	fp->stats = NULL;
+	fp->active = NULL;
+	__bpf_prog_free(fp);
+}
+
 static inline void bpf_prog_unlock_free(struct bpf_prog *fp)
 {
 	__bpf_prog_free(fp);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 034ad93a1ad7..49b0311f48c1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -238,10 +238,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 		/* We keep fp->aux from fp_old around in the new
 		 * reallocated structure.
 		 */
-		fp_old->aux = NULL;
-		fp_old->stats = NULL;
-		fp_old->active = NULL;
-		__bpf_prog_free(fp_old);
+		bpf_prog_clone_free(fp_old);
 	}
 
 	return fp;
@@ -1102,21 +1099,6 @@ static struct bpf_prog *bpf_prog_clone_create(struct bpf_prog *fp_other,
 	return fp;
 }
 
-static void bpf_prog_clone_free(struct bpf_prog *fp)
-{
-	/* aux was stolen by the other clone, so we cannot free
-	 * it from this path! It will be freed eventually by the
-	 * other program on release.
-	 *
-	 * At this point, we don't need a deferred release since
-	 * clone is guaranteed to not be locked.
-	 */
-	fp->aux = NULL;
-	fp->stats = NULL;
-	fp->active = NULL;
-	__bpf_prog_free(fp);
-}
-
 void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 {
 	/* We have to repoint aux->prog to self, as we don't
-- 
2.25.1


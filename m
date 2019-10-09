Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01013D13A2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfJIQJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:09:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41921 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731226AbfJIQJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:09:16 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIEWX-00034Q-Hp; Wed, 09 Oct 2019 16:09:13 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 2/3] bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
Date:   Wed,  9 Oct 2019 18:09:06 +0200
Message-Id: <20191009160907.10981-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009160907.10981-1-christian.brauner@ubuntu.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
This helper is intended for all codepaths that copy structs from
userspace that are versioned by size. bpf_prog_get_info_by_fd() does
exactly what copy_struct_from_user() is doing.
Note that copy_struct_from_user() is calling min() already. So
technically, the min_t() call could go. But the info_len is used further
below so leave it.

[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/bpf/syscall.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 78790778f101..6f4f9097b1fe 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2312,13 +2312,10 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	u32 ulen;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
+	info_len = min_t(u32, sizeof(info), info_len);
+	err = copy_struct_from_user(&info, sizeof(info), uinfo, info_len);
 	if (err)
 		return err;
-	info_len = min_t(u32, sizeof(info), info_len);
-
-	if (copy_from_user(&info, uinfo, info_len))
-		return -EFAULT;
 
 	info.type = prog->type;
 	info.id = prog->aux->id;
-- 
2.23.0


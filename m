Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297FBD13A0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731742AbfJIQJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:09:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41923 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731452AbfJIQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:09:17 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIEWX-00034Q-5J; Wed, 09 Oct 2019 16:09:13 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 1/3] bpf: use check_zeroed_user() in bpf_check_uarg_tail_zero()
Date:   Wed,  9 Oct 2019 18:09:05 +0200
Message-Id: <20191009160907.10981-2-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009160907.10981-1-christian.brauner@ubuntu.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In v5.4-rc2 we added a new helper (cf. [1]) check_zeroed_user() which
does what bpf_check_uarg_tail_zero() is doing generically. We're slowly
switching such codepaths over to use check_zeroed_user() instead of
using their own hand-rolled version.

[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/bpf/syscall.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4e38ad..78790778f101 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -63,30 +63,22 @@ int bpf_check_uarg_tail_zero(void __user *uaddr,
 			     size_t expected_size,
 			     size_t actual_size)
 {
-	unsigned char __user *addr;
-	unsigned char __user *end;
-	unsigned char val;
+	size_t size = min(expected_size, actual_size);
+	size_t rest = max(expected_size, actual_size) - size;
 	int err;
 
 	if (unlikely(actual_size > PAGE_SIZE))	/* silly large */
 		return -E2BIG;
 
-	if (unlikely(!access_ok(uaddr, actual_size)))
-		return -EFAULT;
-
 	if (actual_size <= expected_size)
 		return 0;
 
-	addr = uaddr + expected_size;
-	end  = uaddr + actual_size;
+	err = check_zeroed_user(uaddr + expected_size, rest);
+	if (err < 0)
+		return err;
 
-	for (; addr < end; addr++) {
-		err = get_user(val, addr);
-		if (err)
-			return err;
-		if (val)
-			return -E2BIG;
-	}
+	if (err)
+		return -E2BIG;
 
 	return 0;
 }
-- 
2.23.0


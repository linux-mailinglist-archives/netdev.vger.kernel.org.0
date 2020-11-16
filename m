Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C062B4090
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgKPKNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:13:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7503 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgKPKNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:13:43 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CZPzZ0cxtzhXjy;
        Mon, 16 Nov 2020 18:13:30 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Nov 2020
 18:13:36 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andrii@kernel.org>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <sdf@google.com>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf] selftests/bpf: fix error return code in run_getsockopt_test()
Date:   Mon, 16 Nov 2020 18:16:33 +0800
Message-ID: <20201116101633.64627-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 65b4414a05eb ("selftests/bpf: add sockopt test that exercises BPF_F_ALLOW_MULTI")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_multi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c b/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
index 29188d6f5c8d..51fac975b316 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
@@ -138,7 +138,8 @@ static int run_getsockopt_test(struct bpf_object *obj, int cg_parent,
 	 */
 
 	buf = 0x40;
-	if (setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1) < 0) {
+	err = setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1);
+	if (err < 0) {
 		log_err("Failed to call setsockopt(IP_TOS)");
 		goto detach;
 	}
-- 
2.17.1


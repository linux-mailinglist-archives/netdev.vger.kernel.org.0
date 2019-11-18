Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59A1100476
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKRLlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:41:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54925 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfKRLlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:41:06 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iWfOt-0007Ef-P5; Mon, 18 Nov 2019 11:40:59 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bpf: fix memory leak on object 'data'
Date:   Mon, 18 Nov 2019 11:40:59 +0000
Message-Id: <20191118114059.37287-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return path on when bpf_fentry_test* tests fail does not
kfree 'data'. Fix this by adding the missing kfree.

Addresses-Coverity: ("Resource leak")
Fixes: faeb2dce084a ("bpf: Add kernel test functions for fentry testing")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/bpf/test_run.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 62933279fbba..915c2d6f7fb9 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -161,8 +161,10 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 	    bpf_fentry_test3(4, 5, 6) != 15 ||
 	    bpf_fentry_test4((void *)7, 8, 9, 10) != 34 ||
 	    bpf_fentry_test5(11, (void *)12, 13, 14, 15) != 65 ||
-	    bpf_fentry_test6(16, (void *)17, 18, 19, (void *)20, 21) != 111)
+	    bpf_fentry_test6(16, (void *)17, 18, 19, (void *)20, 21) != 111) {
+		kfree(data);
 		return ERR_PTR(-EFAULT);
+	}
 	return data;
 }
 
-- 
2.24.0


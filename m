Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E9A62121A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiKHNQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiKHNQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:16:01 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B60E218A;
        Tue,  8 Nov 2022 05:15:59 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N67rd2JQBz15MRb;
        Tue,  8 Nov 2022 21:15:45 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 21:15:55 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 21:15:54 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <mykolal@fb.com>,
        <shuah@kernel.org>, <tariqt@nvidia.com>, <maximmi@nvidia.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH bpf] selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch
Date:   Tue, 8 Nov 2022 21:12:42 +0800
Message-ID: <20221108131242.17362-1-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_synproxy fails to be compiled in the 32-bit arch, log is as follows:

  xdp_synproxy.c: In function 'parse_options':
  xdp_synproxy.c:175:36: error: left shift count >= width of type [-Werror=shift-count-overflow]
    175 |                 *tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
        |                                    ^~
  xdp_synproxy.c: In function 'syncookie_open_bpf_maps':
  xdp_synproxy.c:289:28: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
    289 |                 .map_ids = (__u64)map_ids,
        |                            ^

Fix it.

Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/testing/selftests/bpf/xdp_synproxy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c b/tools/testing/selftests/bpf/xdp_synproxy.c
index ff35320d2be9..45fef01a87a8 100644
--- a/tools/testing/selftests/bpf/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/xdp_synproxy.c
@@ -172,7 +172,7 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 	if (tcpipopts_mask == 0xf) {
 		if (mss4 == 0 || mss6 == 0 || wscale == 0 || ttl == 0)
 			usage(argv[0]);
-		*tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
+		*tcpipopts = ((unsigned long long)mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
 	} else if (tcpipopts_mask != 0) {
 		usage(argv[0]);
 	}
@@ -286,7 +286,7 @@ static int syncookie_open_bpf_maps(__u32 prog_id, int *values_map_fd, int *ports
 
 	prog_info = (struct bpf_prog_info) {
 		.nr_map_ids = 8,
-		.map_ids = (__u64)map_ids,
+		.map_ids = (__u64)(unsigned long)map_ids,
 	};
 	info_len = sizeof(prog_info);
 
-- 
2.30.GIT


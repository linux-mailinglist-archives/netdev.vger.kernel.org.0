Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0151A5F9FDE
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJJOIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJJOIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:08:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685DD6EF0C;
        Mon, 10 Oct 2022 07:08:12 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MmLGl366vz9t5X;
        Mon, 10 Oct 2022 22:03:11 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 10 Oct
 2022 22:08:08 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH bpf v3 5/6] selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
Date:   Mon, 10 Oct 2022 10:25:52 -0400
Message-ID: <20221010142553.776550-6-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221010142553.776550-1-xukuohai@huawei.com>
References: <20221010142553.776550-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_xdp_adjust_tail_grow failed with ipv6:
  test_xdp_adjust_tail_grow:FAIL:ipv6 unexpected error: -28 (errno 28)

The reason is that this test case tests ipv4 before ipv6, and when ipv4
test finished, topts.data_size_out was set to 54, which is smaller than the
ipv6 output data size 114, so ipv6 test fails with NOSPC error.

Fix it by reset topts.data_size_out to sizeof(buf) before testing ipv6.

Fixes: 04fcb5f9a104 ("selftests/bpf: Migrate from bpf_prog_test_run")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 9b9cf8458adf..009ee37607df 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -63,6 +63,7 @@ static void test_xdp_adjust_tail_grow(void)
 	expect_sz = sizeof(pkt_v6) + 40; /* Test grow with 40 bytes */
 	topts.data_in = &pkt_v6;
 	topts.data_size_in = sizeof(pkt_v6);
+	topts.data_size_out = sizeof(buf);
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
 	ASSERT_OK(err, "ipv6");
 	ASSERT_EQ(topts.retval, XDP_TX, "ipv6 retval");
-- 
2.30.2


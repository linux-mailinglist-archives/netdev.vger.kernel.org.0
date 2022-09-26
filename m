Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A365EA02A
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 12:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiIZKfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 06:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbiIZKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 06:33:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6741250181;
        Mon, 26 Sep 2022 03:20:51 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MbdvY2sgWzlXW0;
        Mon, 26 Sep 2022 18:16:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 26 Sep
 2022 18:20:38 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <martin.lau@linux.dev>, <daniel@iogearbox.net>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: act_bpf: simplify code logic in tcf_bpf_init()
Date:   Mon, 26 Sep 2022 18:21:58 +0800
Message-ID: <20220926102158.78658-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both is_bpf and is_ebpf are boolean types, so
(!is_bpf && !is_ebpf) || (is_bpf && is_ebpf) can be reduced to
is_bpf == is_ebpf in tcf_bpf_init().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index c5dbb68e6b78..b79eee44e24e 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -333,7 +333,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	is_bpf = tb[TCA_ACT_BPF_OPS_LEN] && tb[TCA_ACT_BPF_OPS];
 	is_ebpf = tb[TCA_ACT_BPF_FD];
 
-	if ((!is_bpf && !is_ebpf) || (is_bpf && is_ebpf)) {
+	if (is_bpf == is_ebpf) {
 		ret = -EINVAL;
 		goto put_chain;
 	}
-- 
2.17.1


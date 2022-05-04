Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326FC519629
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 05:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344418AbiEDDyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 23:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiEDDye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 23:54:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2997417AA0;
        Tue,  3 May 2022 20:51:00 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KtN8b36y9zGpQg;
        Wed,  4 May 2022 11:48:15 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 11:50:56 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <petrm@nvidia.com>, <memxor@gmail.com>, <arnd@arndb.de>,
        <weiyongjun1@huawei.com>, <shaozhengchao@huawei.com>,
        <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf/xdp: Can't detach BPF XDP prog if not exist
Date:   Wed, 4 May 2022 11:52:07 +0800
Message-ID: <20220504035207.98221-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if user sets nonexistent xdp_flags to detach xdp prog, kernel should
return err and tell user that detach failed with detail info.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/core/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8ed0272bf32f..8ed05ef62c68 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9149,6 +9149,12 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 		return -EBUSY;
 	}
 
+	/* no BPF XDP prog attached */
+	if (!new_prog && !(dev->xdp_state[mode].prog)) {
+		NL_SET_ERR_MSG(extack, "no BPF XDP prog attached");
+		return -ENOENT;
+	}
+
 	/* don't allow if an upper device already has a program */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter) {
 		if (dev_xdp_prog_count(upper) > 0) {
-- 
2.17.1


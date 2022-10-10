Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31CE5F0B20
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiI3L4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiI3Lz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:55:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C160128705;
        Fri, 30 Sep 2022 04:55:57 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mf7s53l0zzpTgj;
        Fri, 30 Sep 2022 19:52:57 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 19:55:55 +0800
Received: from huawei.com (10.67.174.245) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 19:55:55 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>
CC:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH -next 2/2] net/rds: Remove unused variable 'total_payload_len'
Date:   Mon, 10 Oct 2022 11:09:04 +0800
Message-ID: <20221010030904.2883557-3-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221010030904.2883557-1-chenzhongjin@huawei.com>
References: <20221010030904.2883557-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_DATE_IN_FUTURE_96_Q autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported by Clang [-Wunused-but-set-variable]

'commit f9fb69adb6c7 ("RDS: make message size limit compliant with spec")'
This commit introduced the variable 'total_copied'. However this variable
is never used by other code except iterates itself, so remove it.

Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/rds/send.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 0c5504068e3c..5e57a1581dc6 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1114,7 +1114,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	struct rds_conn_path *cpath;
 	struct in6_addr daddr;
 	__u32 scope_id = 0;
-	size_t total_payload_len = payload_len, rdma_payload_len = 0;
+	size_t rdma_payload_len = 0;
 	bool zcopy = ((msg->msg_flags & MSG_ZEROCOPY) &&
 		      sock_flag(rds_rs_to_sk(rs), SOCK_ZEROCOPY));
 	int num_sgs = DIV_ROUND_UP(payload_len, PAGE_SIZE);
@@ -1243,7 +1243,6 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	if (ret)
 		goto out;
 
-	total_payload_len += rdma_payload_len;
 	if (max_t(size_t, payload_len, rdma_payload_len) > RDS_MAX_MSG_SIZE) {
 		ret = -EMSGSIZE;
 		goto out;
-- 
2.33.0


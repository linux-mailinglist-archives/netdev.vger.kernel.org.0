Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB61A5927D9
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 04:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiHOCn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 22:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiHOCn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 22:43:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B32A13DD2;
        Sun, 14 Aug 2022 19:43:24 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M5dlN73yPzXddd;
        Mon, 15 Aug 2022 10:39:12 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 10:43:22 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <florent.fourcot@wifirst.fr>, <razor@blackwall.org>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
Date:   Mon, 15 Aug 2022 10:46:29 +0800
Message-ID: <20220815024629.240367-1-shaozhengchao@huawei.com>
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

When bulk delete command is received in the rtnetlink_rcv_msg function,
if bulk delete is not supported, module_put is not called to release
the reference counting. As a result, module reference count is leaked.

Fixes: a6cec0bcd342("net: rtnetlink: add bulk delete support flag")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f7..4b5b15c684ed 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6070,6 +6070,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
 	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
 		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
+		module_put(owner);
 		goto err_unlock;
 	}
 
-- 
2.17.1


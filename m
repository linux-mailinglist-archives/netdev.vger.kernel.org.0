Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C45617399
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiKCBMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 21:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKCBMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 21:12:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C942D1263A;
        Wed,  2 Nov 2022 18:12:07 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2m1Z4jhPzHvRZ;
        Thu,  3 Nov 2022 09:11:46 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 09:12:05 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netfilter-devel@vger.kernel.org>
CC:     <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()
Date:   Thu, 3 Nov 2022 09:12:02 +0800
Message-ID: <20221103011202.2160107-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When type is NFNL_CB_MUTEX and -EAGAIN error occur in nfnetlink_rcv_msg(),
it does not execute nfnl_unlock(). That would trigger potential dead lock.

Fixes: 50f2db9e368f ("netfilter: nfnetlink: consolidate callback types")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/netfilter/nfnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 9c44518cb70f..6d18fb346868 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -294,6 +294,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc) {
+				nfnl_unlock(subsys_id);
 				err = -EAGAIN;
 				break;
 			}
-- 
2.25.1


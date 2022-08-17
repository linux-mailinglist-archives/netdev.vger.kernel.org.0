Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDE9596CD1
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiHQKbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbiHQKa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:30:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B02785B5;
        Wed, 17 Aug 2022 03:30:58 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M742t6Zk7zkWKh;
        Wed, 17 Aug 2022 18:27:34 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 18:30:55 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 17 Aug
 2022 18:30:54 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <brouer@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net/sched: fix netdevice reference leaks in attach_one_default_qdisc()
Date:   Wed, 17 Aug 2022 18:46:46 +0800
Message-ID: <20220817104646.22861-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In attach_default_qdiscs(), when attach default qdisc (fq_codel) fails
and fallback to noqueue, if the original attached qdisc is not released
and a new one is directly attached, this will cause netdevice reference
leaks.

The following is the bug log:

veth0: default qdisc (fq_codel) fail, fallback to noqueue
unregister_netdevice: waiting for veth0 to become free. Usage count = 32
leaked reference.
 qdisc_alloc+0x12e/0x210
 qdisc_create_dflt+0x62/0x140
 attach_one_default_qdisc.constprop.41+0x44/0x70
 dev_activate+0x128/0x290
 __dev_open+0x12a/0x190
 __dev_change_flags+0x1a2/0x1f0
 dev_change_flags+0x23/0x60
 do_setlink+0x332/0x1150
 __rtnl_newlink+0x52f/0x8e0
 rtnl_newlink+0x43/0x70
 rtnetlink_rcv_msg+0x140/0x3b0
 netlink_rcv_skb+0x50/0x100
 netlink_unicast+0x1bb/0x290
 netlink_sendmsg+0x37c/0x4e0
 sock_sendmsg+0x5f/0x70
 ____sys_sendmsg+0x208/0x280

In attach_one_default_qdisc(), release the old one before attaching
a new qdisc to fix this bug.

Fixes: bf6dba76d278 ("net: sched: fallback to qdisc noqueue if default qdisc setup fail")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/sched/sch_generic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d47b9689eba6..87b61ef14497 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1140,6 +1140,11 @@ static void attach_one_default_qdisc(struct net_device *dev,
 
 	if (!netif_is_multiqueue(dev))
 		qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
+
+	if (dev_queue->qdisc_sleeping &&
+	    dev_queue->qdisc_sleeping != &noop_qdisc)
+		qdisc_put(dev_queue->qdisc_sleeping);
+
 	dev_queue->qdisc_sleeping = qdisc;
 }
 
-- 
2.17.1


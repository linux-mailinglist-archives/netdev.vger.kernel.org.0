Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B509A545CD6
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244878AbiFJHHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241586AbiFJHHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:07:46 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF6F633F;
        Fri, 10 Jun 2022 00:07:43 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LKBnV016Jz1K99Y;
        Fri, 10 Jun 2022 15:05:49 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (7.185.36.84) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 15:07:41 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpeml500011.china.huawei.com (7.185.36.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 15:07:40 +0800
From:   Di Zhu <zhudi2@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhudi2@huawei.com>, <rose.chen@huawei.com>,
        <syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com>
Subject: [PATCH] fq_codel: Discard problematic packets with pkt_len 0
Date:   Fri, 10 Jun 2022 15:05:29 +0800
Message-ID: <20220610070529.1623-1-zhudi2@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500011.china.huawei.com (7.185.36.84)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
skbs, that is, the flow->head is null.
The root cause is that: when the first queued skb with pkt_len 0, backlogs
of the flow that this skb enqueued is still 0 and if sch->limit is set to
0 then fq_codel_drop() will be called. At this point, the backlogs of all
flows are all 0, so flow with idx 0 is selected to drop, but this flow have
not any skbs.
skb with pkt_len 0 can break existing processing logic, so just discard
these invalid skbs.

LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5

Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
Signed-off-by: Di Zhu <zhudi2@huawei.com>
---
 net/sched/sch_fq_codel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 839e1235db05..c0f82b7358e1 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -191,6 +191,9 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	unsigned int pkt_len;
 	bool memory_limited;
 
+	if (unlikely(!qdisc_pkt_len(skb)))
+		return qdisc_drop(skb, sch, to_free);
+
 	idx = fq_codel_classify(skb, sch, &ret);
 	if (idx == 0) {
 		if (ret & __NET_XMIT_BYPASS)
-- 
2.27.0


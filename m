Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EF254F1C3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 09:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380631AbiFQHTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 03:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380619AbiFQHTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 03:19:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4183D11C1E;
        Fri, 17 Jun 2022 00:19:23 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LPVjX4jDfzhXZQ;
        Fri, 17 Jun 2022 15:17:20 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (7.185.36.84) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 15:19:21 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpeml500011.china.huawei.com (7.185.36.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 17 Jun 2022 15:19:20 +0800
From:   Di Zhu <zhudi2@huawei.com>
To:     <ast@kernel.org>, <edumazet@google.com>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <yhs@fb.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <zhudi2@huawei.com>, <rose.chen@huawei.com>,
        <syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com>
Subject: [PATCH] bpf: Don't redirect packets with pkt_len 0
Date:   Fri, 17 Jun 2022 15:18:55 +0800
Message-ID: <20220617071855.2482-1-zhudi2@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500011.china.huawei.com (7.185.36.84)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
skbs, that is, the flow->head is null.
The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
run a bpf prog which redirects empty skbs.
So we should determine whether the length of the packet modified by bpf
prog or others like bpf_prog_test is 0 before forwarding it directly.

LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html

Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
Signed-off-by: Di Zhu <zhudi2@huawei.com>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5af58eb48587..c7fbfa90898a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2156,6 +2156,9 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
 static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
 			  u32 flags)
 {
+	if (unlikely(skb->len == 0))
+		return -EINVAL;
+
 	if (dev_is_mac_header_xmit(dev))
 		return __bpf_redirect_common(skb, dev, flags);
 	else
-- 
2.27.0


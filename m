Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44C258231D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiG0J3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiG0J33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:29:29 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928C147B89;
        Wed, 27 Jul 2022 02:29:28 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lt7fv273WzWfq2;
        Wed, 27 Jul 2022 17:25:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 27 Jul
 2022 17:29:15 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <liuhangbin@gmail.com>, <willemb@google.com>, <baruch@tkos.co.il>,
        <pablo@netfilter.org>, <yajun.deng@linux.dev>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net/af_packet: check len when min_header_len equals to 0
Date:   Wed, 27 Jul 2022 17:33:12 +0800
Message-ID: <20220727093312.125116-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User can use AF_PACKET socket to send packets with the length of 0.
When min_header_len equals to 0, packet_snd will call __dev_queue_xmit
to send packets, and sock->type can be any type.

Reported-by: syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com
Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d08c4728523b..5cbe07116e04 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3037,8 +3037,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	if (err)
 		goto out_free;
 
-	if (sock->type == SOCK_RAW &&
-	    !dev_validate_header(dev, skb->data, len)) {
+	if ((sock->type == SOCK_RAW &&
+	     !dev_validate_header(dev, skb->data, len)) || !skb->len) {
 		err = -EINVAL;
 		goto out_free;
 	}
-- 
2.17.1


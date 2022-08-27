Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2615A3585
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 09:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiH0HU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 03:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiH0HUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 03:20:23 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B477C74B;
        Sat, 27 Aug 2022 00:20:21 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MF7L60z9mz1N7Gs;
        Sat, 27 Aug 2022 15:16:46 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 15:20:19 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/2] can: raw: use guard clause to optimize nesting in raw_rcv()
Date:   Sat, 27 Aug 2022 15:20:11 +0800
Message-ID: <0170ad1f07dbe838965df4274fce950980fa9d1f.1661584485.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661584485.git.william.xuanziyang@huawei.com>
References: <cover.1661584485.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can use guard clause to optimize nesting codes like
if (condition) { ... } else { return; } in raw_rcv();

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/raw.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index 9ae7c4206b9a..e7dfa3584e29 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -136,14 +136,13 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
 	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
-		if (ro->join_filters) {
-			this_cpu_inc(ro->uniq->join_rx_count);
-			/* drop frame until all enabled filters matched */
-			if (this_cpu_ptr(ro->uniq)->join_rx_count < ro->count)
-				return;
-		} else {
+		if (!ro->join_filters)
+			return;
+
+		this_cpu_inc(ro->uniq->join_rx_count);
+		/* drop frame until all enabled filters matched */
+		if (this_cpu_ptr(ro->uniq)->join_rx_count < ro->count)
 			return;
-		}
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
 		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
-- 
2.25.1


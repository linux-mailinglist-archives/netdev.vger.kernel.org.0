Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E972D5EB765
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 04:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiI0CLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 22:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiI0CLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 22:11:07 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5C92F55
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:11:04 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mc3086S7Pz1P6t2;
        Tue, 27 Sep 2022 10:06:48 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 10:11:03 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 10:11:02 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH -next] wwan_hwsim: Use skb_put_data() instead of skb_put/memcpy pair
Date:   Tue, 27 Sep 2022 10:45:11 +0800
Message-ID: <20220927024511.14665-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_put_data() instead of skb_put() and memcpy(), which is clear.

Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/net/wwan/wwan_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index fad642f9ffd8..ff09a8cedf93 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -157,8 +157,8 @@ static int wwan_hwsim_port_tx(struct wwan_port *wport, struct sk_buff *in)
 			if ((i + 1) < in->len && in->data[i + 1] == '\n')
 				i++;
 			n = i - s + 1;
-			memcpy(skb_put(out, n), &in->data[s], n);/* Echo */
-			memcpy(skb_put(out, 6), "\r\nOK\r\n", 6);
+			skb_put_data(out, &in->data[s], n);/* Echo */
+			skb_put_data(out, "\r\nOK\r\n", 6);
 			s = i + 1;
 			port->pstate = AT_PARSER_WAIT_A;
 		} else if (port->pstate == AT_PARSER_SKIP_LINE) {
@@ -171,7 +171,7 @@ static int wwan_hwsim_port_tx(struct wwan_port *wport, struct sk_buff *in)
 	if (i > s) {
 		/* Echo the processed portion of a not yet completed command */
 		n = i - s;
-		memcpy(skb_put(out, n), &in->data[s], n);
+		skb_put_data(out, &in->data[s], n);
 	}
 
 	consume_skb(in);
-- 
2.17.1


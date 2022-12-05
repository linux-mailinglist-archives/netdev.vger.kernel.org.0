Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B446427C8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLELrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLELrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:47:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C8212768
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:47:13 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NQhW91zBQzqSwC;
        Mon,  5 Dec 2022 19:43:01 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 5 Dec
 2022 19:47:08 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <michael.jamet@intel.com>,
        <mika.westerberg@linux.intel.com>, <YehezkelShB@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] net: thunderbolt: fix memory leak in tbnet_open()
Date:   Mon, 5 Dec 2022 19:55:59 +0800
Message-ID: <20221205115559.3189177-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tb_ring_alloc_rx() failed in tbnet_open(), it doesn't free ida.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/thunderbolt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index a52ee2bf5575..70fd61ce15c6 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -916,6 +916,7 @@ static int tbnet_open(struct net_device *dev)
 		netdev_err(dev, "failed to allocate Rx ring\n");
 		tb_ring_free(net->tx_ring.ring);
 		net->tx_ring.ring = NULL;
+		tb_xdomain_release_out_hopid(xd, hopid);
 		return -ENOMEM;
 	}
 	net->rx_ring.ring = ring;
-- 
2.34.1


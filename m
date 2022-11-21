Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6646320B8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiKULeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiKULdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:33:37 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEECDFEC;
        Mon, 21 Nov 2022 03:29:14 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VVKgY2V_1669030151;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVKgY2V_1669030151)
          by smtp.aliyun-inc.com;
          Mon, 21 Nov 2022 19:29:12 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH 1/2] Revert "bpf: veth driver panics when xdp prog attached before veth_open"
Date:   Mon, 21 Nov 2022 19:28:47 +0800
Message-Id: <20221121112848.51388-2-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221121112848.51388-1-hengqi@linux.alibaba.com>
References: <eebf1c5ae11db046256eeb1aa287a0019adc3606.camel@redhat.com>
 <20221121112848.51388-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 5e5dc33d5dacb34b0165061bc5a10efd2fd3b66f.

This patch fixes the panic maked by 2e0de6366ac16. Now Paolo
and Toke suggest reverting the patch 2e0de6366ac16 and making
it stronger, so do this first.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2a4592780141..b1ed5a93b6c5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1125,7 +1125,7 @@ static int veth_enable_xdp(struct net_device *dev)
 	int err, i;
 
 	rq = &priv->rq[0];
-	napi_already_on = rcu_access_pointer(rq->napi);
+	napi_already_on = (dev->flags & IFF_UP) && rcu_access_pointer(rq->napi);
 
 	if (!xdp_rxq_info_is_reg(&priv->rq[0].xdp_rxq)) {
 		err = veth_enable_xdp_range(dev, 0, dev->real_num_rx_queues, napi_already_on);
-- 
2.19.1.6.gb485710b


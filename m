Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ED058FF20
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiHKPRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbiHKPRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:17:47 -0400
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB31589814;
        Thu, 11 Aug 2022 08:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+WsXT
        B496pRiThsdIYxgt06NE3Gcvk+x9eC2e8AKguc=; b=UVRLId1UWuRhNt+Z81hLa
        xIIjzlL9Thuh7GE5sNukxhD8IOl0N8PKCCid6WxtdXIeJySQz/y8OupqY0SH0vbT
        QFpncRHqcMPaZxgNKIwA1uaiDDwGqwIoX/63k16Nd6dwXRD8qfSnnmevw2rpemDC
        4WpEMYAH8iOsL7i5KT8thU=
Received: from localhost.localdomain (unknown [113.87.232.118])
        by smtp7 (Coremail) with SMTP id C8CowAD3ipBlHfViwDT+Tg--.45567S4;
        Thu, 11 Aug 2022 23:17:09 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     ioana.ciornei@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.liu@nxp.com,
        Chen Lin <chen45464546@163.com>,
        Chen Lin <chen.lin5@zte.com.cn>
Subject: [PATCH v2] dpaa2-eth: trace the allocated address instead of page struct
Date:   Thu, 11 Aug 2022 23:16:51 +0800
Message-Id: <20220811151651.3327-1-chen45464546@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220811144143.b4mlngr6x76bozwg@skbuf>
References: <20220811144143.b4mlngr6x76bozwg@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAD3ipBlHfViwDT+Tg--.45567S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4xKr4UZF13Ar4xXrW7CFg_yoWDAFbE9r
        nFqr13JF4jkFy0ka1rKr4UXa4v9r47Zr48AF1SgFW3Gr9rAry8Jr1kA34xArZ3ur4SkF9x
        Jw17Aa43J3s3JjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRCSoGPUUUUU==
X-Originating-IP: [113.87.232.118]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/1tbiQhVanlaECkcrUQAAs2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should trace the allocated address instead of page struct.

Fixes: 27c874867c4 ("dpaa2-eth: Use a single page per Rx buffer")
Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cd9ec8052..75d515726 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1660,8 +1660,8 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 		buf_array[i] = addr;
 
 		/* tracing point */
-		trace_dpaa2_eth_buf_seed(priv->net_dev,
-					 page, DPAA2_ETH_RX_BUF_RAW_SIZE,
+		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
+					 DPAA2_ETH_RX_BUF_RAW_SIZE,
 					 addr, priv->rx_buf_size,
 					 bpid);
 	}
-- 
2.25.1


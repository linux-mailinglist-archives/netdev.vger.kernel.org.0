Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D5F58F4E6
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 01:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiHJXcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 19:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHJXc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 19:32:29 -0400
Received: from m12-16.163.com (m12-16.163.com [220.181.12.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52F487FE6B;
        Wed, 10 Aug 2022 16:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=XIdpO
        Qq44WwBDrfcT18lSv7b7H/On0t6NSVFCJoXbes=; b=mQcRRBoLt+b8XkGoggg2d
        aBudR+RH0JF6aKb6yeDX3whtMyrTwIW/OJrPu5StBz4x6yGe0SxUChG/I/bP39iG
        Lhy2QEV+u6zz84vRPy9dFKZF03sn7hBvPUhCwkZzCs4/CN6ZivXlMZfSESwg5bwP
        nLAmlBfI1qEr24MBgjnZXA=
Received: from localhost.localdomain (unknown [113.87.232.118])
        by smtp12 (Coremail) with SMTP id EMCowACn0zlvP_Ri7Nf3Fw--.60811S4;
        Thu, 11 Aug 2022 07:30:03 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     ioana.ciornei@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.liu@nxp.com,
        Chen Lin <chen45464546@163.com>,
        Chen Lin <chen.lin5@zte.com.cn>
Subject: [PATCH] dpaa2-eth: trace the allocated address instead of page struct
Date:   Thu, 11 Aug 2022 07:29:48 +0800
Message-Id: <20220810232948.40636-1-chen45464546@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowACn0zlvP_Ri7Nf3Fw--.60811S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw1DJFyDKF1UKF4kAFWUJwb_yoWDJFc_ur
        nrXr17JF4jkFyFya1Fkr45Xa4v9r47Zr48AF1SgFW3G347Ar1rJw1kA34xArZ5ur4SkF9x
        Jw17Aa43J3s3JjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRAtxhPUUUUU==
X-Originating-IP: [113.87.232.118]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBdhtZnmDkoNZ6JAAAsG
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

Follow the commit 27c874867c4(dpaa2-eth: Use a single page per Rx buffer),
we should trace the allocated address instead of page struct.

Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E285F6055F9
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 05:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJTDhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 23:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJTDhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 23:37:13 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 752BB63FCE
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 20:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=NF524UiF1Rlho55kpZ
        ccnpG59hTNeQeOGBdNsC+P6/g=; b=jJ6eKhhsww5+aks+p7x/rHUPb0+ggdofaP
        rVATIC/Fgf6K9Qbb0FyWfduSE9OL77ihCAstUHxIr2f2CsYCtbaLXseYBuDGlzZD
        Y2nIROrJj6OxxufXS9gaNyn0ZGBNCZCDMk3rkSeVT/rGwwau7d30brUBAldpFCc6
        HyojH2CBo=
Received: from localhost.localdomain (unknown [223.104.21.35])
        by smtp1 (Coremail) with SMTP id C8mowAA3J3vEwVBjI1EnDQ--.34714S2;
        Thu, 20 Oct 2022 11:34:49 +0800 (CST)
From:   xiaolinkui <xiaolinkui@126.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiaolinkui@126.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH] i40e: add a fault tolerance judgment
Date:   Thu, 20 Oct 2022 11:34:25 +0800
Message-Id: <20221020033425.11471-1-xiaolinkui@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8mowAA3J3vEwVBjI1EnDQ--.34714S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUZw45Kr4xur1xGFWxJFb_yoWfXFb_Wr
        1I9F1xWrW5GFnYqw4jkrs7C3yYkFWvgr95uF9Fq3yrA34DZw15AFyDWrWIqr4xGr4fAF95
        A3W3tayfC34rKjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREWEE5UUUUU==
X-Originating-IP: [223.104.21.35]
X-CM-SenderInfo: p0ld0z5lqn3xa6rslhhfrp/1tbiHBug1lpEIOLkJgAAsv
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linkui Xiao <xiaolinkui@kylinos.cn>

Avoid requesting memory when system memory resources are insufficient.
Reference function i40e_setup_tx_descriptors, adding fault tolerance
handling.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d4226161a3ef..673f2f0d078f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1565,6 +1565,9 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	struct device *dev = rx_ring->dev;
 	int err;
 
+	if (!dev)
+		return -ENOMEM;
+
 	u64_stats_init(&rx_ring->syncp);
 
 	/* Round up to nearest 4K */
-- 
2.17.1


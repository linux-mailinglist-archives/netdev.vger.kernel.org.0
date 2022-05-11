Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA2522CAC
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbiEKGzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiEKGzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:55:37 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9107A243105;
        Tue, 10 May 2022 23:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=u1j75
        +jwMktH6WYAlX+Azz8jfD4KSlO2j7a6v1tqq5E=; b=pk1zLcnONLE5+XxUCcVkW
        TDWFbncfWIPO97BebKB3GOACmwfAjDLvC8mwYbI23TXhPNMb2sIwVFV/VXIxLe53
        rnXdENFlckqpfTvu0yfnwE7sZedKRakyMvdXDUNgvaX8d3b6AdQBAcuM4OyLukzh
        4nbFmajLK5H31z8Rx2/VHc=
Received: from ubuntu.localdomain (unknown [58.213.83.157])
        by smtp3 (Coremail) with SMTP id DcmowACXS5zBXXtit4LEBQ--.33384S4;
        Wed, 11 May 2022 14:54:58 +0800 (CST)
From:   Bernard Zhao <zhaojunkui2008@126.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bernard@vivo.com, Bernard Zhao <zhaojunkui2008@126.com>
Subject: [PATCH] intel/i40e: delete if NULL check before dev_kfree_skb
Date:   Tue, 10 May 2022 23:54:51 -0700
Message-Id: <20220511065451.655335-1-zhaojunkui2008@126.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowACXS5zBXXtit4LEBQ--.33384S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF1fCw18Wr1UAF1kZrWUurg_yoWfZFc_Cr
        n7XF1xKw45KwnYqrn8Cr4fu3yjyrZ8W3yrury7t3yfJr9Fyr4UZryDZr95Xw4fWr4rCFy5
        Aa43t3W7C345AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRAR6w3UUUUU==
X-Originating-IP: [58.213.83.157]
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiYAP9qlpEHUaynQAAse
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_kfree_skb check if the input parameter NULL and do the right
thing, there is no need to check again.
This change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 0eae5858f2fe..98cfadfd0f35 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1482,10 +1482,8 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	if (!rx_ring->rx_bi)
 		return;
 
-	if (rx_ring->skb) {
-		dev_kfree_skb(rx_ring->skb);
-		rx_ring->skb = NULL;
-	}
+	dev_kfree_skb(rx_ring->skb);
+	rx_ring->skb = NULL;
 
 	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
-- 
2.33.1


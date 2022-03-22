Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1E44E4957
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 23:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238366AbiCVWw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 18:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiCVWw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 18:52:56 -0400
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 15:51:27 PDT
Received: from postfix01.core.dcmtl.stgraber.net (postfix01.core.dcmtl.stgraber.net [IPv6:2602:fc62:a:1001:216:3eff:feb3:6927])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5AC5DA5E;
        Tue, 22 Mar 2022 15:51:27 -0700 (PDT)
Received: from dakara.stgraber.net (unknown [IPv6:2602:fc62:b:1000:5436:5b25:64e4:d81a])
        by postfix01.core.dcmtl.stgraber.net (Postfix) with ESMTP id 41FD41FD94;
        Tue, 22 Mar 2022 22:42:36 +0000 (UTC)
From:   =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, iyappan@os.amperecomputing.com,
        keyur@os.amperecomputing.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, quan@os.amperecomputing.com,
        stable@vger.kernel.org, stgraber@ubuntu.com,
        toan@os.amperecomputing.com
Subject: [PATCH v2] drivers: net: xgene: Fix regression in CRC stripping
Date:   Tue, 22 Mar 2022 18:42:06 -0400
Message-Id: <20220322224205.752795-1-stgraber@ubuntu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318141207.284972b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220318141207.284972b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Graber <stgraber@ubuntu.com>

All packets on ingress (except for jumbo) are terminated with a 4-bytes
CRC checksum. It's the responsability of the driver to strip those 4
bytes. Unfortunately a change dating back to March 2017 re-shuffled some
code and made the CRC stripping code effectively dead.

This change re-orders that part a bit such that the datalen is
immediately altered if needed.

Fixes: 4902a92270fb ("drivers: net: xgene: Add workaround for errata 10GE_8/ENET_11")
Signed-off-by: Stephane Graber <stgraber@ubuntu.com>
Tested-by: Stephane Graber <stgraber@ubuntu.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index ff2d099aab21..53dc8d5fede8 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -696,6 +696,12 @@ static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
 	buf_pool->rx_skb[skb_index] = NULL;
 
 	datalen = xgene_enet_get_data_len(le64_to_cpu(raw_desc->m1));
+
+	/* strip off CRC as HW isn't doing this */
+	nv = GET_VAL(NV, le64_to_cpu(raw_desc->m0));
+	if (!nv)
+		datalen -= 4;
+
 	skb_put(skb, datalen);
 	prefetch(skb->data - NET_IP_ALIGN);
 	skb->protocol = eth_type_trans(skb, ndev);
@@ -717,12 +723,8 @@ static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
 		}
 	}
 
-	nv = GET_VAL(NV, le64_to_cpu(raw_desc->m0));
-	if (!nv) {
-		/* strip off CRC as HW isn't doing this */
-		datalen -= 4;
+	if (!nv)
 		goto skip_jumbo;
-	}
 
 	slots = page_pool->slots - 1;
 	head = page_pool->head;
-- 
2.34.1


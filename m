Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE6836E8A8
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbhD2K11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:27:27 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54352 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240398AbhD2K10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:27:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UX9cCg3_1619691984;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UX9cCg3_1619691984)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 18:26:37 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     nicolas.ferre@microchip.com
Cc:     claudiu.beznea@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: macb: Remove redundant assignment to w0
Date:   Thu, 29 Apr 2021 18:26:22 +0800
Message-Id: <1619691982-90657-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable w0 is set to zero but these values is not used as it is
overwritten later on, hence redundant assignment can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/cadence/macb_main.c:3265:3: warning: Value stored
to 'w0' is never read [clang-analyzer-deadcode.DeadStores].

drivers/net/ethernet/cadence/macb_main.c:3251:3: warning: Value stored
to 'w0' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 0f6a6cb..741b2e3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3248,7 +3248,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	/* ignore field if any masking set */
 	if (tp4sp_m->ip4src == 0xFFFFFFFF) {
 		/* 1st compare reg - IP source address */
-		w0 = 0;
 		w1 = 0;
 		w0 = tp4sp_v->ip4src;
 		w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
@@ -3262,7 +3261,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	/* ignore field if any masking set */
 	if (tp4sp_m->ip4dst == 0xFFFFFFFF) {
 		/* 2nd compare reg - IP destination address */
-		w0 = 0;
 		w1 = 0;
 		w0 = tp4sp_v->ip4dst;
 		w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
-- 
1.8.3.1


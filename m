Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AFD4552E6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 03:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242159AbhKRCxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 21:53:21 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:39328 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242137AbhKRCxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 21:53:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Ux7HEL._1637203807;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Ux7HEL._1637203807)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 10:50:08 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] ethernet: renesas: Use div64_ul instead of do_div
Date:   Thu, 18 Nov 2021 10:50:05 +0800
Message-Id: <1637203805-125780-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do_div() does a 64-by-32 division. Here the divisor is an
unsigned long which on some platforms is 64 bit wide. So use
div64_ul instead of do_div to avoid a possible truncation.

Eliminate the following coccicheck warning:
./drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:2742:1-7: WARNING:
do_div() does a 64-by-32 division, please consider using div64_ul
instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b4c597f..2b89710 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2489,7 +2489,7 @@ static int ravb_set_gti(struct net_device *ndev)
 		return -EINVAL;
 
 	inc = 1000000000ULL << 20;
-	do_div(inc, rate);
+	inc = div64_ul(inc, rate);
 
 	if (inc < GTI_TIV_MIN || inc > GTI_TIV_MAX) {
 		dev_err(dev, "gti.tiv increment 0x%llx is outside the range 0x%x - 0x%x\n",
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1A455310
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 04:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbhKRDIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 22:08:24 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:47221 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242614AbhKRDIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 22:08:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0Ux6f-3a_1637204719;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Ux6f-3a_1637204719)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 11:05:22 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] net: mvpp2: Use div64_ul instead of do_div
Date:   Thu, 18 Nov 2021 11:05:01 +0800
Message-Id: <1637204701-8224-1-git-send-email-yang.lee@linux.alibaba.com>
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index df6c793..41244a5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2739,7 +2739,7 @@ static u32 mvpp2_cycles_to_usec(u32 cycles, unsigned long clk_hz)
 {
 	u64 tmp = (u64)cycles * USEC_PER_SEC;
 
-	do_div(tmp, clk_hz);
+	tmp = div64_ul(tmp, clk_hz);
 
 	return tmp > U32_MAX ? U32_MAX : tmp;
 }
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EE24914AA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245362AbiARCXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:23:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37140 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244903AbiARCWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04BC9B81240;
        Tue, 18 Jan 2022 02:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A057C36AE3;
        Tue, 18 Jan 2022 02:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472557;
        bh=oLdh2IIQhyz8/cfQ/4uNzzA2+eaqF5O7TwGmsi6SxmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYBNbqlC9W8U3TzYkHpuR2erQ/eQdByLloStEOfqG7vJQfizOxndINIO4MMsQIMzZ
         vtcmS9hVii1zudZNSrawIFCFduERmTxpaH8EGtBDiualMhLn4Gi3bbB/PrRe+4OYsu
         316znsywo5wc1jFKHXdzv1v3qMh9rngsHtj2FzwyuTQgcJaeRYKL03+zO57B7SbzEA
         9BdSGGxJijMpJYqXSn6RQQSNP5la1NIv6qX8ZTzE+lgEBAq5VtON7uhb8nYrfKacK7
         BxDqC/BzEUuQzHPNkdNtWWD3gmo2g2CTQLRbRPis34Uyi9ukULcwCIrzAlw13+unGY
         yuQM3LjPay1Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        biju.das.jz@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 052/217] ethernet: renesas: Use div64_ul instead of do_div
Date:   Mon, 17 Jan 2022 21:16:55 -0500
Message-Id: <20220118021940.1942199-52-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit d9f31aeaa1e5aefa68130878af3c3513d41c1e2d ]

do_div() does a 64-by-32 division. Here the divisor is an
unsigned long which on some platforms is 64 bit wide. So use
div64_ul instead of do_div to avoid a possible truncation.

Eliminate the following coccicheck warning:
./drivers/net/ethernet/renesas/ravb_main.c:2492:1-7: WARNING:
do_div() does a 64-by-32 division, please consider using div64_ul
instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/1637228883-100100-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b4c597f4040c8..151cce2fe36d5 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -30,8 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/sys_soc.h>
 #include <linux/reset.h>
-
-#include <asm/div64.h>
+#include <linux/math64.h>
 
 #include "ravb.h"
 
@@ -2488,8 +2487,7 @@ static int ravb_set_gti(struct net_device *ndev)
 	if (!rate)
 		return -EINVAL;
 
-	inc = 1000000000ULL << 20;
-	do_div(inc, rate);
+	inc = div64_ul(1000000000ULL << 20, rate);
 
 	if (inc < GTI_TIV_MIN || inc > GTI_TIV_MAX) {
 		dev_err(dev, "gti.tiv increment 0x%llx is outside the range 0x%x - 0x%x\n",
-- 
2.34.1


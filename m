Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B10E36B0B3
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhDZJed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:34:33 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:53924 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232542AbhDZJeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 05:34:31 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWpMjkG_1619429625;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UWpMjkG_1619429625)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Apr 2021 17:33:48 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     j.vosburgh@gmail.com
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] bonding/alb: return -ENOMEM when kmalloc failed
Date:   Mon, 26 Apr 2021 17:33:40 +0800
Message-Id: <1619429620-52948-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is using -1 instead of the -ENOMEM defined macro to
specify that a buffer allocation failed. Using the correct error
code is more intuitive.

Smatch tool warning:
drivers/net/bonding/bond_alb.c:850 rlb_initialize() warn: returning -1
instead of -ENOMEM is sloppy

No functional change, just more standardized.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c3091e0..dad5383 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -847,7 +847,7 @@ static int rlb_initialize(struct bonding *bond)
 
 	new_hashtbl = kmalloc(size, GFP_KERNEL);
 	if (!new_hashtbl)
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_bh(&bond->mode_lock);
 
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D436F7B5
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 11:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhD3JWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 05:22:19 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:60044 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhD3JWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 05:22:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UXFfJog_1619774485;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UXFfJog_1619774485)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 30 Apr 2021 17:21:26 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] mac80211: Remove redundant assignment to ret
Date:   Fri, 30 Apr 2021 17:21:23 +0800
Message-Id: <1619774483-116805-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'ret' is set to -ENODEV but this value is never read as it
is overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Clean up the following clang-analyzer warning:

net/mac80211/debugfs_netdev.c:60:2: warning: Value stored to 'ret' is
never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/mac80211/debugfs_netdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 0ad3860..f7aac89 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -57,7 +57,6 @@ static ssize_t ieee80211_if_write(
 		return -EFAULT;
 	buf[count] = '\0';
 
-	ret = -ENODEV;
 	rtnl_lock();
 	ret = (*write)(sdata, buf, count);
 	rtnl_unlock();
-- 
1.8.3.1


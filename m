Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77136C403
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhD0KdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:33:07 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56828 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238205AbhD0Kbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:31:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UWzF2Oi_1619519460;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWzF2Oi_1619519460)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 18:31:03 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] mpls: Remove redundant assignment to err
Date:   Tue, 27 Apr 2021 18:30:56 +0800
Message-Id: <1619519456-61310-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable err is set to -ENOMEM but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

net/mpls/af_mpls.c:1022:2: warning: Value stored to 'err' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/mpls/af_mpls.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 47bab70..05a21dd 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1019,7 +1019,6 @@ static int mpls_route_add(struct mpls_route_config *cfg,
 		goto errout;
 	}
 
-	err = -ENOMEM;
 	rt = mpls_rt_alloc(nhs, max_via_alen, max_labels);
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
-- 
1.8.3.1


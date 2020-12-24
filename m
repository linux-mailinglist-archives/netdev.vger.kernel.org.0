Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1213A2E24FC
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgLXHCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:02:37 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:30461 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgLXHCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 02:02:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UJcT9Ok_1608793300;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UJcT9Ok_1608793300)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Dec 2020 15:01:54 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] bpf: fix: address of local auto-variable assigned to a function parameter.
Date:   Thu, 24 Dec 2020 15:01:38 +0800
Message-Id: <1608793298-123684-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assigning local variable txq to the outputting parameter xdp->txq is not
safe, txq will be released after the end of the function call. 
Then the result of using xdp is unpredictable.

Fix this error by defining the struct xdp_txq_info in function
dev_map_run_prog() as a static type.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 kernel/bpf/devmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68..af6f004 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -454,7 +454,7 @@ static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
 					 struct xdp_buff *xdp,
 					 struct bpf_prog *xdp_prog)
 {
-	struct xdp_txq_info txq = { .dev = dev };
+	static struct xdp_txq_info txq = { .dev = dev };
 	u32 act;
 
 	xdp_set_data_meta_invalid(xdp);
-- 
1.8.3.1


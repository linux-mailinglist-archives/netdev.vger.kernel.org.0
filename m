Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4364476C34
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhLPIte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:49:34 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:54330 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhLPItd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 03:49:33 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowABHTlqA_bphQfc+Aw--.52062S2;
        Thu, 16 Dec 2021 16:49:05 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] sfc: potential dereference of null pointer
Date:   Thu, 16 Dec 2021 16:49:02 +0800
Message-Id: <20211216084902.329009-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowABHTlqA_bphQfc+Aw--.52062S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWUAw17KFWxJr1xJF1rXrb_yoW8Cw1xpa
        1xK347ur4ktw45Za4kCw4kZF9xJasxtFWxWrySk3yrZwn5AF15ZrsrtFW5ur4qyr4DWF12
        yrWUZFsFyFs8JwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjfUeYLvDUUUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of kcalloc() needs to be checked.
To avoid dereference of null pointer in case of the failure of alloc,
such as efx_fini_rx_recycle_ring().
Therefore, it should be better to change the definition of page_ptr_mask
to signed int and then assign the page_ptr_mask to -1 when page_ring is
NULL, in order to avoid the use in the loop in
efx_fini_rx_recycle_ring().

Fixes: 3d95b884392f ("sfc: move more rx code")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/sfc/net_driver.h | 2 +-
 drivers/net/ethernet/sfc/rx_common.c  | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9b4b25704271..beba3e0a6027 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -407,7 +407,7 @@ struct efx_rx_queue {
 	unsigned int page_recycle_count;
 	unsigned int page_recycle_failed;
 	unsigned int page_recycle_full;
-	unsigned int page_ptr_mask;
+	int page_ptr_mask;
 	unsigned int max_fill;
 	unsigned int fast_fill_trigger;
 	unsigned int min_fill;
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 68fc7d317693..d9d0a5805f1c 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 					    efx->rx_bufs_per_page);
 	rx_queue->page_ring = kcalloc(page_ring_size,
 				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
-	rx_queue->page_ptr_mask = page_ring_size - 1;
+	if (!rx_queue->page_ring)
+		rx_queue->page_ptr_mask = -1;
+	else
+		rx_queue->page_ptr_mask = page_ring_size - 1;
 }
 
 static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
-- 
2.25.1


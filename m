Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A6D204BFF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgFWINT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 04:13:19 -0400
Received: from mail.loongson.cn ([114.242.206.163]:33466 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731158AbgFWINT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 04:13:19 -0400
Received: from bogon.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxj2uVufFeEK1IAA--.8S2;
        Tue, 23 Jun 2020 16:13:10 +0800 (CST)
From:   Kaige Li <likaige@loongson.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in enic_init_affinity_hint()
Date:   Tue, 23 Jun 2020 16:13:09 +0800
Message-Id: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dxj2uVufFeEK1IAA--.8S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4DurW5Aw47Wr1UAFykuFg_yoW8GF1xpa
        y8t3y8Zws5Jw1DZa1kK3Z7G3y5ua43u34qkF47A39YqrZ5XFWkJr9rtF43Zr1jqrWUGF1a
        q3W2yr47WFn8Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r43
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
        WxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUj3CztUUUU
        U==
X-CM-SenderInfo: 5olntxtjh6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel module may sleep with holding a spinlock.

The function call paths (from bottom to top) are:

[FUNC] zalloc_cpumask_var(GFP_KERNEL)
drivers/net/ethernet/cisco/enic/enic_main.c, 125: zalloc_cpumask_var in enic_init_affinity_hint
drivers/net/ethernet/cisco/enic/enic_main.c, 1918: enic_init_affinity_hint in enic_open
drivers/net/ethernet/cisco/enic/enic_main.c, 2348: enic_open in enic_reset
drivers/net/ethernet/cisco/enic/enic_main.c, 2341: spin_lock in enic_reset

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

Signed-off-by: Kaige Li <likaige@loongson.cn>
---

+cc netdev@vger.kernel.org

 drivers/net/ethernet/cisco/enic/enic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index cd5fe4f..ee62065 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -122,7 +122,7 @@ static void enic_init_affinity_hint(struct enic *enic)
 		     !cpumask_empty(enic->msix[i].affinity_mask)))
 			continue;
 		if (zalloc_cpumask_var(&enic->msix[i].affinity_mask,
-				       GFP_KERNEL))
+				       GFP_ATOMIC))
 			cpumask_set_cpu(cpumask_local_spread(i, numa_node),
 					enic->msix[i].affinity_mask);
 	}
-- 
2.1.0


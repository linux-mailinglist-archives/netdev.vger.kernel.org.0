Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E57743F442
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 03:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhJ2BKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 21:10:36 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:34390 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230211AbhJ2BKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 21:10:35 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowAAnLKhhSXthZAFaBQ--.31789S2;
        Fri, 29 Oct 2021 09:07:45 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] wireguard: queueing: Fix implicit type conversion
Date:   Fri, 29 Oct 2021 01:07:44 +0000
Message-Id: <1635469664-1708957-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowAAnLKhhSXthZAFaBQ--.31789S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyUWFyxJF1rZr4rXr1fJFb_yoWkAwb_Cw
        n7Wr12gryj9FyI9w13XrWFva4Sgay8X3yxWay8KrZrZw12qrWfX3s5XFyqqr1kG3yfAF17
        ZF1Dtr1Sv342gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVWk
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUHpB-UUUUU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter 'cpu' is defined as unsigned int.
However in the cpumask_next() it is implicitly type conversed
to int.
It is universally accepted that the implicit type conversion is
terrible.
Also, having the good programming custom will set an example for
others.
Thus, it might be better to change the type of 'cpu' from
unsigned int to int.

Fixes: e7096c1 ("net: WireGuard secure network tunnel")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/wireguard/queueing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 4ef2944..64f397f 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -106,7 +106,7 @@ static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
 
 static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 {
-	unsigned int cpu = *stored_cpu, cpu_index, i;
+	int cpu = *stored_cpu, cpu_index, i;
 
 	if (unlikely(cpu == nr_cpumask_bits ||
 		     !cpumask_test_cpu(cpu, cpu_online_mask))) {
-- 
2.7.4


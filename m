Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A74746E0C7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhLICRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:17:55 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:60668 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229909AbhLICRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 21:17:54 -0500
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-01 (Coremail) with SMTP id qwCowAA3PZ1hZrFhOcjlAQ--.27202S2;
        Thu, 09 Dec 2021 10:13:55 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: sched: gred: potential dereference of null pointer
Date:   Thu,  9 Dec 2021 10:13:46 +0800
Message-Id: <20211209021346.2004600-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowAA3PZ1hZrFhOcjlAQ--.27202S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4xtryfXF18GrWxXrWfGrg_yoW3AFcEgw
        4rKr1kAr97JF1rZrWUAr48Gr9a9F1DWw4v9r9xKrZ3tayUJF93W3y7Crs3Aryxur47CryD
        ArZFqFy5Jw1akjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbpwZ7UUUU
        U==
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of kzalloc() needs to be checked.
To avoid use of null pointer in gred_change_vq() in case
of the failure of alloc.

Fixes: 869aa41044b0 ("sch_gred: prefer GFP_KERNEL allocations")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/sched/sch_gred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index f4132dc25ac0..c0d355281baf 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -697,6 +697,8 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
+	if (!prealloc)
+		return -ENOMEM;
 	sch_tree_lock(sch);
 
 	err = gred_change_vq(sch, ctl->DP, ctl, prio, stab, max_P, &prealloc,
-- 
2.25.1


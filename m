Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BBC43F4C9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhJ2CJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:09:12 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:59566 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231348AbhJ2CJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 22:09:11 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowABXGfYSV3thW+2TBQ--.15439S2;
        Fri, 29 Oct 2021 10:06:10 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     jeyu@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] module: Fix implicit type conversion
Date:   Fri, 29 Oct 2021 02:06:09 +0000
Message-Id: <1635473169-1848729-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: zQCowABXGfYSV3thW+2TBQ--.15439S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKFy5GFW7WrWrCFW3KF1kuFg_yoWDCwc_Jr
        1DXrWjgryYvwn29a13Jw4rZryxKw1jgFs09a48WFZxJFyrtr13Aw1vqry3Zrn5WrWrCFn7
        Xas8Jrnxuw1IgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyU
        JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjfUO_MaUUUUU
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable 'cpu' is defined as unsigned int.
However in the for_each_possible_cpu, its values is assigned to -1.
That doesn't make sense and in the cpumask_next() it is implicitly
type conversed to int.
It is universally accepted that the implicit type conversion is
terrible.
Also, having the good programming custom will set an example for
others.
Thus, it might be better to change the definition of 'cpu' from
unsigned int to int.

Fixes: 10fad5e ("percpu, module: implement and use is_kernel/module_percpu_address()")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 927d46c..f10d611 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -632,7 +632,7 @@ static void percpu_modcopy(struct module *mod,
 bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr)
 {
 	struct module *mod;
-	unsigned int cpu;
+	int cpu;
 
 	preempt_disable();
 
-- 
2.7.4


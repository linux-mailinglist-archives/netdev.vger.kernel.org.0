Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BD33FE96A
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 08:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbhIBGpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 02:45:51 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:41630 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241529AbhIBGpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 02:45:50 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowABHyo0NcTBhl3HEAA--.41154S2;
        Thu, 02 Sep 2021 14:37:01 +0800 (CST)
From:   jiasheng <jiasheng@iscas.ac.cn>
To:     netdev@vger.kernel.org
Cc:     jiasheng <jiasheng@iscas.ac.cn>
Subject: [PATCH] bpf: Add env_type_is_resolved() in front of env_stack_push() in btf_resolve()
Date:   Thu,  2 Sep 2021 06:37:00 +0000
Message-Id: <1630564620-552327-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowABHyo0NcTBhl3HEAA--.41154S2
X-Coremail-Antispam: 1UD129KBjvdXoWruw4UKr4fArWUKw48uw4fuFg_yoWkArg_K3
        W8uF1rGwsxKFsaya1jvw4furW2k3yYqFn7Za1aqFs8G3s8WF15Jrn8Xas3JrsrGrWkKrZF
        vFZ8G3sIgF1avjkaLaAFLSUrUUUUOb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbgxYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1ln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxI
        r21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87
        Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E
        jII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8AwCF04k20x
        vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s02
        6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jr
        v_JF1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvE
        c7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r4j6FyUMIIF0xvEx4A2jsIE14
        v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x
        0zRxgArUUUUU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have found that in the complied files env_stack_push()
appear more than 10 times, and under at least 90% circumstances
that env_type_is_resolved() and env_stack_push() appear in pairs.
For example, they appear together in the btf_modifier_resolve()
of the file complie from 'kernel/bpf/btf.c'.
But we have found that in the btf_resolve(), there is only
env_stack_push() instead of the pair.
Therefore, we consider that the env_type_is_resolved()
might be forgotten.

Signed-off-by: jiasheng <jiasheng@iscas.ac.cn>
---
 kernel/bpf/btf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f982a9f0..454c249 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4002,7 +4002,8 @@ static int btf_resolve(struct btf_verifier_env *env,
 	int err = 0;
 
 	env->resolve_mode = RESOLVE_TBD;
-	env_stack_push(env, t, type_id);
+	if (env_type_is_resolved(env, type_id))
+		env_stack_push(env, t, type_id);
 	while (!err && (v = env_stack_peak(env))) {
 		env->log_type_id = v->type_id;
 		err = btf_type_ops(v->t)->resolve(env, v);
-- 
2.7.4


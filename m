Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02F57F498
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 12:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiGXKAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 06:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGXKAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 06:00:07 -0400
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 165A96545;
        Sun, 24 Jul 2022 03:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=XNmwLBbu7C
        n4RBsBpxbvsfvUtnfDMErEAESnr4Ll0p8=; b=o8u4oguqWqUODT50NEjHpmvR0C
        2bBiId0gTT3ZwdYzd6FY5vM6nr2RY1BfeBHZHj2DyDzQpGG6r1A21tRe2vfG0DpO
        SiSYMYBCSXxh46Cpx87ILuPS6Am8peP+vLG/B3yJNnnlZGGJiUPlX5Thm7Lvu1mV
        KORNJaZ07TMC6K1kQ=
Received: from localhost.localdomain (unknown [111.192.161.139])
        by app2 (Coremail) with SMTP id XQUFCgDnWBjQF91ic2uzAA--.33588S4;
        Sun, 24 Jul 2022 17:58:49 +0800 (CST)
From:   Xin Xiong <xiongx18@fudan.edu.cn>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?=E2=80=9CDavid=20S=20=2E=20Miller=20?= 
        <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        James Morris <jmorris@namei.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] xfrm: fix refcount leak in __xfrm_policy_check()
Date:   Sun, 24 Jul 2022 17:55:58 +0800
Message-Id: <20220724095557.4350-1-xiongx18@fudan.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: XQUFCgDnWBjQF91ic2uzAA--.33588S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw13Cr1fuw18KF4kAw1DJrb_yoWkCFb_C3
        4xX3WxWwn3tF1xWF40vw4kAr9ag3s293WkW3yxtas2q340qrWSgFy8Xr9xWF4xWr4qgF15
        tas5WrykAw15ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbf8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjAsqPUUUUU==
X-CM-SenderInfo: arytiiqsuqiimz6i3vldqovvfxof0/1tbiARAREFKp5C7+owAAs8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue happens on an error path in __xfrm_policy_check(). When the
fetching process of the object `pols[1]` fails, the function simply
returns 0, forgetting to decrement the reference count of `pols[0]`,
which is incremented earlier by either xfrm_sk_policy_lookup() or
xfrm_policy_lookup(). This may result in memory leaks.

Fix it by decreasing the reference count of `pols[0]` in that path.

Fixes: 134b0fc544ba ("IPsec: propagate security module errors up from flow_cache_lookup")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/xfrm/xfrm_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..4f8bbb825abc 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3599,6 +3599,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLERROR);
+				xfrm_pol_put(pols[0]);
 				return 0;
 			}
 			pols[1]->curlft.use_time = ktime_get_real_seconds();
-- 
2.25.1


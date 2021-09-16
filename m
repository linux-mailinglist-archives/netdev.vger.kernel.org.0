Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8908340D156
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 03:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhIPBpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 21:45:14 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:39544 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229600AbhIPBpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 21:45:12 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowADHzno9oUJh3yyVAA--.47849S2;
        Thu, 16 Sep 2021 09:43:25 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] openvswitch: Fix condition check by using nla_ok()
Date:   Thu, 16 Sep 2021 01:43:23 +0000
Message-Id: <1631756603-3706451-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowADHzno9oUJh3yyVAA--.47849S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr13GrW5uF1xAry8XF15twb_yoW3AwbEka
        1fKF48X3y2vFnYkr18Gw4qqw1vvw1fWr1F9w17KanrJ340qw45u34DWFWxJr18ur47urZx
        Xw4ayr45Ka17ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUOMKZDUUUU
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just using 'rem > 0' might be unsafe, so it's better
to use the nla_ok() instead.
Because we can see from the nla_next() that
'*remaining' might be smaller than 'totlen'. And nla_ok()
will avoid it happening.

Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/openvswitch/actions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 77d924a..116e38a 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1238,7 +1238,7 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 	const struct nlattr *a;
 	int rem;
 
-	for (a = attr, rem = len; rem > 0;
+	for (a = attr, rem = len; nla_ok(a, rem);
 	     a = nla_next(a, &rem)) {
 		int err = 0;
 
-- 
2.7.4


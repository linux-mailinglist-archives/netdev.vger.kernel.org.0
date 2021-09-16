Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4779740D165
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 03:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhIPBuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 21:50:24 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:47524 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233809AbhIPBuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 21:50:21 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowADn7Xl1okJhgDmVAA--.28835S2;
        Thu, 16 Sep 2021 09:48:38 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] openvswitch: Fix condition check by using nla_ok()
Date:   Thu, 16 Sep 2021 01:48:36 +0000
Message-Id: <1631756916-3759083-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowADn7Xl1okJhgDmVAA--.28835S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr13GrW5uF1xAry8XF15twb_yoWfZrcEka
        n3t3ykW3y2yw4SkF48Jws0yrn2vr1fWrnY9w13KFZxA340qwsxuwn8GFZ7Jr18ur17Zr9x
        Wan3tr1YgF47ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
        0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUChFxUUU
        UU=
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
index 116e38a..8209ab1 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -915,7 +915,7 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
+	for (a = nla_data(attr), rem = nla_len(attr); nla_ok(a, rem);
 	     a = nla_next(a, &rem)) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
-- 
2.7.4


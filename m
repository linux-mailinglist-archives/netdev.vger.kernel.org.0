Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D13740F3BD
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245255AbhIQIJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 04:09:30 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:49028 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245122AbhIQIJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 04:09:25 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowADn7KyzTERhVJzRAA--.3914S2;
        Fri, 17 Sep 2021 16:07:16 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v2] openvswitch: Fix condition check in do_execute_actions() by using nla_ok()
Date:   Fri, 17 Sep 2021 08:07:14 +0000
Message-Id: <1631866034-3869133-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: zQCowADn7KyzTERhVJzRAA--.3914S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr13GrW5uF1xWw48WFW5trb_yoWkXFcEkw
        s3KF1kXw42yrn5Kr48KwsYqw1vvr13Gr1F9wn8KFWay3sYqws8uws8GrZ3Jr18ur429F98
        Xw43Ar4Yga13ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbc8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8ZwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUeHUDDUUUU
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
For example, ovs_dp_process_packet() -> ovs_execute_actions()
-> do_execute_actions(), and attr comes from OVS_CB(skb)->input_vport,
which restores the received packet from the user space.

Fixes: ccb1352e76cff0524e7ccb2074826a092dd13016
('net: Add Open vSwitch kernel components.')
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/openvswitch/actions.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 77d924a..c23537f 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1238,8 +1238,7 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 	const struct nlattr *a;
 	int rem;
 
-	for (a = attr, rem = len; rem > 0;
-	     a = nla_next(a, &rem)) {
+	nla_for_each_attr(a, attr, len, rem) {
 		int err = 0;
 
 		switch (nla_type(a)) {
-- 
2.7.4


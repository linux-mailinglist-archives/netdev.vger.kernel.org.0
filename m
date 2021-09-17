Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A1A40F40F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245118AbhIQI0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 04:26:51 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:58466 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243768AbhIQI0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 04:26:50 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowACXna3bUERhrgjSAA--.4111S2;
        Fri, 17 Sep 2021 16:24:59 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH 2/2] openvswitch: Fix condition check in output_userspace() by using nla_ok()
Date:   Fri, 17 Sep 2021 08:24:58 +0000
Message-Id: <1631867098-3891002-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: zQCowACXna3bUERhrgjSAA--.4111S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtr13GrW5uF1xWw48WFW5trb_yoW8JrW7p3
        Z293yUKrykA3W09w4kCw1vg348Ka4UZrWjga4DXw4SvFnxGw1vvFyvqr4F9r1UJFWUAa90
        qrykZr18Xan7ZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r43
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjNJ55UUUU
        U==
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
-> do_execute_actions() -> output_userspace(), and attr comes
from OVS_CB(skb)->input_vport,which restores the received packet
from the user space.

Fixes: ccb1352e76cff0524e7ccb2074826a092dd13016
('net: Add Open vSwitch kernel components.')
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/openvswitch/actions.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index c23537f..e8236dd 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -915,8 +915,7 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 	upcall.cmd = OVS_PACKET_CMD_ACTION;
 	upcall.mru = OVS_CB(skb)->mru;
 
-	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-	     a = nla_next(a, &rem)) {
+	nla_for_each_nested(a, attr, rem) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;
-- 
2.7.4


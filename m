Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB94560DB50
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 08:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiJZGc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 02:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJZGc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 02:32:28 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF4CA8791;
        Tue, 25 Oct 2022 23:32:27 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MxzS32rRgzJnGD;
        Wed, 26 Oct 2022 14:29:39 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 26 Oct
 2022 14:32:23 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <toke@kernel.org>, <alexander@wetzel-home.de>, <nbd@nbd.name>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net,v3] wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
Date:   Wed, 26 Oct 2022 14:39:59 +0800
Message-ID: <20221026063959.177813-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device is running and the interface status is changed, the gpf issue
is triggered. The problem triggering process is as follows:
Thread A:                           Thread B
ieee80211_runtime_change_iftype()   process_one_work()
    ...                                 ...
    ieee80211_do_stop()                 ...
    ...                                 ...
        sdata->bss = NULL               ...
        ...                             ieee80211_subif_start_xmit()
                                            ieee80211_multicast_to_unicast
                                    //!sdata->bss->multicast_to_unicast
                                      cause gpf issue

When the interface status is changed, the sending queue continues to send
packets. After the bss is set to NULL, the bss is accessed. As a result,
this causes a general-protection-fault issue.

The following is the stack information:
general protection fault, probably for non-canonical address
0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
Workqueue: mld mld_ifc_work
RIP: 0010:ieee80211_subif_start_xmit+0x25b/0x1310
Call Trace:
<TASK>
dev_hard_start_xmit+0x1be/0x990
__dev_queue_xmit+0x2c9a/0x3b60
ip6_finish_output2+0xf92/0x1520
ip6_finish_output+0x6af/0x11e0
ip6_output+0x1ed/0x540
mld_sendpack+0xa09/0xe70
mld_ifc_work+0x71c/0xdb0
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
Reported-by: syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v3: revise format
v2: replace the netif call with test_bit()
---
 net/mac80211/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a364148149f9..874f2a4d831d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4418,6 +4418,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (likely(!is_multicast_ether_addr(eth->h_dest)))
 		goto normal;
 
+	if (unlikely(!ieee80211_sdata_running(sdata))) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	if (unlikely(ieee80211_multicast_to_unicast(skb, dev))) {
 		struct sk_buff_head queue;
 
-- 
2.17.1


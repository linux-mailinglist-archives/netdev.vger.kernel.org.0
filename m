Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCD061950D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiKDLCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiKDLBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:01:50 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BDC2CC98;
        Fri,  4 Nov 2022 04:01:48 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N3d3n0z11z15MJP;
        Fri,  4 Nov 2022 19:01:41 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 19:01:46 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] wifi: mac80211: fix WARNING in ieee80211_link_info_change_notify()
Date:   Fri, 4 Nov 2022 19:08:56 +0800
Message-ID: <20221104110856.364410-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syz reports the following WARNING:
wlan0: Failed check-sdata-in-driver check, flags: 0x0
WARNING: CPU: 3 PID: 5384 at net/mac80211/main.c:287
ieee80211_link_info_change_notify+0x1c2/0x230
Modules linked in:
RIP: 0010:ieee80211_link_info_change_notify+0x1c2/0x230
Call Trace:
<TASK>
ieee80211_set_mcast_rate+0x3e/0x50
nl80211_set_mcast_rate+0x316/0x650
genl_family_rcv_msg_doit+0x20b/0x300
genl_rcv_msg+0x39f/0x6a0
netlink_rcv_skb+0x13b/0x3b0
genl_rcv+0x24/0x40
netlink_unicast+0x4a2/0x740
netlink_sendmsg+0x83e/0xce0
sock_sendmsg+0xc5/0x100
____sys_sendmsg+0x583/0x690
___sys_sendmsg+0xe8/0x160
__sys_sendmsg+0xbf/0x160
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
</TASK>

The execution process is as follows:
Thread A:
ieee80211_open()
    ieee80211_do_open()
        drv_add_interface()     //set IEEE80211_SDATA_IN_DRIVER flag
...
cfg80211_shutdown_all_interfaces()
    ...
    ieee80211_stop()
        ieee80211_do_stop()
            drv_remove_interface() //clear flag
...
nl80211_set_mcast_rate()
    ieee80211_set_mcast_rate()
        ieee80211_link_info_change_notify()
            check_sdata_in_driver() //WARNING because flag is cleared

When the wlan device stops, the IEEE80211_SDATA_IN_ DRIVER flag is cleared
after the interface is removed. And then after the set mcast rate command
is executed, a WARNING is generated because the flag bit is cleared.

Fixes: 591e73ee3f73 ("wifi: mac80211: properly skip link info driver update")
Reported-by: syzbot+bce2ca140cc00578ed07@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/mac80211/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 46f3eddc2388..8a727b532f77 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -284,6 +284,9 @@ void ieee80211_link_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	if (!changed || sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		return;
 
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
 	if (!check_sdata_in_driver(sdata))
 		return;
 
-- 
2.17.1


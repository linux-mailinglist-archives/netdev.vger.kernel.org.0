Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B832D44FE98
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 07:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhKOGMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 01:12:16 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:59499 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbhKOGML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 01:12:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UwYcpfw_1636956548;
Received: from VM20210331-25.tbsite.net(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0UwYcpfw_1636956548)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Nov 2021 14:09:14 +0800
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     cuibixuan@linux.alibaba.com, johannes@sipsolutions.net,
        davem@davemloft.ne, kuba@kernel.org
Subject: [PATCH -next] mac80211: fix suspicious RCU usage in ieee80211_set_tx_power()
Date:   Mon, 15 Nov 2021 14:09:08 +0800
Message-Id: <1636956548-114723-1-git-send-email-cuibixuan@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix suspicious RCU usage warning:

=============================
WARNING: suspicious RCU usage
5.15.0-syzkaller #0 Not tainted
-----------------------------
net/mac80211/cfg.c:2710 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/3744:
 #0: ffffffff8d199ed0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40
net/netlink/genetlink.c:802
 #1: ffff8880282f8628 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock
include/net/cfg80211.h:5377 [inline]
 #1: ffff8880282f8628 (&rdev->wiphy.mtx){+.+.}-{3:3}, at:
nl80211_set_wiphy+0x1c6/0x2c20 net/wireless/nl80211.c:3287

stack backtrace:
CPU: 0 PID: 3744 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ieee80211_set_tx_power+0x74c/0x860 net/mac80211/cfg.c:2710
 rdev_set_tx_power net/wireless/rdev-ops.h:580 [inline]
 nl80211_set_wiphy+0xd5b/0x2c20 net/wireless/nl80211.c:3384
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzbot+79fbc232a705a30d93cd@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
---
 net/mac80211/cfg.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1ab8483..14fbe9e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2702,14 +2702,19 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	enum nl80211_tx_power_setting txp_type = type;
 	bool update_txp_type = false;
 	bool has_monitor = false;
+	int ret = 0;
+
+	rtnl_lock();
 
 	if (wdev) {
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
 			sdata = rtnl_dereference(local->monitor_sdata);
-			if (!sdata)
-				return -EOPNOTSUPP;
+			if (!sdata) {
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
 		}
 
 		switch (type) {
@@ -2719,8 +2724,10 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 			break;
 		case NL80211_TX_POWER_LIMITED:
 		case NL80211_TX_POWER_FIXED:
-			if (mbm < 0 || (mbm % 100))
-				return -EOPNOTSUPP;
+			if (mbm < 0 || (mbm % 100)) {
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
 			sdata->user_power_level = MBM_TO_DBM(mbm);
 			break;
 		}
@@ -2732,7 +2739,7 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 
 		ieee80211_recalc_txpower(sdata, update_txp_type);
 
-		return 0;
+		goto out;
 	}
 
 	switch (type) {
@@ -2742,8 +2749,10 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 		break;
 	case NL80211_TX_POWER_LIMITED:
 	case NL80211_TX_POWER_FIXED:
-		if (mbm < 0 || (mbm % 100))
-			return -EOPNOTSUPP;
+		if (mbm < 0 || (mbm % 100)) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
 		local->user_power_level = MBM_TO_DBM(mbm);
 		break;
 	}
@@ -2778,7 +2787,9 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 		}
 	}
 
-	return 0;
+out:
+	rtnl_unlock();
+	return ret;
 }
 
 static int ieee80211_get_tx_power(struct wiphy *wiphy,
-- 
1.8.3.1


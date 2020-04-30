Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AD11C096B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgD3Vdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:44 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52689 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgD3Vdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:43 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MOz8O-1jp8650rV6-00PM3H; Thu, 30 Apr 2020 23:32:29 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org
Subject: [PATCH 07/15] drop_monitor: work around gcc-10 stringop-overflow warning
Date:   Thu, 30 Apr 2020 23:30:49 +0200
Message-Id: <20200430213101.135134-8-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Jvut3fuVCUJStyT2q/5j1FYj+ej7s7opv8+9Oq4TJu02Tw+aA3n
 fymY+dPKzN4cscCrfqeujzfQhh7XUAPiYqE+axWnneSN6KYsU808BNL/FpTLvtEcsV0uZJH
 Q7FfUhb0HrUA671OUFRqaXIObfmoYffIkQ8W1hmkSEnKz3TKdQ30AdFaPxU5u2mFU1i5Ghv
 xUAw6yB8Hm+dnqJJeoDzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:c9XiUSyQeWo=:GT4r7caaWoRR/d1E5gTP0x
 G3xIjNlLitaH8+kRIOy1cEJzYv9OGYAIO6hwLIEA78jvm0bRI4ZDOMnXkmfnnMSVYmHpC2wNr
 4fq/J4ZZwXxADMJa7eKdtWCpT2qteOG2m5u50ed0V43EojNydrh2UauJdC0KMOfNKm0/Nkzuc
 2Qk9z4l+aK+9UFYkZPpRPXs2vhUeTHB+2WZ1hPbn/FuJo5mRAh1foc6+mckjXCadKSMygsdbZ
 leVT7V6RkouzTxFzxgGDgCIUeelR/BHY4i1uTTB7ybytngHZi0ODLbJwt56+1S7YlwpQ8HRKn
 CcyDx87UJ/EK2MEu2pa62OnkRl3+4abtC+S/yfTT5ZSjqunvxET4pDMYsC4PjGNw1pceL+oy/
 Un+gWCFzLv3gKsDTpWih6NHb5LPBAhyBW2Nz8/M7Pbk464PKvn2FVCFoyV8SeCqFdoiR0wCFe
 qeBtZC4PGZDAnTwJydK323R+83VNWuxbQji7SQbO+bvkp8glDT3QjcHUHFu6bNScJaziosGwq
 143pJ3bo8bEE+sEkVfX426YmU2g50KFuGKQfXbfttJItke93T6z30h2oVjKdTP6f6VrMffNNP
 dcXCCDv7oXM+qEpLEDPUFXRqoJsydwTg45ddaxAApal9T7uTb/H1x8bmjv/pKO0l9Ipn+QjoE
 ONZA8QkND0UV4SZbtI6iFJan0OjoVRU80gK690hdAQHZLbFn6f4A+AeAzIsynJl0Y4TDQfhlG
 7c9/da+A5uMxRiXme95Fuq8Gw0br+44FSXyeY9JXU/nuUj99FpsLi8uUsgG7qBkHsxa2ld5O5
 FjhYyOcCP9AJ7peLoaZIz523vofjuuou/y3DUZ5NIriwq6HMHA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current gcc-10 snapshot produces a false-positive warning:

net/core/drop_monitor.c: In function 'trace_drop_common.constprop':
cc1: error: writing 8 bytes into a region of size 0 [-Werror=stringop-overflow=]
In file included from net/core/drop_monitor.c:23:
include/uapi/linux/net_dropmon.h:36:8: note: at offset 0 to object 'entries' with size 4 declared here
   36 |  __u32 entries;
      |        ^~~~~~~

I reported this in the gcc bugzilla, but in case it does not get
fixed in the release, work around it by using a temporary variable.

Fixes: 9a8afc8d3962 ("Network Drop Monitor: Adding drop monitor implementation & Netlink protocol")
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94881
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/core/drop_monitor.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 8e33cec9fc4e..2ee7bc4c9e03 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -213,6 +213,7 @@ static void sched_send_work(struct timer_list *t)
 static void trace_drop_common(struct sk_buff *skb, void *location)
 {
 	struct net_dm_alert_msg *msg;
+	struct net_dm_drop_point *point;
 	struct nlmsghdr *nlh;
 	struct nlattr *nla;
 	int i;
@@ -231,11 +232,13 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	nlh = (struct nlmsghdr *)dskb->data;
 	nla = genlmsg_data(nlmsg_data(nlh));
 	msg = nla_data(nla);
+	point = msg->points;
 	for (i = 0; i < msg->entries; i++) {
-		if (!memcmp(&location, msg->points[i].pc, sizeof(void *))) {
-			msg->points[i].count++;
+		if (!memcmp(&location, &point->pc, sizeof(void *))) {
+			point->count++;
 			goto out;
 		}
+		point++;
 	}
 	if (msg->entries == dm_hit_limit)
 		goto out;
@@ -244,8 +247,8 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	 */
 	__nla_reserve_nohdr(dskb, sizeof(struct net_dm_drop_point));
 	nla->nla_len += NLA_ALIGN(sizeof(struct net_dm_drop_point));
-	memcpy(msg->points[msg->entries].pc, &location, sizeof(void *));
-	msg->points[msg->entries].count = 1;
+	memcpy(point->pc, &location, sizeof(void *));
+	point->count = 1;
 	msg->entries++;
 
 	if (!timer_pending(&data->send_timer)) {
-- 
2.26.0


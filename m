Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6D34944C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhCYOjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:39:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14545 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhCYOjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:39:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5njT3QJyzPlvv;
        Thu, 25 Mar 2021 22:36:29 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.177.129) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 22:38:54 +0800
From:   'Qiheng Lin <linqiheng@huawei.com>
To:     <linqiheng@huawei.com>, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] cfg80211: regulatory: use DEFINE_SPINLOCK() for spinlock
Date:   Thu, 25 Mar 2021 22:38:54 +0800
Message-ID: <20210325143854.13186-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.174.177.129]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiheng Lin <linqiheng@huawei.com>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 net/wireless/reg.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 21536c48deec..1c14f4d30344 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -126,7 +126,7 @@ static int reg_num_devs_support_basehint;
  * is relevant for all registered devices.
  */
 static bool reg_is_indoor;
-static spinlock_t reg_indoor_lock;
+static DEFINE_SPINLOCK(reg_indoor_lock);
 
 /* Used to track the userspace process controlling the indoor setting */
 static u32 reg_is_indoor_portid;
@@ -210,11 +210,11 @@ static struct regulatory_request *get_last_request(void)
 
 /* Used to queue up regulatory hints */
 static LIST_HEAD(reg_requests_list);
-static spinlock_t reg_requests_lock;
+static DEFINE_SPINLOCK(reg_requests_lock);
 
 /* Used to queue up beacon hints for review */
 static LIST_HEAD(reg_pending_beacons);
-static spinlock_t reg_pending_beacons_lock;
+static DEFINE_SPINLOCK(reg_pending_beacons_lock);
 
 /* Used to keep track of processed beacon hints */
 static LIST_HEAD(reg_beacon_list);
@@ -4262,10 +4262,6 @@ int __init regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
-	spin_lock_init(&reg_requests_lock);
-	spin_lock_init(&reg_pending_beacons_lock);
-	spin_lock_init(&reg_indoor_lock);
-
 	rcu_assign_pointer(cfg80211_regdomain, cfg80211_world_regdom);
 
 	user_alpha2[0] = '9';


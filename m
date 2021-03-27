Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7D34B5E7
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 11:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhC0KAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 06:00:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14935 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhC0J7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 05:59:40 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6vRC3gNpzkgkG;
        Sat, 27 Mar 2021 17:57:59 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 17:59:30 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] mac80211_hwsim: use DEFINE_SPINLOCK() for spinlock
Date:   Sat, 27 Mar 2021 17:59:20 +0800
Message-ID: <1616839160-6654-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guobin Huang <huangguobin4@huawei.com>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index fa7d4c20dc13..d56d2095a0d4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -596,7 +596,7 @@ static const struct nl80211_vendor_cmd_info mac80211_hwsim_vendor_events[] = {
 	{ .vendor_id = OUI_QCA, .subcmd = 1 },
 };
 
-static spinlock_t hwsim_radio_lock;
+static DEFINE_SPINLOCK(hwsim_radio_lock);
 static LIST_HEAD(hwsim_radios);
 static struct rhashtable hwsim_radios_rht;
 static int hwsim_radio_idx;
@@ -763,7 +763,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 /* MAC80211_HWSIM virtio queues */
 static struct virtqueue *hwsim_vqs[HWSIM_NUM_VQS];
 static bool hwsim_virtio_enabled;
-static spinlock_t hwsim_virtio_lock;
+static DEFINE_SPINLOCK(hwsim_virtio_lock);
 
 static void hwsim_virtio_rx_work(struct work_struct *work);
 static DECLARE_WORK(hwsim_virtio_rx, hwsim_virtio_rx_work);
@@ -4410,8 +4410,6 @@ static struct virtio_driver virtio_hwsim = {
 
 static int hwsim_register_virtio_driver(void)
 {
-	spin_lock_init(&hwsim_virtio_lock);
-
 	return register_virtio_driver(&virtio_hwsim);
 }
 
@@ -4440,8 +4438,6 @@ static int __init init_mac80211_hwsim(void)
 	if (channels < 1)
 		return -EINVAL;
 
-	spin_lock_init(&hwsim_radio_lock);
-
 	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
 	if (err)
 		return err;


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0649234DE51
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhC3CY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:24:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15388 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhC3CYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:24:42 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8YBp1hwNzmVBQ;
        Tue, 30 Mar 2021 10:22:58 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 10:24:28 +0800
From:   Shixin Liu <liushixin2@huawei.com>
To:     Karsten Keil <isdn@linux-pingi.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shixin Liu <liushixin2@huawei.com>
Subject: [PATCH -next v2 1/2] mISDN: Use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 30 Mar 2021 10:24:14 +0800
Message-ID: <20210330022416.528300-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Changelog:
From v1:
1. fix the mistake reported by kernel test robot.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 7 ++-----
 drivers/isdn/mISDN/dsp_core.c          | 3 +--
 drivers/isdn/mISDN/l1oip_core.c        | 3 +--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 14092152b786..4f7eaa17fb27 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -173,13 +173,13 @@
 #define	MAX_FRAGS	(32 * MAX_CARDS)
 
 static LIST_HEAD(HFClist);
-static spinlock_t HFClock; /* global hfc list lock */
+static DEFINE_SPINLOCK(HFClock); /* global hfc list lock */
 
 static void ph_state_change(struct dchannel *);
 
 static struct hfc_multi *syncmaster;
 static int plxsd_master; /* if we have a master card (yet) */
-static spinlock_t plx_lock; /* may not acquire other lock inside */
+static DEFINE_SPINLOCK(plx_lock); /* may not acquire other lock inside */
 
 #define	TYP_E1		1
 #define	TYP_4S		4
@@ -5480,9 +5480,6 @@ HFCmulti_init(void)
 	printk(KERN_DEBUG "%s: IRQ_DEBUG IS ENABLED!\n", __func__);
 #endif
 
-	spin_lock_init(&HFClock);
-	spin_lock_init(&plx_lock);
-
 	if (debug & DEBUG_HFCMULTI_INIT)
 		printk(KERN_DEBUG "%s: init entered\n", __func__);
 
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 4946ea14bf74..8766095cd6e7 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -176,7 +176,7 @@ MODULE_LICENSE("GPL");
 
 /*int spinnest = 0;*/
 
-spinlock_t dsp_lock; /* global dsp lock */
+DEFINE_SPINLOCK(dsp_lock); /* global dsp lock */
 struct list_head dsp_ilist;
 struct list_head conf_ilist;
 int dsp_debug;
@@ -1169,7 +1169,6 @@ static int __init dsp_init(void)
 	printk(KERN_INFO "mISDN_dsp: DSP clocks every %d samples. This equals "
 	       "%d jiffies.\n", dsp_poll, dsp_tics);
 
-	spin_lock_init(&dsp_lock);
 	INIT_LIST_HEAD(&dsp_ilist);
 	INIT_LIST_HEAD(&conf_ilist);
 
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index facbd886ee1c..62fad8f1fc42 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -229,7 +229,7 @@
 static const char *l1oip_revision = "2.00";
 
 static int l1oip_cnt;
-static spinlock_t l1oip_lock;
+static DEFINE_SPINLOCK(l1oip_lock);
 static struct list_head l1oip_ilist;
 
 #define MAX_CARDS	16
@@ -1441,7 +1441,6 @@ l1oip_init(void)
 	       l1oip_revision);
 
 	INIT_LIST_HEAD(&l1oip_ilist);
-	spin_lock_init(&l1oip_lock);
 
 	if (l1oip_4bit_alloc(ulaw))
 		return -ENOMEM;
-- 
2.25.1


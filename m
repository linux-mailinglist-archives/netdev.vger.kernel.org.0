Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C831DDF00
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgEVEuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:50:10 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:20408 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726286AbgEVEuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 00:50:09 -0400
Received: from localhost.localdomain (unknown [222.205.77.158])
        by mail-app3 (Coremail) with SMTP id cC_KCgDHz4vEWcdejwXvAA--.20232S4;
        Fri, 22 May 2020 12:49:11 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Guy Mishol <guym@ti.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: fix runtime pm imbalance in wlcore_irq_locked
Date:   Fri, 22 May 2020 12:49:04 +0800
Message-Id: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDHz4vEWcdejwXvAA--.20232S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZFW7tr1fur17Kry5CrWkCrg_yoW5Xr1rpa
        yIvan2yr4kGF1UWFWUAa1kXa4Sg3WxKFZI9F48G34Syrs0y3s8Zr10qasxtFWrK3ykAFW3
        uF43tFyI9Fyjy37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxE
        wVAFwVW8XwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
        4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU8_MaUUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAg0IBlZdtOQJOAAAsr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When wlcore_fw_status() returns an error code, a pairing
runtime PM usage counter decrement is needed to keep the
counter balanced. It's the same for all error paths after
wlcore_fw_status().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/wireless/ti/wlcore/main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f140f7d7f553..fd3608223f64 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -548,7 +548,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 
 		ret = wlcore_fw_status(wl, wl->fw_status);
 		if (ret < 0)
-			goto out;
+			goto err_ret;
 
 		wlcore_hw_tx_immediate_compl(wl);
 
@@ -565,7 +565,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 			ret = -EIO;
 
 			/* restarting the chip. ignore any other interrupt. */
-			goto out;
+			goto err_ret;
 		}
 
 		if (unlikely(intr & WL1271_ACX_SW_INTR_WATCHDOG)) {
@@ -575,7 +575,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 			ret = -EIO;
 
 			/* restarting the chip. ignore any other interrupt. */
-			goto out;
+			goto err_ret;
 		}
 
 		if (likely(intr & WL1271_ACX_INTR_DATA)) {
@@ -583,7 +583,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 
 			ret = wlcore_rx(wl, wl->fw_status);
 			if (ret < 0)
-				goto out;
+				goto err_ret;
 
 			/* Check if any tx blocks were freed */
 			spin_lock_irqsave(&wl->wl_lock, flags);
@@ -596,7 +596,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 				 */
 				ret = wlcore_tx_work_locked(wl);
 				if (ret < 0)
-					goto out;
+					goto err_ret;
 			} else {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
@@ -604,7 +604,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 			/* check for tx results */
 			ret = wlcore_hw_tx_delayed_compl(wl);
 			if (ret < 0)
-				goto out;
+				goto err_ret;
 
 			/* Make sure the deferred queues don't get too long */
 			defer_count = skb_queue_len(&wl->deferred_tx_queue) +
@@ -617,14 +617,14 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
 			ret = wl1271_event_handle(wl, 0);
 			if (ret < 0)
-				goto out;
+				goto err_ret;
 		}
 
 		if (intr & WL1271_ACX_INTR_EVENT_B) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
 			ret = wl1271_event_handle(wl, 1);
 			if (ret < 0)
-				goto out;
+				goto err_ret;
 		}
 
 		if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
@@ -635,6 +635,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
 	}
 
+err_ret:
 	pm_runtime_mark_last_busy(wl->dev);
 	pm_runtime_put_autosuspend(wl->dev);
 
-- 
2.17.1


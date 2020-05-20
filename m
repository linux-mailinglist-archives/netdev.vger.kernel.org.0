Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA331DB499
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgETNIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:08:42 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:12684 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbgETNIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 09:08:42 -0400
Received: from localhost.localdomain (unknown [222.205.77.158])
        by mail-app2 (Coremail) with SMTP id by_KCgCnHr63K8VezDqOAQ--.14485S4;
        Wed, 20 May 2020 21:08:12 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: fix runtime pm imbalance in __wl1271_op_remove_interface
Date:   Wed, 20 May 2020 21:08:04 +0800
Message-Id: <20200520130806.14789-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgCnHr63K8VezDqOAQ--.14485S4
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWfWFyDZrW5ury3AF48Xrb_yoWDCFb_Gr
        s7ZF1kur4kC34Ikr4UCan8XrW09ryDu3Z5urWIvF9xJayj9rZ5tr1rZ3sxZr4fC3yUuF13
        Jwn8AF15Aa4DujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb6AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxE
        wVAFwVW5GwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWU
        GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI4
        8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4U
        MIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42
        IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUb_gA7UUUUU=
        =
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When wl12xx_cmd_role_disable() returns an error code,
a pairing runtime PM usage counter decrement is needed to
keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/wireless/ti/wlcore/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f140f7d7f553..e6c299efbc2e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2698,12 +2698,16 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 		if (!wlcore_is_p2p_mgmt(wlvif)) {
 			ret = wl12xx_cmd_role_disable(wl, &wlvif->role_id);
-			if (ret < 0)
+			if (ret < 0) {
+				pm_runtime_put_noidle(wl->dev);
 				goto deinit;
+			}
 		} else {
 			ret = wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
-			if (ret < 0)
+			if (ret < 0) {
+				pm_runtime_put_noidle(wl->dev);
 				goto deinit;
+			}
 		}
 
 		pm_runtime_mark_last_busy(wl->dev);
-- 
2.17.1


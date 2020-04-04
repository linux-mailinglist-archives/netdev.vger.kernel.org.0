Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B703B19E2AD
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 06:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgDDETG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 00:19:06 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39564 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgDDETG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 00:19:06 -0400
Received: by mail-pj1-f65.google.com with SMTP id z3so3946269pjr.4;
        Fri, 03 Apr 2020 21:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jJ5b9e4qPAJgAbVgZHLdrIdAW2b8v7VFoTTulR1jNA0=;
        b=arY1kFaZiRrneyV07R04qhlsekwDps6B2wVf+hx5tKmMh58Yr4+ejb1SS17vMR/Yjo
         B9UA3ixNBRi4Uxb6kf7HvNF8waCbfuN8EhdRbQC0R7lC9KghPejDBt9OznW/Xi39VTgq
         dBZ5mzPlMGFRJEAgV9t9pc2ICltUFkBFe8MEvckgROHFBZfhOw6ySwtDLAMSGvupLpLv
         vqPkm5MCYMEYQ+XJhXYsFp3UFvLbzlget4EfRMRtZ3+Zt45yg8h3eT2MGYOb5iN8n/9B
         N2yqI7RI4xiTBPLyiAh17a8VLX+LI25eARO5olGewPX2k14X0nvp33b/n7JmmWl0qx7O
         McQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jJ5b9e4qPAJgAbVgZHLdrIdAW2b8v7VFoTTulR1jNA0=;
        b=kwFFNowEPKwYCTrPTtwcWKK6dhGrDePGTLtT02xoo/vXy2BtiBzc/XLbJaC/c1WTz0
         uEu+HmCxPGZVkqPgzL99G+klGncTOVGXs4cA6uQQgyMAZKBcHsRcBUcBaDIBZxCwDGap
         3tZDm4p85qPe+gg9nUnvyKUc/vPlVr7iWo6ic9ji6Hi2/ZvD3Vpm1TsI6ALNGr3BGlnU
         qaWIxuD1TxMeLNEz0YRgrVeNNYmcc+yMkGZmIuDbXCuDJ3h8SwYeuSmvu44p82PS1c9V
         c2Dra+Woagc/MT+XJEjx80Q0ZCG/pj+TezmQmsx88dOdnVr9T17tDa4ErH/GWFvjw1Zp
         eWdA==
X-Gm-Message-State: AGi0PuYtWFPzLOPz5nXyU8/8Tsjedh/nQUsDPNPvTMRYUz4HdGzLdmXV
        ovv0eH2zpGECR7Qsivl196w=
X-Google-Smtp-Source: APiQypI8PoWpDCUoC4oqB9ahvnF1a7qVZ6AT05orDZ4WN7ptxmZ2RekL0xR15+ycsLBt2CuKqBLwYg==
X-Received: by 2002:a17:902:7788:: with SMTP id o8mr11362156pll.9.1585973944554;
        Fri, 03 Apr 2020 21:19:04 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id m2sm6364403pge.81.2020.04.03.21.19.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Apr 2020 21:19:04 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 2/5] ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
Date:   Sat,  4 Apr 2020 12:18:35 +0800
Message-Id: <20200404041838.10426-3-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200404041838.10426-1-hqjagain@gmail.com>
References: <20200404041838.10426-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free wmi later after cmd urb has been killed, as urb cb will access wmi.

the case reported by syzbot:
https://lore.kernel.org/linux-usb/0000000000000002fc05a1d61a68@google.com
BUG: KASAN: use-after-free in ath9k_wmi_ctrl_rx+0x416/0x500
drivers/net/wireless/ath/ath9k/wmi.c:215
Read of size 1 at addr ffff8881cef1417c by task swapper/1/0

Call Trace:
<IRQ>
ath9k_wmi_ctrl_rx+0x416/0x500 drivers/net/wireless/ath/ath9k/wmi.c:215
ath9k_htc_rx_msg+0x2da/0xaf0
drivers/net/wireless/ath/ath9k/htc_hst.c:459
ath9k_hif_usb_reg_in_cb+0x1ba/0x630
drivers/net/wireless/ath/ath9k/hif_usb.c:718
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786

Reported-and-tested-by: syzbot+5d338854440137ea0fef@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |  5 +++--
 drivers/net/wireless/ath/ath9k/hif_usb.h      |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 10 +++++++---
 drivers/net/wireless/ath/ath9k/wmi.c          |  5 ++++-
 drivers/net/wireless/ath/ath9k/wmi.h          |  3 ++-
 5 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index dd0c32379375..f227e19087ff 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -973,7 +973,7 @@ static int ath9k_hif_usb_alloc_urbs(struct hif_device_usb *hif_dev)
 	return -ENOMEM;
 }
 
-static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
+void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
 {
 	usb_kill_anchored_urbs(&hif_dev->regout_submitted);
 	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
@@ -1341,8 +1341,9 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 
 	if (hif_dev->flags & HIF_USB_READY) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
-		ath9k_htc_hw_free(hif_dev->htc_handle);
 		ath9k_hif_usb_dev_deinit(hif_dev);
+		ath9k_destoy_wmi(hif_dev->htc_handle->drv_priv);
+		ath9k_htc_hw_free(hif_dev->htc_handle);
 	}
 
 	usb_set_intfdata(interface, NULL);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 7846916aa01d..a94e7e1c86e9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -133,5 +133,6 @@ struct hif_device_usb {
 
 int ath9k_hif_usb_init(void);
 void ath9k_hif_usb_exit(void);
+void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev);
 
 #endif /* HTC_USB_H */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d961095ab01f..40a065028ebe 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -931,8 +931,9 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 			   u16 devid, char *product, u32 drv_info)
 {
-	struct ieee80211_hw *hw;
+	struct hif_device_usb *hif_dev;
 	struct ath9k_htc_priv *priv;
+	struct ieee80211_hw *hw;
 	int ret;
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath9k_htc_priv), &ath9k_htc_ops);
@@ -967,7 +968,10 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	return 0;
 
 err_init:
-	ath9k_deinit_wmi(priv);
+	ath9k_stop_wmi(priv);
+	hif_dev = (struct hif_device_usb *)htc_handle->hif_dev;
+	ath9k_hif_usb_dealloc_urbs(hif_dev);
+	ath9k_destoy_wmi(priv);
 err_free:
 	ieee80211_free_hw(hw);
 	return ret;
@@ -982,7 +986,7 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 			htc_handle->drv_priv->ah->ah_flags |= AH_UNPLUGGED;
 
 		ath9k_deinit_device(htc_handle->drv_priv);
-		ath9k_deinit_wmi(htc_handle->drv_priv);
+		ath9k_stop_wmi(htc_handle->drv_priv);
 		ieee80211_free_hw(htc_handle->drv_priv->hw);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index d1f6710ca63b..e7a3127395be 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -112,14 +112,17 @@ struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv)
 	return wmi;
 }
 
-void ath9k_deinit_wmi(struct ath9k_htc_priv *priv)
+void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
 {
 	struct wmi *wmi = priv->wmi;
 
 	mutex_lock(&wmi->op_mutex);
 	wmi->stopped = true;
 	mutex_unlock(&wmi->op_mutex);
+}
 
+void ath9k_destoy_wmi(struct ath9k_htc_priv *priv)
+{
 	kfree(priv->wmi);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 380175d5ecd7..d8b912206232 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -179,7 +179,6 @@ struct wmi {
 };
 
 struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv);
-void ath9k_deinit_wmi(struct ath9k_htc_priv *priv);
 int ath9k_wmi_connect(struct htc_target *htc, struct wmi *wmi,
 		      enum htc_endpoint_id *wmi_ctrl_epid);
 int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
@@ -189,6 +188,8 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 void ath9k_wmi_event_tasklet(unsigned long data);
 void ath9k_fatal_work(struct work_struct *work);
 void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv);
+void ath9k_stop_wmi(struct ath9k_htc_priv *priv);
+void ath9k_destoy_wmi(struct ath9k_htc_priv *priv);
 
 #define WMI_CMD(_wmi_cmd)						\
 	do {								\
-- 
2.17.1


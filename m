Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8595A414E42
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhIVQns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 12:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhIVQnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 12:43:45 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13899C061574;
        Wed, 22 Sep 2021 09:42:14 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m3so14387013lfu.2;
        Wed, 22 Sep 2021 09:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKbAlOc1Wlgw4HYxdNy1uVme/WyrLHbAhGlknTbllXY=;
        b=eyMrjTEzwp1Aq4W+/svDhtPTt1yTmfh7El5bIVpJWXrWnkNKXfH7U7sBpSlQo6MfSZ
         HDakQeZ3fUgNT9tozKNQObuCfadSdJCmGbGOCVM+rPQ/g5u6EBTutCe9YVYj1dt3mbQO
         BkfEiPGOeJwDcVPyyVEiUM3GyiY1Xc1pgk/I2Sn5wM2vJ8B3jSmcNY3BXgkmsUa3a9XW
         QP2TckccwKCTXGZCI0ua6hT81DK2OgU6h+IGOZ/pOyHMjbIh68bd8yefdvLjL3gU3udn
         UY8xDoviAoP6GBwR6sW3+Ok1cbUSP2MOIffijnanx/hEBZfxldEAiVP755+WeXdHxm1n
         +82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKbAlOc1Wlgw4HYxdNy1uVme/WyrLHbAhGlknTbllXY=;
        b=vSquOqm3Bb2c22DpvCp+4c9QF+haU2soPGu0+tf8wNF1NUuG9sslfn5Sh/UC/sgnuR
         bjzF4s7Iv6hfrZb4+6RnI+WFt0GK0oY7beucH9wxgeBGXOfgOOVaY09XbMYJVTjckkmd
         68Ye94mD2e65p5gJI9R+vMrBMBqtJbTCYvnjdqgYXs9KpyPTnVVCpSDTEc5AkpOAom2k
         GH7LUX/mAVIzzGSm2ghOiub68qKdNFPamOV2OtNZwckMoQkeMcKBxqQMNwK9Eiprn3dq
         B2DaotHIsfF13FNVAVZ3WF3zaxNGFKjWB2bwSgCNFb/gMjibgI5ZyHN7TJlF+iyPqpRb
         tdMg==
X-Gm-Message-State: AOAM5304YNJ6L1ol1Hzd6FbKObewzpldfPUQ306uPR2xK/sppkxPGNvb
        5GGDBQLjY2AEWYzGnu8pYFk=
X-Google-Smtp-Source: ABdhPJz7To6brLb+kZPYEp3gIZsc155MjryodCTCWDwyOXbQlRqN3tOncpVdU/Oa3pmBk91XHK8iXQ==
X-Received: by 2002:a2e:94d0:: with SMTP id r16mr151073ljh.403.1632328932293;
        Wed, 22 Sep 2021 09:42:12 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.49])
        by smtp.gmail.com with ESMTPSA id y11sm215791lfs.135.2021.09.22.09.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:42:11 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, Sujith.Manoharan@atheros.com,
        linville@tuxdriver.com, vasanth@atheros.com,
        senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: [PATCH RESEND] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Wed, 22 Sep 2021 19:42:04 +0300
Message-Id: <20210922164204.32680-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <4e1374b1-74e4-22ea-d5e0-7cf592a0b65b@gmail.com>
References: <4e1374b1-74e4-22ea-d5e0-7cf592a0b65b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
problem was in incorrect htc_handle->drv_priv initialization.

Probable call trace which can trigger use-after-free:

ath9k_htc_probe_device()
  /* htc_handle->drv_priv = priv; */
  ath9k_htc_wait_for_target()      <--- Failed
  ieee80211_free_hw()		   <--- priv pointer is freed

<IRQ>
...
ath9k_hif_usb_rx_cb()
  ath9k_hif_usb_rx_stream()
   RX_STAT_INC()		<--- htc_handle->drv_priv access

In order to not add fancy protection for drv_priv we can move
htc_handle->drv_priv initialization at the end of the
ath9k_htc_probe_device() and add helper macro to make
all *_STAT_* macros NULL save.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Why resend?
	No activity on this patch since 8/6/21, Kalle Valo has asked around,
	for review and no one claimed it.

Resend changes:
	1. Rebased on top of v5.15-rc2
	2. Removed clean ups for macros
	3. Added 1 more syzbot tag, since this patch has passed 2 syzbot
	tests

---
 drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e67..c8cde2e05d77 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -325,11 +325,11 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-
-#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
+#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
+#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
 #define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
 
 #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index ff61ae34ecdf..07ac88fb1c57 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -944,7 +944,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	priv->hw = hw;
 	priv->htc = htc_handle;
 	priv->dev = dev;
-	htc_handle->drv_priv = priv;
 	SET_IEEE80211_DEV(hw, priv->dev);
 
 	ret = ath9k_htc_wait_for_target(priv);
@@ -965,6 +964,8 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	if (ret)
 		goto err_init;
 
+	htc_handle->drv_priv = priv;
+
 	return 0;
 
 err_init:
-- 
2.33.0


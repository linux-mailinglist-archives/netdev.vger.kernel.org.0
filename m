Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E9552737A
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiENSpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 14:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiENSpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 14:45:01 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A28E1117;
        Sat, 14 May 2022 11:45:00 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id c24so10138825lfv.11;
        Sat, 14 May 2022 11:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sGNsATsttLrQN6yFZVw9J2o2nuVB9fwwv1XFBbtqxw=;
        b=LbepHiW6KnrzVzxIb4gpIJqWoOWL8+fF9rR+Gu39yYYuPb2ro+keCEb34PXAyiRjmf
         IB/BRVjBbv0Z+/RPmFzZPxsLxs1Ilo97pcJ1DrI79c9dBS+LzYEyUXG5vnekwhXbd563
         2GTQd7xaXSzWA+e9PKneybiWnIq0pq6RdNo6C/kuh8FeWT19ZJ/cPSvbRSvW+1GtAwOu
         Ojq8vkY8icC3hCX3kImIsSghEDZh4FTus2Fej4Me0Hzd65QgWVo56ig/3ICIT4nhZ/+n
         GvOkuhu+rb4O+X79wJkNdB84e1PJ1iH22lUSCgCTYgxSB2UyngjpsuODr+NPH91lCUBn
         iKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sGNsATsttLrQN6yFZVw9J2o2nuVB9fwwv1XFBbtqxw=;
        b=lrAQNywUMaP1QYe71KGfxOLTt7YwGzTjfzDlXplERg66/iixgKm5AbMcOHAxICyhCo
         lgNXbmgrX+z48Buwmy+aYv134pUwbuCvKmC/7522AL/X7W5X39mmE7NtT+j7gFiURn3r
         8OpR9PZck3qTsU6c2fdNkywQTmceAIz9EbK1Ta7gadv26o8BHfHmB2x23RFskiW+HutR
         Pbx+Ewf+TscsDwG9ywKXtqFxi59h8IYOvBEoGDpSBxCUFFVmdaHGjTGIREM9x/D8r7hi
         pJgA04armzb4+2yxIde0No4jMJCCmzoma6KxupHiLWfrHDO2/tP9KBJ924vg7MEIC1IC
         CujQ==
X-Gm-Message-State: AOAM533wD+lqx8hPFFx/lGonMByej5xflaHyT5brmVMl5MRcDH4PHGyS
        /O7iVVRDgcfBJ4rE61QANGw=
X-Google-Smtp-Source: ABdhPJxMDBfAFcxma+huXJPCGN4+VtgZOweYDRpzUMfEBA1YRhiiqbKWifSEDdg9g7xHZdyBjk+Vsw==
X-Received: by 2002:a19:6712:0:b0:472:2512:fd25 with SMTP id b18-20020a196712000000b004722512fd25mr7505149lfc.172.1652553898703;
        Sat, 14 May 2022 11:44:58 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.216])
        by smtp.gmail.com with ESMTPSA id f14-20020a056512360e00b0047255d211e5sm778016lfs.276.2022.05.14.11.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 11:44:57 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: [PATCH v4 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Sat, 14 May 2022 21:44:53 +0300
Message-Id: <f158608e209a6f45c76ec856474a796df93d9dcf.1652553719.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
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
all *_STAT_* macros NULL save, since syzbot has reported related NULL
deref in that macros [1]

Link: https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60 [0]
Link: https://syzkaller.appspot.com/bug?id=b8101ffcec107c0567a0cd8acbbacec91e9ee8de [1]
Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes since v3:
	- s/SAVE/SAFE/
	- Added links to syzkaller reports

Changes since v2:
	- My send-email script forgot, that mailing lists exist.
	  Added back all related lists

Changes since v1:
	- Removed clean-ups and moved them to 2/2

---
 drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6b45e63fae4b..e3d546ef71dd 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,11 +327,11 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-
-#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
+#define __STAT_SAFE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
+#define TX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
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
2.36.0


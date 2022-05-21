Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2EC52FF93
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbiEUV2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiEUV2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:28:07 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920FB3E0CF;
        Sat, 21 May 2022 14:28:06 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id v8so17746926lfd.8;
        Sat, 21 May 2022 14:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gpGc4PWvdd0Ku16U2K86UrENQwWiBW1jDKH2DfDJbx4=;
        b=qFC/3t5mIw1j06sroAe4iPZxWhKR4Ttoun8hMUsSsncOn2blvKZvwL4LMwIhAb21fq
         1lJEWT7nFXCwQ22TrvSl8niO/x7GCzvYadlGZ/RkkijTEBqR5HZByTvaNPOzbT+SsQqE
         BLwTdzjjgE/s58IrkktCX7NeBuPzPe6ZWgymxz93hLMP9ioU2BLmB+mPaI3ad3ChdVBv
         PWy452ydqwmpYpTeOXDaCatfGbuhPS0QFSnjM8FLX6LWnZF6QzgGF1TSlyZWC5wNuIDN
         88Sov2T/GwKXKzvOr7h/8cfi+KsohDPMMVsyZVXgiwAAL99FS52AlOUNm8AgJOzwbOuA
         EIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gpGc4PWvdd0Ku16U2K86UrENQwWiBW1jDKH2DfDJbx4=;
        b=tonHdPEwowUG9Mjb4tiIj6cgvajQt0avh4x4Yjkv9tRL7K8pNzEih2Lu4Vs4DHXinY
         L7SGnK5uTbnK86LBdOyqK9bQJkRNRYedtafeZ8gpEr+rJ9PeRz8Qu0axqSkIJ6Qa7vE+
         PC9aAdyAnJraEGThMYHB0jJhoS3Rl6PjkXue05r0vdjcU5jGMvdYzhsgtObY7QvjbHZF
         SFwSkNY8YLiMysWQz7/1PkFK/LmUdmM1G+rXvXmbP1zpj9gGaTE6zYqaHpLhguVpS0Po
         qtntxBLy55VyLu9KfczA7SO7mp1zphhKXa5YVSUL/iHT4LmCxVl+dtOT5MHzy6LOfdCX
         E9fQ==
X-Gm-Message-State: AOAM530fhgGjzjT0fhxZY4BUa91NzhaS0IT7zwlJddM58HMnkwTpJweP
        vHudKSMYxb4whD0a3HRp4do=
X-Google-Smtp-Source: ABdhPJyQArjM4toQLv9QEuYzRRZNB4mGZ+iDp0E93zoBd3YTjBWpbzN7TW/zKSgWM7/YMKVFGT79HQ==
X-Received: by 2002:a05:6512:2613:b0:448:5164:689d with SMTP id bt19-20020a056512261300b004485164689dmr11134987lfb.526.1653168484844;
        Sat, 21 May 2022 14:28:04 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.4])
        by smtp.gmail.com with ESMTPSA id c19-20020a056512075300b0047255d21114sm1198577lfs.67.2022.05.21.14.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 14:28:04 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: [PATCH v5 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Sun, 22 May 2022 00:28:01 +0300
Message-Id: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.36.1
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
all *_STAT_* macros NULL safe, since syzbot has reported related NULL
deref in that macros [1]

Link: https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60 [0]
Link: https://syzkaller.appspot.com/bug?id=b8101ffcec107c0567a0cd8acbbacec91e9ee8de [1]
Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes since v4:
	s/save/safe/ in commit message

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
2.36.1


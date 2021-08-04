Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7723E08FD
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 21:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhHDTtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 15:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240780AbhHDTtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 15:49:32 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BD9C06179C;
        Wed,  4 Aug 2021 12:49:01 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id n17so3717811lft.13;
        Wed, 04 Aug 2021 12:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASOAsKnP84Soa+EvAfE9WaDDDUQEnG7AJSiRgY6SW3M=;
        b=dtGQ+bOuqQ52KEfKOBjilAQolDFqagXrTOFCXglo8BWOJoJYtxovrzgRPoa0sIlxap
         TLDesuCepijVH6q1cVz7/JJiRIyEduKvhs6rkoQWW8RxNcIzOLPT6MkB0wj5jnkBbchI
         Nj1crXH6PFfEq4CjTkruw/LxV+lOsY8vafjAgpgOQLv19yXzLmZpV4mWVFR2dWDD2dYj
         lNXYWC2epp8k2QsVskGXL4zPrgtpDk8dV8qguUZy6A1hhtePlXfS3j7lSfEVcEt+Dlf8
         FntBMdUvmUzmHafo3vD2AYNCviAvBp0nQH+ZArQW3Mw7Pxzw56DALfZziAmHGUxbCb5Z
         nJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASOAsKnP84Soa+EvAfE9WaDDDUQEnG7AJSiRgY6SW3M=;
        b=MaMp9IXhDdq962De8cB8TbD3xuELOuqhmv7lvfKXVf6YYP4H3Z5LnPlMVTD9MoU+P+
         hhMk8/Zr7+/Y8iq8EUubTNuT6zQUIL0fw/XoZNPdjENgYs8xFRbLtfYEYg2Svd7X1Uj8
         IyKR35k3x0QYJZl+7JY1nkLgxwcOWV4BB8vIPKPNMnGJw2gXJ2PMk0UtLKSt2FFf3EkX
         v/CTnboPAPQmkusbjM1W8pq0Ew/IYjZUXqO1Ryn0c4inu0dK4b6xpqtv6wOWoUddfTRA
         3Pf9WDctuyoY9Ps+u0CLEhU2TZdWpuBxokz6BZH2t5/dhsCbBsu/MIcyIRC/fVU7jCRb
         4Glw==
X-Gm-Message-State: AOAM532rp68L64xerQGmwKmlJM3PQnjcP1Z9DXia7B/P8SQI+HePqW2R
        BJszO1FqsYvPXR9JE9JmJ6g=
X-Google-Smtp-Source: ABdhPJxwo6c92bd1w4SF0Q4FtGp4ipdF7UKaQjHgATrOVsd8UkCITo+gFdQZXApfgKiX3YymvPrA2A==
X-Received: by 2002:a19:48cf:: with SMTP id v198mr615943lfa.616.1628106538086;
        Wed, 04 Aug 2021 12:48:58 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id d25sm283322lfj.212.2021.08.04.12.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 12:48:57 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, vasanth@atheros.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com
Subject: [PATCH] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Wed,  4 Aug 2021 22:48:41 +0300
Message-Id: <20210804194841.14544-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
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

Also, I made whitespaces clean ups in *_STAT_* macros definitions
to make checkpatch.pl happy.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Hi, ath9k maintainer/developers!

I know, that you do not like changes, that wasn't tested on real
hardware. I really don't access to this one, so I'd like you to test it on
real hardware piece, if you have one. At least, this patch was tested by
syzbot [1]

[1] https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60

---
 drivers/net/wireless/ath/ath9k/htc.h          | 11 ++++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e67..c16b2a482e83 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -326,11 +326,12 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 
-#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
-#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
+#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
+#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
+#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
 
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
2.32.0


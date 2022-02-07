Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A644ACA55
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 21:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbiBGUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 15:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiBGUY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 15:24:26 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E81EC0401DA;
        Mon,  7 Feb 2022 12:24:25 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id c15so21337953ljf.11;
        Mon, 07 Feb 2022 12:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0QZUBGn5Vf3a75LS52BCKhCqw6Mtv6YRAewQwFkN9YU=;
        b=HhaDozkIYW6SQNj1SQEVEcn2tye5SwdgIeieSdv/hIXRvmL1r923vLwDCNEEGwxBgy
         ejLv9/tQuSRFUF6C7yjnA3fjs9L1IZyReulArI7kR7mayrLqFa+Pu+f1s6gYvelTFBt4
         hKPqwWco2L3GIx8GWLseYf5rrUEGQKsJFMY0Jhq9deKERJj8heycEDGAXc6H2Mlq8GUJ
         KWLysWMrukYAbLX/0qbqPZ3ZcmXbbq6Pt85S7Edf48M0a1LqXGXmv5gXzx4AHPW06Sb2
         Tfogob6yzAnGUGavRbX4E61OEUFN9jaWmhYiqYCD3J2RRxJeibyNkh7HBXNBFzbTkg65
         raiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0QZUBGn5Vf3a75LS52BCKhCqw6Mtv6YRAewQwFkN9YU=;
        b=Xrqxxh0nU7e/xPggz6YBaLVbFHCaTbKhA+9J275ZHIqGcCKjL3jZxntApVSNz5NjgC
         21WPRwAVDnZgsw7Y74uGrwUllrtBogWHQGEWuLHAJ7qFvtBVr2XfzND6X0300NaQlSeD
         n6eTzsGgY2iR4zykNjWRY3OSfgllVfaVj/ErKvMlUzdNUquDmsijYtIgBhHcM0ZoP7jM
         pqxBMN0JeI4KuJKe6+bjBxdSC1IPAkMYxmsD01jLZ3OF5Uf9zacjm+fIXaWraa6RdcHS
         NF8pgT/pjVJEivAJv4pLGl536KV3BlqfFQNE4K8uW7EH8l2A3rfoUCJWicxZR+vc6k7e
         BCXw==
X-Gm-Message-State: AOAM531Y7GuYkyLrSM+MC9p0uAhECLXt1iZLj2sSYcIayRP+j5l7NaFz
        A6Gz0MT2e8T25VVi8MDInRo=
X-Google-Smtp-Source: ABdhPJz4tTPcQksNjB3XhXBM2BhaAlFbe5VIPLCf72OHyrbnaTGpDRyfcnx/8nTl/uDcOydHOb1FUw==
X-Received: by 2002:a2e:8447:: with SMTP id u7mr734250ljh.516.1644265463369;
        Mon, 07 Feb 2022 12:24:23 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.201])
        by smtp.gmail.com with ESMTPSA id n16sm1625618lfq.113.2022.02.07.12.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 12:24:22 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, toke@toke.dk,
        linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Mon,  7 Feb 2022 23:24:18 +0300
Message-Id: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
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
index 6b45e63fae4b..141642e5e00d 100644
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
2.34.1


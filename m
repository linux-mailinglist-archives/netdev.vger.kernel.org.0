Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0A549E9E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245269AbiFMUKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244314AbiFMUJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:09:54 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D78327B09;
        Mon, 13 Jun 2022 11:44:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i29so10295937lfp.3;
        Mon, 13 Jun 2022 11:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ZkWwoMHmOjNQD8c/MvUfXL++UZYPGh4KCJsTnGxYJw=;
        b=Z+Yudr03xA3T6wpYkyh8SrfLyupr9tKRPXD2+loi9r1VgLEXt7mHVHwW3LxTRx3VWN
         0Bvs/G/b44NykMzol8sPhaGMPeS8oJn6GsRn+i2F/l4O+alIlH6P3DPJ8S7rZvjyNvKz
         dYQnIrxwajkFFEjZDvcR8XbHf8NjM1vCUwNbFhWOFRiWCJZAWQWUZDBtasCP2EoN9JTX
         8h6DkoP78r1+u6nYjPtm+tFZQwlpq43t0JqtR2xs5CgrCf4Z8QnJuzsHlN7c3fS2NF5t
         JKcqwrHRaWdw72u+q03PA6TDElEccD8O96TnmUiM+VQSveZbykIbyfzovzJP88LmtFk4
         u1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ZkWwoMHmOjNQD8c/MvUfXL++UZYPGh4KCJsTnGxYJw=;
        b=UWorLSM19cgDotaZEjH0SFgId4+9ljX4Srq0dRxAF7AG9hZX+pSVwNGRIGosIzP0vC
         ABXCw79ZKYYY0osJHB50hhxjpjql6s92qaa/Kf2NMPUENAzNsMKiJQsEbi5kKuirMtDd
         8DzAYB68kC+hdJpqvc5iM5+64uqnN7lbkMKQYaZpTMVCzooOoBtsBNdfPCTGwhWjiax9
         mK8OLBYTzIf1cP4Lerwzrdbj2xMpyTmIyfTHkgCg3rOZeVw4DEQhzmfiWRquDfdD7AXa
         4OhZAuG84DPGnVMygUF/UOhZY/L7VQWtJ+OuhyRigQfUwOqGqXHlck5Id74yCNd9ZzGP
         KZig==
X-Gm-Message-State: AJIora/tdi/k58V5Z7swx+oPiTYuaQqZGlKnCCMrEDgUuGKVRrItSLfA
        EFZcNccOCfe5L5+1GbrHyno=
X-Google-Smtp-Source: AGRyM1vgWfFYu5VOKFpQZS6GlNe0ObJ6V5Ly2KIsrTrNXkPdaPRbPZAnYJyJY7yrTN5mYDLInEEhdw==
X-Received: by 2002:a05:6512:31c3:b0:479:3c8a:b39f with SMTP id j3-20020a05651231c300b004793c8ab39fmr680193lfe.111.1655145844744;
        Mon, 13 Jun 2022 11:44:04 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.27])
        by smtp.gmail.com with ESMTPSA id b15-20020ac247ef000000b004787d3cbc67sm1073598lfp.219.2022.06.13.11.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 11:44:02 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Mon, 13 Jun 2022 21:43:59 +0300
Message-Id: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
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

Changes since v5:
	- No changes

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
index 6b45e63fa..e3d546ef7 100644
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
index ff61ae34e..07ac88fb1 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED5D24621D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgHQJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgHQJHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BB9C061389;
        Mon, 17 Aug 2020 02:07:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y10so5622143plr.11;
        Mon, 17 Aug 2020 02:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2IBGDTRlqNvahuHmxcRRXVtAp4AqF0ucZxlKJk+dn2M=;
        b=bUpe3lkHHiWeE9fypq5FMRZVDtUY8VoTccue34JGh/9p2k4OhRzS6BjyY4Bd9qTRiD
         HcbcBOCidPnkUlckjG0pQpPr3SBnPnm+On29sqxfzZdLsl8FQ7OvWGY8atHAg53TIKUP
         Nhm3LAImHY0LceA50ndVDTenrCowNHDuP0rucbFJFtN5rJxnQgq+F+Qtc3cYgh8nXF4H
         hKgi+3LEO2QPnAJoz2HAsTmDwJrUArE1nTbsBra+um9cAwBjBM9gv4zgoaVU4haxTTFW
         SyDjDgB7rO++ebAZ/h9uwZDeZuM5jI4l1DhA2tmsoxy4eKcodtYoitoHwHh61f9+CApm
         x/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2IBGDTRlqNvahuHmxcRRXVtAp4AqF0ucZxlKJk+dn2M=;
        b=ulOpr+TJEwOi8bVZH9JpQH39kUxgQfQq5sSk/a9Sa4zVladYWAjwFGD8RaRC9jY12P
         LLs8R0E/tP3JDTbTEEw2a/GZKcL2MYwpJYCp1WIg8p8A81N90m8RIzmvm2gfJZE1hMym
         L02UewghV+IBcTr/a+X/UxLHh7caNn5NeOzEF/eL710g5+KUnrrKX045aTC6fNW7jQlt
         HZG9krh4wOHUCNRv4gfoQCFbAhnsFqRSI2pIiCUmrqJVmyl+E5LuTG82cdF1jwU0Jv44
         fQErh6ffWSFH40bPcLabNw/fAlfvlOf87arE6/aah6kc5rwptSYrBxyTCb9fbUqCg17n
         bxpw==
X-Gm-Message-State: AOAM533AvG+0NLBTmBsRuHlPmiUwvaBM5++ShhgFegRKnP4kykvfCm6q
        O4mLUI1/yeVWDIgeoOa5JN0=
X-Google-Smtp-Source: ABdhPJzNy7hxGHuoAT9Ds/zo0r/p3Xdwvw7xt6TvMKktGn938rhVPwowpw50RfYo/4rBLuS0/Azjfg==
X-Received: by 2002:a17:902:c111:: with SMTP id 17mr9611024pli.46.1597655260971;
        Mon, 17 Aug 2020 02:07:40 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:40 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 06/16] wireless: b43legacy: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:27 +0530
Message-Id: <20200817090637.26887-7-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 8 +++-----
 drivers/net/wireless/broadcom/b43legacy/pio.c  | 7 +++----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 2eaf481f03f1..15d592cf056c 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1275,9 +1275,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
 }
 
 /* Interrupt handler bottom-half */
-static void b43legacy_interrupt_tasklet(unsigned long data)
+static void b43legacy_interrupt_tasklet(struct tasklet_struct *t)
 {
-	struct b43legacy_wldev *dev = (struct b43legacy_wldev *)data;
+	struct b43legacy_wldev *dev = from_tasklet(dev, t, isr_tasklet);
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
@@ -3741,9 +3741,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
 	wldev->wl = wl;
 	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
-	tasklet_init(&wldev->isr_tasklet,
-		     b43legacy_interrupt_tasklet,
-		     (unsigned long)wldev);
+	tasklet_setup(&wldev->isr_tasklet, b43legacy_interrupt_tasklet);
 	if (modparam_pio)
 		wldev->__using_pio = true;
 	INIT_LIST_HEAD(&wldev->list);
diff --git a/drivers/net/wireless/broadcom/b43legacy/pio.c b/drivers/net/wireless/broadcom/b43legacy/pio.c
index cbb761378619..aac413d0f629 100644
--- a/drivers/net/wireless/broadcom/b43legacy/pio.c
+++ b/drivers/net/wireless/broadcom/b43legacy/pio.c
@@ -264,9 +264,9 @@ static int pio_tx_packet(struct b43legacy_pio_txpacket *packet)
 	return 0;
 }
 
-static void tx_tasklet(unsigned long d)
+static void tx_tasklet(struct tasklet_struct *t)
 {
-	struct b43legacy_pioqueue *queue = (struct b43legacy_pioqueue *)d;
+	struct b43legacy_pioqueue *queue = from_tasklet(queue, t, txtask);
 	struct b43legacy_wldev *dev = queue->dev;
 	unsigned long flags;
 	struct b43legacy_pio_txpacket *packet, *tmp_packet;
@@ -331,8 +331,7 @@ struct b43legacy_pioqueue *b43legacy_setup_pioqueue(struct b43legacy_wldev *dev,
 	INIT_LIST_HEAD(&queue->txfree);
 	INIT_LIST_HEAD(&queue->txqueue);
 	INIT_LIST_HEAD(&queue->txrunning);
-	tasklet_init(&queue->txtask, tx_tasklet,
-		     (unsigned long)queue);
+	tasklet_setup(&queue->txtask, tx_tasklet);
 
 	value = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
 	value &= ~B43legacy_MACCTL_BE;
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFA82461F5
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgHQJI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgHQJIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:08:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6063C061347;
        Mon, 17 Aug 2020 02:08:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 74so7896655pfx.13;
        Mon, 17 Aug 2020 02:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O5yUISL0n5UDVWTbrqgSqFJ+8un0wnfOhWT/JxFzWgU=;
        b=THtE6gYBzS3NJNRoDz41V470lbExfVM+Uv76yOpHQy6P0r8xs1svhnqBmf7GsSUyJ9
         0OhkBtZ5PAN6RKOWkeyUSCb3niRwhko+isyeF4gb4C1TJQuCxHie5WSg0euWz8e/64b+
         KfHpmXQAK8npYwyRVZz8g6iK7aanPSsLlin/b0AHzZn0rIkTgZVugtkYB9XIt+g0qlxM
         OIXr/2BJbpundJOcGmWtRGizakuH/mM/jLtAmQYn32O5lGqHO9qZfCVG7JVw7sDijVAq
         0ewRCAbin84he/EdyU/BlWomEAyNc3S6H014rT2rRdNbuj5znR19FV3OLYb/f33A+8XT
         ZkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O5yUISL0n5UDVWTbrqgSqFJ+8un0wnfOhWT/JxFzWgU=;
        b=CpXM5WcHwWbLX9ys7X+tJ/PDnzPqpe1HIVapIYbYQt/R1v7sAoGf7Rl7zpijcMq42I
         Taiw0gp/uRy8p1djkwXv1t0JJ4sLLHDgumTw1zrOxEiUhENw1Y0w3O/Qt8OAo5km/ssk
         xSUtBJSYwfOPZ5DNkH++69sx1ajKBlPI6T4ZAYg/yXFP1jIrVAG3q3NFLzIcWszz4E1V
         s0Bmhnplv4E2OYEj2OExSgo3x9a/vdUvgzq5th+RkraO3N/kmDW1nQyHhCc6BwLCkMIX
         C10fOd8Fs3B7WPc4/bis+GgBrq8vsJZPahaw4t8O63YCx0Ioye06PgjpGG+t+LwPy4DQ
         RFJQ==
X-Gm-Message-State: AOAM532GjMSUdJXOSpVloIEnZlcujT6yTW8aXbtSrqodP6VP5V7DTDzg
        Q+72/YiSNMlCPOUXPuhWAmU=
X-Google-Smtp-Source: ABdhPJx7a7b9XqfiJheNfprZ6SjPVpk7DN4CXcJ6/Hoyh5xc/cTtA43nxillzq8XLt/TaWHc8YdwWQ==
X-Received: by 2002:aa7:9493:: with SMTP id z19mr10706326pfk.190.1597655283311;
        Mon, 17 Aug 2020 02:08:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:08:02 -0700 (PDT)
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
Subject: [PATCH 09/16] wireless: iwlegacy: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:30 +0530
Message-Id: <20200817090637.26887-10-allen.cryptic@gmail.com>
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
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 8 +++-----
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 9167c3d2711d..5fe98bbefc56 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1374,9 +1374,9 @@ il3945_dump_nic_error_log(struct il_priv *il)
 }
 
 static void
-il3945_irq_tasklet(unsigned long data)
+il3945_irq_tasklet(struct tasklet_struct *t)
 {
-	struct il_priv *il = (struct il_priv *)data;
+	struct il_priv *il = from_tasklet(il, t, irq_tasklet);
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -3399,9 +3399,7 @@ il3945_setup_deferred_work(struct il_priv *il)
 
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
-	tasklet_init(&il->irq_tasklet,
-		     il3945_irq_tasklet,
-		     (unsigned long)il);
+	tasklet_setup(&il->irq_tasklet, il3945_irq_tasklet);
 }
 
 static void
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index e73c223a7d28..afc54c63c4c6 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4344,9 +4344,9 @@ il4965_synchronize_irq(struct il_priv *il)
 }
 
 static void
-il4965_irq_tasklet(unsigned long data)
+il4965_irq_tasklet(struct tasklet_struct *t)
 {
-	struct il_priv *il = (struct il_priv *)data;
+	struct il_priv *il = from_tasklet(il, t, irq_tasklet);
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -6238,9 +6238,7 @@ il4965_setup_deferred_work(struct il_priv *il)
 
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
-	tasklet_init(&il->irq_tasklet,
-		     il4965_irq_tasklet,
-		     (unsigned long)il);
+	tasklet_setup(&il->irq_tasklet, il4965_irq_tasklet);
 }
 
 static void
-- 
2.17.1


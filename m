Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A02461EF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgHQJHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgHQJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:25 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84CBC061389;
        Mon, 17 Aug 2020 02:07:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y206so7898279pfb.10;
        Mon, 17 Aug 2020 02:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MGsv8A1wVj28a3UQWL19W4pLCqNK/n7XN47Mle0gRf0=;
        b=g0cmPZRhcILxoEnjZPRTGxSCc+cAfwGWvZIKj7Y+pbzSNHFFO2zTQQN9KYG+34IVwa
         j3TmLzAjPiU619fIp3yeL9Igsl1XpItyWHlMwXbOP7+NgYacG0jRF242DFUmHleurIWx
         3Y9yWFTnEOJRCJ7ZC4Vn5W6OcqD4DBy4D9poqtyW+dZlaE7K1b4SArKNzEJ3d2lbjgOx
         TZUC0SBVVAbOR/qPbgoQgp2C3i3Lg0InJUuvelxpeog5G6YJQfg7UmMBEVCwRQum8OL3
         Pu1TYq++IQhlG3AKR4qVlVTeSx4EWsVGlBlyUvUlbVpvEEs8bNk+kbthRmKlEmH2HNmW
         Qhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MGsv8A1wVj28a3UQWL19W4pLCqNK/n7XN47Mle0gRf0=;
        b=lv5uD/JrecHpt+48D85K+DfMyKdvDVsJj4uxu0QOA8rQ4tcWPj67veTazwVEUwcKsJ
         nCFHAS0PLJ1fNjh/jiqQwzWLm/OKgTtaSZoBYOZHSc8n/PTxAdFpHsOdX9Fb2eCBtyAQ
         XftxlmfoQP42qb3tuxD5lE+bgAm4r+lYRdYYYJz1Bv5u6MZrtG0LVRRxE65fFSlrTWbC
         ZhF4ExoWJjZaVIl63R8AKowj3x/+ceDSwJQ/tx8XmO80HQBuq1xSrJdgCizKW3qcoDSh
         T/1zAA7BEf6xqpS1l03acC/K5ZcXlY1mwqV7029/KU6QQkTe72d0cO0eosJkdsQ9hUXl
         77Dg==
X-Gm-Message-State: AOAM533f6wa75+TdxIP+n1JTLS/GY9cqt3Xf8QoO/GJfl1nuXIrOF0+J
        CiMPo4wq+XSeiN5efWU7hkM=
X-Google-Smtp-Source: ABdhPJyIoQbr9T/8qnWekXPjsOiorbPCvMa//vMXiCVBRpI1R33p2QuX6J5OeDaVuSprkarw2Orp4w==
X-Received: by 2002:a63:3241:: with SMTP id y62mr9589717pgy.305.1597655245210;
        Mon, 17 Aug 2020 02:07:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:24 -0700 (PDT)
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
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 04/16] wireless: ath11k: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:25 +0530
Message-Id: <20200817090637.26887-5-allen.cryptic@gmail.com>
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

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 30092841ac46..28d7e833e27f 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -675,9 +675,9 @@ static void ath11k_ahb_free_irq(struct ath11k_base *ab)
 	ath11k_ahb_free_ext_irq(ab);
 }
 
-static void ath11k_ahb_ce_tasklet(unsigned long data)
+static void ath11k_ahb_ce_tasklet(struct tasklet_struct *t)
 {
-	struct ath11k_ce_pipe *ce_pipe = (struct ath11k_ce_pipe *)data;
+	struct ath11k_ce_pipe *ce_pipe = from_tasklet(ce_pipe, t, intr_tq);
 
 	ath11k_ce_per_engine_service(ce_pipe->ab, ce_pipe->pipe_num);
 
@@ -827,8 +827,7 @@ static int ath11k_ahb_config_irq(struct ath11k_base *ab)
 
 		irq_idx = ATH11K_IRQ_CE0_OFFSET + i;
 
-		tasklet_init(&ce_pipe->intr_tq, ath11k_ahb_ce_tasklet,
-			     (unsigned long)ce_pipe);
+		tasklet_setup(&ce_pipe->intr_tq, ath11k_ahb_ce_tasklet);
 		irq = platform_get_irq_byname(ab->pdev, irq_name[irq_idx]);
 		ret = request_irq(irq, ath11k_ahb_ce_interrupt_handler,
 				  IRQF_TRIGGER_RISING, irq_name[irq_idx],
-- 
2.17.1


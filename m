Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C112845AA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgJFFvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgJFFvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 01:51:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D95EC0613A7;
        Mon,  5 Oct 2020 22:51:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so1017884pjb.5;
        Mon, 05 Oct 2020 22:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HG9ZKAE8Yu52ExRQDDjN81ZIm6yQmKnq3Y0AJ5grKyA=;
        b=ZE35pdO771g061VVZvdcfjKDlEaKTtMv2VvZruNsfJfCANlH+YDd8wjr6DGkxecbAz
         JdT1LLSkyMjrGxzQR4toNXBIWe9B0gGCi56oWxmAby8URbCd6s/YLS6Lmggcev774XpA
         XO+q8IzPHmuKCLov/Rc1y4Lf5zURJzUnoS/0ZH/q5GptNSNToZzAS8PltwTycZ6ip7MT
         6/xusvttVjGrhXt6OVfP5A0idA/mFhTu2HiFR/pQAc2dHalPl/ZyqVtT1XF/xDeNftY5
         Z0hkBvBed0MLnmOkmV/t640uRLLiUvtD3L5CxVWRJ1SFb84AzBXFnexpHROWTdxp6pAx
         rOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HG9ZKAE8Yu52ExRQDDjN81ZIm6yQmKnq3Y0AJ5grKyA=;
        b=ApoqzfKXOSXBHUzdHNdumn+9KkQ3IqlfrJTINazaLgWnBVNwdKGZ6eyf9Ax2QxR89T
         +J5K1xwYLXE6P7ysvNk3HaLTpcCxWgI6zbmRtVIhsidfSLjGy7RHoIku7m9yvbN7eMB2
         rLfWTq8OZz4t7GNq8ZmgFh9WlEMBIsdyB9rFkBttwCZW264LcVNVHeh97x3gkaahdplI
         93pddm6Jmw1RQiqcAuKP8NzQgwwiSDSie6du1gPJcaML88DonTmVb3TFN2OjIrrc/nKn
         EjsH1EbetFmNJPhSmvR6C2MDcSb/yuDq+1maAg8/9srq7qfRlwTdA5L7iuIGmadO+Pf4
         Kw+Q==
X-Gm-Message-State: AOAM533UP+uLXoNI1IHfVi4d7/hRl+3Sp9kVzdnZaN9FGohEdn/Xy7fh
        5i6GbTX0oujg7qHAoazPwlc=
X-Google-Smtp-Source: ABdhPJw08TMPOmdXZyG3xQkc/cspaq8QZ61XkT6c69l9DZxa7bqDYxtbbmAUMNtuStXMz4Mil3GclA==
X-Received: by 2002:a17:90a:7f8c:: with SMTP id m12mr2966652pjl.22.1601963514072;
        Mon, 05 Oct 2020 22:51:54 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id x6sm1413685pjp.25.2020.10.05.22.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 22:51:53 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 1/2] ath11k: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:21:34 +0530
Message-Id: <20201006055135.291411-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006055135.291411-1-allen.lkml@gmail.com>
References: <20201006055135.291411-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/wireless/ath/ath11k/pci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index d7eb6b716..b75f47dc3 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -380,9 +380,9 @@ static void ath11k_pci_sync_ce_irqs(struct ath11k_base *ab)
 	}
 }
 
-static void ath11k_pci_ce_tasklet(unsigned long data)
+static void ath11k_pci_ce_tasklet(struct tasklet_struct *t)
 {
-	struct ath11k_ce_pipe *ce_pipe = (struct ath11k_ce_pipe *)data;
+	struct ath11k_ce_pipe *ce_pipe = from_tasklet(ce_pipe, t, intr_tq);
 
 	ath11k_ce_per_engine_service(ce_pipe->ab, ce_pipe->pipe_num);
 
@@ -581,8 +581,7 @@ static int ath11k_pci_config_irq(struct ath11k_base *ab)
 
 		irq_idx = ATH11K_PCI_IRQ_CE0_OFFSET + i;
 
-		tasklet_init(&ce_pipe->intr_tq, ath11k_pci_ce_tasklet,
-			     (unsigned long)ce_pipe);
+		tasklet_setup(&ce_pipe->intr_tq, ath11k_pci_ce_tasklet);
 
 		ret = request_irq(irq, ath11k_pci_ce_interrupt_handler,
 				  IRQF_SHARED, irq_name[irq_idx],
-- 
2.25.1


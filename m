Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1163285CEF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgJGKdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgJGKdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:33:31 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A36C061755;
        Wed,  7 Oct 2020 03:33:31 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so1120813pgj.3;
        Wed, 07 Oct 2020 03:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HG9ZKAE8Yu52ExRQDDjN81ZIm6yQmKnq3Y0AJ5grKyA=;
        b=e9hD9Og8ygIqfuCpfy3OgSoXmTi3hRHN1uIsUZEY2oi+kh+bEHV3em+CNt62TmC87J
         B4Yta4tMlFRyCBc46R9hrTkonZ1bY3VvPR9wRKCI1Vnoe+BYo1CEzgIeJ52BsSzky++W
         bYAlFMylan/q+9LZzHKbRuiC/vIIAdqkSzODPa3KgBUfK6h+b8zAfZi3qhW/2tZhJyCy
         w1ZPb6d4uA4Uj3uuK8wYrBEC7xuU388xncC2RktPEOTivF93X4I5tcw5AOdxpV80Pf+s
         FYo/++Z16AxQtqB1idjslrbaTFWW2ItKXwANFqas2Xq7q68qc+V59YsS023fYOblBYOR
         Pt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HG9ZKAE8Yu52ExRQDDjN81ZIm6yQmKnq3Y0AJ5grKyA=;
        b=Z3T/87yWmIejEbcsYKiOvTyawolM0UpM3n8wTIgCUURc3EAQd9Kw/PA3I6eRBHe9ey
         u+3c8lrcrAgupofR3vUdvJYXL8Up5XiH0o965lHaLBwaSuZHWj52+wolGFBq5sQNLNKp
         Nh8X+FpfOwcH/Nmy4/iDgsdNCdn4aBNdTaIbV3XnGdZfn+W06Ph9i8kx/T0n2ZzgD/oW
         sq+wZUEjtwpoWDhU+riyTPYWdCUMQPrC3AYI0J1U0ub0yAnWu4elLvczM8f+7dUPZI4Z
         xg5zi7BMfCicVRIXGA9XsVu42bJs4dCGPikWCUEu65p4xiMGKwUPY4zO1XneSrTdpnXB
         shXw==
X-Gm-Message-State: AOAM5303q6+TmRtwqxtvZvshKkfqwGGYUxJaOE8V0FDZV+RKOUhVf/JI
        oCumGkRIpyyujtV6+QS2bZI=
X-Google-Smtp-Source: ABdhPJw2/zeJqETexwSce8Lc2Mbg8nsRB34u08hVBEL7qWLWZ5DIFVo2pnpRv8Khrnnm9nMQAc6xXg==
X-Received: by 2002:a62:178d:0:b029:13e:d13d:a0f8 with SMTP id 135-20020a62178d0000b029013ed13da0f8mr2301077pfx.20.1602066811396;
        Wed, 07 Oct 2020 03:33:31 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id v129sm2705327pfc.76.2020.10.07.03.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:33:30 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 3/3] ath11k: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 16:03:09 +0530
Message-Id: <20201007103309.363737-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007103309.363737-1-allen.lkml@gmail.com>
References: <20201007103309.363737-1-allen.lkml@gmail.com>
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


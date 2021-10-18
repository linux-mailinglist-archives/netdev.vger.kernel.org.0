Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F68B430DCC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 04:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhJRCSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 22:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhJRCSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 22:18:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2493EC06161C;
        Sun, 17 Oct 2021 19:16:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v8so9385053pfu.11;
        Sun, 17 Oct 2021 19:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=vfZ5m9dCYUTSElAaUIqCJIXFIZc+JlCKiynKEZrNeT8=;
        b=kUAZQBLdtfrsxoi1M/Fwj3CRp7k17ntnIxiWRM0iS63V2Gan5TaBEd+rZs3GrNbeWm
         DDGZqGoxBSaPLF7YfnoQxPh/UaMJrNBkoYNZ9di1p5HZ/z+P9RJwRebvYrV09Dbw+WCl
         P86o3QBc4QfEOQebwALnGwLuLQXA+NQdBLf3Zlvqzbr4weBoy4OdTNaLKYoAxC91itgL
         EhvxiR4/7duGv4YZmYG49lsL7M9Y+71gbHkoc6yuNQeATugcd4pV/e4IkhgrIs1KAKYl
         0dOOtjQDn1H+UQz2+CHYcritaPAYAFB8fcQIExDw8CaZvXZRIq/buMin6NGq9jk/SS6k
         mXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vfZ5m9dCYUTSElAaUIqCJIXFIZc+JlCKiynKEZrNeT8=;
        b=60wr8egczv10gRRi79pHyi7PDGgto1rIb9RGmWTGvA/5JfBDxQyoENtM4k+Il/Lv+P
         YuHPRXOYPTMJ7QHQ0uGGSiW4UPDx/FwnZr/tlJxbd72o+E7zgef2eff+3uGr3DeyS5XI
         jfIWsYLq7TIwhK/Zc75HLuW871oFknaaQW4RdmODmFrwZwz9W54JhBQttc2hYHQxL2Hl
         mwoo2lgfxDedm+kamA24MioiiDQgQTmtuxm5xIY5FJ2FJQT+JCiI6h+gwCRP/eSjcgll
         IVUW/nFW82VeNpCZCabceK5VAbgk0ilXk7liN8xccr+2JdtreGUxwSBKUchWTNgnwEac
         56kQ==
X-Gm-Message-State: AOAM530+qPaa09gj0P7N4KTW6QaGRWDmp62h3gacFUghaB7IxGBnxDRA
        dnMf1ZpV5w818/QnUu4e9A==
X-Google-Smtp-Source: ABdhPJxYuf7Zi98BOO5h51Om692IkC67HqHC0AwVaYSIyChcV33ITGGOQ9XMgxlaN2yMpS5pflrRlA==
X-Received: by 2002:a63:f817:: with SMTP id n23mr20962600pgh.250.1634523392626;
        Sun, 17 Oct 2021 19:16:32 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id j6sm2534857pgf.60.2021.10.17.19.16.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Oct 2021 19:16:32 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Mon, 18 Oct 2021 02:16:22 +0000
Message-Id: <1634523382-31553-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/cavium/thunder/nic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nic_main.c b/drivers/net/ethernet/cavium/thunder/nic_main.c
index 691e1475d55e..0fbecd093fa1 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1193,7 +1193,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.17.6


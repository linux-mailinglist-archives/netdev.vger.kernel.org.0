Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82B83AD02E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbhFRQRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235837AbhFRQRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:17:03 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F12C0617AF;
        Fri, 18 Jun 2021 09:14:52 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id d2so14744155ljj.11;
        Fri, 18 Jun 2021 09:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pmmBYlRHWMosP77C0Ii9Ste9VmkpwQxWPopXChKoX8U=;
        b=MiWyikh06egv+CM+dP0DpbAtt8nVnjcXBSwZfudsgaHkFKpVWZdO1XgMC8Vfqv87yF
         kXEDIHkcjUwTI3NI9TFzFxLPuqWp0a0Zizi60a09ip1Fse/VqAclrZd685Gtc+gFfEMh
         gd8XYo8ZB+Wq7C4e1mB0k53cCnvLWXZHV/hTYCuhPj+j674yehtwuJah9zH3TYCqY/21
         jMDkvaf6/wOEd+3cFQRNJsTDAXgeg++xj+y6mj+uzQwo0UttB/pAaStzyqKAgWHYcLHu
         hZp1buRIco2EGghQKo4zLSdT4HQhOVOxrbCgqGkZ9pcVs6sBUZbQVSlQ0Ys8t5paX6tb
         JvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pmmBYlRHWMosP77C0Ii9Ste9VmkpwQxWPopXChKoX8U=;
        b=poCW0ESlWt7tdrWLKmf2rvlExD7SlWa02po/Qi8kXQXzWM7lHjvXj02KaP3qrSD45M
         ozSK8SfiFCyJ3dOyhErroT9Z3ZKNQWuHdU5JqET63aqMuvmxEObbNCGuyhtUESEz8P4a
         Uwm2IVMSXeJDAfsnkeoYXGq7yQzVfGBxaYiiWQVYw9MziABOO0Q4PawHZinG0d8yHa25
         nuPwPAq3G7xnwnn9HJ1v8V9LuN4BFLAG/bUdanlKgBVQlwK9thAhDIYSuBJcpiAs9sdQ
         jkJb367HEAn34NEi4erOMPDDrqWjQOfm/jkQdWyvdgjobVKj4Vf9SPvrYERmaH0vzVLF
         Nhdg==
X-Gm-Message-State: AOAM532Gmq55VOITAND5yekRpe0HEKFs/fQUikSzth/h57Tpf5uG7WI3
        PP4YfgnH26a7j5g0R/uBo2k=
X-Google-Smtp-Source: ABdhPJxfdpCMQB64fi+Tq38fP/1PEKy84mwF7jCmbBdPM+AUz90aStt4Wp6ix1eYPrqW3yEixSjXqg==
X-Received: by 2002:a05:651c:201d:: with SMTP id s29mr10262196ljo.258.1624032890195;
        Fri, 18 Jun 2021 09:14:50 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id h19sm951025lfc.225.2021.06.18.09.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:14:49 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        michael@walle.cc, abrodkin@synopsys.com, talz@ezchip.com,
        noamc@ezchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 3/3] net: ethernet: ezchip: fix error handling
Date:   Fri, 18 Jun 2021 19:14:47 +0300
Message-Id: <422b1921ce3ff8f29da93d9a2c99e1d34cf66c77.1624032669.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624032669.git.paskripkin@gmail.com>
References: <cover.1624032669.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As documented at drivers/base/platform.c for platform_get_irq:

 * Gets an IRQ for a platform device and prints an error message if finding the
 * IRQ fails. Device drivers should check the return value for errors so as to
 * not pass a negative integer value to the request_irq() APIs.

So, the driver should check that platform_get_irq() return value
is _negative_, not that it's equal to zero, because -ENXIO (return
value from request_irq() if irq was not found) will
pass this check and it leads to passing negative irq to request_irq()

Fixes: 0dd077093636 ("NET: Add ezchip ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index c562a1e83913..f9a288a6ec8c 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -607,7 +607,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 
 	/* Get IRQ number */
 	priv->irq = platform_get_irq(pdev, 0);
-	if (!priv->irq) {
+	if (priv->irq < 0) {
 		dev_err(dev, "failed to retrieve <irq Rx-Tx> value from device tree\n");
 		err = -ENODEV;
 		goto out_netdev;
-- 
2.32.0


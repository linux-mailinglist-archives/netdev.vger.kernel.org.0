Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E02B0F2F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgKLUrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKLUrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 15:47:46 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B00C0613D1;
        Thu, 12 Nov 2020 12:47:46 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id v143so6809682qkb.2;
        Thu, 12 Nov 2020 12:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=36FLese2veI3iWY1QIV+jskXlXxefI3GQpE+1eH4p2M=;
        b=N242L88XsM3GRxlJ2PrswON7oLbOaXDRPkFkUypxgYjX70C2zM4TZ4z24sFdgzA5wO
         AGb9xNXSszor6MsYuSNJDjb5UZbLxVDyNYmvpqHyIXF8jkwegXAW+Chhn/nyIxtCb3oU
         H+EXURpITkmZlqTUEBwnNrgANQE1shcem8X9KTHmNIJEBmSlW/zYHzq8xl44thxor6IU
         sb/C91xxIwysSeTGnith13BHsiyF2THFRKtg4pn1R3shTmpX0kY4V6xuM6EhN9dX0UeO
         oRUNk7rR4kBHi4VudSvjH1yRt3n/E8rGLJWguEH0kEdXoB/VEQmS98RdPH8/mgbPKfcX
         M+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=36FLese2veI3iWY1QIV+jskXlXxefI3GQpE+1eH4p2M=;
        b=Mq3h1bDmwyfPuCzMGIPLjuFRgY98qTmVF9fTjO9wAM4ziwUzizNsW/dPRXh2tNT680
         5mc/zDmFbsQfDXJ2c+u9D2T1QJ9mCdk+Jh58uOBpotPy8/Ht3hhfJd7NFEbFjgHd+nRJ
         zGQeNez+Mfvht1xDDcIFJya14EXYmJkqse3XfBoezIaq8RpMLl3QgoI1aOvqCK304ymS
         KEKK/7bLzhtwQRFoCpBKlLRjCH2MVF72B0MsAGOwK2NuovB/xPxzoG92b78mhIyXr2nt
         0rvHku8uURijhe35LAJQkCkuzePwmkFPa3EXznjIKyo071TtzrisnUeLuWUUGqQp1sEG
         uCEg==
X-Gm-Message-State: AOAM53042bnP7pMkI0VonKa8xCGoYuES1MeCG7vew2r+IrekKapeP/ks
        +ePfIe6UlQtVp6p53OQ3GgM=
X-Google-Smtp-Source: ABdhPJywpb2aGtJbMUBTz7dHBirLYndXq9uNXazWC4ByK4FHtHoZyXJNI3QQNh4eAvU69x7oIlMddQ==
X-Received: by 2002:ae9:ef02:: with SMTP id d2mr1760318qkg.68.1605214065166;
        Thu, 12 Nov 2020 12:47:45 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id f61sm5369419qtb.75.2020.11.12.12.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 12:47:44 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v1] lan743x: prevent entire kernel HANG on open, for some platforms
Date:   Thu, 12 Nov 2020 15:47:41 -0500
Message-Id: <20201112204741.12375-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

On arm imx6, when opening the chip's netdev, the whole Linux
kernel intermittently hangs/freezes.

This is caused by a bug in the driver code which tests if pcie
interrupts are working correctly, using the software interrupt:

1. open: enable the software interrupt
2. open: tell the chip to assert the software interrupt
3. open: wait for flag
4. ISR: acknowledge s/w interrupt, set flag
5. open: notice flag, disable the s/w interrupt, continue

Unfortunately the ISR only acknowledges the s/w interrupt, but
does not disable it. This will re-trigger the ISR in a tight
loop.

On some (lucky) platforms, open proceeds to disable the s/w
interrupt even while the ISR is 'spinning'. On arm imx6,
the spinning ISR does not allow open to proceed, resulting
in a hung Linux kernel.

Fix minimally by disabling the s/w interrupt in the ISR, which
will prevent it from spinning. This won't break anything because
the s/w interrupt is used as a one-shot interrupt.

Note that this is a minimal fix, overlooking many possible
cleanups, e.g.:
- lan743x_intr_software_isr() is completely redundant and reads
  INT_STS twice for no apparent reason
- disabling the s/w interrupt in lan743x_intr_test_isr() is now
  redundant, but harmless
- waiting on software_isr_flag can be converted from a sleeping
  poll loop to wait_event_timeout()

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # arm imx6 lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # edbc21113bde

To: Jakub Kicinski <kuba@kernel.org>
To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 065e10bc98f2..f4a09e0f3ec5 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -148,7 +148,8 @@ static void lan743x_intr_software_isr(void *context)
 
 	int_sts = lan743x_csr_read(adapter, INT_STS);
 	if (int_sts & INT_BIT_SW_GP_) {
-		lan743x_csr_write(adapter, INT_STS, INT_BIT_SW_GP_);
+		/* disable the interrupt to prevent repeated re-triggering */
+		lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_SW_GP_);
 		intr->software_isr_flag = 1;
 	}
 }
-- 
2.17.1


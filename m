Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12A92C145B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgKWTPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728930AbgKWTPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:15:34 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE76CC0613CF;
        Mon, 23 Nov 2020 11:15:34 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id b144so3537474qkc.13;
        Mon, 23 Nov 2020 11:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R/CpWr48pVOLYZ2UwtgAEuS9Y7dMcGsDjQy5ijlpsqs=;
        b=S3RpQiLFQvz2Bqz/Oe0Tu4aGMdAZLMkWPI19b4BHTdSzR05CC6BjP4ppzktH7/Xomq
         VY7lfoSno2Jmyk8Ht6VwFgvnv0G02bfSikZ0EuZmSMpJo5a3aHl8bXk/D6QrUK/SNOs5
         lFsqv+dUNC3qsf10SCP1UesGwt24WYG2tRFDzBYeaJvaiacDkoTS+d+UkMKyODS8r7UB
         XLxSmLGOcfdVEzH4TeF3PFdMHEuYDg0a+pMYU8H9s+jwtGyRdjRpA4xyiQMgWbjCdfli
         6TfnZ4sJm/+YLm20BzA2i85fG7uUiAEemHZV9m1/AfPySeWw9aPdRtqUYi3MFgIb0+g1
         fCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R/CpWr48pVOLYZ2UwtgAEuS9Y7dMcGsDjQy5ijlpsqs=;
        b=RwVpRImZv7Ti06TkCZRZrbIg1LJBe0iixHDHfDhFs0fxzZSUVc+SMqpvU9cemWAZzx
         aPTcZaiGRdhkqvUGCoX0ew6/jOmPbLN4af8D0bWDis8jvUfRVMkOAdtE6sjywEKrM5Uw
         xHTCivt+QW93OszVGySA/sdfL8Vd33QfxGtZ2WrDgdursifBrJSrXIAn+aCvAAszOyVT
         WIRsAC81JtKG7CUCaXf9WmHtjskCNjjltXA5185fMTPaE5bFJHEFM6RjjfBRQ3b39VW5
         veKJlKybrWX5XZOdNShlnADxXdZwQQdb/4VNvFggw3W+7V0D3qMjC5WjuAU4OEMVUWIq
         ULGg==
X-Gm-Message-State: AOAM533ABhRIs4SjZidcTvD9lOXUN9zbr8ULOXS1ITwr0iiDr8isAB+5
        DfUIg0SHqZKpkfzDkLhTuKKuf1iCOXo=
X-Google-Smtp-Source: ABdhPJylaVUOWy8Ow/WhTqPdWsJDnHvz6hRt6h/sJAyEcW9V8+xV85ePFh+RX92aajTTjnIj0qxtzA==
X-Received: by 2002:a37:5185:: with SMTP id f127mr997434qkb.225.1606158933981;
        Mon, 23 Nov 2020 11:15:33 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id r190sm10116348qkf.101.2020.11.23.11.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 11:15:33 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 2/2] lan743x: replace polling loop by wait_event_timeout()
Date:   Mon, 23 Nov 2020 14:15:29 -0500
Message-Id: <20201123191529.14908-2-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201123191529.14908-1-TheSven73@gmail.com>
References: <20201123191529.14908-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

The driver's ISR sends a 'software interrupt' event to the probe()
thread using the following method:
- probe(): write 0 to flag, enable s/w interrupt
- probe(): poll on flag, relax using usleep_range()
- ISR    : write 1 to flag

Replace with wake_up() / wait_event_timeout(). Besides being easier
to get right, this abstraction has better timing and memory
consistency properties.

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Jakub Kicinski <kuba@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 28 +++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h |  3 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index bdc80098c240..96d34b001198 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -146,7 +146,8 @@ static void lan743x_intr_software_isr(struct lan743x_adapter *adapter)
 
 	/* disable the interrupt to prevent repeated re-triggering */
 	lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_SW_GP_);
-	intr->software_isr_flag = 1;
+	intr->software_isr_flag = true;
+	wake_up(&intr->software_isr_wq);
 }
 
 static void lan743x_tx_isr(void *context, u32 int_sts, u32 flags)
@@ -344,27 +345,22 @@ static irqreturn_t lan743x_intr_entry_isr(int irq, void *ptr)
 static int lan743x_intr_test_isr(struct lan743x_adapter *adapter)
 {
 	struct lan743x_intr *intr = &adapter->intr;
-	int result = -ENODEV;
-	int timeout = 10;
+	int ret;
 
-	intr->software_isr_flag = 0;
+	intr->software_isr_flag = false;
 
-	/* enable interrupt */
+	/* enable and activate test interrupt */
 	lan743x_csr_write(adapter, INT_EN_SET, INT_BIT_SW_GP_);
-
-	/* activate interrupt here */
 	lan743x_csr_write(adapter, INT_SET, INT_BIT_SW_GP_);
-	while ((timeout > 0) && (!(intr->software_isr_flag))) {
-		usleep_range(1000, 20000);
-		timeout--;
-	}
 
-	if (intr->software_isr_flag)
-		result = 0;
+	ret = wait_event_timeout(intr->software_isr_wq,
+				 intr->software_isr_flag,
+				 msecs_to_jiffies(200));
 
-	/* disable interrupts */
+	/* disable test interrupt */
 	lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_SW_GP_);
-	return result;
+
+	return ret > 0 ? 0 : -ENODEV;
 }
 
 static int lan743x_intr_register_isr(struct lan743x_adapter *adapter,
@@ -538,6 +534,8 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 		flags |= LAN743X_VECTOR_FLAG_SOURCE_ENABLE_R2C;
 	}
 
+	init_waitqueue_head(&intr->software_isr_wq);
+
 	ret = lan743x_intr_register_isr(adapter, 0, flags,
 					INT_BIT_ALL_RX_ | INT_BIT_ALL_TX_ |
 					INT_BIT_ALL_OTHER_,
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index a536f4a4994d..b92864913e6c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -616,7 +616,8 @@ struct lan743x_intr {
 	int			number_of_vectors;
 	bool			using_vectors;
 
-	int			software_isr_flag;
+	bool			software_isr_flag;
+	wait_queue_head_t	software_isr_wq;
 };
 
 #define LAN743X_MAX_FRAME_SIZE			(9 * 1024)
-- 
2.17.1


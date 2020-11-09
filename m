Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53C32AC033
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKIPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729174AbgKIPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:46:25 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B665C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 07:46:23 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id ay21so9247239edb.2
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 07:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbtNNKxuw9d4Befj0kdE0L5LYG2+swRyc3tCjO081f4=;
        b=tZj5VqrsTr56IJifNV7LqbYTbhRXzV6Pd1Ni/fz3INRZIm5jAQ6HUwfOkGpi9OYuCC
         UUFqLFObWZb0d50vkp0cojpWZk+yR42ythCZqyyZNL0WeGNBhkd8vEK+C/eoltLFju4/
         Xmo371wO1V7JC3Zb+8INoN2fmUQ1T3YDDR7ByUT9cqPI4EgrzaG131HADIatMeAcgM+d
         5kyXlTFYmukGq2Ju9EcIoTtH9gNatQyqNkEaYE2N44nzrr0kt28q6bj2bbHfW6+rBooT
         8LjODV5d9KZJdd63uVIOa1Ea88IBUMChzbCLDkhpIBvLf7XfGalYOrkgDL/06yLAWAFz
         WLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HbtNNKxuw9d4Befj0kdE0L5LYG2+swRyc3tCjO081f4=;
        b=RKHbAByKztofTa9AB1s7vKznHGoYpoVGhpw3GvXVOLO529p9/xKcAUb9tFl7dL0VEL
         chdIfBaw87sfB/enVjkUchPYISbqOxNG5EVsYKBz50hMrFDOyRbhg8R2HNnP2aT5tg/s
         mJvOWdRo2eTiau7u6S5Dpm+A7ZMhDqssmguDkW7n72989CRpqFYUEIkWtOp8DvL6tCHf
         lOaYnaAMVReOqy2oFnHvaZdEY7l+Q9ybKo+xLt1Ewi3StPDdnJZIQOYxUrC6Z14coW8N
         7yZjpdlJ4f2NYoJnrwH8wZuNKrPlTZqcro5yXhNhbrozkiaUdYc545q7XKWI6OehXT2b
         /bYg==
X-Gm-Message-State: AOAM532B3mfJw/LSVMZCJ8v9Q0L66BNv/t5vlnfp+aMDFGd/+fWPZ/TV
        9sn3iy3e/HUjVld3TXZnIQ7s8SfaQiQ=
X-Google-Smtp-Source: ABdhPJyqrGGNuD0fNKXdOLIuDJH44Kw731pHmMHcc/DCcoJ1OzUZ7hArl1o7WxnvAZVqDVX6tp5efg==
X-Received: by 2002:aa7:c68d:: with SMTP id n13mr16392195edq.350.1604936782212;
        Mon, 09 Nov 2020 07:46:22 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f24sm9051417edx.90.2020.11.09.07.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 07:46:21 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] net: phy: aquantia: do not return an error on clearing pending IRQs
Date:   Mon,  9 Nov 2020 17:46:01 +0200
Message-Id: <20201109154601.3812574-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The referenced commit added in .config_intr() the part of code which upon
configuration of the IRQ state it also clears up any pending IRQ. If
there were actually pending IRQs, a read on the IRQ status register will
return something non zero. This should not result in the callback
returning an error.

Fix this by returning an error only when the result of the
phy_read_mmd() is negative.

Fixes: e11ef96d44f1 ("net: phy: aquantia: remove the use of .ack_interrupt()")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/aquantia_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 345f70f9d39b..968dd43a2b1e 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -250,7 +250,7 @@ static int aqr_config_intr(struct phy_device *phydev)
 	if (en) {
 		/* Clear any pending interrupts before enabling them */
 		err = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
-		if (err)
+		if (err < 0)
 			return err;
 	}
 
@@ -273,7 +273,7 @@ static int aqr_config_intr(struct phy_device *phydev)
 	if (!en) {
 		/* Clear any pending interrupts after we have disabled them */
 		err = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
-		if (err)
+		if (err < 0)
 			return err;
 	}
 
-- 
2.28.0


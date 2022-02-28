Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30924C7E6C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 00:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiB1Xbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 18:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiB1Xbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 18:31:41 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB371EEDA;
        Mon, 28 Feb 2022 15:31:02 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id b20so4328756qkn.9;
        Mon, 28 Feb 2022 15:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rqXBt8yzUjWrarVpoIHmOjmSMgjNVBuHKspHFnevxUA=;
        b=cS1ycKAtfbn+XsNgoBE4DAXZtO7H2lZt5v+XcGll+qQ4wQE8eiouQ9y3BYrCnapRkM
         XFpSNIeiYMc77L6JHAMIyeXIN7uV722UqhjGQWuV0hmVLxlfrwpoJ41VgqabrQVeVb63
         FT3tWvJIdvTQztYHBlMNy1Fau4j82zcNIpzoY7MvU6RthdbPsYeTpGtxonsotF3tOK1H
         mQP41z5/6O+CazPQgwyCFNevY/j1ZadJWAIZ1XrwaqhQaF2DI2sJJgzE6XRy2jbVFkI1
         H6AECCJmQ7MrfYigvtxEcYL3tPX3S6kZ/hJvLwcGrue/srsPCxV3l+zTahQilk4LRngK
         3TRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rqXBt8yzUjWrarVpoIHmOjmSMgjNVBuHKspHFnevxUA=;
        b=fM7yhkJI4Ule+jQwggCipVZing5Le0kPupw+nkzLJV6WwzkWEVCwoXVqOb6P98arA4
         ZqhxtJhOF1dykr41woxVy3iA6XFrcVrCi4BIArzdjzMnFZZPmTZUXXZyc29lCcu9h0/j
         Hg7RkRc/6tM3GQHOt+yBvJlf3eaWEINKCmfUYDeWVn+HylOHCNDhQMMF9OdOiIQmwXPS
         KKVyQ4Xr3M+PUCvXVnALnHRXh/buX4wr+t7/7o6vldU8LELY87gDrlbctZ1F81NpokcX
         Hkns4PMZ/mswbwFGPST3bdJ5F0+xSsAp29tAiBZdhl0z8xF0ohCYPbgV2TqbNaw/42eh
         7b0w==
X-Gm-Message-State: AOAM532qphlQRVk0rfXvAkJXzM2PLonu4dIbnA8BRepv1Oqb4sdHncHj
        fyi7zObzBAX2mGFJycT6xLU=
X-Google-Smtp-Source: ABdhPJyyCW54RFkyJTyjxuy+jdYFhw6jgTumX6JBc2jenfOBm7AIbpEiCmpxMLb0sAl+zvnuGdAf9g==
X-Received: by 2002:a37:687:0:b0:5f1:9134:8815 with SMTP id 129-20020a370687000000b005f191348815mr12442442qkg.255.1646091061288;
        Mon, 28 Feb 2022 15:31:01 -0800 (PST)
Received: from master-x64.sparksnet ([2601:153:980:85b1::10])
        by smtp.gmail.com with ESMTPSA id n1-20020a05622a11c100b002dff3364c6esm6164575qtk.19.2022.02.28.15.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 15:31:01 -0800 (PST)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] net: phy: fix motorcomm module automatic loading
Date:   Mon, 28 Feb 2022 18:30:57 -0500
Message-Id: <20220228233057.1140817-1-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sentinel compatible entry whitespace causes automatic module loading
to fail with certain userspace utilities. Fix this by removing the
whitespace and sentinel comment, which is unnecessary.

Fixes: 48e8c6f1612b ("net: phy: add driver for Motorcomm yt8511 phy")

Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
 drivers/net/phy/motorcomm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 7e6ac2c5e27e..1e3a4eed39bc 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -131,7 +131,7 @@ MODULE_LICENSE("GPL");
 
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
-	{ /* sentinal */ }
+	{}
 };
 
 MODULE_DEVICE_TABLE(mdio, motorcomm_tbl);
-- 
2.25.1


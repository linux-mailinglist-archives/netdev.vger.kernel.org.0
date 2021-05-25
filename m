Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B523390A87
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhEYUex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 16:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhEYUeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 16:34:50 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0657AC061574;
        Tue, 25 May 2021 13:33:20 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i5so24568735qkf.12;
        Tue, 25 May 2021 13:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RaM9ZhBOq1ip9fI9c0kNmvrXXOfvrTxqLTaDnXDsklE=;
        b=hWuUK7cluzYoy82u3Esazs/HHrWHngomoBurFOfts3bxoEURV4mCCUyaz39Y2+V2eH
         IpIsw4KHytR3hg0fr5kaGV8l+hGjSDunk3Vh+4eXliHXe7MOkkZXTcjYnEgTwRjXjJFc
         kWIjPElT0gxpi+XbWhCkk6cKbEnUGcFEFZcKaQQSo3nZDr1zKbYxnbfz6+ocg9cVbXlf
         /t6pVewKEh/UuKMDyb8vHaLkBl1LOl7fJNezw9pfOzc4xxbmmGY+N+jyTHb0vuFYubQC
         r2btiCjehbkcPV0pKfOTlW5YwHt0SRjnPwcowXsQO6g4Q863sNAix62sxOzZbW3D25Gl
         yepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RaM9ZhBOq1ip9fI9c0kNmvrXXOfvrTxqLTaDnXDsklE=;
        b=WyUN133dNCgLWqb00gtI8Vco+dwSrqAQ6siN4xr/adADXbI/R5GNbKbNKbw8MSAn+f
         aaBZTLZBH6gHU9bWS9mNXtFImoKrW6ZMXdoJWG47bwWmQTme2IZ5k91grbzDguPzqskR
         ONkRt+ap9sIkJyPdEil3dqQDZwug+ZeTmbFEyXS1bVP9SU/34fkbEble64lBS1u7teXN
         oxR7hGIyeFCctif8Ps0Ja2gSVX+y43qSoYXY9bSQn+Uo4fzFYvOnpyqJRaCY6TJ/aO4J
         6WDuGxB+JEV8Mi00v5COhdOd/pj1aa5sYyAufGm4so6b1+9K/l1IubK4YgGI8K5O04j6
         bYYQ==
X-Gm-Message-State: AOAM532VVU8PNZSdeHVjx13umJE/JHFazgUqeUHcX97t3BRE4A/UkbrX
        /YWAYd3VtKWKbq5QdBNW5kI=
X-Google-Smtp-Source: ABdhPJwxUyiuRdl786eIOIMv/5m0nQOCh7kL1Brn14qD+GOXA8g7LhxnCGcj8RfX6ae2t0WxlMuJ/g==
X-Received: by 2002:a37:a3cb:: with SMTP id m194mr5305425qke.372.1621974799180;
        Tue, 25 May 2021 13:33:19 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:a465:c799:7794:b233])
        by smtp.gmail.com with ESMTPSA id g4sm159312qtg.86.2021.05.25.13.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 13:33:18 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/2] net: phy: fix yt8511 clang uninitialized variable warning
Date:   Tue, 25 May 2021 16:33:13 -0400
Message-Id: <20210525203314.14681-2-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525203314.14681-1-pgwipeout@gmail.com>
References: <20210525203314.14681-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang doesn't preinitialize variables. If phy_select_page failed and
returned an error, phy_restore_page would be called with `ret` being
uninitialized.
Even though phy_restore_page won't use `ret` in this scenario,
initialize `ret` to silence the warning.

Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
 drivers/net/phy/motorcomm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 796b68f4b499..68cd19540c67 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -50,8 +50,8 @@ static int yt8511_write_page(struct phy_device *phydev, int page)
 
 static int yt8511_config_init(struct phy_device *phydev)
 {
+	int oldpage, ret = 0;
 	unsigned int ge, fe;
-	int ret, oldpage;
 
 	/* set clock mode to 125mhz */
 	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
-- 
2.25.1


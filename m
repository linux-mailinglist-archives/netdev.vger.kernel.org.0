Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FC394BE4
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 13:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhE2LHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 07:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhE2LHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 07:07:42 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC586C061574;
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id ee9so3209328qvb.8;
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BHAPU9WEhe/IzLMZhMUy9J1dZ6fQXj5w6gD2AFHDUxk=;
        b=GBm7RPfWVL3eiOLiCALVzFus8WA+qOh/0NGG59feXfnTC8IihmgwDkejiku2/35vBG
         IkNGXfnSqTXcI15tfdTYO+MAx4MuRSUL/fP0sEdK/teIkjr1vGJZ5ZqyelNt9bWKB139
         SuF8t18QTQeto+BptnZm+Qe7jM55ZB0M1T/fOcwan+E1byy9dVeUZJJSLQpqi9ux/Hb7
         BQWwrxpujhcqPEbFbn0xWypECXGbV1ZnPmGzmlBrbGSDb4drIhvDGhYIatc0pYnNkrhJ
         X0kTD4TRYHQM00aImlwKYy7vT53dAezD4NUCq4fjEJQhwldgsDCMI70Bk3pfPNtJIt7/
         t+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BHAPU9WEhe/IzLMZhMUy9J1dZ6fQXj5w6gD2AFHDUxk=;
        b=DgPzJTCx/LX75oBJ2WqXXtMLVckzOMxxXwbtoImwIwR3hYmUGCIQ+CTfVFxK/ngM2k
         QwlZTARStxajz1/9HsFA1qKQ4RMDVI5rMwd9OpCSLcQTgb+WH5fPotjRjkSMYwO/c2Lt
         jPkXXYZxsw69/ou4P24VoSLx1BVV6+9slMxlN/HJWpO6RN78/x8UgkowtkxVOxjw0iHx
         kcOKElMUvKe9mBxHsVLoXeqaSh1EOYYEc/HW2I8eAjdAmUkshlLed3oBYVg7tPSeFIjR
         Mo9ai9ms5GzcaUk0Dpc2G1jDG8b5Rb9cCFT7BHFv9wdfeXaxFOzDLj2XGL7+c9GzTPV7
         rA8Q==
X-Gm-Message-State: AOAM533R90sPyGdLBnL3QPhF/jTr8mJySR+TSe8yi7xG0PskQ2jCdHNU
        I5yaCmsL3PyeE1hLHcDEBbaXhLUPrwInzqpK
X-Google-Smtp-Source: ABdhPJwS4lSQgX/7PoX4A8kBZicr2rpGO3qLlEm64wPaCqyO2U94yreiItA/phAku0pF/Av19qrFBg==
X-Received: by 2002:a0c:e40e:: with SMTP id o14mr8188188qvl.30.1622286364041;
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:5af:2aab:d2d5:7c9a])
        by smtp.gmail.com with ESMTPSA id t137sm5328991qke.50.2021.05.29.04.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 04:06:03 -0700 (PDT)
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
Subject: [PATCH v3 1/2] net: phy: fix yt8511 clang uninitialized variable warning
Date:   Sat, 29 May 2021 07:05:55 -0400
Message-Id: <20210529110556.202531-2-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210529110556.202531-1-pgwipeout@gmail.com>
References: <20210529110556.202531-1-pgwipeout@gmail.com>
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

Fixes: 48e8c6f1612b ("net: phy: add driver for Motorcomm yt8511 phy")
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56A91B6488
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgDWTeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgDWTeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:34:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F9FC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:34:36 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h2so7767217wmb.4
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hXV8Wtun0GovOWCgeFyuMPagkqdRp/yW2NQOzdJWQko=;
        b=DtJWMvuseVoQv3cxoFxfdZgY0LMK9sdtkhDsEOpXfCrjJf/F2A/GzQnCc3MaeqKWK2
         y0BTehqBvmZIsndjQMEHIeShBjZ4QGL/Ms8PHlSviTLlLOc2RZXMMb4ShG8JgmmXE623
         upuCIdfMiO3AUND2LTubX6/lclWyvTOOQEzx1Vx8IVRRcKyhvyeMg6rGbymfWMKBc0/a
         1beU32s4gq64ifvVO0vMNr0FRvxnMHi9JFkBg1Ds0HRufa0ai0DADJ0o89dPSHnd6VWG
         0cRJ4gzaylhlOcyQo1SgzYWojfCUao4XOmBiFbSl6jIe0QgGUEUrgDUyyGf0KIxibc+z
         12WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hXV8Wtun0GovOWCgeFyuMPagkqdRp/yW2NQOzdJWQko=;
        b=iPJ24e8PJc0NLM2eCZc0xrhzpksbHwzWPYysPUxUZIFvmc6lbrXTivezddDT2bbO8q
         PUcrsMDH5RX+QA60COMDQW6ZD7GQsaz9/4JO9y70iaVq/Lb1Rpq6gyfUaN4ozVA0AlYU
         VOYrDbjh/JiwSXPBw7AcvrTMKxMQILCRe7dLF2s/l1ke9L6OIreBwVQ9zKZ8JRA4z2w+
         me+3Gan9alnsnewGt96w0lyJKcoAbillrVWcNxZRgmoBpZyt4B63iCesYPg5GFGOIUiK
         VyK6gjwKHdGKGNY5spdHGfgXQnjs6Fdo9b1IaxsQez+eiOUZ3UrEML574IYTxakgnv+k
         Ujiw==
X-Gm-Message-State: AGi0PuZpfFouqA2rj5VZU03KILEr4kmBQ1S/7yGikmX95lFG8IzVmCZv
        CXCIs15zSFMiGincvfqn17TwZNAI
X-Google-Smtp-Source: APiQypIiUX5PBSSydsYoHmlLN/0Mv3h0Csvm2AE25rIvHxL0sypl/z7mA1N1mZwqcWGqhM6G9Me5hQ==
X-Received: by 2002:a5d:660d:: with SMTP id n13mr6427082wru.369.1587670474558;
        Thu, 23 Apr 2020 12:34:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c569:21dc:2ec:9a23? (p200300EA8F296000C56921DC02EC9A23.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c569:21dc:2ec:9a23])
        by smtp.googlemail.com with ESMTPSA id h3sm4990073wrm.73.2020.04.23.12.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 12:34:34 -0700 (PDT)
Subject: [PATCH net-next 1/3] net: phy: make phy_suspend a no-op if PHY is
 suspended already
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Message-ID: <ebc88561-76c1-e81e-2229-9bd16270366d@gmail.com>
Date:   Thu, 23 Apr 2020 21:34:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gently handle the case that phy_suspend() is called whilst PHY is in
power-down.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ac2784192..206d98502 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1524,6 +1524,9 @@ int phy_suspend(struct phy_device *phydev)
 	struct phy_driver *phydrv = phydev->drv;
 	int ret;
 
+	if (phydev->suspended)
+		return 0;
+
 	/* If the device has WOL enabled, we cannot suspend the PHY */
 	phy_ethtool_get_wol(phydev, &wol);
 	if (wol.wolopts || (netdev && netdev->wol_enabled))
-- 
2.26.2



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85101D9A7B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436527AbfJPTxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:53:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43389 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394234AbfJPTxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:53:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so29409651wrq.10
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 12:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Hpza1PEkNXxGmTrDJLEfss3TW9r/lIzyTKVu2LqrB6s=;
        b=vOGzSkmdBgJDmMri8YLX018uN3ViYYOwByGsQOmZyeoCZbJ+z0JvPcR75GkTvWZKq0
         djcfb0jDriIH8CE9NYsMrVNFf5E4LrkdiYoIu4ZoSH4du8SGBJc0wUl5HDZU0FNpqZ4O
         rPWmCYjMzhxC3VxOnelqNNWh9xAtnULv/Dp6aHv1NrNDAJHHBXt9NRqd/Om6uEpnfpHF
         dfkc8NAbRnvhkettZFWbQI70QE++V7RL+vC8T+C8OgQhXT77ft5wRVu3Qx032XNxjiWZ
         LyALxDyA1VDfrrLrcXRBTnixDEvSoTAg6RKzHNf9DwgBYRXIyuZgp56uVD6lSdIPt+Fq
         cP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Hpza1PEkNXxGmTrDJLEfss3TW9r/lIzyTKVu2LqrB6s=;
        b=Sy03ccsNIQ6Q89ANzHBh1wcsFqNiqvoU9w0ZC4awyp+ySJdRrtatDSPanHgY8IEa0e
         OZRK8YkR8vzQOSQcXtcc4AKqw0QjEkKBRSQ+BXLi/CCRxRBPyyWv9T1bcQWyWFG1i6s1
         jcbFyWHRywFTtgTVFYJt21oU31SWAKzti7acijrOh3y5yjlhqt5XgfXZX96g0nLkcCX+
         uMw/4dw4eh+k1ttjQgrjqGGGOBulE3roENj2ACvSPqxsdcmg/SYBNVs3ahMIxVo6vZuQ
         O7sLLxQco2z4+18NWlRebAUFPbAFt+ccxThALlxbGhcqxyntilXsX98ZVp6NnOu9knJG
         jYmg==
X-Gm-Message-State: APjAAAVwZdz3qPljwh1HKug8hpznvvhNEPkOwPD23loCvdJL9KPx/MCt
        /Ee+ltoJs0kVPaNWfgDDHzU93gM1
X-Google-Smtp-Source: APXvYqwaUPtbdtNcngaJM/8YIr1mopgWqaaI95qewciFp6aSW4F9Pd8qr6N1YmUbJnjr+W9TVyHPtQ==
X-Received: by 2002:adf:e401:: with SMTP id g1mr4178022wrm.211.1571255617287;
        Wed, 16 Oct 2019 12:53:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:d1a1:ef77:d584:db28? (p200300EA8F266400D1A1EF77D584DB28.dip0.t-ipconnect.de. [2003:ea:8f26:6400:d1a1:ef77:d584:db28])
        by smtp.googlemail.com with ESMTPSA id q124sm5473308wma.5.2019.10.16.12.53.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 12:53:36 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: avoid NPE if read_page/write_page
 callbacks are not available
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <41aba46c-6d75-9a15-9360-1336110dd28e@gmail.com>
Date:   Wed, 16 Oct 2019 21:53:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there's a bug in the module subsystem [0] preventing load of
the PHY driver module on certain systems (as one symptom).
This results in a NPE on such systems for the following reason:
Instead of the correct PHY driver the genphy driver is loaded that
doesn't implement the read_page/write_page callbacks. Every call to
phy_read_paged() et al will result in a NPE therefore.

In parallel to fixing the root cause we should make sure that this one
and maybe similar issues in other subsystems don't result in a NPE
in phylib. So let's check for the callbacks before using them and warn
once if they are not available.

[0] https://marc.info/?t=157072642100001&r=1&w=2

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9412669b5..0ae1722ba 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -689,11 +689,17 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
 
 static int __phy_read_page(struct phy_device *phydev)
 {
+	if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
+		return -EOPNOTSUPP;
+
 	return phydev->drv->read_page(phydev);
 }
 
 static int __phy_write_page(struct phy_device *phydev, int page)
 {
+	if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
+		return -EOPNOTSUPP;
+
 	return phydev->drv->write_page(phydev, page);
 }
 
-- 
2.23.0


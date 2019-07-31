Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8A07CF4F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 23:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfGaVFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 17:05:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39268 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfGaVFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 17:05:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so18022133wrt.6
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 14:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hDbHbE5Zv9TcvZT2Mae0eiMoON8N6QMf+zZr/r3HZhw=;
        b=rCWTu+sgjg8tVi3c48PAjRByRc5M5cwIEnwqCjbGNQE3/mA7TZ1O5HuyeNMblTBbZs
         thqb9TioxJM+mrhzOPSgTX96eRALHGEn2Ewca9lutFvp0OKR4StoiOHxgqky2NsWydDG
         ArhFjN/6E5xZStgwl4xbxiQdPi2c5IY6z/LkhJR9xDv1QL11E9FOIB4KMEZwdQkVrXt5
         YF1qMBxmw4aJ5NEl55rt4h0Uy/QAmnfGzTvMXNuQ8pfUkCRr7dIuh76WljYuVZVxLtAQ
         0dGDkMMdnG63wz6og3Qh//fXOWeZGun9SJpHMhrY4QFXuSXhiA2fvShzJq4XOf/BWliW
         wCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hDbHbE5Zv9TcvZT2Mae0eiMoON8N6QMf+zZr/r3HZhw=;
        b=emaV4loMQel0seVpGGlKjbroZ6Gfn0YS9N1EQLUZsxIG/gXrNgaVWM5maUSgQequ8L
         iXwVtHNfWhcR6fgJ6qXK8y3LmujhTYT6UNlM9uvQEfe/RUeGa8nKAT892H+9M+Ia8OaU
         xWLeLKTtqY/HKw2YnkUDOmY/SwdTSPKP2Cd6TJsarxfXD4XS9ImuYEvopbPhqoKWRv1f
         Q6H083+wOnksEZLyLHkF54k0p5hr+IuvMO9aHuu2xBiHDOxtAN3B7iI4SD97FZ8beI4f
         q1ljRv/HSiFY9eVW0wymyolEKps3XFwTiWs1LFsc/OzkyLiGRXKa0i9kUiYskef8RcXS
         rn3g==
X-Gm-Message-State: APjAAAXWeYdlOGjXgt7B7nPw4mzMcM0aNo7yyfAcXs/kWURNejHk9CsE
        MW9fFe8T6nA81LJRTNR6pkE=
X-Google-Smtp-Source: APXvYqwHDOqAImjC7Tozwi2eOooA97CGveMRSDzbFZ3MXFCh14mMdtXIFFUY2ds/H+rgGyvIdSHO3g==
X-Received: by 2002:adf:df8b:: with SMTP id z11mr79322430wrl.62.1564607113309;
        Wed, 31 Jul 2019 14:05:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:ec44:8c7f:aacb:2a8? (p200300EA8F434200EC448C7FAACB02A8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:ec44:8c7f:aacb:2a8])
        by smtp.googlemail.com with ESMTPSA id x185sm64818377wmg.46.2019.07.31.14.05.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 14:05:12 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        liuyonglong <liuyonglong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: fix race in genphy_update_link
Message-ID: <19122a98-cfcd-424c-a598-e034c1a9349d@gmail.com>
Date:   Wed, 31 Jul 2019 23:05:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In phy_start_aneg() autoneg is started, and immediately after that
link and autoneg status are read. As reported in [0] it can happen that
at time of this read the PHY has reset the "aneg complete" bit but not
yet the "link up" bit, what can result in a false link-up detection.
To fix this don't report link as up if we're in aneg mode and PHY
doesn't signal "aneg complete".

[0] https://marc.info/?t=156413509900003&r=1&w=2

Fixes: 4950c2ba49cc ("net: phy: fix autoneg mismatch case in genphy_read_status")
Reported-by: liuyonglong <liuyonglong@huawei.com>
Tested-by: liuyonglong <liuyonglong@huawei.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6b5cb87f3..7ddd91df9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1774,6 +1774,12 @@ int genphy_update_link(struct phy_device *phydev)
 	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
 	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
 
+	/* Consider the case that autoneg was started and "aneg complete"
+	 * bit has been reset, but "link up" bit not yet.
+	 */
+	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
+		phydev->link = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL(genphy_update_link);
-- 
2.22.0


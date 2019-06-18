Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CDB4ABF7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfFRUjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:39:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40793 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730621AbfFRUjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:39:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so915257wre.7;
        Tue, 18 Jun 2019 13:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqLJBpTFEaLyH94sYy+DvxdzXV+8za6jehbuul9HSrg=;
        b=kX4JD+1dVBQmI+3sx/kfhyEstODcRRW67o8XCyqJ1G8i4Bo6Mui7qTzjtQE3Y1Va+l
         67EVtNzmXpNDu+r1DXQuOxpgjrjmOJ7PDsf9qEFqUCDMjL2qunv5UpLeOAURNi+Ghk89
         Fq7GdyNSv4pBiKPib6z40rJdzrJd9o2ryDg8qj3trFEOUXcBjcz/FpoP0xqehmgaxMSC
         TFvTJfYKDOL0HDsU5JKjbZ1EY6rEWfNKGLtev7WSIANb8V2tfl+UGFUZGciNwRXRSNaJ
         o533TtRBmOnb95/UWRVvG40hSuyZxKZKHBRZ97RDNGDBazH/d/p4WLKLQ3EmZcvFetjm
         pHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqLJBpTFEaLyH94sYy+DvxdzXV+8za6jehbuul9HSrg=;
        b=PT8Wu0GEaKoK7fxl9ijcVZVFhz/2W7lxL1+8xzjPVvc9FSyuhHMy+cYTjI3CmyovTf
         phf02qCRew4HpgK+ge6bXAye0uDThzU41nmmw2dp4f7I8kjybIZQh69sJlGp4qzNIc5A
         2ipgEIGv4NyAaGpwc8FoRTm4A0WWlSVuCs2WjzBG/6L2ApFXM/cEVRSpO3Ix7mCARyYE
         v9bAwGQ5TJorBzO7x6JbzDHXAWr3HIJ9oN1484KHBle0Fzaq/X/osAb0TufMsKKuxvGz
         J8L/ASiK7avmnw6sGUTAYcHK7vKgOK99BfL8Brdvkr7ZoRWXrJB4jGEp+NrNeGE/0Nl1
         txRQ==
X-Gm-Message-State: APjAAAWpPhGbZvlEJz4iJ19zpDHTaiNS9Xl+j4Z0d1J16ovJofNSiJc5
        2dICV+0uOsPb5+gEvW4MGrciB5Wr
X-Google-Smtp-Source: APXvYqwHa7M7aKZdKxzjVqMVS6s7vB6hrd5drDzNXzzXcW0wGcX4o3k2zagiAqmKg9izcam8n76//Q==
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr10131804wrv.114.1560890378190;
        Tue, 18 Jun 2019 13:39:38 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E0008BE4A1C4AD46470.dip0.t-ipconnect.de. [2003:f1:33c2:e00:8be:4a1c:4ad4:6470])
        by smtp.googlemail.com with ESMTPSA id c4sm19694372wrb.68.2019.06.18.13.39.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 13:39:37 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        khilman@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1] net: stmmac: initialize the reset delay array
Date:   Tue, 18 Jun 2019 22:39:27 +0200
Message-Id: <20190618203927.5862-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ce4ab73ab0c27c ("net: stmmac: drop the reset delays from struct
stmmac_mdio_bus_data") moved the reset delay array from struct
stmmac_mdio_bus_data to a stack variable.
The values from the array inside struct stmmac_mdio_bus_data were
previously initialized to 0 because the struct was allocated using
devm_kzalloc(). The array on the stack has to be initialized
explicitly, else we might be reading garbage values.

Initialize all reset delays to 0 to ensure that the values are 0 if the
"snps,reset-delays-us" property is not defined.
This fixes booting at least two boards (MIPS pistachio marduk and ARM
sun8i H2+ Orange Pi Zero). These are hanging during boot when
initializing the stmmac Ethernet controller (as found by Kernel CI).
Both have in common that they don't define the "snps,reset-delays-us"
property.

Fixes: ce4ab73ab0c27c ("net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
On my Amlogic boards the delay values are 0 even without this patch.
I may have been lucky with my kernel build that I'm not triggering
the same fault as Kernel CI found on the two boards mentioned here: [0]

Please feel free to squash this into net-next commit ce4ab73ab0c27c.

[0] https://lore.kernel.org/netdev/7hr27qdedo.fsf@baylibre.com/T/#u


 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index da310de06bf6..18cadf0b0d66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -241,7 +241,7 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 #ifdef CONFIG_OF
 	if (priv->device->of_node) {
 		struct gpio_desc *reset_gpio;
-		u32 delays[3];
+		u32 delays[3] = { 0, 0, 0 };
 
 		reset_gpio = devm_gpiod_get_optional(priv->device,
 						     "snps,reset",
-- 
2.22.0


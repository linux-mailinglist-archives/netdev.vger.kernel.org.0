Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7922DB5C9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgLOVXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:23:25 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:39281 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729470AbgLOVW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:22:57 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 47BC323E69;
        Tue, 15 Dec 2020 22:22:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1608067331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=etQ4Fzx7rMh/535H995nJAxwVb6v9GuZ3TAJHpMwXPQ=;
        b=Kd2y8tp/8psbPQ/7CQD9sc5475fvnN5zvccF+POM1qbl5jGHol848fGIP9IC4HA/2W6ubw
        GC7N/6mFd+ChmKYeHdX+0CKSSXVCPmVGrE85bhQCMuQddoh4U6pA/LfoBCeskQjlpGj60c
        eKr6U/DEJSdvQdEVF5R2jRpURsrh2G4=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 3/4] enetc: drop MDIO_DATA() macro
Date:   Tue, 15 Dec 2020 22:21:59 +0100
Message-Id: <20201215212200.30915-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201215212200.30915-1-michael@walle.cc>
References: <20201215212200.30915-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

value is u16, masking with 0xffff is a nop. Drop it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 665f7a0c71cb..591b16f01507 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -41,7 +41,6 @@ static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 #define MDIO_CTL_DEV_ADDR(x)	((x) & 0x1f)
 #define MDIO_CTL_PORT_ADDR(x)	(((x) & 0x1f) << 5)
 #define MDIO_CTL_READ		BIT(15)
-#define MDIO_DATA(x)		((x) & 0xffff)
 
 static bool enetc_mdio_is_busy(struct enetc_mdio_priv *mdio_priv)
 {
@@ -93,7 +92,7 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 	}
 
 	/* write the value */
-	enetc_mdio_wr(mdio_priv, ENETC_MDIO_DATA, MDIO_DATA(value));
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_DATA, value);
 
 	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
-- 
2.20.1


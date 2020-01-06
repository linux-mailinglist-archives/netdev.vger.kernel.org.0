Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79D1130B8D
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgAFBeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40970 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgAFBef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so48004571wrw.8
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l4ygTGqqRc1jSg6CtD5Z5EdcRdAmYi1pbQryB8nFE50=;
        b=CZD8UAEaMzPi4YjC+KLsyQUj8FhOTtDu8LMrUcP0PTOeB4ZwrTMzf3J4C2zw2u8h+/
         U9+BR+K9BnX+PIp3OMmSyWLF2E/NCfGZz2RMec3myOM6xJmP6aWe7w5ogf3EvwXjIXU2
         3XmyTG3SQdI8bzTMzQDro4vDObS0oyy/iiPtCoH05BxxIvkKcBoAjY1Oh4VzthwCRWEv
         P9imJiWCocZJQuLhQxP7/YYoz2mFq4O/ps5RGQ6g33QnPHTPoJVMfuM6EKYmNrywPNyg
         u0Ds9HmK5r9OKDq+ktaK1b7bNyB05CyfjrLqWQHQB4EG2j6qW3gyOLJi9jbb6NtfkSbx
         m0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l4ygTGqqRc1jSg6CtD5Z5EdcRdAmYi1pbQryB8nFE50=;
        b=RZMtbLS04yyT5szpNO52BqLx29FgvM71YGp+xwR50zah+USpJnq6CfrwcWlrLM7Hp7
         Fsmgr3EJJH82IZrx1qqIyhboea4MrCNttT2gK3LsqJKEGM2qfVyixwNtPXTwrrvvecXG
         35e4YENAfphT5bBATkTCszdoejGs/8/tRTD/8OmvT4ulvPGJJp+q/wJ4b95b+dUaQEED
         Z4KY0uqefpISw76+8864+YtDTvfy/6S0/4PxNhnq1ci26K8Cwna/VD28YCF52AudiyuI
         sb4/vSjtBLzTkPmS5qQNdPGTSYOEzv+nZtQpow8C9PURNvrd+BQQ5jTK8OJXW7RtloKM
         53IA==
X-Gm-Message-State: APjAAAV0Aiie9tmWl3//yaSKSt5YxoFBHHWxry9QB5G6FaHoAGKOmq8a
        6ovVjXhUA6vX+CDzn+fN0tY=
X-Google-Smtp-Source: APXvYqxTDFH8pUzgZosQsgiEHN00i2dCT4/9SazyrQDyiKcSgizl0Szwxui1a4c5ctDluuKtV8O+wQ==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr99966248wrp.19.1578274474077;
        Sun, 05 Jan 2020 17:34:34 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 2/9] net: phylink: make QSGMII a valid PHY mode for in-band AN
Date:   Mon,  6 Jan 2020 03:34:10 +0200
Message-Id: <20200106013417.12154-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

QSGMII is a SerDes protocol clocked at 5 Gbaud (4 times higher than
SGMII which is clocked at 1.25 Gbaud), with the same 8b/10b encoding and
some extra symbols for synchronization. Logically it offers 4 SGMII
interfaces multiplexed onto the same physical lanes. Each MAC PCS has
its own in-band AN process with the system side of the QSGMII PHY, which
is identical to the regular SGMII AN process.

So allow QSGMII as a valid in-band AN mode, since it is no different
from software perspective from regular SGMII.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
- None.

Changes in v4:
- None.

Changes in v3:
- None.

Changes in v2:
- None.

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1edca9725370..88686e0f9ae1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -281,6 +281,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_QSGMII:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
-- 
2.17.1


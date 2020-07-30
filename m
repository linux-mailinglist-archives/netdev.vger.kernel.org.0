Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753B4233968
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgG3T6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgG3T6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:58:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F33DC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g8so6740738wmk.3
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G/402jvunHbjF11hVgmWiTzJle9vwpONJILlatnYutU=;
        b=YASyrnjDo9cNRO78DLG5xZnVwWfhB+fqQqd/4KypqPMexjBZWBmnAh8voruvqJtaKK
         BNlBmSK5wO3c+fDne9E9WhwwvA3E2CFlw3E1/QgsXBE9UzWokKJf0ppMV2H5gmzOmcEM
         kMBZvjaZP77U1TdVF1BZeuVYcBKmtWRVjVI4IlCxY3dXfUqqzLugi+T/YIo2jaLBKhOF
         HFPk/ZGAPT4i5KLrVxPPpIjppkkrTYC/fZrMF0dN+QFUA/C+X8K9yLXPvQ5y3/Yybd1E
         IBngFgh6OZQi+QtvmEyQR7r/XUn832ouzQtLQLQa1u6Lb20qBJ9hhFpPqIIMRhugLv0R
         abUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/402jvunHbjF11hVgmWiTzJle9vwpONJILlatnYutU=;
        b=RIeOy02xojgq5eSzxf/obR1pkLfidMSsnOvsnx33a/SEr6J2QRYfMn2e2RqDn6V68B
         iheRam2dysMWql6WbtKwAu0nVhGTqqDtPBILAGkoGZ+9XNTtqsx47wKJZycNznTFPPzD
         BKTrBIMdlMuP+293wFSDd5DaO5l6YwPbOIe+NGe61lWVM4miHv6nk2wMdoAeyxcBwKEI
         6xjnoiwvRMUSnfPYo38Vp2bVDm7BcNkNOFeSYsmGu1yPlh0DJIRUmxDPvvh+do5Y8812
         wjU7icIK0wkwWE0iB0TaOGtf0uWhVNQTA53OGVLR3cnc6kHJLQGy1i4ddbn0SNhRWfd0
         PArQ==
X-Gm-Message-State: AOAM531eV63bePl5y7Wx/3JKvHrcl6GMb68WbjGZQDx4FenquM2nOnZ2
        K9yti4edKXzP840pZKhJK9xO8q97Jswpzg==
X-Google-Smtp-Source: ABdhPJzU2hob98qCaw+589Spvxz5Z0BU9N4qh3sCc9n32WkLKX5fgDOL8XtMr9giYu0WEscbcgtKtQ==
X-Received: by 2002:a1c:43c3:: with SMTP id q186mr774827wma.144.1596139095907;
        Thu, 30 Jul 2020 12:58:15 -0700 (PDT)
Received: from xps13.lan (3e6b1cc1.rev.stofanet.dk. [62.107.28.193])
        by smtp.googlemail.com with ESMTPSA id z6sm11326993wml.41.2020.07.30.12.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:58:15 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH v2 2/4 net-next] net: mdiobus: use flexible sleeping for reset-delay-us
Date:   Thu, 30 Jul 2020 21:57:47 +0200
Message-Id: <20200730195749.4922-3-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730195749.4922-1-bruno.thomsen@gmail.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO bus reset pulse width is created by using udelay()
and that function might not be optimal depending on
device tree value. By switching to the new fsleep() helper
the correct delay function is called depending on
delay length, e.g. udelay(), usleep_range() or msleep().

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..5df3782b05b4 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -554,7 +554,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		bus->reset_gpiod = gpiod;
 
 		gpiod_set_value_cansleep(gpiod, 1);
-		udelay(bus->reset_delay_us);
+		fsleep(bus->reset_delay_us);
 		gpiod_set_value_cansleep(gpiod, 0);
 	}
 
-- 
2.26.2


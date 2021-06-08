Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4839C39F4C7
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhFHLTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhFHLS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 07:18:59 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B623C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 04:17:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id og14so26694142ejc.5
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 04:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X1OHkdWCJzA5G7HjR6q3jFZ8XtuTT/1SsQlBOUKHX8w=;
        b=llB4PJmVUsltHY6Bdhw6pj/kBXElBqyntNdc83ShracFJqPIH/r+8zwQxvEObJBB/n
         tEQD7LbgMZqeE0NORju8D5DrpVoZybiRaTlPnB+ZfRvbookOQQqaqJ+RBDNjLNITMRbH
         6jEJlLply41FN3M+gnROWGkM0BYxglofI+zM4BFAvNy5P9qmnZG6J9Egzk5FhbVMYzHN
         nznFBroWLidsZ346lt+pd+WROW8m4vwqqFbKPn2YaZ5Uhuljqz9t81egDDatQNHeG0n6
         rOpAoKtThQMcbsbARe0upGK1Kcks1qJcTHurqZM5wtakMZhMBfn00iiBE57ZFFvJoThd
         BIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X1OHkdWCJzA5G7HjR6q3jFZ8XtuTT/1SsQlBOUKHX8w=;
        b=B/gofTsDQHwh3wdtnBZVUT+Y3AKdbUh6sjMDYrGlK6cjc6BwIt2xYsN4v4+kb5iKB7
         vMLYe4G8vS2/M7PDzkV851q3yYAXybjo3RUj9DKUvXp2wf2V+69c718O6GgfdYSY8vO9
         sElNhMqonKYas7csFwpSS/isIsSB6JgPZRbUPYwilGFSWx4yVE26oozoVzOl9xmnSI46
         hz5hAFvgyoZPOlC4d3uLlJxcyy5ByB2qowqJUHHGjznvMGiSTArwuYAES0bONb1C1DvP
         1mGdpRKLLAXrQ0uaxiHNNKnhAERlLRNuhcqnX6yvl03S7zRkTmP2pGP6xLwnSi7z3j9R
         seLQ==
X-Gm-Message-State: AOAM5314FnROwk7eI8PXktlCWI3U7P3dCb5D8gAPBjjjFtB5wfmxE7SA
        iH7TjjTkL6gh9cS5mhMXhdI=
X-Google-Smtp-Source: ABdhPJzb8oZqoghixaytf4ptmAzDTkVd+aldnC2/HmnaXH02zcldyTkdSt9l0Q+PIBSBjd26fNnc+g==
X-Received: by 2002:a17:906:e4b:: with SMTP id q11mr22412770eji.404.1623151023456;
        Tue, 08 Jun 2021 04:17:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id am5sm7617980ejc.28.2021.06.08.04.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 04:17:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: felix: set TX flow control according to the phylink_mac_link_up resolution
Date:   Tue,  8 Jun 2021 14:16:51 +0300
Message-Id: <20210608111651.4084572-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Instead of relying on the static initialization done by ocelot_init_port()
which enables flow control unconditionally, set SYS_PAUSE_CFG_PAUSE_ENA
according to the parameters negotiated by the PHY.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ce607fbaaa3a..a2a15919b960 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -940,6 +940,8 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, tx_pause);
+
 	/* Undo the effects of felix_phylink_mac_link_down:
 	 * enable MAC module
 	 */
-- 
2.25.1


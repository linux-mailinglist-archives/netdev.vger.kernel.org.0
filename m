Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C63A1CF2
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhFISpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:45:24 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:37545 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFISpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:45:22 -0400
Received: by mail-ej1-f41.google.com with SMTP id ce15so39901534ejb.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJOMwWkmACOVjOePCsgqeCByFG0o+AG6cYYoRpeib2s=;
        b=Y1bAIXtA7d23t7BzzQcah5uggKYj8oy+xhQ7wIUIA8oiVJZv1VN6LAwxFScl9GqYdl
         2mjAWI1ZoGQj5jp8zxx8n+ysNI6mrrz/U6XR79/NyKo4KQlV4uFDatorspicItOMw4my
         3dB8O9oRsIWGfgoSy6sogJCu+C6W+5cYHiv1YmRk20haR9guUfcHfuXBIJBuvPvb8ItL
         UxEU5grsaHroguR3KWF0e6l5zOwkVGHqugqn+fpD4hiQXQ2sPodgjLyD2WBArd6y76xL
         geDdLMZGJo28keR2ZN9Et/TsYci1BzexhnzP2r6ff+Z6gJB8rFwhnYO93qRv250ZagnV
         H4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJOMwWkmACOVjOePCsgqeCByFG0o+AG6cYYoRpeib2s=;
        b=JILPl1N8HRN2ixZap5NqzL6V6eK4gJPEmnKTQPTAGe7do/Ts3+bShO1TokoAUQS/3B
         eK59nxRO3HOz87Wn5eljG7xiJiLY5Cdl2bN8IC8l/e7EEH7rBkXoFgMOil6vHO5bk2vg
         ZWTqLG69615R7fW1tmmOblHLL2r+b9bySMc3jx6wTusOA1oUAWUb5k82JmZT0hRuo0Ui
         oPAfuna6BvZpiIPmsdGJxO6+tLjWATuCjCvtE5Nb3sO4D/r+tB2snCTVIOEqwLU3RX5t
         regpIsaT68PoMOOAkCxezQso93pbOeFZyIQ7zp1AwcQU40OrDp8/hUnVhjcqifU5tny8
         q9zw==
X-Gm-Message-State: AOAM532oCyMFUKWZvxgIAumb2tjvbC2Vy4HS0vzoZHkFPBpO1/HgSOBo
        /3NIjOXqORsw3BD2UchmDmc=
X-Google-Smtp-Source: ABdhPJx12AdDmvxWJKZZUOoqy4RGvMsvYneUxfvkhVEiyU1p4JOgSohvtxjQS/XIhUxh/eXgio17Cg==
X-Received: by 2002:a17:907:1112:: with SMTP id qu18mr1070040ejb.511.1623264139656;
        Wed, 09 Jun 2021 11:42:19 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 06/13] net: pcs: xpcs: also ignore phy id if it's all ones
Date:   Wed,  9 Jun 2021 21:41:48 +0300
Message-Id: <20210609184155.921662-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

xpcs_get_id() searches multiple MMDs for a known PHY ID, starting with
MDIO_MMD_PCS (3). However not all integrators might have implemented
that MMD on their MDIO bus. For example, the NXP SJA1105 and SJA1110
switches only implement vendor-specific MMD 1 and 2.

When there is nothing on an MDIO bus at a certain address, traditionally
the bus returns 0xffff, which means that the bus remained in its default
pull-up state for the duration of the MDIO transaction. The 0xffff value
is widely used in drivers/net/phy/phy_device.c (see get_phy_c22_id for
example) to denote a missing device.

So it makes sense for the xpcs to ignore this value as well, and
continue its search, eventually finding the proper PHY ID in the
vendor-specific MMDs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 743b53734eeb..ecf5011977d3 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -965,8 +965,10 @@ static u32 xpcs_get_id(struct dw_xpcs *xpcs)
 	if (ret < 0)
 		return 0xffffffff;
 
-	/* If Device IDs are not all zeros, we found C73 AN-type device */
-	if (id | ret)
+	/* If Device IDs are not all zeros or all ones,
+	 * we found C73 AN-type device
+	 */
+	if ((id | ret) && (id | ret) != 0xffffffff)
 		return id | ret;
 
 	/* Next, search C37 PCS using Vendor-Specific MII MMD */
-- 
2.25.1


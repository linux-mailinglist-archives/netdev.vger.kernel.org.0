Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B810920A1D6
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405831AbgFYPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405829AbgFYPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:24:07 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B73C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:24:07 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t21so4510106edr.12
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ScaA1qPqH2co8Q7vAYQz1eWeNCP4sWbZpFvYfd2hEas=;
        b=a5DCITKG7qUWUWgJzlBnOJnLcEeMrnrgUsffbteG6jbHMkjcCfiFM/zwx6fOeiR9x8
         V3nskVy4+OV4esYLJUlB+BxAug8UjWfQNGB0NS3NEROqq6pzhzWBKmie5WGtu3+8zqqh
         Z0x+ssGWm0m0/2wiiD4gMKU6iWy5oh6Ls90SjlqLxyO7h5idw04LVY/Sv6an5F95LHHR
         ygPo+9nPzpi/8Yeb4vNZLsMSphVJThdecgWRtPU5riQkprP4fpbPMrT+lhBTYX6OfGAp
         X5+Fvm4g7T5K2Jq2pPRxWvPbyHDj9tVPJLE8Q2esTI17Qcvt/rxJBLZb/R2otvw6JMbv
         dJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ScaA1qPqH2co8Q7vAYQz1eWeNCP4sWbZpFvYfd2hEas=;
        b=Zq/Qg7LObtgA6sKHpvunsp9It5uP+usnFythmPbroZCUABgcdZ3ecyFve2Er4xQKwO
         cKOTieCs61/o7RNZY8Dq6RmQyuGj+OaYOWdBBvV2Y9FaJSjw27MTV/T0A6Xtxz1BecVv
         85x6AAWWylus72E0lljjSYcPIQDJ5frWEZANhBWN8W0oDm7i5sfsl/SY6DnpVjRkOkDU
         Y556iNIZocMaDojRY/9mIxkj4MXTllgP8L7wwA9gyRurZXg8vS+p0dZFyM5GoNflz/Tg
         77QK0C9dQ6MbpbFOHBP1gUjrF/Ih6BEBqHV+j6TwzLBaXfhcXYr45oQC0PqJecRKNqd8
         +5iA==
X-Gm-Message-State: AOAM530ZKFQW/I7Q9V3mad4qOlGqY2fq2DrVyk6yW9BuuPi0DqiiRzm9
        sbpcQ7c+pSOPmRkI0vv2TSU=
X-Google-Smtp-Source: ABdhPJxXO27eO0ceuwQzK7S/7Xrnfkaj+3mxfZU2b6B+FRTNgFNBWAKY/XwwgBe46jq8eAc3bAN4cw==
X-Received: by 2002:aa7:d054:: with SMTP id n20mr32076252edo.344.1593098646322;
        Thu, 25 Jun 2020 08:24:06 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:24:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 6/7] net: dsa: felix: disable in-band AN in MII_BMCR without reset
Date:   Thu, 25 Jun 2020 18:23:30 +0300
Message-Id: <20200625152331.3784018-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625152331.3784018-1-olteanv@gmail.com>
References: <20200625152331.3784018-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The PCS doesn't need to be reset, we just need to clear BMCR_ANENABLE.
Since the only writable fields of MII_BMCR in this PCS are:

- BMCR_RESET
- BMCR_LOOPBACK
- BMCR_ANENABLE
- BMCR_PDOWN
- BMCR_ISOLATE
- BMCR_ANRESTART

it's safe to write zero to disable in-band AN.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7d2673dab7d3..dba62c609efc 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -807,7 +807,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 			if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
 
 		phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
-		phy_write(pcs, MII_BMCR, BMCR_RESET);
+		phy_write(pcs, MII_BMCR, 0);
 	}
 }
 
@@ -844,7 +844,7 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
 		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
 
 	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
-	phy_write(pcs, MII_BMCR, BMCR_RESET);
+	phy_write(pcs, MII_BMCR, 0);
 }
 
 static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
-- 
2.25.1


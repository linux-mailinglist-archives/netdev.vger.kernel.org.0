Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB106905E7
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfHPQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:32:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34954 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfHPQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:32:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so2110149wrq.2;
        Fri, 16 Aug 2019 09:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6HbAK58OFpvUkR4KVobqfgmu2nw3vionRRZeOZxs7qk=;
        b=j6xs8jyqYHCksBi8VbBmmaZdhf0SXI+9FiWiAWovygXL8Fca04dNsHaPyG6IANCbvH
         eHxEFyoU4MAgq3AAeUQPP0ADAqdm88ePkQCQ8Bxr54eXy5vIBrGasNNv4iYpzXFAYmvx
         VgNW2uF+jk2EaJ4F1rF3hh+yvojCXOtO8wBFGAQmIUcz4t2C2KVj5TZUWZh1k9sRKMWn
         /RK33G7caRd10ZqawNx0iqs2TeMGnCq795KtSo/73tQn7KZbdeRAyV4sWtAklut3QmMJ
         MVPIS5eq6P9a+HlF3OuSLm+sDvcBZbzknb+Qv6+gr5U6ynWlcx1quSCZDFuTUDAk8ia4
         fqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6HbAK58OFpvUkR4KVobqfgmu2nw3vionRRZeOZxs7qk=;
        b=G9mhZtVXdP/XVmB41lLiZT262hhuBkU/91Qel/UHolB7TSPdNtaMpjqy1UkcC78N5A
         DMuHmtzRh/+ThZ0M6t/JplCk4vLtgGZdmpr5w/zn9k1T3sti4/LXZCfGR3c8tHDF52Ag
         SBx7V0iOUElWhvIaxfY1POO7roPakFn1WKMccJsVpR0K/raPp3Z8yfniKmK7yvivy29r
         6FriOVL6ZjdV0zdFFSgbpNaaSiyKdp1YqxMdrZTQlb/D1kQLWvPuhzeAw7k7E43MVcey
         DEl/MHVHDDs3FG81egW+sASKN9Uzy/4fjJe9PjnEYk6fTknjzQDeyGAkdhwCPxkbv+YI
         9p1w==
X-Gm-Message-State: APjAAAXioLvjMjLl/yo2JSocjf4fam7QxWLxhQ1gD3Hz9fq2mJeSeWFD
        pg/uxyT7qpAnS19s7aGUFJxltpa45Vs=
X-Google-Smtp-Source: APXvYqx2jvorbue0DE240aovjk9DjwXLAjqL7ff0F+PIfq1w3trzWgyadXlJO3LcmtIyDfzriA/vEg==
X-Received: by 2002:adf:fc87:: with SMTP id g7mr11872230wrr.319.1565973153280;
        Fri, 16 Aug 2019 09:32:33 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id d19sm11031677wrb.7.2019.08.16.09.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:32:32 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 3/3] net: fec: add support for PTP system timestamping for MDIO devices
Date:   Fri, 16 Aug 2019 18:31:57 +0200
Message-Id: <20190816163157.25314-4-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190816163157.25314-1-h.feurstein@gmail.com>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to improve the synchronisation precision of phc2sys (from
the linuxptp project) for devices like switches which are attached
to the MDIO bus, it is necessary the get the system timestamps as
close as possible to the access which causes the PTP timestamp
register to be snapshotted in the switch hardware. Usually this is
triggered by an MDIO write access, the snapshotted timestamp is then
transferred by several MDIO reads.

The ptp_read_system_*ts functions already check the ptp_sts pointer.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2f6057e7335d..60e866631b61 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1815,10 +1815,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	reinit_completion(&fep->mdio_done);
 
 	/* start a write op */
+	ptp_read_system_prets(bus->ptp_sts);
 	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
 		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
 		FEC_MMFR_TA | FEC_MMFR_DATA(value),
 		fep->hwp + FEC_MII_DATA);
+	ptp_read_system_postts(bus->ptp_sts);
 
 	/* wait for end of transfer */
 	time_left = wait_for_completion_timeout(&fep->mdio_done,
@@ -2034,6 +2036,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		pdev->name, fep->dev_id + 1);
 	fep->mii_bus->priv = fep;
 	fep->mii_bus->parent = &pdev->dev;
+	fep->mii_bus->ptp_sts_supported = true;
 
 	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
 	err = of_mdiobus_register(fep->mii_bus, node);
-- 
2.22.1


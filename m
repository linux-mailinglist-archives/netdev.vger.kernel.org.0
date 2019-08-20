Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7700995A2F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfHTItJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:49:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35942 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfHTItD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 04:49:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so11511750wrt.3;
        Tue, 20 Aug 2019 01:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDL1hIKadz1gfObFDnKi45zKhu1D1Ko8kUYujKrQlXI=;
        b=Eev7i6GzahYrLsR0wFJydyUOqhkGy0UVi5NypT33nkNFTETCLPE/pDVaolap9SKM1D
         9TiAi4Nnzn6piRb3l8GXZQqGP05ylBLVO1lMUWGpOAMSuMCllaq6EEYazl/Ft0McA7S6
         lTVdRGdxo1K/KVNb8HePAjZeFGMlubvy/rOCmmExGctrPjsAi3iRc3jrDEoGmP1mPhgJ
         QLcdznl3R0xdyKVzfpY8El3rPs23JdJb03xV0L7VDhL4AoAxHxG32qX+LegZ/MmN63gi
         ZPAUJWFiXR8QHi0UIL3UymONMsLobxwfJvEUMgO5RyeGJqv9r/1YvcIMtbnhiNRwnktG
         YVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDL1hIKadz1gfObFDnKi45zKhu1D1Ko8kUYujKrQlXI=;
        b=qY9zzdWXwTPnv3cB0Yi68G9qoQRIsndakrb2H2uCg/VL9WReInWoPexTyXj7TcEqSW
         bVO554EsWSMRcBbDmg/8LXyDpRAxOE8oTwXjR6koTEny7FbzoKDs7PauHa1PrzFXAJR0
         3D8foW7Ub4Yc6e/DAzBoaKam7uW9y7sLHfoiAXNzAugn/V5bjfrOpy8vSqkZU4qNmupu
         OTBbrrjzV4yN7/iwggsKWSGk5s18eUyDwc1WL5HYxEePxd9rzE93TA5tM5uqmh2epqbA
         puezlm4XqYGc4k91cXp48B1pqr4USU7kAnfcJigIvN2YSCg0HKdtUlkAsNqGmGijoQiU
         9F1A==
X-Gm-Message-State: APjAAAVBeoKmxJwYP6MTM79whBIy5kfdiG+wdevFPPdS/GYGrBefgd2s
        JpcjOmOaj+avsU/96QebjiLqBpEM8Gg=
X-Google-Smtp-Source: APXvYqwwZ1dBDGbYAQszivzUqUT0eItl/QLi/GTtdUO22WiA5QVggUXxRrv6VC+gmTXvTOe0SEJEUg==
X-Received: by 2002:adf:cd81:: with SMTP id q1mr29360456wrj.16.1566290940464;
        Tue, 20 Aug 2019 01:49:00 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id s64sm36437105wmf.16.2019.08.20.01.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 01:48:59 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v3 4/4] net: fec: add support for PTP system timestamping for MDIO devices
Date:   Tue, 20 Aug 2019 10:48:33 +0200
Message-Id: <20190820084833.6019-5-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820084833.6019-1-hubert.feurstein@vahle.at>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

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
 drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c01d3ec3e9af..dd1253683ac0 100644
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
@@ -1956,7 +1958,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct device_node *node;
 	int err = -ENXIO;
-	u32 mii_speed, holdtime;
+	u32 mii_speed, mii_period, holdtime;
 
 	/*
 	 * The i.MX28 dual fec interfaces are not equal.
@@ -1993,6 +1995,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	 * document.
 	 */
 	mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 5000000);
+	mii_period = div_u64((u64)mii_speed * 2 * NSEC_PER_SEC, clk_get_rate(fep->clk_ipg));
 	if (fep->quirks & FEC_QUIRK_ENET_MAC)
 		mii_speed--;
 	if (mii_speed > 63) {
@@ -2034,6 +2037,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		pdev->name, fep->dev_id + 1);
 	fep->mii_bus->priv = fep;
 	fep->mii_bus->parent = &pdev->dev;
+	fep->mii_bus->flags = MII_BUS_F_PTP_STS_SUPPORTED;
+	fep->mii_bus->ptp_sts_offset = 32 * mii_period;
 
 	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
 	err = of_mdiobus_register(fep->mii_bus, node);
-- 
2.22.1


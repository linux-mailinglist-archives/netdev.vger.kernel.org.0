Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A231D3AB02F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhFQJvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:33 -0400
Received: from first.geanix.com ([116.203.34.67]:41918 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231873AbhFQJva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:30 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id 106774C325D;
        Thu, 17 Jun 2021 09:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923361; bh=Uk5FCCq/1hvryiYQiavefB+WTK09cJgC9AtSy84qEt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=GnnqdQ5V/UeL4MATP7d7kuaHLuKjFWGWmCX7OvdCB+Ed2c88XZ02kn9IIEDwEq4Jj
         dItGk5y35TPEhcibTjc85UQ2nG1bImQ96nikqRAcUn4iBEcQrx79IK5HgfDvgRMKm/
         XIpCFGFRl9rQE7B4paV1KKTidbeIVA4uOSBTOe7kBO7CF+ZGXXZTAPgZ1sU7EQzo/j
         K9HdgolAGZZ8ulFj8pmxZXR0cvNVWwwe8xrrBM+2m4LF2uJdkJa53Icp9xpZ9WtNYr
         +w4vyJSNOQ25set5m5akPFMsB0F9/A2L/ssvf5d3RoTPQt1JK0G2/+KfoZYoLkn5XF
         0oKYPjd63/SJQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/6] net: gianfar: Clear CAR registers
Date:   Thu, 17 Jun 2021 11:49:20 +0200
Message-Id: <fe53d563c9b53266273f6fee148cbc34c1258d2f.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
References: <cover.1623922686.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAR1 and CAR2 registers are W1C style registers, to the memset does not
actually clear them.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index a0277fe8cc60..ebd1065f39fa 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3103,6 +3103,9 @@ static void gfar_hw_init(struct gfar_private *priv)
 		/* Mask off the CAM interrupts */
 		gfar_write(&regs->rmon.cam1, 0xffffffff);
 		gfar_write(&regs->rmon.cam2, 0xffffffff);
+		/* Clear the CAR registers (w1c style) */
+		gfar_write(&regs->rmon.car1, 0xffffffff);
+		gfar_write(&regs->rmon.car2, 0xffffffff);
 	}
 
 	/* Initialize ECNTRL */
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED34F1DF141
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgEVVbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:31:11 -0400
Received: from foss.arm.com ([217.140.110.172]:42312 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730976AbgEVVbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DBA41063;
        Fri, 22 May 2020 14:31:09 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D5063F68F;
        Fri, 22 May 2020 14:31:09 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 01/11] net: phy: Don't report success if devices weren't found
Date:   Fri, 22 May 2020 16:30:49 -0500
Message-Id: <20200522213059.1535892-2-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522213059.1535892-1-jeremy.linton@arm.com>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

C45 devices are to return 0 for registers they haven't
implemented. This means in theory we can terminate the
device search loop without finding any MMDs. In that
case we want to immediately return indicating that
nothing was found rather than continuing to probe
and falling into the success state at the bottom.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ac2784192472..245899b58a7d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -742,6 +742,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 		}
 	}
 
+	/* no reported devices */
+	if (*devs == 0) {
+		*phy_id = 0xffffffff;
+		return 0;
+	}
+
 	/* Now probe Device Identifiers for each device present. */
 	for (i = 1; i < num_ids; i++) {
 		if (!(c45_ids->devices_in_package & (1 << i)))
-- 
2.26.2


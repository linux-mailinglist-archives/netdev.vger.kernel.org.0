Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1AE21CA71
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgGLQsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 12:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgGLQsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 12:48:30 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBA2C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 09:48:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so11897728ejb.4
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yezM8YWJfYkjuSfoqppEKLwC3kVG4r46rnpG5L2EQ3Q=;
        b=WvtK1RfeUhEdKZdbceUp8boiPE3nDiCyqrCLShlK3vo8X0ProHH57PGGQlvJCt4Nyy
         8y/hJLS+CxFIjzBp/y4pGX7S6mBpqWcZLeiwT45aCLpvBtAITkocK4Djy5RPQK988mwF
         iwJNA0XnWCrWBhuWQ4hoPcNMcBx210vFfW48OwzmD2iJNQ74HssC6kZqECk206ME6a23
         i0xl8s9gdAqG5zffrWcSOXv4DyeRxmJ3AjXEoSNOJoByGCEveB52LEuDxFsOLvlSMCJq
         yd13RfZuDc+gjYFOnEGGwnBNOQ08OeF9fDDrRhTCFz6om7KaWdQecbVkAXPUqOyqB2av
         DgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yezM8YWJfYkjuSfoqppEKLwC3kVG4r46rnpG5L2EQ3Q=;
        b=c1w4haDOmMCsBZohRu2nkp/qJtz6M001WUMWkZyfnryJB1Oj5i7mJuXH2X87sh3uTf
         hah2iULU2WNOOH+rWpO/GAK0kqJj68Wb9XCsLLezHLnemEVfcO+rPV7wn9zLHB9XSQj0
         3+qKhAG+QHmSa1NQ+/UglkDk0MeAwgBUL3qQ4+2UzyJtVoetIVGbQvTrg7/JmW19n3v4
         DNRnKJEML6nwjjQkdkx2d1PHO7LM06PuwuwqT1us0+lTu0NCb0KOpeEdkFfCIbKla6TY
         3TKG1qwPRjqohe9fAMlkPfsTuKgrjZZ2ZtlJTiJIOZFWxxq+E+ni4krKrONdBFeWZxXh
         EhoA==
X-Gm-Message-State: AOAM531/880hAMik1lFHVmM68IL4wH6LQSR+4YvMDDKpNJ+qhRe1gn/Z
        1GLo6Kv8Q7Z0nEjQT8Dzco6Qepb9
X-Google-Smtp-Source: ABdhPJzvNcsyzAObJXsDiYAnrxhO/UIh/2GsYJljiHXXJYlQGMJHr+YF2Cx9lKz/RPrfRtoZlkZN1g==
X-Received: by 2002:a17:906:cc13:: with SMTP id ml19mr69398024ejb.288.1594572508892;
        Sun, 12 Jul 2020 09:48:28 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bq8sm7639059ejb.103.2020.07.12.09.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 09:48:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc
Subject: [PATCH net-next] net: phy: continue searching for C45 MMDs even if first returned ffff:ffff
Date:   Sun, 12 Jul 2020 19:48:15 +0300
Message-Id: <20200712164815.1763532-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

At the time of introduction, in commit bdeced75b13f ("net: dsa: felix:
Add PCS operations for PHYLINK"), support for the Lynx PCS inside Felix
was relying, for USXGMII support, on the fact that get_phy_device() is
able to parse the Lynx PCS "device-in-package" registers for this C45
MDIO device and identify it correctly.

However, this was actually working somewhat by mistake (in the sense
that, even though it was detected, it was detected for the wrong
reasons).

The get_phy_c45_ids() function works by iterating through all MMDs
starting from 1 (MDIO_MMD_PMAPMD) and stops at the first one which
returns a non-zero value in the "device-in-package" register pair,
proceeding to see what that non-zero value is.

For the Felix PCS, the first MMD (1, for the PMA/PMD) returns a non-zero
value of 0xffffffff in the "device-in-package" registers. There is a
code branch which is supposed to treat this case and flag it as wrong,
and normally, this would have caught my attention when adding initial
support for this PCS:

	if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
		/* If mostly Fs, there is no device there, then let's probe
		 * MMD 0, as some 10G PHYs have zero Devices In package,
		 * e.g. Cortina CS4315/CS4340 PHY.
		 */

However, this code never actually kicked in, it seems, because this
snippet from get_phy_c45_devs_in_pkg() was basically sabotaging itself,
by returning 0xfffffffe instead of 0xffffffff:

	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
	*devices_in_package &= ~BIT(0);

Then the rest of the code just carried on thinking "ok, MMD 1 (PMA/PMD)
says that there are 31 devices in that package, each having a device id
of ffff:ffff, that's perfectly fine, let's go ahead and probe this PHY
device".

But after cleanup commit 320ed3bf9000 ("net: phy: split
devices_in_package"), this got "fixed", and now devs_in_pkg is no longer
0xfffffffe, but 0xffffffff. So now, get_phy_device is returning -ENODEV
for the Lynx PCS, because the semantics have remained mostly unchanged:
the loop stops at the first MMD that returns a non-zero value, and that
is MMD 1.

But the Lynx PCS is simply a clause 37 PCS which implements the required
MAC-side functionality for USXGMII (when operated in C45 mode, which is
where C45 devices-in-package detection is relevant to). Of course it
will fail the PMD/PMA test (MMD 1), since it is not a PHY. But it does
implement detection for MDIO_MMD_PCS (3):

- MDIO_DEVS1=0x008a, MDIO_DEVS2=0x0000,
- MDIO_DEVID1=0x0083, MDIO_DEVID2=0xe400

Let get_phy_c45_ids() continue searching for valid MMDs, and don't
assume that every phy_device has a PMA/PMD MMD implemented.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cf3505e2f587..15e5bb25103f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -734,7 +734,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
 	 */
-	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0; i++) {
+	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0 &&
+	     (devs_in_pkg & 0x1fffffff) == 0x1fffffff; i++) {
 		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
 			/* Check that there is a device present at this
 			 * address before reading the devices-in-package
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3AC33C84F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhCOVPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhCOVPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228EC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:08 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id m22so59092489lfg.5
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=4PXGw3uTopKOX12zGc4cs1F/+LDcHOWa0xhpMMXr6uQ=;
        b=u6H5ii0vyRCiaCNFoVq82IGksW/t/np9azuAJuC+E+++290VpvyUj79sHZfOpgqTSp
         xhhGy979YjicQMBzTMKN+vcLUIj75YZrgXk5OcanmXwaTQVHeynAhehMFTLWAmj+1US8
         +8UwrG1RT7063cEnCKXS0pDTJQ4TJ4IuHPZ8Y6N+jbwODcKZs/RbNjmt2F04I6ey+owp
         AzMMt3adxan0MdqalkdW1roBPtdv4PHrYkzk04m3kJj/zps6WtbHCtRlbBrRZVi4mR3n
         EvFxt42s5P/6ElpEskpnCWKfAYEiefgC5H92f9mYzfWSAwzulBo1pC7m/bqcTH+FYtUs
         Yifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=4PXGw3uTopKOX12zGc4cs1F/+LDcHOWa0xhpMMXr6uQ=;
        b=Nnii4R6Zb2OmAm6cQ5KxATyY9L6NZKO0FYr6VOjcITc+sWdAe+iamCmPkNrdMpNzqc
         WKXQsomDhM90gbb0xnvku5CAgPBlytWflS/aPfcfPkfMq2qIGSO41IgmPtgAGPAoBHdD
         Y9ho0WIsvl0uLm1m/caoHK9cskrUxUPFIreYDv3IfEZ4Mn4doTl3GAd1rIeThzES13yu
         gVMW0vY08UrWa2800ONnytpI5Lrg4VnHSlIadxHiYLOnZPl4fu4aJnbWW6TPIL0O7/eT
         X8TlLs/WOM/vQsa1LvEFApn8RdJi/8l4NnIAf2xIIsA/yUO9WK4kg8IcIT5kylHt+rae
         ZqUg==
X-Gm-Message-State: AOAM532N5XlXRGx2Eit+kEB+QS1ED5WP5FOOorXCXdy0ON1XdWwogzR1
        +R8g19Ow58+AxXsFhfUiS772eQ==
X-Google-Smtp-Source: ABdhPJwffxfpOWRQ3ZFHvfqrri3g+MF/Dxz1i9hIT4auyAxvtXZz42BZl/ybN+FxlBHaDLeoq2Q9Yw==
X-Received: by 2002:a19:ed8:: with SMTP id 207mr8661331lfo.164.1615842907269;
        Mon, 15 Mar 2021 14:15:07 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v11sm2975003ljp.63.2021.03.15.14.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:06 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/5] net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
Date:   Mon, 15 Mar 2021 22:13:57 +0100
Message-Id: <20210315211400.2805330-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315211400.2805330-1-tobias@waldekranz.com>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware has a somewhat quirky protocol for reading out the VTU
entry for a particular VID. But there is no reason why we cannot
create a better API for ourselves in the driver.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c70d4b7db4f5..86027e98d83d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1472,13 +1472,23 @@ static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_vtu_flush(chip);
 }
 
-static int mv88e6xxx_vtu_getnext(struct mv88e6xxx_chip *chip,
-				 struct mv88e6xxx_vtu_entry *entry)
+static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
+			     struct mv88e6xxx_vtu_entry *entry)
 {
+	int err;
+
 	if (!chip->info->ops->vtu_getnext)
 		return -EOPNOTSUPP;
 
-	return chip->info->ops->vtu_getnext(chip, entry);
+	entry->vid = vid - 1;
+	entry->valid = false;
+
+	err = chip->info->ops->vtu_getnext(chip, entry);
+
+	if (entry->vid != vid)
+		entry->valid = false;
+
+	return err;
 }
 
 static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
@@ -1585,19 +1595,13 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
 
-	vlan.vid = vid - 1;
-	vlan.valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
 		return err;
 
 	if (!vlan.valid)
 		return 0;
 
-	if (vlan.vid != vid)
-		return 0;
-
 	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
 		if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
 			continue;
@@ -1679,15 +1683,12 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		if (err)
 			return err;
 	} else {
-		vlan.vid = vid - 1;
-		vlan.valid = false;
-
-		err = mv88e6xxx_vtu_getnext(chip, &vlan);
+		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 		if (err)
 			return err;
 
 		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
-		if (vlan.vid != vid || !vlan.valid)
+		if (!vlan.valid)
 			return -EOPNOTSUPP;
 
 		fid = vlan.fid;
@@ -1964,14 +1965,11 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	vlan.vid = vid - 1;
-	vlan.valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
 		return err;
 
-	if (vlan.vid != vid || !vlan.valid) {
+	if (!vlan.valid) {
 		memset(&vlan, 0, sizeof(vlan));
 
 		err = mv88e6xxx_atu_new(chip, &vlan.fid);
@@ -2067,17 +2065,14 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
 	if (!vid)
 		return -EOPNOTSUPP;
 
-	vlan.vid = vid - 1;
-	vlan.valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
 		return err;
 
 	/* If the VLAN doesn't exist in hardware or the port isn't a member,
 	 * tell switchdev that this VLAN is likely handled in software.
 	 */
-	if (vlan.vid != vid || !vlan.valid ||
+	if (!vlan.valid ||
 	    vlan.member[port] == MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 		return -EOPNOTSUPP;
 
-- 
2.25.1


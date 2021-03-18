Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56B73407A2
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhCROQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbhCROQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:16 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D528C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:16 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 16so7654237ljc.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=bYs1Xthv5i1LFr+tljtLjYlXNiB00exl9DF7BJEJ/so=;
        b=l7hXwlqBw0IekkinPV1IrL8kMOUi52q46CYR4dB8RIn+b3xrYBDJYBYvNidv1oQYnS
         hOV/ymD5lKSp1Q4GN8a3ZiKljJv+Bj7Zp/tmpFIRzm8+2VAs3o23Fyb4n/LVt4ZzXHUA
         o43bHgV2DgmPleyfa+RBtjndGqCORrQcTYIe4l3txDpgwKtqItFVkq7wNG+BBBPaaO39
         u7PHuCSEhwL4TncJsyKFbdZ0c+FdXZePqJiAQnngk5SNNNdje8qjGghDWLQG38veW81+
         tcs8VtFLz6quexUgeSvkFcaaIl2uvHevAWBcAEW4sYaDI30wVhox5mWxrm1ijNHOxBIg
         0tPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=bYs1Xthv5i1LFr+tljtLjYlXNiB00exl9DF7BJEJ/so=;
        b=Dp5LNum13bIbfLPgwMk4QPEy1pe+bx77i6wYA37QlTYvqqfb6uwoQrP05MYOMWLCoy
         jVVeCSmnzWKLI+DKd3dF8XJTwX5OnzK/RZsBE6oA0Np0fvPb/l6IaYdADxppxI5Rzc4d
         kLwwqohti2f/sPOrwfJGL2QW/kx/vAYywFslVyFcPbx+6VtMPURmLbkiPHz0pjk1Kt0k
         yLZ6c5LCfOhZ4ItU8IFHNe9uJi4Q12d9eCSt8ni5B/YPiRbV91vKjkJQM68rsDpUvDqR
         8GyrgFJ/eScYyNVneFkWmYTrVoeu7yVNkhREwL6fea+u8jwq24BJf7VnznCry89vS+qn
         klSQ==
X-Gm-Message-State: AOAM533vhG0YsqXeHf6d5VV1sroJM7MNlAM6Q5LQrFysmUOnhQKdEJz5
        wZhSPaPvt34d9rJbRkFKDMdzxQ==
X-Google-Smtp-Source: ABdhPJzOccmt6RggYkbg94ODgFdyd+G0/CMsH92/o2CoBvA9qM+fmpZ2QW1Lzq1+4I3sBDyPH2hKfA==
X-Received: by 2002:a2e:b537:: with SMTP id z23mr5343739ljm.350.1616076975037;
        Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:14 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 4/8] net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
Date:   Thu, 18 Mar 2021 15:15:46 +0100
Message-Id: <20210318141550.646383-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
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
index 0a4e467179c9..c18c55e1617e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1502,13 +1502,23 @@ static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
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
+	entry->vid = vid ? vid - 1 : mv88e6xxx_max_vid(chip);
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
@@ -1615,19 +1625,13 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
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
@@ -1709,15 +1713,12 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
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
@@ -1994,14 +1995,11 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
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
@@ -2097,17 +2095,14 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
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


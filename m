Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0B7E251
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733140AbfHAShJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:37:09 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37198 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733092AbfHAShI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 14:37:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id d15so52813426qkl.4;
        Thu, 01 Aug 2019 11:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EXX+Qqt0ZE4eNfvP2E1+A9brR0aRRRpY9IipGGAkATQ=;
        b=dFP9ya7c6lifFd28xUcnEnQvUD089Zqr0fwV6wo8yk9BIv1yMTGM9ACNclJl67/mmH
         2u6gIi7IN5VK7yezxNr5Q8ubY4q9PwZv6+Io/3OPMT5gy8abzjW6uzDPQs6Y0T75/ali
         jgdcblz711gwb5U3T07juZk1PLQ5SDaWnXjeZsTparnVBryx0xhM3tbxgU1AkFdW0n24
         d1vVLZTV0vXzf4xQ4inYHWwr0WY9e5qIbi3aQW/Zvv1BJxezbqKSV9JU/qxb0FHPAgJD
         tPIinC0TSQUcnRX4JNpw3tJTo6Hg31tZdxqvUcPqhlB/S7dehh/hruOBvROBBAOA8iAU
         n5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EXX+Qqt0ZE4eNfvP2E1+A9brR0aRRRpY9IipGGAkATQ=;
        b=TmVEqjBJD1JHZt34vk31t3wCPdb+eFPmVhw70GlVhxen6FGEFsFrJz2NqE6cgS7iDE
         t6YMDCM+1GrL0/uPKxrlWNIRC7Yo/kE5wcrk02O6QDLHAPR9Z0btGT4fATYZFKOfFqOf
         5HK0g+H6F/SwDHIolg4cenK2bFtpQCqU6yp6c7vk66GR9iKI+uJB+t1AOhdVXYhQmK3c
         ZhiRyYG/W07EvblwkcnKN1nYRWgWj4ibz4rbBvVDQNRp728TnYrDtlFOiyO3a2/Bm+2x
         x2Nhii/dm5MmMK+ifgwm2r94Ge89oj2KhDMNU3KxlBgjQB4ghCLxWODNX6H9OczquJfL
         LkdA==
X-Gm-Message-State: APjAAAU1OYI/h0vccnHkXXNDYV7WbdcGWlrWsd9Dt5yUfMxTCoFgc91b
        pyB8O9p7sgY9ICIQem2a//SJsOHuS5U=
X-Google-Smtp-Source: APXvYqxnMAC/ti1fHp9fTjD9vA+YleCPtjM9ih/ATPLJM9PdQYJWceMG5tqPzDHwzqjXVBjnbWk4Og==
X-Received: by 2002:ae9:edcf:: with SMTP id c198mr76908910qkg.79.1564684627230;
        Thu, 01 Aug 2019 11:37:07 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z33sm32739001qtc.56.2019.08.01.11.37.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 11:37:06 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 5/5] net: dsa: mv88e6xxx: call vtu_getnext directly in vlan_add
Date:   Thu,  1 Aug 2019 14:36:37 -0400
Message-Id: <20190801183637.24841-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190801183637.24841-1-vivien.didelot@gmail.com>
References: <20190801183637.24841-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrapping mv88e6xxx_vtu_getnext makes the code less easy to read and
_mv88e6xxx_port_vlan_add is the only function requiring the preparation
of a new VLAN entry.

To simplify things up, remove the mv88e6xxx_vtu_get wrapper and
explicit the VLAN lookup in _mv88e6xxx_port_vlan_add. This rework
also avoids programming the broadcast entries again when changing a
port's membership, e.g. from tagged to untagged.

At the same time, rename the helper using an old underscore convention.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 93 +++++++++++++++-----------------
 1 file changed, 44 insertions(+), 49 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 50a6dbcc669c..8c4216e7a4bb 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1401,43 +1401,6 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
 }
 
-static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
-			     struct mv88e6xxx_vtu_entry *entry, bool new)
-{
-	int err;
-
-	if (!vid)
-		return -EOPNOTSUPP;
-
-	entry->vid = vid - 1;
-	entry->valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, entry);
-	if (err)
-		return err;
-
-	if (entry->vid == vid && entry->valid)
-		return 0;
-
-	if (new) {
-		int i;
-
-		/* Initialize a fresh VLAN entry */
-		memset(entry, 0, sizeof(*entry));
-		entry->vid = vid;
-
-		/* Exclude all ports */
-		for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
-			entry->member[i] =
-				MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER;
-
-		return mv88e6xxx_atu_new(chip, &entry->fid);
-	}
-
-	/* switchdev expects -EOPNOTSUPP to honor software VLANs */
-	return -EOPNOTSUPP;
-}
-
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid_begin, u16 vid_end)
 {
@@ -1616,26 +1579,58 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 	return 0;
 }
 
-static int _mv88e6xxx_port_vlan_add(struct mv88e6xxx_chip *chip, int port,
+static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 				    u16 vid, u8 member)
 {
+	const u8 non_member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER;
 	struct mv88e6xxx_vtu_entry vlan;
-	int err;
+	int i, err;
 
-	err = mv88e6xxx_vtu_get(chip, vid, &vlan, true);
+	if (!vid)
+		return -EOPNOTSUPP;
+
+	vlan.vid = vid - 1;
+	vlan.valid = false;
+
+	err = mv88e6xxx_vtu_getnext(chip, &vlan);
 	if (err)
 		return err;
 
-	if (vlan.valid && vlan.member[port] == member)
-		return 0;
-	vlan.valid = true;
-	vlan.member[port] = member;
+	if (vlan.vid != vid || !vlan.valid) {
+		memset(&vlan, 0, sizeof(vlan));
 
-	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
-	if (err)
-		return err;
+		err = mv88e6xxx_atu_new(chip, &vlan.fid);
+		if (err)
+			return err;
 
-	return mv88e6xxx_broadcast_setup(chip, vid);
+		for (i = 0; i < mv88e6xxx_num_ports(chip); ++i)
+			if (i == port)
+				vlan.member[i] = member;
+			else
+				vlan.member[i] = non_member;
+
+		vlan.vid = vid;
+		vlan.valid = true;
+
+		err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
+		if (err)
+			return err;
+
+		err = mv88e6xxx_broadcast_setup(chip, vlan.vid);
+		if (err)
+			return err;
+	} else if (vlan.member[port] != member) {
+		vlan.member[port] = member;
+
+		err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
+		if (err)
+			return err;
+	} else {
+		dev_info(chip->dev, "p%d: already a member of VLAN %d\n",
+			 port, vid);
+	}
+
+	return 0;
 }
 
 static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
@@ -1660,7 +1655,7 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	mv88e6xxx_reg_lock(chip);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		if (_mv88e6xxx_port_vlan_add(chip, port, vid, member))
+		if (mv88e6xxx_port_vlan_join(chip, port, vid, member))
 			dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
 				vid, untagged ? 'u' : 't');
 
-- 
2.22.0


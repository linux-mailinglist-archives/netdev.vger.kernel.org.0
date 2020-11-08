Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB102AADE6
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 23:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgKHWik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 17:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHWik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 17:38:40 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39089C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 14:38:40 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id f11so3445305lfs.3
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 14:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=XvtYpd7qnwyp8B6VdF4G5l6lzv7PvAqFGFj4/R7RbeI=;
        b=KEbuLhOdGYUVjdVRnF7T6xxbVzlQn/IqW1bg1PMBVa2GkKYQZJ8K7o0ErrxhphuvGS
         qvy1gs1uS56n6KKvpNFnfENQUhY/cM+tzGDLAV6Z9liS1EgkAFza3m8mAUFhjsq2jVPj
         /7D9G5/mBngBJ5Ceikfmy3BarjvDDpNhCdIiK0+bEJd6w7MG00r0IqYrIJ5MhdY+nhlo
         lds7IJW9k86YBJIY1M9kwPqtNzkiHdZigZBfk7O9N/S7jTjohCp0WJKfjvlsISVt09Sw
         gWzygLb6KWulak3Xz/DbEJKkX0mUDlfWi3VikWNw1IC4kVxHPcm4X1PmSg57qGRqkpgv
         Q07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=XvtYpd7qnwyp8B6VdF4G5l6lzv7PvAqFGFj4/R7RbeI=;
        b=iajzW2rJDi4896so+ZUAHMD1romYgaeFjIgf0htw8OnfEgyWUh8k+Q4rsSM2cuJNgm
         fQh5YinU36+XAc6B+s68srL0VLD+X3EY1GRCKIHv0j/YW7FSXFHanPDXRJiLhWBLjRN8
         5nXcA1Ib+1Sxo3CtamUGwexuY8edVqtQs8QIMBc8viYD+FVsTbla8Jj6NyOmV0VtWe9E
         Zr871vDJER0+e8Lot8cGlmn9+zZThV41F+FINGCTVNkDbkqBtZWflvXlHxaInF4qzd0X
         ezZbSLYFawptW+sGVZf+pzRYs0BVNexCh+DhE7+GnsLZW2M/XGL6MM+rbEyY79ll6b5w
         q4bw==
X-Gm-Message-State: AOAM5333OyE82QnEkcCZ3+cUx7lPKbbfKC6P1xu5oygSSztC9/Dhp/CU
        ezpyAZCZ/VBgOdiz50JK1B0apOJFZSJhEjAj
X-Google-Smtp-Source: ABdhPJzn+eeTJwKBIr9Z5qorxqRzjvUBXBmdAt9oY67qhNzBCyBcS0ot/qclUFAtR6Rnz+ehCi3qzw==
X-Received: by 2002:a05:6512:2033:: with SMTP id s19mr443455lfs.462.1604875118700;
        Sun, 08 Nov 2020 14:38:38 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c22sm1555457lfm.45.2020.11.08.14.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 14:38:38 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: 6352: parse VTU data before loading STU data
Date:   Sun,  8 Nov 2020 23:38:10 +0100
Message-Id: <20201108223810.15266-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the 6352, doing a VTU GetNext op, followed by an STU GetNext op
will leave you with both the member- and state- data in the VTU/STU
data registers. But on the 6097 (which uses the same implementation),
the STU GetNext will override the information gathered from the VTU
GetNext.

Separate the two stages, parsing the result of the VTU GetNext before
doing the STU GetNext.

We opt to update the existing implementation for all applicable chips,
as opposed to creating a separate callback for 6097. Though the
previous implementation did work for (at least) 6352, the datasheet
does not mention the masking behavior.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

I was not sure if I should have created a separate callback, but I
have not found any documentation that suggests that you can expect the
STU GetNext op to mask the bits that are used to store VTU membership
information in the way that 6352 does. So depending on undocumented
behavior felt like something we would want to get rid of anyway.

Tested on 6097F and 6352.

drivers/net/dsa/mv88e6xxx/global1_vtu.c | 55 ++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 48390b7b18ad..2f146645a723 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -125,11 +125,9 @@ static int mv88e6xxx_g1_vtu_vid_write(struct mv88e6xxx_chip *chip,
  * Offset 0x08: VTU/STU Data Register 2
  * Offset 0x09: VTU/STU Data Register 3
  */
-
-static int mv88e6185_g1_vtu_data_read(struct mv88e6xxx_chip *chip,
-				      struct mv88e6xxx_vtu_entry *entry)
+static int mv88e6185_g1_vtu_stu_data_read(struct mv88e6xxx_chip *chip,
+					  u16 *regs)
 {
-	u16 regs[3];
 	int i;
 
 	/* Read all 3 VTU/STU Data registers */
@@ -142,12 +140,45 @@ static int mv88e6185_g1_vtu_data_read(struct mv88e6xxx_chip *chip,
 			return err;
 	}
 
-	/* Extract MemberTag and PortState data */
+	return 0;
+}
+
+static int mv88e6185_g1_vtu_data_read(struct mv88e6xxx_chip *chip,
+				      struct mv88e6xxx_vtu_entry *entry)
+{
+	u16 regs[3];
+	int err;
+	int i;
+
+	err = mv88e6185_g1_vtu_stu_data_read(chip, regs);
+	if (err)
+		return err;
+
+	/* Extract MemberTag data */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
 		unsigned int member_offset = (i % 4) * 4;
-		unsigned int state_offset = member_offset + 2;
 
 		entry->member[i] = (regs[i / 4] >> member_offset) & 0x3;
+	}
+
+	return 0;
+}
+
+static int mv88e6185_g1_stu_data_read(struct mv88e6xxx_chip *chip,
+				      struct mv88e6xxx_vtu_entry *entry)
+{
+	u16 regs[3];
+	int err;
+	int i;
+
+	err = mv88e6185_g1_vtu_stu_data_read(chip, regs);
+	if (err)
+		return err;
+
+	/* Extract PortState data */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		unsigned int state_offset = (i % 4) * 4 + 2;
+
 		entry->state[i] = (regs[i / 4] >> state_offset) & 0x3;
 	}
 
@@ -374,16 +405,20 @@ int mv88e6352_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 		return err;
 
 	if (entry->valid) {
-		/* Fetch (and mask) VLAN PortState data from the STU */
-		err = mv88e6xxx_g1_vtu_stu_get(chip, entry);
+		err = mv88e6185_g1_vtu_data_read(chip, entry);
 		if (err)
 			return err;
 
-		err = mv88e6185_g1_vtu_data_read(chip, entry);
+		err = mv88e6xxx_g1_vtu_fid_read(chip, entry);
 		if (err)
 			return err;
 
-		err = mv88e6xxx_g1_vtu_fid_read(chip, entry);
+		/* Fetch VLAN PortState data from the STU */
+		err = mv88e6xxx_g1_vtu_stu_get(chip, entry);
+		if (err)
+			return err;
+
+		err = mv88e6185_g1_stu_data_read(chip, entry);
 		if (err)
 			return err;
 	}
-- 
2.17.1


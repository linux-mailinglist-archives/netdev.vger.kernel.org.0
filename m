Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC462B0427
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgKLLoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgKLLny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:43:54 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA91C0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:43:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id r9so7900715lfn.11
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=BPDAyQYzFPdK9NiniqWJzLw5xX4oTAkPYDIQVljvlaw=;
        b=QiK4X3vBpgTmJ9D66gjnndI3Bo00Z3s2KpIj1NkfBvJASR416DcOD7i6yITXWsxLZZ
         2AofWpP2dLh5IKNFV7I0WCOMCCoFFHR+AxzIW4ciiWQaDy0OwrVyo9OJ9Zvcx2fGGYIJ
         2w4DlDCkte3IMlmCPyFaJCBkz0kSbLPRTAwaSu5QN7h3QEHGYBMJ34IEM2fVunz8IDNI
         re1kQItMlCWvvtglRn0XeB1eedkDGyJf7T8xwcQ+S6NksHXd/1iwbWXG53+903b7iror
         p5JyyjOb4U2DatU4LCyoug8rRDZMgtmLGRtxQ2dts3gfkYzo8BtkDqQIAhV7Odl07Hbs
         OodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=BPDAyQYzFPdK9NiniqWJzLw5xX4oTAkPYDIQVljvlaw=;
        b=im2r3VepcePCt3Cltn59iYBDyVTr4ZgVDxPTALEdXVigZnaam34yC6t/gVcBPwzDQ4
         JhDfdRT/MAYkEsLHlk5ckQqZHU7jjaARn8wulNYlCDGrj8aZFRgwtuonbrAO8SzXS/Q1
         ZMeoLeKCS5dIj0EH92UbNhUzt5G3lIPoDpaKXmrNKnMR7EXxuDHULMINdj7qFX5jugzX
         bYO2INO5LghIh0w+SaRdRMEXChlZBU44gIjoKDc0wHolPNjjRBCFUiaHBfK1D07+5l24
         ZjeKwX5k8ae2ipsaSRMDYxlL0JNenz9zU+3umePDRmcB97fnzAiBQCsNAL4PFMjdmCjR
         fLww==
X-Gm-Message-State: AOAM532mVJ2UumYFNrZqjxkPD9nHyjRVvpp82lvaiDAxbmoVpC6s6zSn
        SPP7psbO6LKj5Llj/XAqPCJO3Q==
X-Google-Smtp-Source: ABdhPJy5ytfnrL+mimuWie2DHQG2wKflZIvLpVXY3BtGy1j4zwKpAAHs4MRIpjaINGZf/yLCenkEaQ==
X-Received: by 2002:ac2:5301:: with SMTP id c1mr5760857lfh.72.1605181428783;
        Thu, 12 Nov 2020 03:43:48 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l26sm534970lfp.26.2020.11.12.03.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:43:48 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net] net: dsa: mv88e6xxx: Avoid VTU corruption on 6097
Date:   Thu, 12 Nov 2020 12:43:35 +0100
Message-Id: <20201112114335.27371-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As soon as you add the second port to a VLAN, all other port
membership configuration is overwritten with zeroes. The HW interprets
this as all ports being "unmodified members" of the VLAN.

In the simple case when all ports belong to the same VLAN, switching
will still work. But using multiple VLANs or trying to set multiple
ports as tagged members will not work.

On the 6352, doing a VTU GetNext op, followed by an STU GetNext op
will leave you with both the member- and state- data in the VTU/STU
data registers. But on the 6097 (which uses the same implementation),
the STU GetNext will override the information gathered from the VTU
GetNext.

Separate the two stages, parsing the result of the VTU GetNext before
doing the STU GetNext.

We opt to update the existing implementation for all applicable chips,
as opposed to creating a separate callback for 6097, because although
the previous implementation did work for (at least) 6352, the
datasheet does not mention the masking behavior.

Fixes: ef6fcea37f01 ("net: dsa: mv88e6xxx: get STU entry on VTU GetNext")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

v1 -> v2:
  - Rebased against net, as this is a bugfix.
  - Make sure to also update STU information in the 6185 callback.
  - Include user impact in commit message.

 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 59 ++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 48390b7b18ad..1048509a849b 100644
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
 
@@ -349,6 +380,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 		if (err)
 			return err;
 
+		err = mv88e6185_g1_stu_data_read(chip, entry);
+		if (err)
+			return err;
+
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
 		 * VTU DBNum[7:4] are located in VTU Operation 11:8
 		 */
@@ -374,16 +409,20 @@ int mv88e6352_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
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


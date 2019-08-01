Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0B27E253
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733122AbfHAShJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:37:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33552 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733069AbfHAShG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 14:37:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id r6so67052046qtt.0;
        Thu, 01 Aug 2019 11:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pGi8H59E1OhtYa7RV1NV+08kQPmaea3wa8GhYLJtxig=;
        b=B+46mN08Xg+FcohLIV0VDxhPrWM8uEY5xa8LddKuSjtqf0B3f1YCULEmz6+dlkDnBP
         6gP7ackMdSDs7iR+jEDKxAHuraPsFYhoeaUDoFifeP5Z20zR8HTkcAb2IdK103lJ7cc9
         7MYZqkq1MQlOalCRF199P1kHbP8NnQ47uwFQYq+pvG82O3DTGenA08P7qt++Jizgsh9V
         k+/X6397gnX9eZXNNU+CYFBP2y/02oAwr73KSGyXTCBmCEUgywRPWQH6x5rIGRvQ1lc8
         le3fNmyACjKiQJpMSNOPj6NY7fUpvPq+zS7Q4onhlOT8vHIqqeHyFmkjK+bq68UhZVeF
         0voQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGi8H59E1OhtYa7RV1NV+08kQPmaea3wa8GhYLJtxig=;
        b=kVOjX8hCur2y2dJcKiu1WTuaLKaAJHdZ4q54maNu8Z/jAPMFMSBsz/UES1UPI9cAgp
         Fum+q8AJeJk5eMUCtZhFOyjOpHBDMesVQBMCH4VCkME50/OeuPJQHralqeVyeVvFeDso
         fz3H+gIJFMyX1SH6njEY5ri5YKsiFS/tT+MIq0zfyWyR1BbzYsUQmlwoHZReNMSIJCCi
         wNPcu4TbCPBJa+ljEjm4n5dz8B7w8vL3clCuqAbDztAA+fpoLDOMJQegmvO0S0sp2gUA
         ljOS7NejcIQpuUtGhHomgye7BR6loqOPXrWcK1DoruoEWXOojitHHx3GBHQZoJ4e3wfW
         +a8g==
X-Gm-Message-State: APjAAAURsb5b6kmvWN2Kdz7eWkpn2OE209pRRRYQQ2k0weWuh6j/32T3
        tadOzY6sewkLtqAWnAhb6h/2CMwk/bw=
X-Google-Smtp-Source: APXvYqzBgTkymGyZ4xDWaJEsToBDte3lExeHgyvo940ZrtYT/WzPY0pPBh2z+AE0MN+Z70CIM8qyAA==
X-Received: by 2002:ac8:142:: with SMTP id f2mr91502850qtg.336.1564684625641;
        Thu, 01 Aug 2019 11:37:05 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j2sm32816077qtb.89.2019.08.01.11.37.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 11:37:05 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 4/5] net: dsa: mv88e6xxx: call vtu_getnext directly in vlan_del
Date:   Thu,  1 Aug 2019 14:36:36 -0400
Message-Id: <20190801183637.24841-5-vivien.didelot@gmail.com>
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

Wrapping mv88e6xxx_vtu_getnext makes the code less easy to read.
Explicit the call to mv88e6xxx_vtu_getnext in _mv88e6xxx_port_vlan_del
and the return value expected by switchdev in case of software VLANs.

At the same time, rename the helper using an old underscore convention.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 42ab57dbc790..50a6dbcc669c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1671,18 +1671,27 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static int _mv88e6xxx_port_vlan_del(struct mv88e6xxx_chip *chip,
-				    int port, u16 vid)
+static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
+				     int port, u16 vid)
 {
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	err = mv88e6xxx_vtu_get(chip, vid, &vlan, false);
+	if (!vid)
+		return -EOPNOTSUPP;
+
+	vlan.vid = vid - 1;
+	vlan.valid = false;
+
+	err = mv88e6xxx_vtu_getnext(chip, &vlan);
 	if (err)
 		return err;
 
-	/* Tell switchdev if this VLAN is handled in software */
-	if (vlan.member[port] == MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
+	/* If the VLAN doesn't exist in hardware or the port isn't a member,
+	 * tell switchdev that this VLAN is likely handled in software.
+	 */
+	if (vlan.vid != vid || !vlan.valid ||
+	    vlan.member[port] == MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 		return -EOPNOTSUPP;
 
 	vlan.member[port] = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER;
@@ -1721,7 +1730,7 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 		goto unlock;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		err = _mv88e6xxx_port_vlan_del(chip, port, vid);
+		err = mv88e6xxx_port_vlan_leave(chip, port, vid);
 		if (err)
 			goto unlock;
 
-- 
2.22.0


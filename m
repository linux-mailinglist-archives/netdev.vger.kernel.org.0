Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCA7E24F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733068AbfHAShG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:37:06 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42868 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfHAShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 14:37:05 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so52794422qkm.9;
        Thu, 01 Aug 2019 11:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R/MA4foSMaGoWFxlfY4cPflimdupamiwT0ApWs++Zso=;
        b=fNKSX/9LGlJCr5kd51EloAvr8/wtHlXGpzhdoF0ltk2VnBZVzAmV3XvMzV9AUpBGrA
         TuSUxribz4B93h+zbTo4zsgDfnt/hr99IXcJuj0XPJMwKBzK1sYl3pprw23EBPqYoAEx
         nRMMwPcTnGtmBH7C/DwZ43qgM7MwOnbqUFVMNPtnfMz5VCFqdlouk90PEXC76cHwknFd
         cPnqRiGPb38gUV2lLaXe964vFPdBbgEH0rMPFEbEfyLg9BbBhzmkkQL8bXy6BsGuo65Y
         c9r5jfOm+PIkWnUfiu28NzqlqR+Fba9Ki6BH+s8cviLUPYfCshi+q4Rah4YpV0vBoWFg
         rTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R/MA4foSMaGoWFxlfY4cPflimdupamiwT0ApWs++Zso=;
        b=NMZY/Li1Ic+pUBtGc+j0sUo3MFEwvRYqis/WqArHeCf23eJJzyfVfzFS6Ykev6DXii
         ZE4777RT0brKMa9d79HkH28ZiMWmYuBW62EUayAFBnd8Bkeo563RW+8KLWdIzLXEALWs
         B+S8f/TouthJI/BKmycgTSe1zD+LqdJ52q4JPO7RxjVr8fCbVFPPZPe5uGlhaF9vvNFv
         48x1OBXCidLx4ywd+AXwP1/AseoP7MfEwmT60qufMCIFZPg++YX5uOSCu6wu3dvIlxV2
         6VdZZQph57c+eR1eCoPbMF4WxJ5NBdO2LD0CM+UYMUPjxYPqzdaV8SHW/fOyJMAC/QaX
         7POA==
X-Gm-Message-State: APjAAAVYdRFszmrDjdKfQUloP9Y9NTZA6BxjexY03qC1Nvo1rN8F7Nwp
        JICzGw6SRSItWaDmoYfKV+B536sSPDs=
X-Google-Smtp-Source: APXvYqzhfiIo3JbdkLesk7sr/eeDIW0IZ+toGEhudhUfGeMQFxwjz5tZd6xn/XnaSG0hdFlZg311vg==
X-Received: by 2002:a05:620a:13f9:: with SMTP id h25mr78624936qkl.283.1564684623980;
        Thu, 01 Aug 2019 11:37:03 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y14sm31164501qkb.109.2019.08.01.11.37.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 11:37:03 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 3/5] net: dsa: mv88e6xxx: call vtu_getnext directly in db load/purge
Date:   Thu,  1 Aug 2019 14:36:35 -0400
Message-Id: <20190801183637.24841-4-vivien.didelot@gmail.com>
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

mv88e6xxx_vtu_getnext is simple enough to call it directly in the
mv88e6xxx_port_db_load_purge function and explicit the return code
expected by switchdev for software VLANs when an hardware VLAN does
not exist.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c825fa3477fa..42ab57dbc790 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1540,23 +1540,36 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 					const unsigned char *addr, u16 vid,
 					u8 state)
 {
-	struct mv88e6xxx_vtu_entry vlan;
 	struct mv88e6xxx_atu_entry entry;
+	struct mv88e6xxx_vtu_entry vlan;
+	u16 fid;
 	int err;
 
 	/* Null VLAN ID corresponds to the port private database */
-	if (vid == 0)
-		err = mv88e6xxx_port_get_fid(chip, port, &vlan.fid);
-	else
-		err = mv88e6xxx_vtu_get(chip, vid, &vlan, false);
-	if (err)
-		return err;
+	if (vid == 0) {
+		err = mv88e6xxx_port_get_fid(chip, port, &fid);
+		if (err)
+			return err;
+	} else {
+		vlan.vid = vid - 1;
+		vlan.valid = false;
+
+		err = mv88e6xxx_vtu_getnext(chip, &vlan);
+		if (err)
+			return err;
+
+		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
+		if (vlan.vid != vid || !vlan.valid)
+			return -EOPNOTSUPP;
+
+		fid = vlan.fid;
+	}
 
 	entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UNUSED;
 	ether_addr_copy(entry.mac, addr);
 	eth_addr_dec(entry.mac);
 
-	err = mv88e6xxx_g1_atu_getnext(chip, vlan.fid, &entry);
+	err = mv88e6xxx_g1_atu_getnext(chip, fid, &entry);
 	if (err)
 		return err;
 
@@ -1577,7 +1590,7 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		entry.state = state;
 	}
 
-	return mv88e6xxx_g1_atu_loadpurge(chip, vlan.fid, &entry);
+	return mv88e6xxx_g1_atu_loadpurge(chip, fid, &entry);
 }
 
 static int mv88e6xxx_port_add_broadcast(struct mv88e6xxx_chip *chip, int port,
-- 
2.22.0


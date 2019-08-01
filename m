Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5ECA7E24C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732402AbfHAShC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:37:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38020 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfHAShC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 14:37:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so71272792qtl.5;
        Thu, 01 Aug 2019 11:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ecP8BzjRTmaPVZT171G2tkivu+sU9POVGx+xi0BQoIE=;
        b=EPPcVkyGBYWuMX5ynsFj+mL+7tV4H/5ZsoM/12cb/0VDhp58PpI6cKAdkBBx4LVWhR
         Dvfm5fynLniYJVdUyEjQ4UhdxoDdMD0MVzBHpvv0ZPaCQoGhJBm+mw9+Qff0vH4E+vvQ
         oM8irggmv17Iw3pY0/8efI/o0eOBoGcAYkOjmxX8DXV0LwsseYoIyJNiZ54/mlT+Y5MO
         Ys8dPJnq3Qd/igR+DBNTaA0lPb/KWw1A7MPo5fFhVwLI2FKE0DhxKhcKBI2fpXgv6CEK
         S8WcUaovepgAzPrB3jvOkofIHgvO6b5YeBxfaApo/dBguqBSIUu+wL8MTIPBqaLTPxyA
         2vdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ecP8BzjRTmaPVZT171G2tkivu+sU9POVGx+xi0BQoIE=;
        b=JzDnn4stMb0UFh7t9cEhVkvXj39IJYkcIiyLIYRhWRv+ej0w9QMY2DKcrFKO4dYiLy
         dJbXkrOqT7iOLbnGAAtpfICtlZSjxGsiYl28+jF5dtgvnLgnYjbwGNgkVCIA1xn/JDjr
         mTVqSlTw/7rtB86axN63C8jwtpgsP0bVAJQb9J+waPTBRDSsfom6FgxH4nxFPDCjXYqA
         WN4mYVwTCgpuOiAlT7RcRXZskhJhyqFl9Tul43d9q+FBXggzZ5uqFa+vQp4I0oSXGNAt
         vf6zlfWLuMoJsBIhDZWaZBawmYNm5i1Bmol+/ayiFXR25I/veDSgaL/a08K7lziKAfJs
         YENg==
X-Gm-Message-State: APjAAAXGbG38WGQ+DpcVjpU7wefCcjs7x6vSqOOM6NuegkAFFym0l5Ku
        tuS6lfP3eOU7Vz3U/2bhq5dqAPRwQoo=
X-Google-Smtp-Source: APXvYqyacsPbgNcPEp2uZ5u9E/FMUWUfGT4CaTZvOM73mN8ED6BxsErdqv141y7/42ZJCU1OiD+ZAQ==
X-Received: by 2002:ac8:7651:: with SMTP id i17mr91877728qtr.245.1564684620395;
        Thu, 01 Aug 2019 11:37:00 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d141sm30941421qke.3.2019.08.01.11.36.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 11:36:59 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 1/5] net: dsa: mv88e6xxx: lock mutex in vlan_prepare
Date:   Thu,  1 Aug 2019 14:36:33 -0400
Message-Id: <20190801183637.24841-2-vivien.didelot@gmail.com>
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

Lock the mutex in the mv88e6xxx_port_vlan_prepare function
called by the DSA stack, instead of doing it in the internal
mv88e6xxx_port_check_hw_vlan helper.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2e500428670c..1b2cb46d3b53 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1453,12 +1453,10 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (!vid_begin)
 		return -EOPNOTSUPP;
 
-	mv88e6xxx_reg_lock(chip);
-
 	do {
 		err = mv88e6xxx_vtu_getnext(chip, &vlan);
 		if (err)
-			goto unlock;
+			return err;
 
 		if (!vlan.valid)
 			break;
@@ -1487,15 +1485,11 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 			dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
 				port, vlan.vid, i,
 				netdev_name(dsa_to_port(ds, i)->bridge_dev));
-			err = -EOPNOTSUPP;
-			goto unlock;
+			return -EOPNOTSUPP;
 		}
 	} while (vlan.vid < vid_end);
 
-unlock:
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
+	return 0;
 }
 
 static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
@@ -1529,15 +1523,15 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 	/* If the requested port doesn't belong to the same bridge as the VLAN
 	 * members, do not support it (yet) and fallback to software VLAN.
 	 */
+	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_check_hw_vlan(ds, port, vlan->vid_begin,
 					   vlan->vid_end);
-	if (err)
-		return err;
+	mv88e6xxx_reg_unlock(chip);
 
 	/* We don't need any dynamic resource from the kernel (yet),
 	 * so skip the prepare phase.
 	 */
-	return 0;
+	return err;
 }
 
 static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
-- 
2.22.0


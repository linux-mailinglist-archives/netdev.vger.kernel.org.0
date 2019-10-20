Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC21BDDC0D
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfJTDUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:30 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39278 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfJTDU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id 4so9077774qki.6;
        Sat, 19 Oct 2019 20:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NCuQ5c3Q5Co4XOtKERxmNTHt3o/cAKRwvT16Zs2Sg08=;
        b=l3qU4JL0yU4oehIXYFwmj9J2TJe64ma8+HiqVRi/SUmhUIM8Y7W9O0JiW+YenGk7Ba
         SXhG2SFXTdHoe6m9FFmeG03AO0CidZfTRp5lqFRQm5z0V8HcFUXBO6hdOpF1z3/s3yMJ
         JX36HPRiPAhPnUwcTla0QJv3oz/QctciC9CN5gJ/b7DlmX/K05Fsq36TR3nMAKg6Qhk5
         1vOyZAGszHQwfG/nckTjvsEgdZHJzPCybZJVwFOc4z5OEKl2gueKPDMNmIjEj/SwsVoP
         EH2olq24/syiWVMBC5tyn1VXWvTSL2HB6khejJ3KsQ69EJHEKiXCsz/DLC4NRPFxUgbm
         de1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NCuQ5c3Q5Co4XOtKERxmNTHt3o/cAKRwvT16Zs2Sg08=;
        b=PqAspuWKaN8U8ovjL6bh92fLq14glx+RX77NAwMZ+jAlXn0Q9vOC7msXbg9ecbadmE
         md1+pzX96zarTDX7ZFkfh11Hw/TmXE/zDFOz1EO/NrA0RVauUNiEPpkJT4BYiNv5eInF
         6cH7/DNTOXyRQzspdDi4Z3MkBBHWE8MSOe7TTe3CFGM0ttGYjvPDwwYVF6W5EuDpjd1X
         ijtmNA07o0qlkNcvZF6sx8uyWqX3P/bqejyo+zLoe57Y/hsbjGRVKGbLBcc8Bhh5dRvr
         JScwdBxFsGR1O6iDpXduJzHnCrSX0oQRKq5sOl3gbrFlTfhgxoxkEQkXlCBQfufcD3ZX
         ZYtQ==
X-Gm-Message-State: APjAAAXllnrZW7ldsatSm23fDWG5OuUDYXGuu+Ww5ndfFIw7TvWQXfBH
        W/6leuVrQreCv9qHryfGzms=
X-Google-Smtp-Source: APXvYqwNQFA/t+ETCVjVpQH36IurcQm2Ki0ciznWBe33OxOmKSCau1YIFb4WIVraqEpe33GyBmgYlA==
X-Received: by 2002:a05:620a:214d:: with SMTP id m13mr16763921qkm.104.1571541625354;
        Sat, 19 Oct 2019 20:20:25 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z72sm7110305qka.115.2019.10.19.20.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:24 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 13/16] net: dsa: mv88e6xxx: use ports list to map bridge
Date:   Sat, 19 Oct 2019 23:19:38 -0400
Message-Id: <20191020031941.3805884-14-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of digging into the other dsa_switch structures of the fabric
and relying too much on the dsa_to_port helper, use the new list
of switch fabric ports to remap the Port VLAN Map of local bridge
group members or remap the Port VLAN Table entry of external bridge
group members.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 36 +++++++++++++-------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index af8943142053..8771f2525932 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2043,29 +2043,23 @@ static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
 static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 				struct net_device *br)
 {
-	struct dsa_switch *ds;
-	int port;
-	int dev;
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
 	int err;
 
-	/* Remap the Port VLAN of each local bridge group member */
-	for (port = 0; port < mv88e6xxx_num_ports(chip); ++port) {
-		if (dsa_to_port(chip->ds, port)->bridge_dev == br) {
-			err = mv88e6xxx_port_vlan_map(chip, port);
-			if (err)
-				return err;
-		}
-	}
-
-	/* Remap the Port VLAN of each cross-chip bridge group member */
-	for (dev = 0; dev < DSA_MAX_SWITCHES; ++dev) {
-		ds = chip->ds->dst->ds[dev];
-		if (!ds)
-			break;
-
-		for (port = 0; port < ds->num_ports; ++port) {
-			if (dsa_to_port(ds, port)->bridge_dev == br) {
-				err = mv88e6xxx_pvt_map(chip, dev, port);
+	list_for_each_entry(dp, &dst->ports, list) {
+		/* Remap the Port VLAN Map of local bridge group members and
+		 * remap the PVT entry of external bridge group members.
+		 */
+		if (dp->bridge_dev == br) {
+			if (dp->ds == ds) {
+				err = mv88e6xxx_port_vlan_map(chip, dp->index);
+				if (err)
+					return err;
+			} else {
+				err = mv88e6xxx_pvt_map(chip, dp->ds->index,
+							dp->index);
 				if (err)
 					return err;
 			}
-- 
2.23.0


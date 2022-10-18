Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C6C604B16
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiJSPUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiJSPUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:20:33 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A4418B485;
        Wed, 19 Oct 2022 08:14:14 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 58AB51884ADE;
        Wed, 19 Oct 2022 15:12:49 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id EF72C250052C;
        Wed, 19 Oct 2022 15:12:48 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 0)
        id D86329EC0002; Wed, 19 Oct 2022 15:12:48 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id F21D89120FED;
        Tue, 18 Oct 2022 16:57:01 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v8 net-next 11/12] net: dsa: mv88e6xxx: add blackhole ATU entries
Date:   Tue, 18 Oct 2022 18:56:18 +0200
Message-Id: <20221018165619.134535-12-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018165619.134535-1-netdev@kapio-technology.com>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Blackhole FDB entries can now be added, deleted or replaced in the
driver ATU.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 62 +++++++++++++++++++++++++++++---
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 71843fe87f77..7a7cd1f0e735 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2735,6 +2735,58 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
 	return err;
 }
 
+static int mv88e6xxx_blackhole_fdb_loadpurge(struct dsa_switch *ds,
+					     const unsigned char *addr, u16 vid, u8 state)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_atu_entry entry;
+	struct mv88e6xxx_vtu_entry vlan;
+
+	u16 fid = 0;
+	int err;
+
+	if (vid == 0) {
+		fid = MV88E6XXX_FID_BRIDGED;
+	} else {
+		mv88e6xxx_reg_lock(chip);
+		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
+		mv88e6xxx_reg_unlock(chip);
+		if (err)
+			return err;
+
+		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
+		if (!vlan.valid)
+			return -EOPNOTSUPP;
+
+		fid = vlan.fid;
+	}
+
+	ether_addr_copy(entry.mac, addr);
+	entry.portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
+	entry.state = state;
+	entry.trunk = false;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_g1_atu_loadpurge(chip, fid, &entry);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_blackhole_fdb_add(struct dsa_switch *ds,
+				       const unsigned char *addr, u16 vid)
+{
+	return mv88e6xxx_blackhole_fdb_loadpurge(ds, addr, vid,
+						 MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
+}
+
+static int mv88e6xxx_blackhole_fdb_del(struct dsa_switch *ds,
+				       const unsigned char *addr, u16 vid)
+{
+	return mv88e6xxx_blackhole_fdb_loadpurge(ds, addr, vid,
+						 MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED);
+}
+
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
 				  u16 fdb_flags, struct dsa_db db)
@@ -2742,9 +2794,10 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	/* Ignore entries with flags set */
-	if (fdb_flags)
+	if (fdb_flags & DSA_FDB_FLAG_LOCKED)
 		return 0;
+	if (fdb_flags & DSA_FDB_FLAG_BLACKHOLE)
+		return mv88e6xxx_blackhole_fdb_add(ds, addr, vid);
 
 	if (mv88e6xxx_port_is_locked(chip, port))
 		mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
@@ -2765,9 +2818,10 @@ static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
 	bool locked_found = false;
 	int err = 0;
 
-	/* Ignore entries with flags set */
-	if (fdb_flags)
+	if (fdb_flags & DSA_FDB_FLAG_LOCKED)
 		return 0;
+	if (fdb_flags & DSA_FDB_FLAG_BLACKHOLE)
+		return mv88e6xxx_blackhole_fdb_del(ds, addr, vid);
 
 	if (mv88e6xxx_port_is_locked(chip, port))
 		locked_found = mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
-- 
2.34.1


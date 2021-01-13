Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8322F4BD0
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbhAMM4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:56:05 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39124 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbhAMMzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:55:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 61EFD9C0DCE;
        Wed, 13 Jan 2021 07:45:36 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id W5ZObefErLHT; Wed, 13 Jan 2021 07:45:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id AC79E9C0DCC;
        Wed, 13 Jan 2021 07:45:35 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FniZPELW2f2W; Wed, 13 Jan 2021 07:45:35 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id AE7929C0DA5;
        Wed, 13 Jan 2021 07:45:33 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/6] net: dsa: ksz: fix FID management
Date:   Wed, 13 Jan 2021 13:45:17 +0100
Message-Id: <c5c35fb4a3e4784a5e26a7b7181a0a2925674712.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FID (Filter ID) is a 7 bits field used to link the VLAN table
to the static and dynamic mac address tables.
Until now the KSZ8795 driver could only add one VLAN as the FID was
always set to 1.
This commit allows setting a FID for each new active VLAN.
The FID list is stored in a static table dynamically allocated from
ks8795_fid structure.
Each newly activated VLAN is associated to the next available FID.
Only the VLAN 0 is not added to the list as it is a special VLAN.
As it has a special meaning, see IEEE 802.1q.
When a VLAN is no more used, the associated FID table entry is reset
to 0.

Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 59 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 +
 drivers/net/dsa/microchip/ksz_common.h  |  1 +
 3 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microc=
hip/ksz8795.c
index c973db101b72..6962ba4ee125 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -648,7 +648,7 @@ static enum dsa_tag_protocol ksz8795_get_tag_protocol=
(struct dsa_switch *ds,
 						      int port,
 						      enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_KSZ8795;
+	return DSA_TAG_PROTO_NONE;
 }
=20
 static void ksz8795_get_strings(struct dsa_switch *ds, int port,
@@ -796,6 +796,41 @@ static int ksz8795_port_vlan_filtering(struct dsa_sw=
itch *ds, int port,
 	return 0;
 }
=20
+static void ksz8795_del_fid(u16 *ksz_fid_table, u16 vid)
+{
+	u8 i =3D 0;
+
+	if (!ksz_fid_table)
+		return;
+
+	for (i =3D 0; i < VLAN_TABLE_FID_SIZE; i++) {
+		if (ksz_fid_table[i] =3D=3D vid) {
+			ksz_fid_table[i] =3D 0;
+			break;
+		}
+	}
+}
+
+static int ksz8795_get_next_fid(u16 *ksz_fid_table, u16 vid, u8 *fid)
+{
+	u8 i =3D 0;
+	int ret =3D -EOVERFLOW;
+
+	if (!ksz_fid_table)
+		return ret;
+
+	for (i =3D 0; i < VLAN_TABLE_FID_SIZE; i++) {
+		if (!ksz_fid_table[i]) {
+			ksz_fid_table[i] =3D vid;
+			*fid =3D i;
+			ret =3D 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 				  const struct switchdev_obj_port_vlan *vlan)
 {
@@ -803,17 +838,24 @@ static void ksz8795_port_vlan_add(struct dsa_switch=
 *ds, int port,
 	struct ksz_device *dev =3D ds->priv;
 	u16 data, vid, new_pvid =3D 0;
 	u8 fid, member, valid;
+	int ret;
=20
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
=20
 	for (vid =3D vlan->vid_begin; vid <=3D vlan->vid_end; vid++) {
+		if (vid =3D=3D 0)
+			continue;
+
 		ksz8795_r_vlan_table(dev, vid, &data);
 		ksz8795_from_vlan(data, &fid, &member, &valid);
=20
 		/* First time to setup the VLAN entry. */
 		if (!valid) {
-			/* Need to find a way to map VID to FID. */
-			fid =3D 1;
+			ret =3D ksz8795_get_next_fid(dev->ksz_fid_table, vid, &fid);
+			if (ret) {
+				dev_err(ds->dev, "Switch FID table is full, cannot add");
+				return;
+			}
 			valid =3D 1;
 		}
 		member |=3D BIT(port);
@@ -855,7 +897,7 @@ static int ksz8795_port_vlan_del(struct dsa_switch *d=
s, int port,
=20
 		/* Invalidate the entry if no more member. */
 		if (!member) {
-			fid =3D 0;
+			ksz8795_del_fid(dev->ksz_fid_table, vid);
 			valid =3D 0;
 		}
=20
@@ -1087,6 +1129,9 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	for (i =3D 0; i < (dev->num_vlans / 4); i++)
 		ksz8795_r_vlan_entries(dev, i);
=20
+	/* Assign first FID to VLAN 1 and always return FID=3D0 for this vlan *=
/
+	dev->ksz_fid_table[0] =3D 1;
+
 	/* Setup STP address for STP operation. */
 	memset(&alu, 0, sizeof(alu));
 	ether_addr_copy(alu.mac, eth_stp_addr);
@@ -1261,6 +1306,12 @@ static int ksz8795_switch_init(struct ksz_device *=
dev)
 	/* set the real number of ports */
 	dev->ds->num_ports =3D dev->port_cnt;
=20
+	dev->ksz_fid_table =3D devm_kzalloc(dev->dev,
+					  VLAN_TABLE_FID_SIZE * sizeof(u16),
+					  GFP_KERNEL);
+	if (!dev->ksz_fid_table)
+		return -ENOMEM;
+
 	return 0;
 }
=20
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/mi=
crochip/ksz8795_reg.h
index 40372047d40d..fe4c4f7fdd47 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -915,6 +915,7 @@
  */
=20
 #define VLAN_TABLE_FID			0x007F
+#define VLAN_TABLE_FID_SIZE		128
 #define VLAN_TABLE_MEMBERSHIP		0x0F80
 #define VLAN_TABLE_VALID		0x1000
=20
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/mic=
rochip/ksz_common.h
index 720f22275c84..44e97c55c2da 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -77,6 +77,7 @@ struct ksz_device {
 	bool synclko_125;
=20
 	struct vlan_table *vlan_cache;
+	u16 *ksz_fid_table;
=20
 	struct ksz_port *ports;
 	struct delayed_work mib_read;
--=20
2.25.1


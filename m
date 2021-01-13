Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA42F4BD5
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbhAMM4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:56:32 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39230 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbhAMM4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:56:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7E75D9C0DD5;
        Wed, 13 Jan 2021 07:45:42 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id MRdasevrwtCY; Wed, 13 Jan 2021 07:45:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1CBEC9C0DD0;
        Wed, 13 Jan 2021 07:45:42 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id p1xrnGGU0hhJ; Wed, 13 Jan 2021 07:45:42 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 1BFF29C0DCC;
        Wed, 13 Jan 2021 07:45:39 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/6] net: dsa: ksz: do not change tagging on del
Date:   Wed, 13 Jan 2021 13:45:20 +0100
Message-Id: <c3effba30b2ae979a4b7990bbf6096ca26e3de7a.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a VLAN is removed, the tagging policy should not be changed as
still active VLANs could be impacted.

Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microc=
hip/ksz8795.c
index 193f03ef9160..b55fb2761993 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -880,7 +880,6 @@ static void ksz8795_port_vlan_add(struct dsa_switch *=
ds, int port,
 static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan)
 {
-	bool untagged =3D vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev =3D ds->priv;
 	u16 data, vid, pvid, new_pvid =3D 0;
 	u8 fid, member, valid;
@@ -888,8 +887,6 @@ static int ksz8795_port_vlan_del(struct dsa_switch *d=
s, int port,
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
 	pvid =3D pvid & 0xFFF;
=20
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
-
 	for (vid =3D vlan->vid_begin; vid <=3D vlan->vid_end; vid++) {
 		ksz8795_r_vlan_table(dev, vid, &data);
 		ksz8795_from_vlan(data, &fid, &member, &valid);
--=20
2.25.1


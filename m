Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1112D2F4BCE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbhAMM4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:56:04 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39116 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbhAMMzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:55:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 2C1899C0DCF;
        Wed, 13 Jan 2021 07:45:38 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 7nsceJMoUmDn; Wed, 13 Jan 2021 07:45:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id C8E0E9C0DCB;
        Wed, 13 Jan 2021 07:45:37 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id accOWXalYQb3; Wed, 13 Jan 2021 07:45:37 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id D0B8B9C0DCD;
        Wed, 13 Jan 2021 07:45:35 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/6] net: dsa: ksz: move tag/untag action
Date:   Wed, 13 Jan 2021 13:45:18 +0100
Message-Id: <8e1cd9b167bd39c0f82ca8970a355cdfbc0fe885.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tag/untag action at the end of the function to avoid
tagging or untagging traffic if only vlan 0 is handled.

Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microc=
hip/ksz8795.c
index 6962ba4ee125..4b060503b2e8 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -840,8 +840,6 @@ static void ksz8795_port_vlan_add(struct dsa_switch *=
ds, int port,
 	u8 fid, member, valid;
 	int ret;
=20
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
-
 	for (vid =3D vlan->vid_begin; vid <=3D vlan->vid_end; vid++) {
 		if (vid =3D=3D 0)
 			continue;
@@ -874,6 +872,8 @@ static void ksz8795_port_vlan_add(struct dsa_switch *=
ds, int port,
 		vid |=3D new_pvid;
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
 	}
+
+	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 }
=20
 static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
--=20
2.25.1


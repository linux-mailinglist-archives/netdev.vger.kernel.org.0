Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4762F4BCB
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbhAMMzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:55:52 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39120 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbhAMMzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:55:50 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2021 07:55:49 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 9FFB99C0DD7;
        Wed, 13 Jan 2021 07:45:44 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id PF0KqBo2V4kf; Wed, 13 Jan 2021 07:45:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 45CF39C0DD3;
        Wed, 13 Jan 2021 07:45:44 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yoNQApLFomgm; Wed, 13 Jan 2021 07:45:44 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 47E8F9C0DCC;
        Wed, 13 Jan 2021 07:45:42 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 5/6] net: dsa: ksz: fix wrong pvid
Date:   Wed, 13 Jan 2021 13:45:21 +0100
Message-Id: <4d34da2534c912e290d77d4296a4aa68229fd6e6.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A logical 'or' was performed until now.
So if vlan 1 is the current pvid and vlan 20 is set as the new one,
vlan 21 is the new pvid.
This commit fixes this by setting the right mask to set the new pvid.

Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microc=
hip/ksz8795.c
index b55fb2761993..44306a7e297a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -868,8 +868,8 @@ static void ksz8795_port_vlan_add(struct dsa_switch *=
ds, int port,
=20
 	if (new_pvid) {
 		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
-		vid &=3D 0xfff;
-		vid |=3D new_pvid;
+		vid &=3D ~0xfff;
+		vid |=3D (new_pvid & 0xfff);
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
 	}
=20
--=20
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF172F4BCF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbhAMM4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:56:05 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39128 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbhAMMzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:55:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id B5F3F9C0DCC;
        Wed, 13 Jan 2021 07:45:46 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SjBZ2rqqZ1J4; Wed, 13 Jan 2021 07:45:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 5F3D49C0DD6;
        Wed, 13 Jan 2021 07:45:46 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xge2FfEn1AmX; Wed, 13 Jan 2021 07:45:46 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 68CE89C0DCC;
        Wed, 13 Jan 2021 07:45:44 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 6/6] net: dsa: ksz: fix wrong read cast to u64
Date:   Wed, 13 Jan 2021 13:45:22 +0100
Message-Id: <28e0730f2bdac275384fac85c4a342fb91f9455f.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'(u64)*value' casts a u32 to a u64. So depending on endianness,
LSB or MSB is lost.
The pointer needs to be cast to read the full u64:
'*((u64 *)value)'

Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/mic=
rochip/ksz_common.h
index 44e97c55c2da..492dcb2011f1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -213,7 +213,7 @@ static inline int ksz_read64(struct ksz_device *dev, =
u32 reg, u64 *val)
 		/* Ick! ToDo: Add 64bit R/W to regmap on 32bit systems */
 		value[0] =3D swab32(value[0]);
 		value[1] =3D swab32(value[1]);
-		*val =3D swab64((u64)*value);
+		*val =3D swab64((((u64)value[1]) << 32) | value[0]);
 	}
=20
 	return ret;
--=20
2.25.1


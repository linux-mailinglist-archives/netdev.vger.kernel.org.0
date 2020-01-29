Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB14814C892
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgA2KNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:13:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726069AbgA2KNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:13:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580292798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qN3ZMiyg6k0Klq3ubOpVoXU/m+7p8QDtEqCphhnXzWs=;
        b=b2lr3a+XgiekcXpq3e1DC0XvnYkSawE+DI0yzYqJTWO2xKq7UHJb9b3HfCtqfYOmE6YvHa
        K6ao0AYL/ilAr6c9Islu/gpinUanf1vIiK4dVRtI93+EtlaJ4g2yCewfScj+EavnDztVnE
        UEMSHUbwpMBoB6hZuolPjPhTIvOM9D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-VAHyqa_oOX24Z6Len-d7vg-1; Wed, 29 Jan 2020 05:13:11 -0500
X-MC-Unique: VAHyqa_oOX24Z6Len-d7vg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 945D48018CF;
        Wed, 29 Jan 2020 10:13:10 +0000 (UTC)
Received: from hive.redhat.com (unknown [10.43.2.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F11E60BE0;
        Wed, 29 Jan 2020 10:13:09 +0000 (UTC)
From:   Petr Oros <poros@redhat.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        ivecera@redhat.com
Subject: [PATCH net] phy: avoid unnecessary link-up delay in polling mode
Date:   Wed, 29 Jan 2020 11:13:08 +0100
Message-Id: <20200129101308.74185-1-poros@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 93c0970493c71f ("net: phy: consider latched link-down status in
polling mode") removed double-read of latched link-state register for
polling mode from genphy_update_link(). This added extra ~1s delay into
sequence link down->up.
Following scenario:
 - After boot link goes up
 - phy_start() is called triggering an aneg restart, hence link goes
   down and link-down info is latched.
 - After aneg has finished link goes up. In phy_state_machine is checked
   link state but it is latched "link is down". The state machine is
   scheduled after one second and there is detected "link is up". This
   extra delay can be avoided when we keep link-state register double rea=
d
   in case when link was down previously.

With this solution we don't miss a link-down event in polling mode and
link-up is faster.

Fixes: 93c0970493c71f ("net: phy: consider latched link-down status in po=
lling mode")
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/phy/phy-c45.c    | 5 +++--
 drivers/net/phy/phy_device.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index a1caeee1223617..bceb0dcdecbd61 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -239,9 +239,10 @@ int genphy_c45_read_link(struct phy_device *phydev)
=20
 		/* The link state is latched low so that momentary link
 		 * drops can be detected. Do not double-read the status
-		 * in polling mode to detect such short link drops.
+		 * in polling mode to detect such short link drops except
+		 * the link was already down.
 		 */
-		if (!phy_polling_mode(phydev)) {
+		if (!phy_polling_mode(phydev) || !phydev->link) {
 			val =3D phy_read_mmd(phydev, devad, MDIO_STAT1);
 			if (val < 0)
 				return val;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6a5056e0ae7757..d5f4804c34d597 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
=20
 	/* The link state is latched low so that momentary link
 	 * drops can be detected. Do not double-read the status
-	 * in polling mode to detect such short link drops.
+	 * in polling mode to detect such short link drops except
+	 * the link was already down.
 	 */
-	if (!phy_polling_mode(phydev)) {
+	if (!phy_polling_mode(pihydev) || !phydev->link) {
 		status =3D phy_read(phydev, MII_BMSR);
 		if (status < 0)
 			return status;
--=20
2.24.1


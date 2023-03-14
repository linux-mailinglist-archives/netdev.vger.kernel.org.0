Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9176B8EF2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjCNJoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCNJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:44:04 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 02:43:14 PDT
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3076964B0D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1678786992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7tbw9TmeMdRn2UCmdGU94Xr+1fBO62rxHueKSryZmmk=;
        b=KygxX7q+OivpjqjevH0+JOpK1hhRiOQrFMhecRsCIA3hjD1SdYmRsCyaiKBcW9H/hRTvR2
        9cJ+uGNqYgzinWd4dvQIxQE3XDhiuF+GGp3rW3zS+ttucR2cOw7YqYOBfehlBNun6DJ+qJ
        6AVKD9zGkN9U7O43FweD+oGm7pBAtyS03CqgWO3OJhpvfDDEmg5SAQrrpuyudQDGw+/Qpv
        pRgLbY2QIyrHEkS4OXWh9dZmjKjhGNyaofChdQwfSwF4CxFt76qNAQw87j/Gei2Aml5nMh
        nhsArmkRBfFiU8fPys2vPWdddFSbmXOc3RMSIjDXuB/m5zNr8iTNSTqzWXCruQ==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-488-ypav22jWMM-feJswm-WTNg-1; Tue, 14 Mar 2023 05:37:03 -0400
X-MC-Unique: ypav22jWMM-feJswm-WTNg-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 14 Mar 2023 02:36:58 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <rtanwar@maxlinear.com>,
        <mohammad.athari.ismail@intel.com>, <edumazet@google.com>,
        <michael@walle.cc>, <pabeni@redhat.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH net-next v4] net: phy: mxl-gpy: enhance delay time required by loopback disable function
Date:   Tue, 14 Mar 2023 17:36:48 +0800
Message-ID: <20230314093648.44510-1-lxu@maxlinear.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPY2xx devices need 3 seconds to fully switch out of loopback mode
before it can safely re-enter loopback mode. Implement timeout mechanism
to guarantee 3 seconds waited before re-enter loopback mode.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
v2 changes:
 Update comments.

v3 changes:
 Submit for net-next.

v4 changes:
 Implement timeout mechanism as re-enter loopback mode is quite rare use ca=
se.
 The delay is not required to resume normal function.

 drivers/net/phy/mxl-gpy.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index e5972b4ef6e8..7316d6ba0cb5 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -107,6 +107,14 @@ struct gpy_priv {
=20
 =09u8 fw_major;
 =09u8 fw_minor;
+
+=09/* It takes 3 seconds to fully switch out of loopback mode before
+=09 * it can safely re-enter loopback mode. Record the time when
+=09 * loopback is disabled. Check and wait if necessary before loopback
+=09 * is enabled.
+=09 */
+=09bool lb_dis_chk;
+=09u64 lb_dis_to;
 };
=20
 static const struct {
@@ -769,18 +777,34 @@ static void gpy_get_wol(struct phy_device *phydev,
=20
 static int gpy_loopback(struct phy_device *phydev, bool enable)
 {
+=09struct gpy_priv *priv =3D phydev->priv;
+=09u16 set =3D 0;
 =09int ret;
=20
-=09ret =3D phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-=09=09=09 enable ? BMCR_LOOPBACK : 0);
-=09if (!ret) {
-=09=09/* It takes some time for PHY device to switch
-=09=09 * into/out-of loopback mode.
+=09if (enable) {
+=09=09/* wait until 3 seconds from last disable */
+=09=09if (priv->lb_dis_chk && time_is_after_jiffies64(priv->lb_dis_to))
+=09=09=09msleep(jiffies64_to_msecs(priv->lb_dis_to - get_jiffies_64()));
+
+=09=09priv->lb_dis_chk =3D false;
+=09=09set =3D BMCR_LOOPBACK;
+=09}
+
+=09ret =3D phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, set);
+=09if (ret)
+=09=09return ret;
+
+=09if (enable) {
+=09=09/* It takes some time for PHY device to switch into
+=09=09 * loopback mode.
 =09=09 */
 =09=09msleep(100);
+=09} else {
+=09=09priv->lb_dis_chk =3D true;
+=09=09priv->lb_dis_to =3D get_jiffies_64() + HZ * 3;
 =09}
=20
-=09return ret;
+=09return 0;
 }
=20
 static int gpy115_loopback(struct phy_device *phydev, bool enable)
--=20
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640826B9B7E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCNQbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCNQbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:31:24 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754F3F970
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1678811440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6mjPhA2lQF534BzBLLDE/8crxKiQZQUCr9iyTar43+8=;
        b=AXfkAg9gSfUrylTzwqHTy+Mm+jFRm/3r0wkLSOwc9UJs5o1mBtOM0pZUylydjPY64ULyma
        fh1uCeIVol2KcCExlzXDX0jcmczprOalUrW0Pbexk3nsvzQOOwuhDGgyjzUvpr+vAmF0SA
        AEMxagClbWxVxIwj/ta2kZ7xIRUBObgW7fFInJTEKaB5tAtttFs1kem+PWjpQEoEoFUfZL
        U8mNxU0mCBCuiHrT0Ukzx+sJZvB/KGAoz92ORHnioVM1sDMzZZ2CP/wW0qzN86uNTYy0vv
        07GaajucBAMrzxC6oJEwN2OfjA9dz/39l1o/P26pVz4bDVcPGCcphAsB071Rmw==
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-187-vt_wWJqTMSujNw5O8Jmwcg-1; Tue, 14 Mar 2023 12:30:36 -0400
X-MC-Unique: vt_wWJqTMSujNw5O8Jmwcg-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2375.34;
 Tue, 14 Mar 2023 09:30:30 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <rtanwar@maxlinear.com>,
        <mohammad.athari.ismail@intel.com>, <edumazet@google.com>,
        <michael@walle.cc>, <pabeni@redhat.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH net-next v5] net: phy: mxl-gpy: enhance delay time required by loopback disable function
Date:   Wed, 15 Mar 2023 00:30:23 +0800
Message-ID: <20230314163023.36637-1-lxu@maxlinear.com>
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

v5 changes:
 Fix race condition introduced in v4.
 Remove the bool variable lb_dis_chk added in v4.

 drivers/net/phy/mxl-gpy.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index e5972b4ef6e8..8e6bb97b5f85 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -107,6 +107,13 @@ struct gpy_priv {
=20
 =09u8 fw_major;
 =09u8 fw_minor;
+
+=09/* It takes 3 seconds to fully switch out of loopback mode before
+=09 * it can safely re-enter loopback mode. Record the time when
+=09 * loopback is disabled. Check and wait if necessary before loopback
+=09 * is enabled.
+=09 */
+=09u64 lb_dis_to;
 };
=20
 static const struct {
@@ -769,18 +776,34 @@ static void gpy_get_wol(struct phy_device *phydev,
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
+=09=09u64 now =3D get_jiffies_64();
+
+=09=09/* wait until 3 seconds from last disable */
+=09=09if (time_before64(now, priv->lb_dis_to))
+=09=09=09msleep(jiffies64_to_msecs(priv->lb_dis_to - now));
+
+=09=09set =3D BMCR_LOOPBACK;
+=09}
+
+=09ret =3D phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, set);
+=09if (ret <=3D 0)
+=09=09return ret;
+
+=09if (enable) {
+=09=09/* It takes some time for PHY device to switch into
+=09=09 * loopback mode.
 =09=09 */
 =09=09msleep(100);
+=09} else {
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


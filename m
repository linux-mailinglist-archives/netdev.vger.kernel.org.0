Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190266655F0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjAKIX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbjAKIXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:23:00 -0500
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AF52738
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1673425334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sIEXVSUhPNjiEiCVGDt3ZBHd2NSvVs0dFCfD31OVFoA=;
        b=J6VuMHXpKm5AZsCoMPtdH4olfyjsj+/zCTF0+qA1ZPG+nIt+l5syuaoOiVNe0bUxCbbkBG
        ME4nsiwoakU7KCtVknAG6ihooW2fBWaNYoLgeRIsvQ2NM54NeF6ak5aJIrYW7gdLsukQoF
        uNue/SeKZ4NGaPu2cUErAT5XDV5ITxk7rYxAFUYGhm3MR7Ot163Uexx8XmP2LzUhLo7c/J
        ZLJV00Wg8lwj/bcgudsLUKeRBr31VxmrSKRZmdou74gWnvaap2ZosPXJ1vvat7KlsM5AQn
        99PLCBn99DcTFYz1TZ/vt8HapY19vUQwkB8b37qUFbeDv66QuOsiXS81W6ZU2g==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-175-m-5Ii-jhNY6EtnD_xIXoag-1; Wed, 11 Jan 2023 03:22:13 -0500
X-MC-Unique: m-5Ii-jhNY6EtnD_xIXoag-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Wed, 11 Jan 2023 00:22:08 -0800
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        <edumazet@google.com>, <michael@walle.cc>, <pabeni@redhat.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH net-next v3] net: phy: mxl-gpy: fix delay time required by loopback disable function
Date:   Wed, 11 Jan 2023 16:22:01 +0800
Message-ID: <20230111082201.15181-1-lxu@maxlinear.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPY2xx devices need 3 seconds to fully switch out of loopback mode
before it can safely re-enter loopback mode.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
v2 changes:
 Update comments.

v3 changes:
 Submit for net-next.

 drivers/net/phy/mxl-gpy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 147d7a5a9b35..b682d7fc477c 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -770,9 +770,11 @@ static int gpy_loopback(struct phy_device *phydev, boo=
l enable)
 =09=09=09 enable ? BMCR_LOOPBACK : 0);
 =09if (!ret) {
 =09=09/* It takes some time for PHY device to switch
-=09=09 * into/out-of loopback mode.
+=09=09 * into/out-of loopback mode. It takes 3 seconds
+=09=09 * to fully switch out of loopback mode before
+=09=09 * it can safely re-enter loopback mode.
 =09=09 */
-=09=09msleep(100);
+=09=09msleep(enable ? 100 : 3000);
 =09}
=20
 =09return ret;
--=20
2.17.1


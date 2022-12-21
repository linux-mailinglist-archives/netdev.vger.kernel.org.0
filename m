Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA37F652EC8
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiLUJpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiLUJp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:45:29 -0500
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794AB220E1
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1671615878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=B0c2ZUJ/q3gYeutVcLUbSrqH/PdMGOKhVUZqcGqTa+8=;
        b=PGnpmvYaQTSI4e8TfzoPQ9cAqqad8S3xVsrL5xdPrlVW2kXl3LLdzzd/YeaToPDKS1+XyL
        sEa76qR4jeo+FW8Nxy1DkFMSM7A92DdlhZslymUrgCGoDgBZo9Xrpy1oNkJawzAfokuKtV
        1JVVD2gkP2YCVFLRXe2h9vpiQZLoM2nRfQXAMzKOYz2i6LD47lTgt3ok0sdWewuqAUTJJB
        6LkFRQchPgVlwc1h3ttkLOkTKTnule7915zbpigjOl4Re8bhlJM44UkI+Z1WTVSNSUmH+W
        O1nZ3DSZriHr593l2XaNk0lRsrWAIfQimXTUWJXSqvTcIDWraZQ3CFlqrqMWmA==
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-612-SXrkZs4hOGC9b6xwuRiTkw-1; Wed, 21 Dec 2022 04:44:36 -0500
X-MC-Unique: SXrkZs4hOGC9b6xwuRiTkw-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2375.24;
 Wed, 21 Dec 2022 01:44:31 -0800
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH net v2] net: phy: mxl-gpy: fix delay time required by loopback disable function
Date:   Wed, 21 Dec 2022 17:43:58 +0800
Message-ID: <20221221094358.29639-1-lxu@maxlinear.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A504964C519
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiLNIak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbiLNIaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:30:25 -0500
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E16B1AF0B
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1671006582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UWvGn0WXLrSpTrgN/Z8AyvR1OPVO5/ANZy5KB2qrPQQ=;
        b=JUVzcvapYJy7w84BHyUWiY2Hr7VGu03olJz3kx6bK8Bp3CsWrkLdF2xVFK4n8cxna5c96Q
        eI+DHHGwqDWoqoOHvpRJlNgTwi1ZYfjUwN1ztmEeymmKUt5lpT6WKwMy3H79QAI30a6SWd
        SQMfoUfLA05SDScQISb5oHGDoflf8NDXrNCOa3WrGPWCO15bHHTa6bkW+74qV6OZcImz2F
        DZ658bYLcafidjtQdoXfUGjCHa3qYLDXH+fBlGEFCrNKRD1I9k4KeHJDOnzg3Q2ghFPcFA
        joXps8GlLQ4CvJUGwN/rGgmXVDzweFsVRTkktMP1H1h21TPDiFRQCvrDvEIfOA==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-519-a0pVYlTHMCaMkfoWzKsfig-1; Wed, 14 Dec 2022 03:29:40 -0500
X-MC-Unique: a0pVYlTHMCaMkfoWzKsfig-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Wed, 14 Dec 2022 00:29:36 -0800
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH] net: phy: enhance Maxlinear GPY loopback disable function
Date:   Wed, 14 Dec 2022 16:29:24 +0800
Message-ID: <20221214082924.54990-1-lxu@maxlinear.com>
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

GPY need 3 seconds to switch out of loopback mode.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
 drivers/net/phy/mxl-gpy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 147d7a5a9b35..81ea7c768657 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -770,9 +770,10 @@ static int gpy_loopback(struct phy_device *phydev, boo=
l enable)
 =09=09=09 enable ? BMCR_LOOPBACK : 0);
 =09if (!ret) {
 =09=09/* It takes some time for PHY device to switch
-=09=09 * into/out-of loopback mode.
+=09=09 * into/out-of loopback mode. It takes 3 seconds
+=09=09 * before re-enter loopback mode.
 =09=09 */
-=09=09msleep(100);
+=09=09msleep(enable ? 100 : 3000);
 =09}
=20
 =09return ret;
--=20
2.17.1


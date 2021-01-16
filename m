Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B496C2F8DDA
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbhAPRKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:10:54 -0500
Received: from mail-41103.protonmail.ch ([185.70.41.103]:24658 "EHLO
        mail-41103.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbhAPRKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:10:50 -0500
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jan 2021 12:10:49 EST
Received: from mail-03.mail-europe.com (mail-03.mail-europe.com [91.134.188.129])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41103.protonmail.ch (Postfix) with ESMTPS id 792242000E1D
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 16:14:55 +0000 (UTC)
Authentication-Results: mail-41103.protonmail.ch;
        dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="P31Pw8GS"
Date:   Sat, 16 Jan 2021 16:13:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610813609; bh=MHzz5FyKwn7i42NSMZN+CFQWUj4wNAT96aUlGXKrpkU=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=P31Pw8GS8uCTnDc06Sme0658TXm4qVC3TfBLj1M3KKBtrC3eBWgN1yeNFR83i1V5i
         54nShNvAjODsiYCGQZXHravtehg57ou8GGXFcDjKVAKvzVmL84xi98ZPJI2hEltQTy
         Sm0C37o2A5eh4CZDZSdCgtNfic/kpc3gHQb8vmYHJ0anfjjdr8AjI/oZqxlo8YDIjx
         LrTuOwCxuZbunb/mN6+IAV65GESTTQCT8HeNZTXhQbQ/0x+5CqqnOj5mlACweU+qhe
         OxV5bnB+4Jq5pzZ1L/Gh6WtyBypl9FxBJljslLDCZRImpyGOF4HVt3NzEt5C5RXBjq
         vHSkflgoicWjQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] mdio, phy: fix -Wshadow warnings triggered by nested container_of()
Message-ID: <20210116161246.67075-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

container_of() macro hides a local variable '__mptr' inside. This
becomes a problem when several container_of() are nested in each
other within single line or plain macros.
As C preprocessor doesn't support generating random variable names,
the sole solution is to avoid defining macros that consist only of
container_of() calls, or they will self-shadow '__mptr' each time:

In file included from ./include/linux/bitmap.h:10,
                 from drivers/net/phy/phy_device.c:12:
drivers/net/phy/phy_device.c: In function =E2=80=98phy_device_release=
=E2=80=99:
./include/linux/kernel.h:693:8: warning: declaration of =E2=80=98__mptr=
=E2=80=99 shadows a previous local [-Wshadow]
  693 |  void *__mptr =3D (void *)(ptr);     \
      |        ^~~~~~
./include/linux/phy.h:647:26: note: in expansion of macro =E2=80=98containe=
r_of=E2=80=99
  647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
      |                          ^~~~~~~~~~~~
./include/linux/mdio.h:52:27: note: in expansion of macro =E2=80=98containe=
r_of=E2=80=99
   52 | #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
      |                           ^~~~~~~~~~~~
./include/linux/phy.h:647:39: note: in expansion of macro =E2=80=98to_mdio_=
device=E2=80=99
  647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
      |                                       ^~~~~~~~~~~~~~
drivers/net/phy/phy_device.c:217:8: note: in expansion of macro =E2=80=
=98to_phy_device=E2=80=99
  217 |  kfree(to_phy_device(dev));
      |        ^~~~~~~~~~~~~
./include/linux/kernel.h:693:8: note: shadowed declaration is here
  693 |  void *__mptr =3D (void *)(ptr);     \
      |        ^~~~~~
./include/linux/phy.h:647:26: note: in expansion of macro =E2=80=98containe=
r_of=E2=80=99
  647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
      |                          ^~~~~~~~~~~~
drivers/net/phy/phy_device.c:217:8: note: in expansion of macro =E2=80=
=98to_phy_device=E2=80=99
  217 |  kfree(to_phy_device(dev));
      |        ^~~~~~~~~~~~~

As they are declared in header files, these warnings are highly
repetitive and very annoying (along with the one from linux/pci.h).

Convert the related macros from linux/{mdio,phy}.h to static inlines
to avoid self-shadowing and potentially improve bug-catching.
No functional changes implied.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/mdio.h | 23 ++++++++++++++++++-----
 include/linux/phy.h  |  7 +++++--
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index dbd69b3d170b..ffb787d5ebde 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -49,7 +49,11 @@ struct mdio_device {
 =09unsigned int reset_assert_delay;
 =09unsigned int reset_deassert_delay;
 };
-#define to_mdio_device(d) container_of(d, struct mdio_device, dev)
+
+static inline struct mdio_device *to_mdio_device(const struct device *dev)
+{
+=09return container_of(dev, struct mdio_device, dev);
+}
=20
 /* struct mdio_driver_common: Common to all MDIO drivers */
 struct mdio_driver_common {
@@ -57,8 +61,12 @@ struct mdio_driver_common {
 =09int flags;
 };
 #define MDIO_DEVICE_FLAG_PHY=09=091
-#define to_mdio_common_driver(d) \
-=09container_of(d, struct mdio_driver_common, driver)
+
+static inline struct mdio_driver_common *
+to_mdio_common_driver(const struct device_driver *driver)
+{
+=09return container_of(driver, struct mdio_driver_common, driver);
+}
=20
 /* struct mdio_driver: Generic MDIO driver */
 struct mdio_driver {
@@ -73,8 +81,13 @@ struct mdio_driver {
 =09/* Clears up any memory if needed */
 =09void (*remove)(struct mdio_device *mdiodev);
 };
-#define to_mdio_driver(d)=09=09=09=09=09=09\
-=09container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
+
+static inline struct mdio_driver *
+to_mdio_driver(const struct device_driver *driver)
+{
+=09return container_of(to_mdio_common_driver(driver), struct mdio_driver,
+=09=09=09    mdiodrv);
+}
=20
 /* device driver data */
 static inline void mdiodev_set_drvdata(struct mdio_device *mdio, void *dat=
a)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 24fcc6456a9e..bc323fbdd21e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -648,8 +648,11 @@ struct phy_device {
 =09const struct macsec_ops *macsec_ops;
 #endif
 };
-#define to_phy_device(d) container_of(to_mdio_device(d), \
-=09=09=09=09      struct phy_device, mdio)
+
+static inline struct phy_device *to_phy_device(const struct device *dev)
+{
+=09return container_of(to_mdio_device(dev), struct phy_device, mdio);
+}
=20
 /**
  * struct phy_tdr_config - Configuration of a TDR raw test
--=20
2.30.0



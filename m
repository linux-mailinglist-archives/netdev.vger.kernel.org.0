Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BEB19FC9
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfEJPFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 11:05:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38699 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfEJPFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 11:05:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id f2so7884595wmj.3;
        Fri, 10 May 2019 08:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:user-agent
         :content-transfer-encoding;
        bh=X7R+Ckr+t1Y3MDojCT6r8rBxjPCEckNOzxwxkELIS1M=;
        b=n/nhKivLwp7HiGjRp095/EAlDSWIcDLw7vxk1E3JbpqA6TnYxjIBzyi9HxIc6Tsbkz
         lzKaFzLqXWMoGnr7QT8xBPZHma10UkTZol2nxDEIjllN+b/VD7GlBYQCjnojQChWALGv
         xyfvqlHyo95nXF7V187xX/kcuh2tR9tCqNlN4a3+Lg3EamBQoZLo/u0V0rHMrmTpwlqx
         EkUqnHxoq/TuukF5V9KoEXqmbpAmx/rRTlA1j/B72BjYvm4V8OL0PVbyCzeMSTHzXyWG
         t1d/v1h51pYtn8vGmxHnuL4boXzNi5acEr5AecgGgy2CxaoKWH+9gFL1jo8/QUpKLb4B
         +1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :user-agent:content-transfer-encoding;
        bh=X7R+Ckr+t1Y3MDojCT6r8rBxjPCEckNOzxwxkELIS1M=;
        b=PImfDMJVB2MNNki0cA2+Pdzly0HDDfo/KY+Xk4iu6AlVEeIFgkn/Wws45DLDIxn7p1
         xX1cqmHnde2gG+OgWQZU4v4cVmSPtUhqHqTnQMDOzTTU/2yugwVMeCQ+ox/Ue4TbEayu
         xypnZPnoIaxyUWft6PsJMYO49eo9ykUqXPLstFpIr+hAIAuE5iExSSrwhp1BcoQqwuQ3
         skx7NMF3pqKIBdXrzKkui/Og89epW+c/s1EzwiEdKa2tTGSFA0Wgo5pQsSK2OVVel77l
         Y2GhtbXMRDFjgQB+ItAUaVnsed+E9TM5Yqy7tYw32upglwDlXV/Pg3peFC9rZeNlsF27
         qISw==
X-Gm-Message-State: APjAAAUD2+vlCWblwGiyRU67GzIz6CNmNpnSvmj8aOEUn1KUFkOQsuZX
        Nn2bn7Bqt0OaxaW1AujUjQY=
X-Google-Smtp-Source: APXvYqzLgy5dMEiOySkyzGmSB95yAHW1kHlgR2mXa2fdMrWtciAGmNDtVawQGweRi2Z94rFzxILnUQ==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr7750527wmg.53.1557500715767;
        Fri, 10 May 2019 08:05:15 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id z9sm6481275wma.39.2019.05.10.08.05.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 08:05:14 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: net: phy: realtek: regression, kernel null pointer dereference
Date:   Fri, 10 May 2019 17:05:13 +0200
MIME-Version: 1.0
Message-ID: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
pointer dereference.
The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
  net: phy: realtek: Add rtl8211e rx/tx delays config
which uncovered a bug in phy-core when attempting to call
  phydev->drv->read_page
which can be null.
The patch to drivers/net/phy/phy-core.c below fixes the kernel null pointer
dereference. After applying the patch, there is still no network. I have
also tested the patch to drivers/net/phy/realtek.c, but no success. The
system hangs forever while initializing eth0.

Any suggestions?

Regards,
  Vicen=C3=A7.

--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -648,11 +648,17 @@
=20
 static int __phy_read_page(struct phy_device *phydev)
 {
+=09if (!phydev->drv->read_page)
+=09=09return -EOPNOTSUPP;
+=09
 =09return phydev->drv->read_page(phydev);
 }
=20
 static int __phy_write_page(struct phy_device *phydev, int page)
 {
+=09if (!phydev->drv->write_page)
+=09=09return -EOPNOTSUPP;
+
 =09return phydev->drv->write_page(phydev, page);
 }
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -214,8 +214,10 @@
 =09 * for details).
 =09 */
 =09oldpage =3D phy_select_page(phydev, 0x7);
-=09if (oldpage < 0)
-=09=09goto err_restore_page;
+=09if (oldpage < 0) {
+=09=09dev_warn(&phydev->mdio.dev, "Unable to set rgmii delays\n");
+=09=09return 0;
+=09}
=20
 =09ret =3D phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
 =09if (ret)


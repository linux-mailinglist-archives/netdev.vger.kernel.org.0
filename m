Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2965215B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiLTNUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiLTNT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:19:57 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321F712D2C
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:19:57 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7DD0C9C088F;
        Tue, 20 Dec 2022 08:19:56 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 1mfUxQx6ywwF; Tue, 20 Dec 2022 08:19:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 028BC9C088E;
        Tue, 20 Dec 2022 08:19:56 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 028BC9C088E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671542396; bh=97D5Z7h3Lq5wflhCB8z4Yu12HSf/KW4FuyDiFN1xmns=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=KW7EHJAkSaSQU35gTAcOYok51+FDbvtf7xu573DiHcq18fPgQSkA9G6Ndjd70HPE8
         Tmeo2XfM2zfACkDR8ChLhjO0VBomBIE32K8xhNP9qTf5qKMiblDOJd6gNIm7+gz8GZ
         32K02PgHKnheCNbPDnCs8CUudhFfeTOsnqW9wU4LFlQ7vsJDOW+XtbHuFedwLAwHhy
         c/kXzNGsoe+wwu+Uu1UkEA+34d9VNbLlxyvPH2JxfoLKqH+bG8ObRe0d3djLYVE06Z
         k1cddYv9y/oieRVXKlvL1ijuDSE0RMGZvvRKWwEvEwsf07ubdynE9zyAjw0mApR7Mk
         PTYvPLiJSy94Q==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XyOt_dRSzLij; Tue, 20 Dec 2022 08:19:55 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (mtl.savoirfairelinux.net [192.168.50.3])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 192FC9C088F;
        Tue, 20 Dec 2022 08:19:55 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v3 2/3] net: phy: make phy_enable_interrupts() non-static
Date:   Tue, 20 Dec 2022 14:19:22 +0100
Message-Id: <20221220131921.806365-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, phy_disable_interrupts() allows to disable interrupts without
freeing them. However, the only exported function to re-enable them is
phy_request_interrupt(), which also requests them again. It should be
possible to re-enable interrupts without re-allocating them.

This is required for lan78xx.c where we want to enable/disable the phy
interrupts during lan78xx_link_status_change().

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/phy/phy.c | 3 ++-
 include/linux/phy.h   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 33250da76466..4168cf54aa59 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1040,10 +1040,11 @@ static irqreturn_t phy_interrupt(int irq, void *p=
hy_dat)
  * phy_enable_interrupts - Enable the interrupts from the PHY side
  * @phydev: target phy_device struct
  */
-static int phy_enable_interrupts(struct phy_device *phydev)
+int phy_enable_interrupts(struct phy_device *phydev)
 {
 	return phy_config_interrupt(phydev, PHY_INTERRUPT_ENABLED);
 }
+EXPORT_SYMBOL(phy_enable_interrupts);
=20
 /**
  * phy_request_interrupt - request and enable interrupt for a PHY device
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..d2350f0dc566 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1715,6 +1715,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct=
 ifreq *ifr, int cmd);
 int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int =
cmd);
 int phy_disable_interrupts(struct phy_device *phydev);
+int phy_enable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
--=20
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF612459BC7
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 06:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhKWFfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 00:35:52 -0500
Received: from mail.loongson.cn ([114.242.206.163]:47466 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229690AbhKWFfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 00:35:51 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxZ+jqfJxh_n4AAA--.2870S2;
        Tue, 23 Nov 2021 13:32:31 +0800 (CST)
From:   Yinbo Zhu <zhuyinbo@loongson.cn>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc:     zhuyinbo@loongson.cn
Subject: [PATCH v1 2/2] net: mdio: fixup ethernet phy module auto-load function
Date:   Tue, 23 Nov 2021 13:32:23 +0800
Message-Id: <1637645543-24618-1-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: AQAAf9AxZ+jqfJxh_n4AAA--.2870S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF17uF4rZF47JrW7KF13CFg_yoW5Kr48pF
        ZYk3WYkrW8JrsxWwn5Cw48CF1Ykw4Iy39rGFy0939Y9rs8XryvqFyfKFyY9r15uayruw1a
        qay0vFyDZFykArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
        evJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the phy_id is only phy identifier, that phy module auto-load function
should according the phy_id event rather than other information, this
patch is remove other unnecessary information and add phy_id event in
mdio_uevent function and ethernet phy module auto-load function will
work well.

Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
---
Hi Russell King,

I don't see that mail from you, but I have a look about your advice for my patch on netdev patchwork

> The MDIO bus contains more than just PHYs. This completely breaks
> anything that isn't a PHY device - likely by performing an
> out-of-bounds access.
> 
> This change also _totally_ breaks any MDIO devices that rely on
> matching via the "of:" mechanism using the compatible specified in
> DT. An example of that is the B53 DSA switch.
>
> Sorry, but we've already learnt this lesson from a similar case with
> SPI. Once one particular way of dealing with MODALIAS has been
> established for auto-loading modules for a subsystem, it is very
> difficult to change it without causing regressions.

> We need a very clear description of the problem that these patches are
> attempting to address, and then we need to see that effort has been
> put in to verify that changing the auto-loading mechanism is safe to
> do - such as auditing every single driver that use the MDIO subsystem.

if mdio_uevent doesn't include my patch, you will see that mdio uevent is like 
"MODALIAS= of:NphyTethernet-phyCmarvell,88E1512", "marvell,88E1512" is only a
phy dts compatible, and that name can use any a string that in the same driver, 
if phy driver not use dts, and this MODALIAS is NULL, it is not unique, and even
thoug use that modalias, that do_mdio_entry doesn't get that compatibe 
information, event though it can get compatible and it looks ugly, but that phy id 
is unique if phy chip following 802.3 spec,
whatever whether use dts, use phy id it will always okay that phy dev to match phy
 driver, because phy it is getted by mdiobus_register
and mdio device driver will call mdiobus_register whatever whether use dts.

>  struct bus_type mdio_bus_type = {
> -	.name		= "mdio_bus",
> +	.name		= "mdio",

> This looks like an unrelated user-interface breaking change. This
> changes the path of all MDIO devices and drivers in /sys/bus/mdio_bus/*


I think mdio_bus is ugly, you can other bus, eg. usb,pci.  in addition, mdio bus name 
should be Consistent with mdio alias configure, eg. MDIO_MODULE_PREFIX.

BRs,
Yinbo Zhu. 

 drivers/net/phy/mdio_bus.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6865d93..999f0d4 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -962,12 +962,12 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 
 static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	int rc;
+	struct phy_device *pdev;
 
-	/* Some devices have extra OF data and an OF-style MODALIAS */
-	rc = of_device_uevent_modalias(dev, env);
-	if (rc != -ENODEV)
-		return rc;
+	pdev = to_phy_device(dev);
+
+	if (add_uevent_var(env, "MODALIAS=mdio:p%08X", pdev->phy_id))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -991,7 +991,7 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 };
 
 struct bus_type mdio_bus_type = {
-	.name		= "mdio_bus",
+	.name		= "mdio",
 	.dev_groups	= mdio_bus_dev_groups,
 	.match		= mdio_bus_match,
 	.uevent		= mdio_uevent,
-- 
1.8.3.1


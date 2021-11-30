Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B277462E6F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbhK3IZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:25:55 -0500
Received: from mail.loongson.cn ([114.242.206.163]:39886 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229951AbhK3IZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 03:25:52 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxz8on36Vhh7UBAA--.4073S3;
        Tue, 30 Nov 2021 16:22:06 +0800 (CST)
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
Subject: [PATCH v3 2/2] net: mdio: rework mdio_uevent for mdio ethernet phy device
Date:   Tue, 30 Nov 2021 16:21:57 +0800
Message-Id: <1638260517-13634-2-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
X-CM-TRANSID: AQAAf9Dxz8on36Vhh7UBAA--.4073S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw48GF15Arykuw48Zr4Utwb_yoW8CFy5pF
        4rJFyrtrWjgr47Wwn5C3yDWF1a9397K397GryF9wsY9rs8AryDXFyftFy29r13AFW8u3W7
        ta4vqr18ua4DJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPm14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
        e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
        8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
        jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
        kIwI1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I
        3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxV
        WUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8I
        cVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
        AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZE
        Xa7VUjLL07UUUUU==
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The of_device_uevent_modalias is service for 'of' type platform driver
, which ask the first args must be 'of' that use MODULE_DEVICE_TABLE
when driver was exported, but ethernet phy is a kind of 'mdio' type
device and it is inappropriate if driver use 'of' type for exporting,
in fact, most mainstream ethernet phy driver hasn't used 'of' type,
even though phy driver was exported use 'of' type and it's irrelevant
with mdio_uevent, at this time, platform_uevent was responsible for
reporting uevent to match modules.alias configure, so, whatever that
of_device_uevent_modalias was unnecessary, this patch was to remove it
and add phy_id as modio uevent then ethernet phy module auto load
function will work well.

Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
---
Change in v3:
		Rework the patch commit log information.

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


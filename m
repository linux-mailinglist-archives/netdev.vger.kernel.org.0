Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85BB46837D
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384417AbhLDJR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:17:26 -0500
Received: from mail.loongson.cn ([114.242.206.163]:38794 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1384410AbhLDJRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 04:17:24 -0500
Received: from localhost.localdomain.localdomain (unknown [10.2.5.46])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Ax6shAMathLt0CAA--.6211S3;
        Sat, 04 Dec 2021 17:13:44 +0800 (CST)
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
Subject: [PATCH v4 2/2] net: mdio: rework mdio_uevent for mdio ethernet phy device
Date:   Sat,  4 Dec 2021 17:13:28 +0800
Message-Id: <1638609208-10339-2-git-send-email-zhuyinbo@loongson.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
References: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
X-CM-TRANSID: AQAAf9Ax6shAMathLt0CAA--.6211S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw48GF15Arykuw48Zr4Utwb_yoW8Cr43pF
        4rJFyYyrWjgr47Wws5C3yDuF1a9397t397Gryj9wsY9rs8AryDXFyftFy29r13AFW8u3W7
        tayvqr18uFyDJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPC14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4U
        JwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
        IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
        kIc2xKxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
        x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
        v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
        x2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
        80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
        43ZEXa7VUjeWlDUUUUU==
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


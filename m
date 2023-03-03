Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0EC6A9BF9
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCCQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjCCQnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:43:19 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC52B2884E;
        Fri,  3 Mar 2023 08:43:15 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D098940009;
        Fri,  3 Mar 2023 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677861794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFWNgWUO7ht6IxOffU33Vyth+9mz8NU5szlox5lMPSk=;
        b=PSgSqa/IASgFC0/Zs555HTAsr8ef3BktnmZwJSCiHdc3XF00kVMvhi1nzTxLvcjJNSteo5
        +VY7EhQVoeglPjN/rwJWHs6o+GqwJ1POoX3j88z0JPldWI6MEmPs/a4e2SXJdAfmp5g425
        iBnFxDu6iXPrKHUe1srfhM5KIZwe3RZog1dQsb4SjNYyRtIYPC3ngJIWufKNOT1ihg9IU5
        0Ii6+txKg9VWx8MkBTgB4xOPYeftc3zUa3BRZOL9YP393+Eu/Na32lXYld4jVz7VtUbb6N
        jZim7nZfnpSd+cpyvraRfyqW/I2L7YIeQeE3P3dF3n45mvqkvksvz+0Z7yoRPA==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sven Eckelmann <sven@narfation.org>,
        Wang Yufen <wangyufen@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH v2 2/4] net: Expose available time stamping layers to user space.
Date:   Fri,  3 Mar 2023 17:42:39 +0100
Message-Id: <20230303164248.499286-3-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230303164248.499286-1-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

Time stamping on network packets may happen either in the MAC or in
the PHY, but not both.  In preparation for making the choice
selectable, expose both the current and available layers via sysfs.

In accordance with the kernel implementation as it stands, the current
layer will always read as "phy" when a PHY time stamping device is
present.  Future patches will allow changing the current layer
administratively.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in v2:
    - Move the introduction of selected_timestamping_layer variable in next
      patch.

 .../ABI/testing/sysfs-class-net-timestamping  | 17 ++++++
 net/core/net-sysfs.c                          | 60 +++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-timestamping

diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/Documentation/ABI/testing/sysfs-class-net-timestamping
new file mode 100644
index 000000000000..529c3a6eb607
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
@@ -0,0 +1,17 @@
+What:		/sys/class/net/<iface>/available_timestamping_providers
+Date:		January 2022
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		Enumerates the available providers for SO_TIMESTAMPING.
+		The possible values are:
+		- "mac"  The MAC provides time stamping.
+		- "phy"  The PHY or MII device provides time stamping.
+
+What:		/sys/class/net/<iface>/current_timestamping_provider
+Date:		January 2022
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		Show the current SO_TIMESTAMPING provider.
+		The possible values are:
+		- "mac"  The MAC provides time stamping.
+		- "phy"  The PHY or MII device provides time stamping.
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8409d41405df..26095634fb31 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -620,6 +620,64 @@ static ssize_t threaded_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(threaded);
 
+static ssize_t available_timestamping_providers_show(struct device *dev,
+						     struct device_attribute *attr,
+						     char *buf)
+{
+	const struct ethtool_ops *ops;
+	struct net_device *netdev;
+	struct phy_device *phydev;
+	int ret = 0;
+
+	netdev = to_net_dev(dev);
+	phydev = netdev->phydev;
+	ops = netdev->ethtool_ops;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	ret += sprintf(buf, "%s\n", "mac");
+	buf += 4;
+
+	if (phy_has_tsinfo(phydev)) {
+		ret += sprintf(buf, "%s\n", "phy");
+		buf += 4;
+	}
+
+	rtnl_unlock();
+
+	return ret;
+}
+static DEVICE_ATTR_RO(available_timestamping_providers);
+
+static ssize_t current_timestamping_provider_show(struct device *dev,
+						  struct device_attribute *attr,
+						  char *buf)
+{
+	const struct ethtool_ops *ops;
+	struct net_device *netdev;
+	struct phy_device *phydev;
+	int ret;
+
+	netdev = to_net_dev(dev);
+	phydev = netdev->phydev;
+	ops = netdev->ethtool_ops;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (phy_has_tsinfo(phydev)) {
+		ret = sprintf(buf, "%s\n", "phy");
+	} else {
+		ret = sprintf(buf, "%s\n", "mac");
+	}
+
+	rtnl_unlock();
+
+	return ret;
+}
+static DEVICE_ATTR_RO(current_timestamping_provider);
+
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
 	&dev_attr_type.attr,
@@ -653,6 +711,8 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
 	&dev_attr_threaded.attr,
+	&dev_attr_available_timestamping_providers.attr,
+	&dev_attr_current_timestamping_provider.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.25.1


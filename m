Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF321AE87E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgDQXFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:05:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgDQXFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 19:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HXRC6JArc8uPWai4BkkSg3ZKRr1f5fCi4iLfAo0L48U=; b=PabZKthlwles2Mg6IJ1H4zFMEk
        pYzCELvKrLNUYRCZoqQrQmE3/jy/YScePnsebwWR00XTEZ87+HrrLM4IMFC2wbDHgo2YEKLqkmfgT
        1J03GHeTaEW1WoAbMyhpZsD3P4GjtiEfUL0vzSeNt5ZpWKO8Z2rVkYGwl3xlW2dfh0qk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPa2J-003MpZ-1t; Sat, 18 Apr 2020 01:04:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/3] net: Add testing sysfs attribute
Date:   Sat, 18 Apr 2020 01:03:49 +0200
Message-Id: <20200417230350.802675-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200417230350.802675-1-andrew@lunn.ch>
References: <20200417230350.802675-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to speed, duplex and dorment, report the testing status
in sysfs.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/ABI/testing/sysfs-class-net | 13 +++++++++++++
 net/core/net-sysfs.c                      | 15 ++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 664a8f6a634f..5e8b09743e04 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -124,6 +124,19 @@ Description:
 		authentication is performed (e.g: 802.1x). 'link_mode' attribute
 		will also reflect the dormant state.
 
+What:		/sys/class/net/<iface>/testing
+Date:		Jun 2019
+KernelVersion:	5.2
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates whether the interface is under test. Possible
+		values are:
+		0: interface is not being tested
+		1: interface is being tested
+
+		When an interface is under test, it cannot be expected
+		to pass packets as normal.
+
 What:		/sys/clas/net/<iface>/duplex
 Date:		October 2009
 KernelVersion:	2.6.33
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4773ad6ec111..0d9e46de205e 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -243,6 +243,18 @@ static ssize_t duplex_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(duplex);
 
+static ssize_t testing_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+
+	if (netif_running(netdev))
+		return sprintf(buf, fmt_dec, !!netif_testing(netdev));
+
+	return -EINVAL;
+}
+static DEVICE_ATTR_RO(testing);
+
 static ssize_t dormant_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
@@ -260,7 +272,7 @@ static const char *const operstates[] = {
 	"notpresent", /* currently unused */
 	"down",
 	"lowerlayerdown",
-	"testing", /* currently unused */
+	"testing",
 	"dormant",
 	"up"
 };
@@ -524,6 +536,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_speed.attr,
 	&dev_attr_duplex.attr,
 	&dev_attr_dormant.attr,
+	&dev_attr_testing.attr,
 	&dev_attr_operstate.attr,
 	&dev_attr_carrier_changes.attr,
 	&dev_attr_ifalias.attr,
-- 
2.26.1


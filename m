Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B171B8F8F
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 14:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408906AbfITMP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 08:15:59 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:45500 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408877AbfITMP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 08:15:58 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 02A992E15EB;
        Fri, 20 Sep 2019 15:15:56 +0300 (MSK)
Received: from vla5-2bf13a090f43.qloud-c.yandex.net (vla5-2bf13a090f43.qloud-c.yandex.net [2a02:6b8:c18:3411:0:640:2bf1:3a09])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 5NXPwXvyij-Ft2CgrFa;
        Fri, 20 Sep 2019 15:15:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1568981755; bh=EjjzrzuTe0P7JC5j7/C7bPcfbLrLIGG5YbvkvN3j0qg=;
        h=Message-ID:Date:To:From:Subject;
        b=izF18+4xI9xNBOwZ5GijqqmrzSe95PiZ9WM6HWAQrjTniG9DWToMvMpw6hcunlkUM
         Siq8icxfkmnXo1TqHdbJvq283Y+8eEgk/JBWPPsqNdlyxIQ7aTqlHTJwMnIphpCIXA
         Hz15HTIpmcnUk6f0rteByE62yvqvaHWAwuY1vvHM=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:344a:8fe6:6594:f7b2])
        by vla5-2bf13a090f43.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id wmW5BdhqIF-FtI0qs1c;
        Fri, 20 Sep 2019 15:15:55 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] net/core/dev: print rtnl kind as driver name for virtual
 devices
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date:   Fri, 20 Sep 2019 15:15:55 +0300
Message-ID: <156898175525.7362.16591901912362742168.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device kind gives more information than only arbitrary device name.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 net/core/dev.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 71b18e80389f..c84561634afd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9651,17 +9651,14 @@ static int __net_init netdev_init(struct net *net)
  */
 const char *netdev_drivername(const struct net_device *dev)
 {
-	const struct device_driver *driver;
 	const struct device *parent;
 	const char *empty = "";
 
 	parent = dev->dev.parent;
-	if (!parent)
-		return empty;
-
-	driver = parent->driver;
-	if (driver && driver->name)
-		return driver->name;
+	if (parent)
+		return dev_driver_string(parent);
+	if (dev->rtnl_link_ops)
+		return dev->rtnl_link_ops->kind;
 	return empty;
 }
 
@@ -9677,8 +9674,8 @@ static void __netdev_printk(const char *level, const struct net_device *dev,
 				netdev_name(dev), netdev_reg_state(dev),
 				vaf);
 	} else if (dev) {
-		printk("%s%s%s: %pV",
-		       level, netdev_name(dev), netdev_reg_state(dev), vaf);
+		printk("%s%s %s%s: %pV", level, netdev_drivername(dev),
+		       netdev_name(dev), netdev_reg_state(dev), vaf);
 	} else {
 		printk("%s(NULL net_device): %pV", level, vaf);
 	}


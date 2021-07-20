Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE3C3CFD43
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhGTOez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237368AbhGTORU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:17:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB73B61222;
        Tue, 20 Jul 2021 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792419;
        bh=3U5cHZKM8awP+zSxZS1EIJAve4S7wCshkfB/0fjPCio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CU3FxOTTjkiYuPjrfEcw2Y4nW6o++8SBX/VbNf/F0YM4jTEd73zGuANVEzsc0bmBT
         N/QQGELQXhF9oPKSF+LgdupZi/obfubPGr4HjLGjV6Y9rE3NZq44bgl2f61r6SN4lD
         XxjoHXmUs9R/RLYI+J3wH9FqBLnLQCH+9X4GJPTMl3ByN0gU32V8+zI3SkAvzf1nQX
         6poTT9RN0zjtiI6gc2K12Bwodx563Q+jRclKJOOmh++2BqUZs775+YTBgB8d2G0uj1
         QwNUynCF1flCZrNir0LW2oMrxNngTp+v1IxAAnkrtg/eHNnFypOXUuiZ/bPhQrYumS
         REg72AmybTuxQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 06/31] phonet: use siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:13 +0200
Message-Id: <20210720144638.2859828-7-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

phonet has a single private ioctl that is broken in compat
mode on big-endian machines today because the data returned
from it is never copied back to user space.

Move it over to the ndo_siocdevprivate callback, which also
fixes the compat issue.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/usb/cdc-phonet.c | 5 +++--
 net/phonet/pn_dev.c          | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index 8d1f69dad603..e1da9102a540 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -253,7 +253,8 @@ static int usbpn_close(struct net_device *dev)
 	return usb_set_interface(pnd->usb, num, !pnd->active_setting);
 }
 
-static int usbpn_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int usbpn_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				void __user *data, int cmd)
 {
 	struct if_phonet_req *req = (struct if_phonet_req *)ifr;
 
@@ -269,7 +270,7 @@ static const struct net_device_ops usbpn_ops = {
 	.ndo_open	= usbpn_open,
 	.ndo_stop	= usbpn_close,
 	.ndo_start_xmit = usbpn_xmit,
-	.ndo_do_ioctl	= usbpn_ioctl,
+	.ndo_siocdevprivate = usbpn_siocdevprivate,
 };
 
 static void usbpn_setup(struct net_device *dev)
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index ac0fae06cc15..876d0ae5f9fd 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -233,11 +233,11 @@ static int phonet_device_autoconf(struct net_device *dev)
 	struct if_phonet_req req;
 	int ret;
 
-	if (!dev->netdev_ops->ndo_do_ioctl)
+	if (!dev->netdev_ops->ndo_siocdevprivate)
 		return -EOPNOTSUPP;
 
-	ret = dev->netdev_ops->ndo_do_ioctl(dev, (struct ifreq *)&req,
-						SIOCPNGAUTOCONF);
+	ret = dev->netdev_ops->ndo_siocdevprivate(dev, (struct ifreq *)&req,
+						  NULL, SIOCPNGAUTOCONF);
 	if (ret < 0)
 		return ret;
 
-- 
2.29.2


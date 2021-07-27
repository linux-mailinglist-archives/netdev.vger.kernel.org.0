Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489563D7730
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhG0Nqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236764AbhG0NqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D62A161A7A;
        Tue, 27 Jul 2021 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393570;
        bh=hk3tPGvys72BUPLz3nQf72WAfa99K1fpmZiSmds8Uyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pu+emFX9WU8IcMJEOnQvFo1ybYXkywwS0WUq6c9U6jkaQSywvUYEZuPWBXQLFHCRg
         p6gmu5kXc6Hw+uqK0nhRU+DPOBpD+D6nD25Yu8FLwwI/tEfRUH8XJWcEugSifpq5mL
         HezFIo1r8F5pvECQmYzvLLaaTYw/2wvtgrGTPKgy3/ZZ67PzrNGgK0ChLxGp6s/9sA
         S+zJHJ+wvWYwAUF+SAo9aQeF375mvMWPuKU+qyOC2kC9EF1kMPdx9r8RczVkyIoMmk
         pIpJysZYrpIbU0/pB+B7d5ovP73LSCFfvUEFJip959d0HR71RLpYVRTdDzdi/h/tbJ
         BYLC8u/3DLFYA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Remi Denis-Courmont <courmisch@gmail.com>
Subject: [PATCH net-next v3 06/31] phonet: use siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:52 +0200
Message-Id: <20210727134517.1384504-7-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Remi Denis-Courmont <courmisch@gmail.com>
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


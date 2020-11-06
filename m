Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25DD2A9FFF
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgKFWTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgKFWTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:19:12 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542E02224A;
        Fri,  6 Nov 2020 22:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701151;
        bh=HjouUAoEbv0fMI8xUTp5LuywhWHtVz/DrEjJeJXaZ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l61PuB19EoIDJZjY/OHKZxkG09zPGFkevmFhYWsFiBqosQE0ecG7xL6atVeYECwMo
         DxMtxYUguIBvP4yLPd+c8cS0A3QN8z3HxXeTwnPuPiLb2SRN67oZltz0EcMBaHMB3K
         iR+t+muAhkns1/PKithlvzGD6M/1YHQcLqsvxXxE=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 27/28] ppp: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:42 +0100
Message-Id: <20201106221743.3271965-28-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

ppp has a custom statistics interface using SIOCDEVPRIVATE
ioctl commands that works correctly in compat mode.

Convert it to use ndo_siocdevprivate as a cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 7d005896a0f9..c39ba3d27283 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1342,11 +1342,11 @@ ppp_start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int
-ppp_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+ppp_net_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+		       void __user *addr, int cmd)
 {
 	struct ppp *ppp = netdev_priv(dev);
 	int err = -EFAULT;
-	void __user *addr = (void __user *) ifr->ifr_ifru.ifru_data;
 	struct ppp_stats stats;
 	struct ppp_comp_stats cstats;
 	char *vers;
@@ -1454,7 +1454,7 @@ static const struct net_device_ops ppp_netdev_ops = {
 	.ndo_init	 = ppp_dev_init,
 	.ndo_uninit      = ppp_dev_uninit,
 	.ndo_start_xmit  = ppp_start_xmit,
-	.ndo_do_ioctl    = ppp_net_ioctl,
+	.ndo_siocdevprivate = ppp_net_siocdevprivate,
 	.ndo_get_stats64 = ppp_get_stats64,
 };
 
-- 
2.27.0


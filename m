Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2933D775B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbhG0Nre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237147AbhG0Nqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BA461ABD;
        Tue, 27 Jul 2021 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393599;
        bh=9HEmQTMcD+tGVqx872uJelDKhvWrPIrr/YltYHMDktc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFlfVIqHVDaxeDE4pmV6k0c9/5GuaHZDoQKExEoQEQx7FspdegsjzvxITDpGqdQx/
         eqhQIX9QLNlgXF5gO3WGOS4eKKZ4AoQbm29NA2Igk+aVWDFB864yVDCAe/cxmSixCS
         qxM2KL1uabypaItuNW938eBaP+ywZwKSZY5APFJrt3qgOrJ6GoVM7iajXC1hjtoCd5
         kpyGe3itGmLxFwOEkrOH/0VFCJK8WhI30sJvMT9y0OneXn9xBfcJprB6fIA5cvLv2Y
         y8X3MUQlLjonpqWIdHlwDtWKwnCEBEuUlLIMplW6k48N6mFnY3IimI8mrDAOeeQc6/
         KHuJIL/pYT0dA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org
Subject: [PATCH net-next v3 23/31] ppp: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:09 +0200
Message-Id: <20210727134517.1384504-24-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

ppp has a custom statistics interface using SIOCDEVPRIVATE
ioctl commands that works correctly in compat mode.

Convert it to use ndo_siocdevprivate as a cleanup.

Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 930e49ef15f6..216a9f4e9750 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1452,11 +1452,11 @@ ppp_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -1585,7 +1585,7 @@ static const struct net_device_ops ppp_netdev_ops = {
 	.ndo_init	 = ppp_dev_init,
 	.ndo_uninit      = ppp_dev_uninit,
 	.ndo_start_xmit  = ppp_start_xmit,
-	.ndo_do_ioctl    = ppp_net_ioctl,
+	.ndo_siocdevprivate = ppp_net_siocdevprivate,
 	.ndo_get_stats64 = ppp_get_stats64,
 	.ndo_fill_forward_path = ppp_fill_forward_path,
 };
-- 
2.29.2


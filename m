Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A513CFD93
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbhGTOs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239959AbhGTOVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D0561287;
        Tue, 20 Jul 2021 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792439;
        bh=bQyvPlSHaN7O4KBdIUZXvJlU77ZYJ1DL+/RyCtFKyWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGvTGWF7PD3vpUbSrTk1jBsTNJFYzZ1PUZVYkpBLobrbGcXtonsbza706Z9T9qoAw
         BPW17w6li1S4ypCzGMhrysVjImsY9ageJm1e5Sm8Dkwe0/cc1OqsVThOBC1anijbz2
         VqF+QH5qNt+WiHY+E2rjMSRaJ8TMX5+xJkRvplJZHK0QN6oGmnjTUskwDCFWYObQf5
         R95vz3msPRXUoDUJCiquGigCKpqSolRw99MpEBUqCzawYn/ziqlF26rv5bPQ6dM0OS
         13MJYauSNiy2zUEyZBjQOPBnBy9zAv7eNaIEjf5G0uFnFxWN9cdgWBSEbS65VSu11j
         QP8Yozye+Lnug==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 23/31] ppp: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:30 +0200
Message-Id: <20210720144638.2859828-24-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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


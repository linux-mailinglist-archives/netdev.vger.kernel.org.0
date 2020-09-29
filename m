Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E037C27B99D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgI2BcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbgI2Bbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A8421D7D;
        Tue, 29 Sep 2020 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343091;
        bh=s34KDftLwNqohmNXhpW+r5cjhudfdyFekn3KqLfndg0=;
        h=From:To:Cc:Subject:Date:From;
        b=n3I1hfOVuObDNt2JiltLBOcx/N7k9yXU6FAMD2qKNpWrA4aKZEJiKsilRYqWq/D1b
         XY8cb4mN9lpWN01DP4vl+s68f8yZ1A37Ij0PdKai6XuPX6hwGlDL9YArzCJdQvNvPf
         yVGPZwAyT2n1BfZBxqSbyt3uhAkdKskYvRUth0lI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/11] drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
Date:   Mon, 28 Sep 2020 21:31:19 -0400
Message-Id: <20200929013129.2406832-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 44a049c42681de71c783d75cd6e56b4e339488b0 ]

PVC devices are virtual devices in this driver stacked on top of the
actual HDLC device. They are the devices normal users would use.
PVC devices have two types: normal PVC devices and Ethernet-emulating
PVC devices.

When transmitting data with PVC devices, the ndo_start_xmit function
will prepend a header of 4 or 10 bytes. Currently this driver requests
this headroom to be reserved for normal PVC devices by setting their
hard_header_len to 10. However, this does not work when these devices
are used with AF_PACKET/RAW sockets. Also, this driver does not request
this headroom for Ethernet-emulating PVC devices (but deals with this
problem by reallocating the skb when needed, which is not optimal).

This patch replaces hard_header_len with needed_headroom, and set
needed_headroom for Ethernet-emulating PVC devices, too. This makes
the driver to request headroom for all PVC devices in all cases.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_fr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 038236a9c60ee..67f89917277ce 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1044,7 +1044,7 @@ static void pvc_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_DLCI;
 	dev->flags = IFF_POINTOPOINT;
-	dev->hard_header_len = 10;
+	dev->hard_header_len = 0;
 	dev->addr_len = 2;
 	netif_keep_dst(dev);
 }
@@ -1096,6 +1096,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	dev->mtu = HDLC_MAX_MTU;
 	dev->min_mtu = 68;
 	dev->max_mtu = HDLC_MAX_MTU;
+	dev->needed_headroom = 10;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->ml_priv = pvc;
 
-- 
2.25.1


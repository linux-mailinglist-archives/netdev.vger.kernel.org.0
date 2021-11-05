Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330F5446161
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhKEJcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 05:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhKEJcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 05:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 744EB6124D;
        Fri,  5 Nov 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636104608;
        bh=nC9kf7bs5KJzCx8ciQRMFgPzwKy9T7bzGzFAIYAfJRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHbCOcXwBjq4POD4qXhgSF3lOFVXSP/HCj/7xRMEZ9OX8lI1+YVP57BRGlccbb19o
         d0VYxeaTPFxjD7ls92TUtlpL5DxJGISqDk1EEbHi3ozKPmnOSUFgJgYDKS8OhsPw87
         DNbjaWC0A1pLPSP7z56yg/oTCrsc28hciO3Gz2IhvG8oWc/m7rU7stndgf8tNq37tQ
         pYe5sX0Hcs+WJ3bEm1go7xupKznUFtFgrrzA1bz54cgN+A50PthRFrVHiKhKjqSk7s
         CGqczVEJ8qW9Xi9tjiQZrfCwuFnvQrNi9LibFVX1l53aGKB/Uw12Bx54pONUyK53jr
         1CZG+RQnR6AHA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>
Cc:     Rakesh Babu <rsaladi2@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] octeontx2-nicvf: fix ioctl callback
Date:   Fri,  5 Nov 2021 10:29:40 +0100
Message-Id: <20211105092954.1771974-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211105092954.1771974-1-arnd@kernel.org>
References: <20211105092954.1771974-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The mii ioctls are now handled by the ndo_eth_ioctl() callback,
not the old ndo_do_ioctl(), but octeontx2-nicvf introduced the
function for the old way.

Move it over to ndo_eth_ioctl() to actually allow calling it from
user space.

Fixes: 43510ef4ddad ("octeontx2-nicvf: Add PTP hardware clock support to NIX VF")
Fixes: a76053707dbf ("dev_ioctl: split out ndo_eth_ioctl")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index e6cb8cd0787d..78944ad3492f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -501,7 +501,7 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_set_features = otx2vf_set_features,
 	.ndo_get_stats64 = otx2_get_stats64,
 	.ndo_tx_timeout = otx2_tx_timeout,
-	.ndo_do_ioctl	= otx2_ioctl,
+	.ndo_eth_ioctl	= otx2_ioctl,
 };
 
 static int otx2_wq_init(struct otx2_nic *vf)
-- 
2.29.2


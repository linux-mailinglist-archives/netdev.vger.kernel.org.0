Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BA412E005
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 19:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgAAS06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 13:26:58 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:13092
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727374AbgAAS02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 13:26:28 -0500
X-IronPort-AV: E=Sophos;i="5.69,382,1571695200"; 
   d="scan'208";a="334542275"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/AES128-SHA256; 01 Jan 2020 19:26:24 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] fsl/fman: use resource_size
Date:   Wed,  1 Jan 2020 18:49:44 +0100
Message-Id: <1577900990-8588-5-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577900990-8588-1-git-send-email-Julia.Lawall@inria.fr>
References: <1577900990-8588-1-git-send-email-Julia.Lawall@inria.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use resource_size rather than a verbose computation on
the end and start fields.

The semantic patch that makes these changes is as follows:
(http://coccinelle.lip6.fr/)

<smpl>
@@ struct resource ptr; @@
- (ptr.end + 1 - ptr.start)
+ resource_size(&ptr)

@@ struct resource *ptr; @@
- (ptr->end + 1 - ptr->start)
+ resource_size(ptr)
</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/ethernet/freescale/fman/mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index f0806ace1ae2..55f2122c3217 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -692,7 +692,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	mac_dev->res = __devm_request_region(dev,
 					     fman_get_mem_region(priv->fman),
-					     res.start, res.end + 1 - res.start,
+					     res.start, resource_size(&res),
 					     "mac");
 	if (!mac_dev->res) {
 		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
@@ -701,7 +701,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	}
 
 	priv->vaddr = devm_ioremap(dev, mac_dev->res->start,
-				   mac_dev->res->end + 1 - mac_dev->res->start);
+				   resource_size(mac_dev->res));
 	if (!priv->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		err = -EIO;


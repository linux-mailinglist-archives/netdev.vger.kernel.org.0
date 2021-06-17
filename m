Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F5F3AB031
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhFQJvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:40 -0400
Received: from first.geanix.com ([116.203.34.67]:41936 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhFQJvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:33 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id B2E3D4C329C;
        Thu, 17 Jun 2021 09:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923363; bh=DU/8XgCmqOcU1c6ia7VRITPn2rmzotPkskeH7i2WLuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RgrmVPT09wm4owgY4qqyp8/Cci0ulXlxBLzQH/V6PWyzfV0B+YZZoqHaAAYmrtzhw
         fKIbQ+trbTrGvtF7YQJZTlJTLuHNFGtMDdeLOgEV1FiowJSmaJ3HVdNA6QQmcpmJrs
         /CkWA61DVbjlYzWX+EA8sljVcnjTUx3nw/MvOsylX9fDerHOnBs5kpQv3eaRS/O4KN
         H5qhRnMrIHBtlHZZswU+VcoPKc5jdnlVtSiVVqQHaLLin5Tu03eqOcSOfTGj0LQHgl
         EiCbGbZ2j8/Yt7DjTBrdbiCdfeX7rk5D0268u3aNIXBXE8SU5iAX6OzsrDUqwpX+A3
         eF3O0kvBnpE0A==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4/6] net: gianfar: Avoid 16 bytes of memset
Date:   Thu, 17 Jun 2021 11:49:23 +0200
Message-Id: <3550366c0e6eda798a36a6695e6b4736e41e40ab.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
References: <cover.1623922686.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memset on CAMx is wrong, as it actually unmasks all carry irq's,
which we clearly are not interested in.

The memset on CARx registers is just pointless, as they are W1C.

So let's just stop the memset before CAR1.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index ebd1065f39fa..4608c0c337bc 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3098,7 +3098,7 @@ static void gfar_hw_init(struct gfar_private *priv)
 
 	/* Zero out the rmon mib registers if it has them */
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_RMON) {
-		memset_io(&(regs->rmon), 0, sizeof(struct rmon_mib));
+		memset_io(&regs->rmon, 0, offsetof(struct rmon_mib, car1));
 
 		/* Mask off the CAM interrupts */
 		gfar_write(&regs->rmon.cam1, 0xffffffff);
-- 
2.32.0


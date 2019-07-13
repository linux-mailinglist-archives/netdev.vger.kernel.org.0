Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005D66779A
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 04:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfGMCJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 22:09:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39955 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbfGMCJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 22:09:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so5318288pgj.7
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 19:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=c7B2XhPhx3hw3rI1jyHAq5icUgQsUc/Zl9RG/a09lWU=;
        b=Qu1UD1p+P592a01DnTGKLPDlyvydmPyEswfpn1k84I0bE7Dg8TfFQLPqQd/QywHxwX
         Rhp56Zm8gdSbszFGhbjv8cda0iNg6nnBfCrUErJOBGli0t90XLRpAEtSi7fQbJtxYH1y
         FSzBjWdHixhDAgdBJuMnDxy8SgTVXmg3Xocv+qN95tWu2f4wQ4cetBzFHRlIsgWD+TAT
         FgXskpPfUUYYIbUDeb0IEkbLaeZAiEGGOai5JYE+u7Cn5kTAYm1tVpcCNuIu8x+xdriT
         Aex1hVNfof6LmXFCeJ5gE1PGWnLhXxDF3mqP1X4roSGpI8B2Gv4nm8tahVXqs2FDfXaC
         IoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=c7B2XhPhx3hw3rI1jyHAq5icUgQsUc/Zl9RG/a09lWU=;
        b=Q0OSOvrdxITPmqG6EXlUglxwO27vc3q1Nf/SWCGnVyVx+m8C/LpIIpyp0e19Ma6s2W
         Ieh9CdK++IFSO6hqciewZyj4mgTwgAiXTkzM+PPQqAujAqBBEsqG10rzouxcBu0ivShx
         0Yw2coeYyFCCtjDbFQpg8Gei0+rfk7Jr/7Ry/2Vr+f5MOx9vVkZd83fqYmuKBtp7O4kN
         gAEBKyBIlqE4kEDubAR7HYzdgXBp+VhAMY0K2yQHrjkSWmux/wOIzCP4nW3OEJJz8vm/
         Ly8//iGZlo9kJkGn3ja2H49eqyIP02iZvOFChDxnE1mCZ2wTyiRqIwnvyNWFPK3T3P5Z
         vhbQ==
X-Gm-Message-State: APjAAAXBbuJnOLUITLOwpcAHcbP4uvDgJdCx2oJt8CQ6CUdeTPvMUyJM
        sKjabKxDTrmd5WJZlqpFXNPrAKd22a0=
X-Google-Smtp-Source: APXvYqyDtr3/mI8WaCLhbbyGrcrvxi5aP6EwNoJpuWTyLhp0wg6gLLHtgfdCINv+pbEw5AULmsPpIg==
X-Received: by 2002:a65:44cb:: with SMTP id g11mr4364459pgs.288.1562983763982;
        Fri, 12 Jul 2019 19:09:23 -0700 (PDT)
Received: from localhost.localdomain (76-14-106-55.rk.wavecable.com. [76.14.106.55])
        by smtp.gmail.com with ESMTPSA id x24sm669860pgl.84.2019.07.12.19.09.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 19:09:23 -0700 (PDT)
From:   Rosen Penev <rosenp@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 2/2] net-next: ag71xx: Rearrange ag711xx struct to remove holes
Date:   Fri, 12 Jul 2019 19:09:21 -0700
Message-Id: <20190713020921.18202-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190713020921.18202-1-rosenp@gmail.com>
References: <20190713020921.18202-1-rosenp@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed ____cacheline_aligned attribute to ring structs. This actually
causes holes in the ag71xx struc as well as lower performance.

Rearranged struct members to fall within respective cachelines. The RX
ring struct now does not share a cacheline with the TX ring. The NAPI
atruct now takes up its own cachelines and does not share.

According to pahole -C ag71xx -c 32

Before:

struct ag71xx {
	/* size: 384, cachelines: 12, members: 22 */
	/* sum members: 375, holes: 2, sum holes: 9 */

After:

struct ag71xx {
	/* size: 376, cachelines: 12, members: 22 */
	/* last cacheline: 24 bytes */

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 8f450a03a885..f19711984d34 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -295,16 +295,15 @@ struct ag71xx {
 	/* Critical data related to the per-packet data path are clustered
 	 * early in this structure to help improve the D-cache footprint.
 	 */
-	struct ag71xx_ring rx_ring ____cacheline_aligned;
-	struct ag71xx_ring tx_ring ____cacheline_aligned;
-
+	struct ag71xx_ring rx_ring;
 	u16 rx_buf_size;
-	u8 rx_buf_offset;
+	u16 rx_buf_offset;
+	u32 msg_enable;
+	struct ag71xx_ring tx_ring;
 
 	struct net_device *ndev;
 	struct platform_device *pdev;
 	struct napi_struct napi;
-	u32 msg_enable;
 	const struct ag71xx_dcfg *dcfg;
 
 	/* From this point onwards we're not looking at per-packet fields. */
@@ -313,20 +312,17 @@ struct ag71xx {
 	struct ag71xx_desc *stop_desc;
 	dma_addr_t stop_desc_dma;
 
-	int phy_if_mode;
-
-	struct delayed_work restart_work;
-	struct timer_list oom_timer;
-
-	struct reset_control *mac_reset;
-
 	u32 fifodata[3];
 	int mac_idx;
+	int phy_if_mode;
 
-	struct reset_control *mdio_reset;
 	struct mii_bus *mii_bus;
 	struct clk *clk_mdio;
 	struct clk *clk_eth;
+	struct reset_control *mdio_reset;
+	struct delayed_work restart_work;
+	struct timer_list oom_timer;
+	struct reset_control *mac_reset;
 };
 
 static int ag71xx_desc_empty(struct ag71xx_desc *desc)
-- 
2.17.1


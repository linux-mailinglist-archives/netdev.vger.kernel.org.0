Return-Path: <netdev+bounces-1436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCAE6FDC98
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F4F1C20D4B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66EFB8C10;
	Wed, 10 May 2023 11:23:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC5D20B4B
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:23:22 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA58C1B3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Bd7PajHz4MZbHz2uos8jHjkB5H7CWroHmo9oty9mSHg=; b=Ok1dUqQJD7xh55FxiVooX8njHQ
	N46SPlNor7QqzhSW/9sZ5+IGwj4ksmEiyZWzgLqM9nqJefiHP4Iy5ekfwXJ03Qx5/l2IXY0vyo8tu
	kZ0+Y3hnw47UCytGZlw1MooVgwry0ADJE7MOQQfTxKsiogIe7keh+nGb/oMMGFlDQcARwvJbMbJhh
	mb8uq3w80SxWB62APoEZghiTAAS3GK9weeXq0BKC1O1t31K9JmHBMC2Zx5XTwVmuK5xBfCFxUXqKT
	ca5vSO31CZ/LT2RPDaEYj8EG4XxOKP254mQfnDfKZEIt/N7htgYw4BPBOmrAg66DYWhaXfZ5IUF+J
	qMwFcB8g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47700 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwhuf-0004po-94; Wed, 10 May 2023 12:23:17 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwhue-001Xo4-K9; Wed, 10 May 2023 12:23:16 +0100
In-Reply-To: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH RFC net-next 1/7] net: sfp: add helper to modify signal states
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwhue-001Xo4-K9@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 12:23:16 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are a couple of locations in the code where we modify
sfp->state, and then call sfp_set_state(, sfp->state) to update
the outputs/soft state to control the module. Provide a helper
which takes a mask and new state so that this is encapsulated in
one location.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 89636dc71e48..c97a87393fdb 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -734,6 +734,12 @@ static void sfp_set_state(struct sfp *sfp, unsigned int state)
 		sfp_soft_set_state(sfp, state);
 }
 
+static void sfp_mod_state(struct sfp *sfp, unsigned int mask, unsigned int set)
+{
+	sfp->state = (sfp->state & ~mask) | set;
+	sfp_set_state(sfp, sfp->state);
+}
+
 static unsigned int sfp_check(void *buf, size_t len)
 {
 	u8 *p, check;
@@ -1537,16 +1543,14 @@ static void sfp_module_tx_disable(struct sfp *sfp)
 {
 	dev_dbg(sfp->dev, "tx disable %u -> %u\n",
 		sfp->state & SFP_F_TX_DISABLE ? 1 : 0, 1);
-	sfp->state |= SFP_F_TX_DISABLE;
-	sfp_set_state(sfp, sfp->state);
+	sfp_mod_state(sfp, SFP_F_TX_DISABLE, SFP_F_TX_DISABLE);
 }
 
 static void sfp_module_tx_enable(struct sfp *sfp)
 {
 	dev_dbg(sfp->dev, "tx disable %u -> %u\n",
 		sfp->state & SFP_F_TX_DISABLE ? 1 : 0, 0);
-	sfp->state &= ~SFP_F_TX_DISABLE;
-	sfp_set_state(sfp, sfp->state);
+	sfp_mod_state(sfp, SFP_F_TX_DISABLE, 0);
 }
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
-- 
2.30.2



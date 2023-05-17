Return-Path: <netdev+bounces-3272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BADA9706566
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F4628163F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4653A156C3;
	Wed, 17 May 2023 10:37:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FDB2CA6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:37:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029F73AA1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bFOA3EXkR9/6xPQNNwGnfHDGjSutcSAbzwUI/GipgLs=; b=FUq5YSCv0x1FHjnWXr9jKlOd5s
	HynIfRZJ7PNRQG0JfURB2X8TWIBIK3hjUKURzEzz0TitGDR8rR271tsntHrgteCwHqBHFTfzR7NZC
	wHjQ292vHLlw9Dn5Y1RW8UutBPtJ4bfb5f2VHEEzLeBiGPXxvrI2yLX7rQ/UIhrU9UAWMFQfXgNGx
	GHIWTMz7KQtAFOLmN/mhUNmBeceQKntQNNNyAYUIL4RK1/VhOUFOMWkWTzF1VP6m7uwil4tgsGMTm
	jvx+J/tvGuIkWvyayEoYIunbflAsnPzfE/bVjQJJ8S6qeLACsRzjIhWLhzJmQCkD3XwEygr+iHNKb
	yyKCVj5Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35088 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzEXT-0007Y8-St; Wed, 17 May 2023 11:37:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzEXT-005jUJ-94; Wed, 17 May 2023 11:37:47 +0100
In-Reply-To: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
References: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 1/7] net: sfp: add helper to modify signal states
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzEXT-005jUJ-94@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 11:37:47 +0100
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
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



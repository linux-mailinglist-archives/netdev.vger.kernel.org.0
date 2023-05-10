Return-Path: <netdev+bounces-1438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFCF6FDC9D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DA422813A8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09E78C16;
	Wed, 10 May 2023 11:23:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965B38C0A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:23:32 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807F210D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Yev/FGcvUCHug58x5B+sADXv7d8Glbd5WsOwE5C1nlE=; b=jgvcyEsjHBNSrqKGFqJhKMHwLB
	iBZTmuK+jIXgSdOHoMdQ6sliWVLSP+dUU+3Uoxic4KgugiBYZsJ4cGUToazaZPzJvsb5fiLskfZi6
	oMT6shUFGoTJpNy9EWQfv4FB6MY/Xs+SU5PmDVvGEFIUCZCvYTC37lVfCFhI9anMQaISvdxqGvtlw
	OSvmVGt2iRRYrLo0/AbvEMbFMPBLhj4sA26ddVPpkwUCYoEmTQRPMvlpelJyyFkN4AumfabWjyZrG
	AaZyjKU1g5I0PsLp/Th9KyFntwBlcREC6uEa9v8z+OOmMN+9oFQsGavM47NaQHWRpc08V3itzBo9E
	nnnn5HLQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43236 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwhup-0004qJ-JE; Wed, 10 May 2023 12:23:27 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwhuo-001XoI-Tl; Wed, 10 May 2023 12:23:26 +0100
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
Subject: [PATCH RFC net-next 3/7] net: sfp: swap order of rtnl and st_mutex
 locks
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwhuo-001XoI-Tl@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 12:23:26 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Swap the order of the rtnl and st_mutex locks - st_mutex is now nested
beneath rtnl lock instead of rtnl being beneath st_mutex. This will
allow us to hold st_mutex only while manipulating the module's hardware
or software control state.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 3fc703e4dd21..ffb6c37dac96 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2600,8 +2600,8 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
-	mutex_lock(&sfp->st_mutex);
 	rtnl_lock();
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	if (sfp->tx_fault_ignore)
@@ -2628,8 +2628,8 @@ static void sfp_check_state(struct sfp *sfp)
 	if (changed & SFP_F_LOS)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
-	rtnl_unlock();
 	mutex_unlock(&sfp->st_mutex);
+	rtnl_unlock();
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
-- 
2.30.2



Return-Path: <netdev+bounces-1437-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 173016FDC9B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5D6F2813B3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379BF8C1A;
	Wed, 10 May 2023 11:23:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0828C10
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:23:27 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AF01B3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=n7QzSXGc5XvR5IyFp5v6ZpmUudEkhaDNvOZipYSbKAU=; b=X1B7lZ1UFI7Q0yXwF63uIijwgF
	ILXckX2lvZ4iQyxkrJHtOLV7mn1jHRQMlluq5XYB5LJECT+gOE8SvPeICwbtsY5ocgktjrb5xP6AL
	6XK9ylZiYcLU8yoU3ry+7e7m8GYP6Y+jON9baYMJUs6z8Ro6TZQufrbV4Q7biuVqPRiAdxhRJJM0q
	ZwKxpG22jak/GylY/nBjxaqyPRipG8Y27hy7hE9pOdzU+I7eW/pVB8pZLlpk5FhNs2+qRuPc5iMoN
	GLmEMcWT9RmvhFR7OnbYZzrFEoq1vvn+WKZMCzq5LECN0pwD5oiTzhU8nkGPsIFo0XWBTZFRcfk3a
	jpRoQPow==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47710 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwhuk-0004q1-Eb; Wed, 10 May 2023 12:23:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwhuj-001XoA-Oe; Wed, 10 May 2023 12:23:21 +0100
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
Subject: [PATCH RFC net-next 2/7] net: sfp: move rtnl lock to cover reading
 state
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwhuj-001XoA-Oe@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 10 May 2023 12:23:21 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As preparation to moving st_mutex inside rtnl_lock, we need to first
move the rtnl lock to cover reading the state.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c97a87393fdb..3fc703e4dd21 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2601,6 +2601,7 @@ static void sfp_check_state(struct sfp *sfp)
 	unsigned int state, i, changed;
 
 	mutex_lock(&sfp->st_mutex);
+	rtnl_lock();
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	if (sfp->tx_fault_ignore)
@@ -2616,7 +2617,6 @@ static void sfp_check_state(struct sfp *sfp)
 	state |= sfp->state & (SFP_F_TX_DISABLE | SFP_F_RATE_SELECT);
 	sfp->state = state;
 
-	rtnl_lock();
 	if (changed & SFP_F_PRESENT)
 		sfp_sm_event(sfp, state & SFP_F_PRESENT ?
 				SFP_E_INSERT : SFP_E_REMOVE);
-- 
2.30.2



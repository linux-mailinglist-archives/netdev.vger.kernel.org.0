Return-Path: <netdev+bounces-3275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD01D70656D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 520D12815DA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA133168C9;
	Wed, 17 May 2023 10:38:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4BF156F8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:38:08 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8749740DE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hNpm6We+t2Q1lGo0VB0s+7r/ynTyQuMR1V5qmcSVkLY=; b=HtfiD2IY/2Pbwt9asdXNgQ1uDB
	L0Q2GH7iWUAAnnTCNMeUrcszi/WUatEkrUOTVDCurUojRUjRrunJC9Pa6uRhIDwkp7erlH3huof2j
	nDa3UBUQNNCWvtKxe0biR3WY/aBFDVbJq7y9duqET/K25z5ljg5ZXW43sDpr2BajJVkbnpnhpYwSr
	iEU1Scz/W/l+iuaLCZhRINJKbp0a6IZv04Mkqs1LyZOP7gvhZfMzqkasgFWDIRXhftdXgVHyVyY8i
	NxS0efI/IGrqCtHJ6PooBeb2y1pyh2UpNGZrpYmjFE10B7d3J/w9etsz5ZNqKJDwrv1WWJ2QggVlq
	uvS/SPCg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42774 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzEXj-0007Ym-8g; Wed, 17 May 2023 11:38:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzEXi-005jUc-Kc; Wed, 17 May 2023 11:38:02 +0100
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
Subject: [PATCH net-next 4/7] net: sfp: move sm_mutex into sfp_check_state()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzEXi-005jUc-Kc@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 11:38:02 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Provide an unlocked version of sfp_sm_event() which can be used by
sfp_check_state() to avoid having to keep re-taking the lock if
several signals have changed state.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ffb6c37dac96..e5cd36e3a421 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2456,10 +2456,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	}
 }
 
-static void sfp_sm_event(struct sfp *sfp, unsigned int event)
+static void __sfp_sm_event(struct sfp *sfp, unsigned int event)
 {
-	mutex_lock(&sfp->sm_mutex);
-
 	dev_dbg(sfp->dev, "SM: enter %s:%s:%s event %s\n",
 		mod_state_to_str(sfp->sm_mod_state),
 		dev_state_to_str(sfp->sm_dev_state),
@@ -2474,7 +2472,12 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 		mod_state_to_str(sfp->sm_mod_state),
 		dev_state_to_str(sfp->sm_dev_state),
 		sm_state_to_str(sfp->sm_state));
+}
 
+static void sfp_sm_event(struct sfp *sfp, unsigned int event)
+{
+	mutex_lock(&sfp->sm_mutex);
+	__sfp_sm_event(sfp, event);
 	mutex_unlock(&sfp->sm_mutex);
 }
 
@@ -2617,17 +2620,19 @@ static void sfp_check_state(struct sfp *sfp)
 	state |= sfp->state & (SFP_F_TX_DISABLE | SFP_F_RATE_SELECT);
 	sfp->state = state;
 
+	mutex_lock(&sfp->sm_mutex);
 	if (changed & SFP_F_PRESENT)
-		sfp_sm_event(sfp, state & SFP_F_PRESENT ?
-				SFP_E_INSERT : SFP_E_REMOVE);
+		__sfp_sm_event(sfp, state & SFP_F_PRESENT ?
+				    SFP_E_INSERT : SFP_E_REMOVE);
 
 	if (changed & SFP_F_TX_FAULT)
-		sfp_sm_event(sfp, state & SFP_F_TX_FAULT ?
-				SFP_E_TX_FAULT : SFP_E_TX_CLEAR);
+		__sfp_sm_event(sfp, state & SFP_F_TX_FAULT ?
+				    SFP_E_TX_FAULT : SFP_E_TX_CLEAR);
 
 	if (changed & SFP_F_LOS)
-		sfp_sm_event(sfp, state & SFP_F_LOS ?
-				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
+		__sfp_sm_event(sfp, state & SFP_F_LOS ?
+				    SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
+	mutex_unlock(&sfp->sm_mutex);
 	mutex_unlock(&sfp->st_mutex);
 	rtnl_unlock();
 }
-- 
2.30.2



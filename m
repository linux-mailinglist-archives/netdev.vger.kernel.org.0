Return-Path: <netdev+bounces-3273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDA7706567
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D1B62815D2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47D9156C3;
	Wed, 17 May 2023 10:37:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D18168A1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:37:59 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BA697
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sK9Zv/F/3N/Z+TuY/Z51i8V4sNSTy1qZYOSC6LTWCTk=; b=JgffTdyt1IHMyRwNvp1CHjEX6s
	M0JSMNOyfPAoUDrIF6nOTMIjnfHNF+FXVygLb+rNG/9EsggaH3iYa+3KPW7bWCkZ57m5QETr7DzEj
	TrrbqLYWwtzOqvhclfMBd9rtkWykX68BsMJBlXCzt3T4YYw9ppoqmXtaPmhKVVoiF5jfPHAg070MU
	uyUQbnHk0eKbnDV2PuHDtQvSZgJ62dxbnbirSHBXk/X8hS8Zj08SXujgbZd+7f6Z5oP9wgUJnsRw9
	4ShBLyJRa/mP154Th2Uq9RQw9fj1Wp5NJ+GXjQPXtmMGjBypgsqgLQTOzW961a6OuvDELy25vEtj7
	Eiu33O2Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35094 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzEXY-0007YL-Vs; Wed, 17 May 2023 11:37:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzEXY-005jUP-Cq; Wed, 17 May 2023 11:37:52 +0100
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
Subject: [PATCH net-next 2/7] net: sfp: move rtnl lock to cover reading state
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzEXY-005jUP-Cq@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 11:37:52 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As preparation to moving st_mutex inside rtnl_lock, we need to first
move the rtnl lock to cover reading the state.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
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



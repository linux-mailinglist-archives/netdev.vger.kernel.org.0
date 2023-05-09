Return-Path: <netdev+bounces-1147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C936FC560
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 491BD1C20B5D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BAA17AD9;
	Tue,  9 May 2023 11:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D9A3C02
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:50:22 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F6A421B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xh9s5IbynD8CooX/lu/DFiW8KIaZvoskAIpkKox8Mcw=; b=lf5PxGwCc+z7W4fQvJr5MUMIcd
	7yrLxxZzRAmjpsADDhGiqlCTOm7pizpX5PwZ+SkN6bzYAO5E3SF2nAJAYFzG6Er13STq4uw8mYUQj
	Idr69XrsAz6jb/5S0M5JPdVPkGT7SzeY+BpfPWgdPCwWJkHqIrbLJE6OJ/tleEIMJDxv1aERVWr6B
	THLg1nJ3pVW5pK5XpK3cSS2fVwPQx/gEfa59O8BFP9tboyMKl36vEREwSj54mMdpYOh1eHcWWwe1X
	BzgEXTv1dsBv0BFUO/jG9cWwJLlm7ycL6da7giztHRMTJTw52rgILITiuc4h8XqOWgrm1jBp6EiEr
	up1ziEag==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:50910 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pwLr2-00033h-Pu; Tue, 09 May 2023 12:50:04 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pwLr2-001Ms2-3d; Tue, 09 May 2023 12:50:04 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Voon Weifeng <weifeng.voon@intel.com>,
	netdev@vger.kernel.org
Subject: [PATCH net] net: pcs: xpcs: fix incorrect number of interfaces
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 09 May 2023 12:50:04 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In synopsys_xpcs_compat[], the DW_XPCS_2500BASEX entry was setting
the number of interfaces using the xpcs_2500basex_features array
rather than xpcs_2500basex_interfaces. This causes us to overflow
the array of interfaces. Fix this.

Fixes: f27abde3042a ("net: pcs: add 2500BASEX support for Intel mGbE controller")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 539cd43eae8d..f19d48c94fe0 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1203,7 +1203,7 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 	[DW_XPCS_2500BASEX] = {
 		.supported = xpcs_2500basex_features,
 		.interface = xpcs_2500basex_interfaces,
-		.num_interfaces = ARRAY_SIZE(xpcs_2500basex_features),
+		.num_interfaces = ARRAY_SIZE(xpcs_2500basex_interfaces),
 		.an_mode = DW_2500BASEX,
 	},
 };
-- 
2.30.2



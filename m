Return-Path: <netdev+bounces-8820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04FA9725DE7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5465281419
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CCC35B3C;
	Wed,  7 Jun 2023 11:59:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6633CAA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:59:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3C01BEC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CTbswC2wAt+WpcUwJOtfJtor9aQJUnA5Fs3Pr42utho=; b=kEBUe5Cer46bqRDHmjMc6oBrDv
	/368AWMDxG3d/+G9ztTyNryOgDjOjtI8VqHatXOdyFx6aXrjR97rpbI1o5G4r/ABOrQN0az3xEmPo
	qgrydJNibQfueL7xNsdAcwz0nPwjn5ye/ZaPCn7d9+4KXrQRjgnkwiCs9dXRtz3kbKsaiRxfhV7Hv
	eQN6PBuAHeUq+cwzFIA6p/NPN4WtD1ZQzCFRFsKGin93HyhBLJlLBjqj+PQ4i7YB0lZX/H6rouFFZ
	9zAlPb64LqTkCOZ4oTDoEIert+BQjlSsJYmGKVa/nO2s5IwvWP0JwqPqIN6GqKBQ54rCiKcmUjM73
	0aA2uhpQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44402 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6roV-0007Mx-9x; Wed, 07 Jun 2023 12:58:55 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6roU-00Cfau-NF; Wed, 07 Jun 2023 12:58:54 +0100
In-Reply-To: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
References: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 09/11] net: pcs: lynx: check that the fwnode is
 available prior to use
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q6roU-00Cfau-NF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:54 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Check that the fwnode is marked as available prior to trying to lookup
the PCS device, and return -ENODEV if unavailable. Document the return
codes from lynx_pcs_create_fwnode().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index c2d01da40430..fca48ebf0b81 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -6,6 +6,7 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 #include <linux/pcs-lynx.h>
+#include <linux/property.h>
 
 #define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
 #define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
@@ -346,11 +347,24 @@ struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
 }
 EXPORT_SYMBOL(lynx_pcs_create_mdiodev);
 
+/*
+ * lynx_pcs_create_fwnode() creates a lynx PCS instance from the fwnode
+ * device indicated by node.
+ *
+ * Returns:
+ *  -ENODEV if the fwnode is marked unavailable
+ *  -EPROBE_DEFER if we fail to find the device
+ *  -ENOMEM if we fail to allocate memory
+ *  pointer to a phylink_pcs on success
+ */
 struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node)
 {
 	struct mdio_device *mdio;
 	struct phylink_pcs *pcs;
 
+	if (!fwnode_device_is_available(node))
+		return ERR_PTR(-ENODEV);
+
 	mdio = fwnode_mdio_find_device(node);
 	if (!mdio)
 		return ERR_PTR(-EPROBE_DEFER);
-- 
2.30.2



Return-Path: <netdev+bounces-12090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 012D1735FBC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 00:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFE1C280F6F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67DB14AB9;
	Mon, 19 Jun 2023 22:03:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B716A522A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 22:03:47 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21256134
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Content-Disposition:In-Reply-To:References;
	bh=B7fya5iuzHJNJlfHdAfnE44G93SQ28RhHSzFlWqMHzc=; b=TdmSF02i2FKBcKum8/w8PjIGD8
	HyufLwVuj6+grWY7JWy+F2RoXb0nPtwvCPRlCV/9DVoff9DdlmT4NCoVI9ASE06kjGraQxBCTZH07
	P8dgaJZNgeZxvgxXIeIneLducoP/fGfse+I/r32lzVnShdHbmPNUWJ+JucRVRz1DgeCg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBMyN-00GwiC-Qk; Tue, 20 Jun 2023 00:03:43 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1] net: phy-c45: Fix genphy_c45_ethtool_set_eee description
Date: Tue, 20 Jun 2023 00:03:32 +0200
Message-Id: <20230619220332.4038924-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The text has been cut/paste from genphy_c45_ethtool_get_eee but not
changed to reflect it performs set.

Additionally, extend the comment. This function implements the logic
that eee_enabled has global control over EEE. When eee_enabled is
false, no link modes will be advertised, and as a result, the MAC
should not transmit LPI.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

Since v0:

Rework documentation as suggested by Russell King

drivers/net/phy/phy-c45.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index fee514b96ab1..93ed07223377 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -1425,12 +1425,15 @@ int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
 EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
 
 /**
- * genphy_c45_ethtool_set_eee - get EEE supported and status
+ * genphy_c45_ethtool_set_eee - set EEE supported and status
  * @phydev: target phy_device struct
  * @data: ethtool_eee data
  *
- * Description: it reportes the Supported/Advertisement/LP Advertisement
- * capabilities.
+ * Description: sets the Supported/Advertisement/LP Advertisement
+ * capabilities. If eee_enabled is false, no links modes are
+ * advertised, but the previously advertised link modes are
+ * retained. This allows EEE to be enabled/disabled in a
+ * non-destructive way.
  */
 int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data)
-- 
2.40.1



Return-Path: <netdev+bounces-9248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1887728435
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5283A1C20FEE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C6F16413;
	Thu,  8 Jun 2023 15:52:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B308115ADE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 15:52:03 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2A52D7B;
	Thu,  8 Jun 2023 08:51:40 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686239498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KipQ904kAoqGtS96BrNjtOhgVzKh/rdRo+o3pLuVLgA=;
	b=maFxXu50qWEyI66ivk9kQ1/bxq+RSHUWsYwUSJ8Sv9P/A1Al6Wetw8FWqdcQMlVo8WJcB9
	IJWGdcDgIv/Upj9cFAIOGWF0N2fENd+b3GJ/q6V42LJ22WNHwVkiAD3PJCyTjqUOiK50Dc
	vDDpUj9ZTtmOoISX2GfdDBQANOo3d+Cm9upLkC4QG0kVYcENsjjzfRlGkC5O4PeLmoXeGe
	jvarR/acOQJoMEdO00ynKx0kw/Kkw/LTpN1rUZ/fhmMSHCdlscUCc9gBivWar3W6Se9jf7
	becxnjJ+FA1HTJvNXrw1d2b6ECpuI2H3uOTLXvudXHF4IOciFB0YMZwasJ53IA==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6F4206000D;
	Thu,  8 Jun 2023 15:51:36 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Horatiu.Vultur@microchip.com,
	Allan.Nielsen@microchip.com,
	UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 0/2] fixes for Q-USGMII speeds and autoneg 
Date: Thu,  8 Jun 2023 18:34:12 +0200
Message-Id: <20230608163415.511762-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As reported here [1], there are some inconsistencies for the Q-USGMII
mode speeds and configuration. The first patch in this fixup series
makes so that we correctly report the max speed of 1Gbps for this mode.

The second patch uses a dedicated helper to decode the control word.
This is necessary as although USGMII control words are close to USXGMII,
they don't support the same speeds.

Thanks,

Maxime

[1] : https://lore.kernel.org/netdev/ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk/

Maxime Chevallier (2):
  net: phylink: report correct max speed for QUSGMII
  net: phylink: use a dedicated helper to parse usgmii control word

 drivers/net/phy/phylink.c | 41 +++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/mdio.h |  3 +++
 2 files changed, 42 insertions(+), 2 deletions(-)

-- 
2.40.1



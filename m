Return-Path: <netdev+bounces-5546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB0571212E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 997232816B8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8427AD2F;
	Fri, 26 May 2023 07:35:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB65AD2B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:35:40 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE373E58
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:35:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2RyL-0005lc-Dw; Fri, 26 May 2023 09:34:49 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q2RyJ-002u6s-Ar; Fri, 26 May 2023 09:34:47 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q2RyI-002ntb-5y; Fri, 26 May 2023 09:34:46 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: [PATCH net-next v2 0/5] Microchip DSA Driver Improvements
Date: Fri, 26 May 2023 09:34:40 +0200
Message-Id: <20230526073445.668430-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

changes v2:
- set .max_register = U8_MAX, it should be more readable
- clarify in the RMW error handling patch, logging behavior
  expectation.

I'd like to share a set of patches for the Microchip DSA driver. These
patches were chosen from a bigger set because they are simpler and
should be easier to review. The goal is to make the code easier to read,
get rid of unused code, and handle errors better.

Oleksij Rempel (4):
  net: dsa: microchip: improving error handling for 8-bit register RMW
    operations
  net: dsa: microchip: remove ksz_port:on variable
  net: dsa: microchip: ksz8: Prepare ksz8863_smi for regmap register
    access validation
  net: dsa: microchip: Add register access control for KSZ8873 chip

Vladimir Oltean (1):
  net: dsa: microchip: add an enum for regmap widths

 drivers/net/dsa/microchip/ksz8795.c      | 28 ++-------
 drivers/net/dsa/microchip/ksz8863_smi.c  | 13 +++-
 drivers/net/dsa/microchip/ksz9477.c      | 24 ++++----
 drivers/net/dsa/microchip/ksz9477_i2c.c  |  2 +-
 drivers/net/dsa/microchip/ksz_common.c   | 47 ++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   | 77 +++++++++++++++++-------
 drivers/net/dsa/microchip/ksz_spi.c      |  2 +-
 drivers/net/dsa/microchip/lan937x_main.c |  8 +--
 8 files changed, 135 insertions(+), 66 deletions(-)

-- 
2.39.2



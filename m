Return-Path: <netdev+bounces-3897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E30D770977D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A042B281CCD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C3EC2EB;
	Fri, 19 May 2023 12:47:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D45A7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 12:47:24 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F20812B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 05:47:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzzVg-0007wW-B7; Fri, 19 May 2023 14:47:04 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1pzzVe-001Jbg-H0; Fri, 19 May 2023 14:47:02 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1pzzVd-002fD3-F2; Fri, 19 May 2023 14:47:01 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v4 0/2] Fine-Tune Flow Control and Speed Configurations in Microchip KSZ8xxx DSA Driver
Date: Fri, 19 May 2023 14:46:58 +0200
Message-Id: <20230519124700.635041-1-o.rempel@pengutronix.de>
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

change v4:
- instead of downstream/upstream use CPU-port and PHY-port
- adjust comments
- minor fixes

changes v3:
- remove half duplex flow control configuration
- add comments
- s/stram/stream

changes v2:
- split the patch to upstream and downstream part
- add comments
- fix downstream register offset
- fix CPU configuration

This patch set focuses on enhancing the configurability of flow
control, speed, and duplex settings in the Microchip KSZ8xxx DSA driver.

The first patch allows more granular control over the CPU port's flow
control, speed, and duplex settings. The second patch introduces a
method for port configurations for port with integrated PHYs, primarily
concerning flow control based on duplex mode.

Oleksij Rempel (2):
  net: dsa: microchip: ksz8: Make flow control, speed, and duplex on CPU
    port configurable
  net: dsa: microchip: ksz8: Add function to configure ports with
    integrated PHYs

 drivers/net/dsa/microchip/ksz8.h       |   4 +
 drivers/net/dsa/microchip/ksz8795.c    | 132 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.c |   1 +
 3 files changed, 135 insertions(+), 2 deletions(-)

-- 
2.39.2



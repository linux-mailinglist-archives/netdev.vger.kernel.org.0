Return-Path: <netdev+bounces-2440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B4B701F6B
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 024A91C209B0
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F92BA3E;
	Sun, 14 May 2023 20:11:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAFEA93F
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:11:22 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86F61B5;
	Sun, 14 May 2023 13:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684095081; x=1715631081;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0v693RssdllD+u0hi8Qnrc42nWVUr677WOVyW0Gpybc=;
  b=09ywQmsc2eZZXZ5URGVWr6pyMc0lkcRhgXULb1ILsbn067gklyQtmgvH
   YAdVDwZKHMXpxEyyrKyeVlzKQGSsHGmS7rGvbPyrwXlc6YK0DEwqlMk7i
   QYSM5BNnRAAuVUi+zPdXWIf/Y5X+KqRgphp4L5bpTR8b4Dl5R6LQ7uvpd
   kMwu7ZHAazgEDNpSyTNEFKYM4NE2QmwZ5HW/m5S5f+lgpDlPOr5c0tgHd
   +ymSdeG/spbgSG3X8NvgycgGXkpAv3W+P6N8+/ENxuhdqEhvGmJubjykk
   SPOymlKqYF96ytLDe3II9o8vcW4k1IvgkJbscTWVyqQHXesO0KamaeumS
   g==;
X-IronPort-AV: E=Sophos;i="5.99,274,1677567600"; 
   d="scan'208";a="211196321"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 May 2023 13:11:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 14 May 2023 13:11:19 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 14 May 2023 13:11:17 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/7] net: lan966x: Add support for PCP, DEI, DSCP
Date: Sun, 14 May 2023 22:10:22 +0200
Message-ID: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch series extends lan966x to offload to the hardware the
following features:
- PCP: this configuration is per port both at ingress and egress.
- App trust: which allows to specify a trust order of app selectors.
  This can be PCP or DSCP or DSCP/PCP.
- default priority
- DSCP: this configuration is shared between the ports both at ingress
  and egress.

Horatiu Vultur (7):
  net: lan966x: Add registers to configure PCP, DEI, DSCP
  net: lan966x: Add support for offloading pcp table
  net: lan966x: Add support for apptrust
  net: lan966x: Add support for offloading dscp table
  net: lan966x: Add support for offloading default prio
  net: lan966x: Add support for PCP rewrite
  net: lan966x: Add support for DSCP rewrite

 .../net/ethernet/microchip/lan966x/Kconfig    |  11 +
 .../net/ethernet/microchip/lan966x/Makefile   |   1 +
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 366 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  57 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 149 +++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 132 +++++++
 7 files changed, 718 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c

-- 
2.38.0



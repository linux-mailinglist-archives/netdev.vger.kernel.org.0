Return-Path: <netdev+bounces-3111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7FB70586B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04429281216
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A13A24E91;
	Tue, 16 May 2023 20:14:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F252290FE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:14:20 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D003A9D;
	Tue, 16 May 2023 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684268059; x=1715804059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ewWoc+jUbqxV0xdr2Z+8Ttcyp13vnOvEcRhcwJ0pdCA=;
  b=bjN2+7BJRIAkdPV5RTQMOiPQOUrcs4AhIlICXs1xZWkGXvH6mUOKERJt
   PcNY8dEIaTQ18mpYIv/U4uv36o3/hj7y9WQpN+66DO2cKzViSvlMOdOpr
   gjgnGKZlxNyfHhbKKrQ45dp+3qE93l7jK0h8rJsmqRCAm5oCXYmYA8KpN
   FNNzn1ID18n78XY0ZTy8SQmAXK9w3TRYRR8BbS3YCbw3PrwjszxWzoA9i
   8WEEs95MtGOrm/w3zVYoMmNL8vXBDYh4KyACGLIvx6ryEdlOtfiZYCWqt
   7gBl58H/UinWIdvSlrEXbGqjvWH2BGU3PISMRpDK3nxbMZtcZBxTBF9ug
   w==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="211596910"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 13:14:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 13:14:16 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 16 May 2023 13:14:14 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
	<daniel.machon@microchip.com>, <piotr.raczynski@intel.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/7] net: lan966x: Add support for PCP, DEI, DSCP
Date: Tue, 16 May 2023 22:14:01 +0200
Message-ID: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

v1->v2:
- fix whitespace between app_itr and .priority in patch 2
- simplify function lan966x_dcb_ieee_setapp by removing goto and use
  returns instead
- remove check against 0

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
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 365 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  57 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 149 +++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 132 +++++++
 7 files changed, 717 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c

-- 
2.38.0



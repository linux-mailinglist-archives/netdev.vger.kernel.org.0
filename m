Return-Path: <netdev+bounces-1054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A02A96FC063
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C94601C20AF1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6919E5685;
	Tue,  9 May 2023 07:26:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A9E20FA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:26:59 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0293210D;
	Tue,  9 May 2023 00:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683617217; x=1715153217;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EiWcDGm9kPTUoT7mNpIWmxyZdUu0f+7L9LoX1d8HUhY=;
  b=CuCPVV+TIU227X6z6xNZ7BE0G+/7bGHWpErZX8t9uJXgyM/LP+/ykW77
   dO7WRi2uKMIUooBFRvyJyCFtAaGSXtucvVOLCyBvgSNuAeVeSD3dWYRbE
   ah7H5F19JaROTFcmWlt5EOfQ6NMHTwLCRis/VcC1n9zMPNBjXYYqd6Buj
   IJ+sMoQ56c1g9Ve+UrzM6kvE9QZvnBhU9kdFQuXY/00zHhgBUspUdioJG
   j5bSXeeyNs6sOEu6q0R5Hu98cN/Y28yLbGdI+wV7AyTPMdOPEek/MVSQA
   DozZc9TOVnC1R1ptJjT1CYr6rQMTeuCJyf/PGn7f1Tat0bTz+lD7IQQV8
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,261,1677567600"; 
   d="scan'208";a="212523827"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 00:26:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 00:26:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 9 May 2023 00:26:51 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lars.povlsen@microchip.com>,
	<Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
	<UNGLinuxDriver@microchip.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/3] net: lan966x: Add support for ES0 VCAP
Date: Tue, 9 May 2023 09:26:42 +0200
Message-ID: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
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

Provide the Egress Stage 0 (ES0) VCAP (Versatile Content-Aware
Processor) support for the lan966x platform.

The ES0 VCAP has only 1 lookup which is accessible with a TC chain
id 10000000.

Currently only one action is support which is vlan pop. Also it is
possible to link the IS1 to ES0 using 'goto chain 10000000'.

Horatiu Vultur (3):
  net: lan966x: Add ES0 VCAP model
  net: lan966x: Add ES0 VCAP keyset configuration for lan966x
  net: lan966x: Add TC support for ES0 VCAP

 .../ethernet/microchip/lan966x/lan966x_main.h |   3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h |  15 +
 .../microchip/lan966x/lan966x_tc_flower.c     |  61 ++++
 .../microchip/lan966x/lan966x_vcap_ag_api.c   | 264 +++++++++++++++++-
 .../microchip/lan966x/lan966x_vcap_debugfs.c  |  23 ++
 .../microchip/lan966x/lan966x_vcap_impl.c     |  82 ++++++
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  67 +++--
 7 files changed, 485 insertions(+), 30 deletions(-)

-- 
2.38.0



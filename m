Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB4612D07
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 22:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJ3VcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 17:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJ3Vb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 17:31:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8BBB1DE;
        Sun, 30 Oct 2022 14:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667165518; x=1698701518;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yF+CHeWI4UiDbUU7IwMxj8YjpjdcFZ5iBSnZRE+nm6s=;
  b=CWel5ZVUj7ZgFJtNu+6hGkzS+vLl6iPeeQiUaFT59M3C5DS+9nuRBsL4
   m2HJUMcQo2cFwn8hjEWLTzGbOrqLgq7YQ+ahU79MdeUCIOUYjPkmCeeh2
   YfeNpgWaj9y8T9QLZ9fJAve5U7E3kCdLC9j5pE0QC43Q+0sVNeujNFZOn
   Tzl+FEnCr41p3ySL912gz8lr6HTsrulYds/1COsPUM9cGgUFSbgAAC948
   e3CUZLTVnFdM8j3IpEAzjtfTHG+NcmVBdRu+TOf7F80Wax6YkchriAb1D
   0PWKUzD62Lui5iN1Mtc5cGhNbdMFxK5bE2wkfRWbl3MTZ92iLlEyHOBN1
   A==;
X-IronPort-AV: E=Sophos;i="5.95,226,1661842800"; 
   d="scan'208";a="186969027"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2022 14:31:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 30 Oct 2022 14:31:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 30 Oct 2022 14:31:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
Date:   Sun, 30 Oct 2022 22:36:33 +0100
Message-ID: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were multiple problems in different parts of the driver when
the MTU was changed.
The first problem was that the HW was missing to configure the correct
value, it was missing ETH_HLEN and ETH_FCS_LEN. The second problem was
when vlan filtering was enabled/disabled, the MRU was not adjusted
corretly. While the last issue was that the FDMA was calculated wrongly
the correct maximum MTU.

v1->v2:
- when calculating max frame possible to receive add also the vlan tags
  length

Horatiu Vultur (3):
  net: lan966x: Fix the MTU calculation
  net: lan966x: Adjust maximum frame size when vlan is enabled/disabled
  net: lan966x: Fix FDMA when MTU is changed

 .../net/ethernet/microchip/lan966x/lan966x_fdma.c |  8 ++++++--
 .../net/ethernet/microchip/lan966x/lan966x_main.c |  4 ++--
 .../net/ethernet/microchip/lan966x/lan966x_main.h |  2 ++
 .../net/ethernet/microchip/lan966x/lan966x_regs.h | 15 +++++++++++++++
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c |  6 ++++++
 5 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.38.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6E54DE2B9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbiCRUqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiCRUqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:46:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756492F24C6;
        Fri, 18 Mar 2022 13:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647636321; x=1679172321;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LMJP/2acd+OFXBjHMXwfo/UcaXhYkEkbzfNtUF8RVbk=;
  b=zRcIlgsc8C6mrPr3gMp3O37o1opGh5a/iW8C+5EFgIlHb5I7BSIAp9Wh
   drCV8DA+Jd+O+y71SeP/ppNpVLgOUyqbkS8xt+WVv1+CROh6IIK549ehl
   ARi8rPes1KItvb/mowdbEBaL8AleIzQZnv3tPpldx9IFifca7AzYRxyG7
   5OPNzEhR0InOrr1QpyjpWeN9i/DEDSlDBUb7CxfzoRtpg5VXI6bbLKHwn
   r82EvCuHkLVbfjS+FoujiRiPxBMVFXt9CM4JB37IeY2Ptqc2GtAqZMJOj
   /sWmWCZZAgMv1tnOazWjftTw2hqkG8v9zUIyT9UusB7Dq2BqW694TeZ3d
   w==;
X-IronPort-AV: E=Sophos;i="5.90,192,1643698800"; 
   d="scan'208";a="156976381"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 13:45:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 13:45:18 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Mar 2022 13:45:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/4] net: lan966x: Add support for FDMA
Date:   Fri, 18 Mar 2022 21:47:46 +0100
Message-ID: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when injecting or extracting a frame from CPU, the frame
is given to the HW each word at a time. There is another way to
inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
In this way the entire frame is given to the HW. This improves both
RX and TX bitrate.

v1->v2:
- fix typo in commit message in last patch
- remove first patch as the changes are already there
- make sure that there is space in skb to put the FCS
- move skb_tx_timestamp closer to the handover of the frame to the HW

Horatiu Vultur (4):
  net: lan966x: Add registers that are used for FDMA.
  net: lan966x: Expose functions that are needed by FDMA
  net: lan966x: Add FDMA functionality
  net: lan966x: Update FDMA to change MTU.

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 775 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  44 +-
 .../ethernet/microchip/lan966x/lan966x_main.h | 120 +++
 .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 106 +++
 6 files changed, 1038 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

-- 
2.33.0


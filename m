Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939A66E4A92
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjDQOB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjDQOBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:01:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D09159F4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681740059; x=1713276059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N5Xa2Hq2raagdRRPOPeqv8q1O6rblKIhUB+rM/HkJCs=;
  b=vTR1L8sllaA1R9ooloi5em+v2Vxz18UbNwKBOKFYR6xW8rUbSLvqIMX3
   d3qRs4+6qqsKaR+/cQ3N+JcWkOdY1kPpkAN/h7W1QRvlTgN0C+blBa4gd
   9b93c9AYs9F7FTrceBF/6O1fqg1DOspwtbLrj3kAseFww5MmUSXoSMd46
   quld+XKWpoSSFHDC9u/mffTIn/cO9KvywctNYAbIQoM5ziZGp5G65BOQn
   9+qRBuRL0PIPOTOUsuYmN4cH0W25FAQMETq70OaKUwbAv6Ct/pEdOVLft
   KWCnH6TeDHOnimFIhGCnmpMgYP0Zllz+qdDENgzycpQ+eBW/kdWVsWBPl
   w==;
X-IronPort-AV: E=Sophos;i="5.99,204,1677567600"; 
   d="scan'208";a="206859062"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2023 07:00:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Apr 2023 07:00:52 -0700
Received: from daire-X570.emdalo.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Mon, 17 Apr 2023 07:00:50 -0700
From:   <daire.mcnamara@microchip.com>
To:     <nicholas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <conor.dooley@microchip.com>
CC:     Daire McNamara <daire.mcnamara@microchip.com>
Subject: [PATCH v2 0/1] Adjust macb max_tx_len for mpfs
Date:   Mon, 17 Apr 2023 15:00:40 +0100
Message-ID: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daire McNamara <daire.mcnamara@microchip.com>

Several customers have reported unexpected ethernet issues whereby
the GEM stops transmitting and receiving. Performing an action such
as ifconfig <ethX> down; ifconfig <ethX> up clears this particular
condition.

The origin of the issue is a stream of AMBA_ERRORS (bit 6) from the
tx queues.

This patch sets the max_tx_length to SRAM size (16 KiB
in the case of mpfs) divided by num_queues (4 in the case of mpfs)
and then subtracts 56 bytes from that figure - resulting in max_tx_len
of 4040.  The max jumbo length is also set to 4040.  These figures
are derived from Cadence erratum 1686.

Change from v1
- Switched from using macb_is_gem() to hw_is_gem() as macb_is_gem()
  relies on capabilities being read and these have not been ascertained
  at this point of the probe routine.

Daire McNamara (1):
  net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs

 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.25.1


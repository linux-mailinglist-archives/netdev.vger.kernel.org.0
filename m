Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB0A6E13D9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 20:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDMSDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 14:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMSDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 14:03:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983A919AD
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681409026; x=1712945026;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=paGZhgNENs8ChKU87qCiqdODNqxb5LjMSzSf/rSx/mo=;
  b=E24shiEzQvSnXw6z1oK0uMgXQusHGzJjuNQTYcB3Dw9OFfTmpxmX60qG
   uPra2GE3AuffuU9WHH394c5e7uA+oRvhDyxmiKqR2tth5WH73j4jkv3na
   0AwyElD7MGXPqdK7hi51I+XeF8POyWhZYDe0I+2hYsF4EZPPZ1xNsrjQZ
   Ad6kOkH4EjpsZHkMf295Fco7jTxOgaf3vMmeTQoUZ1CMRKoAtY27iCgdw
   Fb+xxe+GlEOADCvJwOjvzGL7ZC1tWnws9Qh/kVjIWXVXQcFgeIyJt0CZR
   mUyew37JoubFe46sgM6aMWj3nYUkYeQ4i2P3USuNoihSktqo7YG2q6Oxr
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,194,1677567600"; 
   d="scan'208";a="210327671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2023 11:03:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 13 Apr 2023 11:03:42 -0700
Received: from daire-X570.emdalo.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 13 Apr 2023 11:03:40 -0700
From:   <daire.mcnamara@microchip.com>
To:     <nicholas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <conor.dooley@microchip.com>
CC:     Daire McNamara <daire.mcnamara@microchip.com>
Subject: [PATCH v1 0/1] Adjust macb max_tx_len for mpfs
Date:   Thu, 13 Apr 2023 19:03:36 +0100
Message-ID: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Daire McNamara (1):
  net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs

 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)


base-commit: 7a124d3a4a346563967b8887882858e5ef46f030
prerequisite-patch-id: 08908afdfe3b919f92560dd4306178c5f3f588dd
-- 
2.25.1


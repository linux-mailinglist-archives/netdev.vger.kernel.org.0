Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402316589EC
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiL2HaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiL2HaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:30:20 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EA2F58B
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 23:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672299019; x=1703835019;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q12J5SE+XFS5BhzAquuNtQB2SViSlKOmJrT1QkazAwI=;
  b=b6vJol9R7p8OU/w/MAnZxPb6RT4Jwi9dqUN6EDRj0h47TwCTvhs0ZTRH
   iLZpr6uJlRz6EwiM8WrbEykr2DE7vom9JACF/bbjlW3jhOX+GR9qSGrle
   J7siw1CFp24sAu6kAUB7G578mR/dISJiNIbp3Ie4tqZZOXG3UM7phfBVM
   0=;
X-IronPort-AV: E=Sophos;i="5.96,283,1665446400"; 
   d="scan'208";a="283448118"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 07:30:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 148B0819BC;
        Thu, 29 Dec 2022 07:30:16 +0000 (UTC)
Received: from EX19D002UWA003.ant.amazon.com (10.13.138.235) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 29 Dec 2022 07:30:15 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA003.ant.amazon.com (10.13.138.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 29 Dec 2022 07:30:15 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 29 Dec 2022 07:30:13
 +0000
From:   <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net 0/7] ENA driver bug fixes
Date:   Thu, 29 Dec 2022 07:30:04 +0000
Message-ID: <20221229073011.19687-1-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

ENA driver bug fixes

David Arinzon (7):
  net: ena: Fix toeplitz initial hash value
  net: ena: Don't register memory info on XDP exchange
  net: ena: Account for the number of processed bytes in XDP
  net: ena: Use bitmask to indicate packet redirection
  net: ena: Fix rx_copybreak value update
  net: ena: Set default value for RX interrupt moderation
  net: ena: Update NUMA TPH hint register upon NUMA node update

 drivers/net/ethernet/amazon/ena/ena_com.c     | 29 ++-----
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 83 ++++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 17 +++-
 4 files changed, 85 insertions(+), 50 deletions(-)

-- 
2.38.1


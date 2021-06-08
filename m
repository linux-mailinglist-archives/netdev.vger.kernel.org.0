Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050BE39FB9A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhFHQDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:03:50 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:28214 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhFHQDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168116; x=1654704116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cPbsK4lKOVkLyyWBxpkXAx2UOF7CjrRWdNpsIp3GDxY=;
  b=rtkqXbDBrTvA6HD4cHig6J1WHjBdMmxC/PekZZ3g72RKS8DxidqIfXiI
   LmOQZnZeQraukNyX6u2yvkbbzK4VYpce9w3cbtexHxlbdfi3pqNRE7ZWH
   uQEUPDGHvZZ8NxHz43PdBZsYQNSwCsuGbtOF43yfTwZ+czBYMVRE28Fh3
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="937232851"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 08 Jun 2021 16:01:48 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 76A51A1FF6;
        Tue,  8 Jun 2021 16:01:47 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.147) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:01:39 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net-next 00/10] Use build_skb and reorganize some code in ENA
Date:   Tue, 8 Jun 2021 19:01:08 +0300
Message-ID: <20210608160118.3767932-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13D24UWA004.ant.amazon.com (10.43.160.233) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
this patchset introduces several changes:

- Use build_skb() on RX side.
  This allows to ensure that the headers are in the linear part

- Batch some code into functions and remove some of the code to make it more
  readable and less error prone

- Fix RST format and outdated description in ENA documentation

- Improve cache alignment in the code

Please review

Shay Agroskin (10):
  net: ena: optimize data access in fast-path code
  net: ena: Remove unused code
  net: ena: Improve error logging in driver
  net: ena: use build_skb() in RX path
  net: ena: add jiffies of last napi call to stats
  net: ena: Remove module param and change message severity
  net: ena: fix RST format in ENA documentation file
  net: ena: aggregate doorbell common operations into a function
  net: ena: Use dev_alloc() in RX buffer allocation
  net: ena: re-organize code to improve readability

 .../device_drivers/ethernet/amazon/ena.rst    | 164 +++++++------
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |   2 -
 drivers/net/ethernet/amazon/ena/ena_com.c     |   3 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  30 ++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  18 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 216 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  23 +-
 7 files changed, 249 insertions(+), 207 deletions(-)

-- 
2.25.1


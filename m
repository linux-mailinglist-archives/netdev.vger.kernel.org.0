Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B79E2D31A8
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgLHSDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:03:42 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46143 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgLHSDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450622; x=1638986622;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6+wdS0lXDwjhOcAGVfFnvCexoNX6iZXaPAm6agab0/o=;
  b=oQxdmjVaZ3vdZdHHmLoDNzmp6p4zsEnhQ6TyFtyOB7N+Wkno8tyQGhwu
   8SwOJycnKpN/xXEvyUNod2Lwc6OhTetc1dxgO9gYDQcQAkkaF+xjT8G+O
   mFpOy3JaXs/qCfVV14Sz36C/Fgz9exnFxwwuLHfLV374S1flUf0z1eRPh
   E=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="71301413"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 08 Dec 2020 18:02:55 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 1CF682233F7;
        Tue,  8 Dec 2020 18:02:54 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.211) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:02:45 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        David Woodhouse <dwmw@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Bshara Saeed <saeedb@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Nafea Bshara <nafea@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Netanel Belgazal <netanel@amazon.com>,
        Ali Saidi <alisaidi@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Samih Jubran <sameehj@amazon.com>,
        Noam Dagan <ndagan@amazon.com>
Subject: [PATCH net-next v5 0/9] XDP Redirect implementation for ENA driver
Date:   Tue, 8 Dec 2020 20:01:59 +0200
Message-ID: <20201208180208.26111-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
ENA is adding XDP Redirect support for its driver and some other
small tweaks.

This series adds the following:

- Make log messages in the driver have a uniform format using
  netdev_* function
- Improve code readability
- Add support for XDP Redirect

v1->v2: Removed the word "atomic" from the name of
	ena_increase_stat_atomic() as it is misleading.

v2->v3: Fixed checkpatch errors

v3->v4: Added an explanation to the decision of using netdev_* prints in
	functions that are also called before netdev is registered.

v4->v5: Added return value check for xdp_do_redirect() and
	xdp_convert_buff_to_frame(). Also replace the variable casting
	in patch 3 with something more readable.

Shay Agroskin (9):
  net: ena: use constant value for net_device allocation
  net: ena: add device distinct log prefix to files
  net: ena: store values in their appropriate variables types
  net: ena: fix coding style nits
  net: ena: aggregate stats increase into a function
  net: ena: use xdp_frame in XDP TX flow
  net: ena: introduce XDP redirect implementation
  net: ena: use xdp_return_frame() to free xdp frames
  net: ena: introduce ndo_xdp_xmit() function for XDP_REDIRECT

 drivers/net/ethernet/amazon/ena/ena_com.c     | 391 ++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  23 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  71 +--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  23 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 403 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  12 +-
 7 files changed, 551 insertions(+), 375 deletions(-)

-- 
2.17.1


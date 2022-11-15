Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF74562A449
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiKOVkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiKOVkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:40:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0075FC0;
        Tue, 15 Nov 2022 13:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668548422; x=1700084422;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kwDjaYV376eo+k6PnCx6gQO5TgRlJXK0NEAZ3XOfsgo=;
  b=ylteita//j1FXdoaHsWm/uGpI40PTSgJoFyTs9efSJeHykrxJbXo6VSa
   HqHhpF9+SfmdCHdzbjyc/iFCAcNdx+RNskmN6Hc42tqpD113NAaawnZif
   zG3OZbmZrMZoaHlT7R0FKMzKbe+waXSzaN8GGIS5gQdvRdBkcU6b4nD6G
   iUty33i+2cGZMhC3tNKsm0pBNz3vGTSuaddtJcqkt5qD8sPk3++ssZfum
   4TsJ4vrvzg8DPRNiLvYTfM98rpmqgR9ja7TavYI7zl9JGBRIbzK8HZjcc
   Lqupxuga6NZfeKdAvPGjk56HdroMJ5y1B82ndXOiQs3GbwLJrny+kon3G
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="189162886"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2022 14:40:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 15 Nov 2022 14:40:21 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 15 Nov 2022 14:40:18 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/5] net: lan966x: Extend xdp support
Date:   Tue, 15 Nov 2022 22:44:51 +0100
Message-ID: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the current support of XDP in lan966x with the action XDP_TX and
XDP_REDIRECT.
The first patch introduced a headroom for all the received frames. This
is needed when the XDP_TX and XDP_REDIRECT is added.
The next 2 patches, just introduced some helper functions that can be
reused when is needed to transmit back the frame.
The last 2 patches introduce the XDP actions XDP_TX and XDP_REDIRECT.

v1->v2:
- use skb_reserve of using skb_put and skb_pull
- make sure that data_len doesn't include XDP_PACKET_HEADROOM

Horatiu Vultur (5):
  net: lan966x: Add XDP_PACKET_HEADROOM
  net: lan966x: Introduce helper functions
  net: lan966x: Add len field to lan966x_tx_dcb_buf
  net: lan966x: Add support for XDP_TX
  net: lan966x: Add support for XDP_REDIRECT

 .../ethernet/microchip/lan966x/lan966x_fdma.c | 177 ++++++++++++++----
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  15 ++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  39 +++-
 4 files changed, 195 insertions(+), 41 deletions(-)

-- 
2.38.0


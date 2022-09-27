Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773D35ECD6C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiI0T7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiI0T6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:55 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B665F372A;
        Tue, 27 Sep 2022 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q0bSnmkVYfhr1GAU9MS1lz7YWt0x6Xo7B/xrBdyZ/SE=; b=ijx71oq78ZNUaGhJZYbNq9N0EK
        nSvNNvLzl4rbSkYT13DZI9LUhdQ1oNtQqGzC+K2ZUoJojFytIGs1Gsa+Pss0+0CAnn3w/5lTcbGbX
        nTQduJRlj5k1/2lPYmo6hE2NvDrG4X1VHWaf2ZIHJBtKB3HENvABBg6mFrumhLvEW4NU=;
Received: from [88.117.54.199] (helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGj7-0005u7-BP; Tue, 27 Sep 2022 21:58:45 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 0/6] tsnep: multi queue support and some other improvements
Date:   Tue, 27 Sep 2022 21:58:36 +0200
Message-Id: <20220927195842.44641-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for additional TX/RX queues along with RX flow classification
support.

Binding is extended to allow additional interrupts for additional TX/RX
queues. Also dma-coherent is allowed as minor improvement.

RX path optimisation is done by using page pool as preparations for future
XDP support.

v4:
- rework dma-coherent commit message (Krzysztof Kozlowski)
- fixed order of interrupt-names in binding (Krzysztof Kozlowski)
- add line break between examples in binding (Krzysztof Kozlowski)
- add RX_CLS_LOC_ANY support to RX flow classification

v3:
- now with changes in cover letter

v2:
- use netdev_name() (Jakub Kicinski)
- use ENOENT if RX flow rule is not found (Jakub Kicinski)
- eliminate return code of tsnep_add_rule() (Jakub Kicinski)
- remove commit with lazy refill due to depletion problem (Jakub Kicinski)

Gerhard Engleder (6):
  dt-bindings: net: tsnep: Allow dma-coherent
  dt-bindings: net: tsnep: Allow additional interrupts
  tsnep: Move interrupt from device to queue
  tsnep: Support multiple TX/RX queue pairs
  tsnep: Add EtherType RX flow classification support
  tsnep: Use page pool for RX

 .../bindings/net/engleder,tsnep.yaml          |  43 ++-
 drivers/net/ethernet/engleder/Kconfig         |   1 +
 drivers/net/ethernet/engleder/Makefile        |   2 +-
 drivers/net/ethernet/engleder/tsnep.h         |  47 ++-
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  40 ++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  13 +-
 drivers/net/ethernet/engleder/tsnep_main.c    | 356 +++++++++++++-----
 drivers/net/ethernet/engleder/tsnep_rxnfc.c   | 307 +++++++++++++++
 8 files changed, 693 insertions(+), 116 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_rxnfc.c

-- 
2.30.2


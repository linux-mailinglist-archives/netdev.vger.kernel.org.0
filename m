Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961F65E83B0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiIWUaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiIWUaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:30:01 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC61251B4;
        Fri, 23 Sep 2022 13:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kLELtFLnMTdGs6Gk86hiiORDsWLg2YLw6Mt5EX6VkrY=; b=TJmblVxJaLM5LOf/m0bNX34cD4
        LmRGZQIKyzjDqxrYjOlDVE/b4QctcJ3NWZ/Phujg1IJrA4um3UNZRHF/z+O16zmJSh38u3gefMw60
        e0Rp9TKoGcShc5WlxjOwshDjKFAKDhXI6l7FZf5WDJtQSG0VtjbJ/44brTtEaZ6/YBoc=;
Received: from [88.117.54.199] (helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1obpDZ-0002Jm-DQ; Fri, 23 Sep 2022 22:24:13 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/6] tsnep: multi queue support and some other improvements
Date:   Fri, 23 Sep 2022 22:22:40 +0200
Message-Id: <20220923202246.118926-1-gerhard@engleder-embedded.com>
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

Gerhard Engleder (6):
  dt-bindings: net: tsnep: Allow dma-coherent
  dt-bindings: net: tsnep: Allow additional interrupts
  tsnep: Move interrupt from device to queue
  tsnep: Support multiple TX/RX queue pairs
  tsnep: Add EtherType RX flow classification support
  tsnep: Use page pool for RX

 .../bindings/net/engleder,tsnep.yaml          |  39 +-
 drivers/net/ethernet/engleder/Kconfig         |   1 +
 drivers/net/ethernet/engleder/Makefile        |   2 +-
 drivers/net/ethernet/engleder/tsnep.h         |  47 ++-
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  38 ++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  13 +-
 drivers/net/ethernet/engleder/tsnep_main.c    | 356 +++++++++++++-----
 drivers/net/ethernet/engleder/tsnep_rxnfc.c   | 281 ++++++++++++++
 8 files changed, 662 insertions(+), 115 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_rxnfc.c

-- 
2.30.2


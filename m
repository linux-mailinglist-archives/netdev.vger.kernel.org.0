Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46455BA1D6
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiIOUgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOUgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:36:49 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D505E55F
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FjV1/bqLMbekkqQ+eBARc+/1xhdVjPombu/Xj0f50MY=; b=VCvWXWLpGqG/CaErS2ShsFruEW
        NFleXcYLaquqg4tTA+jnZsXnVQeSxe2InhyP7laD1UjEY8yr23Wz7sBUMKJMI/968ScbWOvv1WBcs
        lSGYVpBTCG01r3XGpGaG9yGbPm3Iv7oNGf/nvRYr5y84rAoSMsAnU6+2yHXDAvlYCq74=;
Received: from [88.117.54.199] (helo=hornet.engleder.at)
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oYvbH-00086K-AH; Thu, 15 Sep 2022 22:36:43 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/7] tsnep: multi queue support and some other improvements
Date:   Thu, 15 Sep 2022 22:36:30 +0200
Message-Id: <20220915203638.42917-1-gerhard@engleder-embedded.com>
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

RX path optimisation is done by using page pool and reworked RX buffer
allocation. Both changes are preparations for future XDP support.

Gerhard Engleder (7):
  dt-bindings: net: tsnep: Allow dma-coherent
  dt-bindings: net: tsnep: Allow additional interrupts
  tsnep: Move interrupt from device to queue
  tsnep: Support multiple TX/RX queue pairs
  tsnep: Add EtherType RX flow classification support
  tsnep: Use page pool for RX
  tsnep: Rework RX buffer allocation

 .../bindings/net/engleder,tsnep.yaml          |  39 +-
 drivers/net/ethernet/engleder/Kconfig         |   1 +
 drivers/net/ethernet/engleder/Makefile        |   2 +-
 drivers/net/ethernet/engleder/tsnep.h         |  49 +-
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  45 ++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  13 +-
 drivers/net/ethernet/engleder/tsnep_main.c    | 429 ++++++++++++------
 drivers/net/ethernet/engleder/tsnep_rxnfc.c   | 285 ++++++++++++
 8 files changed, 716 insertions(+), 147 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_rxnfc.c

-- 
2.30.2


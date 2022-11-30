Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9363E0D5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiK3ThT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiK3ThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:37:17 -0500
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82388BD12
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yaYUfPPM8H+RK/Msk66vVvjV6vxTWqZGz+BcY/oCcS0=; b=VTI9J6gSPTlaK6cTryCs/m9si7
        Q0VtM5XlrBggVkaXqWfwXh+OZpMDBjfUIV8yvf66nmgI9SPhyh6lG8VDmAssbMCsarA9gM6Br04X7
        +DlHzrJSkZOgfn3O74zuFS61HF1XeQbO6mTT3HJCXXch98qnNJAbW+6gDOxlWYoR2JeE=;
Received: from [88.117.56.227] (helo=hornet.engleder.at)
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p0StM-0004tu-6d; Wed, 30 Nov 2022 20:37:12 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/4] tsnep: Throttle interrupts, RX buffer allocation and ethtool_get_channels()
Date:   Wed, 30 Nov 2022 20:37:04 +0100
Message-Id: <20221130193708.70747-1-gerhard@engleder-embedded.com>
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

Collection of improvements found during development of XDP support.
Hopefully the last patch series before the XDP support.

ethtool_get_channels() is needed for automatic TAPRIO configuration in
combination with multiple queues.

Rework of the RX buffer allocation is prework of XDP. It ensures that
packets are only dropped if RX queue would otherwise run empty because
of failed allocations. So it should reduce the number of dropped packets
under low memory conditions.

v2:
- post rotten packet fix separately (Jakub Kicinski)
- implement ethtool::get_coalesce / set_coalesce (Jakub Kicinski)

Gerhard Engleder (4):
  tsnep: Consistent naming of struct net_device
  tsnep: Add ethtool::get_channels support
  tsnep: Throttle interrupts
  tsnep: Rework RX buffer allocation

 drivers/net/ethernet/engleder/tsnep.h         |   8 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c | 165 +++++++++++-
 drivers/net/ethernet/engleder/tsnep_hw.h      |   7 +
 drivers/net/ethernet/engleder/tsnep_main.c    | 245 ++++++++++++------
 4 files changed, 345 insertions(+), 80 deletions(-)

-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D6062E5A9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbiKQUPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiKQUOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:14:55 -0500
Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF16131EC7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BDl59ye8fKXlBHCPY4PgTywulAeUvYLsyCdc29JoN8w=; b=La14fmw8sYfIN8HMTG/DXhhFNq
        cUbaGJXDcTGGS0PtVzV7n+BYdidUYBGMLBHjyuirgKpII9Q8DVccCHp7km7Xs57X1pn0sG8NEOuOs
        XyL4ezdbSn0gF3kHIGdXvTyzHh2KwaZ7VYcqj17TjsQHHo99cEICbrKWtp9jPNqrmTAo=;
Received: from [88.117.56.227] (helo=hornet.engleder.at)
        by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ovlHa-0001s8-FD; Thu, 17 Nov 2022 21:14:46 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/4] tsnep: Throttle irq, rotten pkts, RX buffer alloc and ethtool_get_channels()
Date:   Thu, 17 Nov 2022 21:14:36 +0100
Message-Id: <20221117201440.21183-1-gerhard@engleder-embedded.com>
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

Fix of rotten packets increased CPU load and caused slight drop of iperf
performance, because CPU load was already at 100% before. This performance
drop is compensated with interrupt throttling, which makes sense anyway.

ethtool_get_channels() is needed for automatic TAPRIO configuration in
combination with multiple queues.

Rework of RX buffer allocation is prework of XDP. It ensures that packets
are only dropped if RX queue would otherwise run empty because of
failed allocations. So it should reduce the number of dropped packets
under low memory conditions.

Gerhard Engleder (4):
  tsnep: Throttle interrupts
  tsnep: Fix rotten packets
  tsnep: Add ethtool get_channels support
  tsnep: Rework RX buffer allocation

 drivers/net/ethernet/engleder/tsnep.h         |   4 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  19 ++
 drivers/net/ethernet/engleder/tsnep_hw.h      |   7 +
 drivers/net/ethernet/engleder/tsnep_main.c    | 252 +++++++++++++-----
 4 files changed, 214 insertions(+), 68 deletions(-)

-- 
2.30.2


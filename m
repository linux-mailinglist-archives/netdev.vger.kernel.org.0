Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B9D520FE7
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiEJIs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiEJIs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:48:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BD6B2A28DF
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652172300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HZ0wgBsT02eEoyM4MFyhhixjC2WrnWtTCj8UNl8FVks=;
        b=NdreDmpLqLmfFWXvaKl1idCnqwLb9P7PAnYRmzk4eIeJHr7/HcZ8oT0G4FvFWPm1BJVR7v
        jK/DF9EjSs4GLohoA828JSpAuKjMk3tjILY1856HYh/rKcGTmfEV65QwTg8a/d1gPdT/qG
        T906FLP2dQ0utbiuzkU9wYaSqXmpA2s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567--lEOWOW6Obuanfew8ezNsw-1; Tue, 10 May 2022 04:44:57 -0400
X-MC-Unique: -lEOWOW6Obuanfew8ezNsw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0EF729ABA19;
        Tue, 10 May 2022 08:44:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB8F8413721;
        Tue, 10 May 2022 08:44:54 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 0/5] sfc: refactor of efx_set_channels
Date:   Tue, 10 May 2022 10:44:38 +0200
Message-Id: <20220510084443.14473-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code configuring RX, TX and XDP_TX queues in efx_set_channels was a
bit messy and difficult to follow. Some of my recent changes to add
support for sharing TX queues for XDP when not enough channels are
available contributed even more to this.

This patch series contains no functional changes, but only a refactor to
make that part of the driver's code clearer and easier to maintain.

Since these changes partially undo commit 059a47f1da93 ("net: sfc: add
missing xdp queue reinitialization"), I've specifically tested against
regression of this change.

Tested: receiving packets with iperf3 and with samples/bpf/xdp_rxq_info.
Then increased ring sizes to force their reallocation and repeated the
tests.

Íñigo Huguet (5):
  sfc: add new helper macros to iterate channels by type
  sfc: separate channel->tx_queue and efx->xdp_tx_queue mappings
  sfc: rename set_channels to set_queues and document it
  sfc: refactor efx_set_xdp_tx_queues
  sfc: move tx_channel_offset calculation to interrupts probe

 drivers/net/ethernet/sfc/ef100_netdev.c |   2 +-
 drivers/net/ethernet/sfc/efx.c          |   2 +-
 drivers/net/ethernet/sfc/efx_channels.c | 155 ++++++++++++------------
 drivers/net/ethernet/sfc/efx_channels.h |   2 +-
 drivers/net/ethernet/sfc/net_driver.h   |  21 ++++
 5 files changed, 99 insertions(+), 83 deletions(-)

-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5664047BA
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhIIJaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232860AbhIIJaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 05:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631179744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UJFJy/0BaHlqH2c/JRnf3STy2KHZHL1KbjWxtW7U0ZQ=;
        b=hjW9UcTbcpUgwlkhfMldglBKv859RBhN4igD6T8Zbl8hVCRZwFF8+9NdvGKRz+i8PyfF63
        XSny1Do2VkmYSmpde2SITCg1I2ga4qm7HUt20R4LKifk9xS3IQoYRAgI15aAsa9ulrA+of
        3t5LVXGh9TUT+n1cspqj5ATlDaXN09I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-Oim_kd1VMBiqgQPgoIWmcg-1; Thu, 09 Sep 2021 05:29:03 -0400
X-MC-Unique: Oim_kd1VMBiqgQPgoIWmcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8311E1030C23;
        Thu,  9 Sep 2021 09:29:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA87177F1;
        Thu,  9 Sep 2021 09:28:58 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net 0/2] sfc: fallback for lack of xdp tx queues
Date:   Thu,  9 Sep 2021 11:28:44 +0200
Message-Id: <20210909092846.18217-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there are not enough hardware resources to allocate one tx queue per
CPU for XDP, XDP_TX and XDP_REDIRECT actions were unavailable, and using
them resulted each time with the packet being drop and this message in
the logs: XDP TX failed (-22)

These patches implement 2 fallback solutions for 2 different situations
that might happen:
1. There are not enough free resources for all the tx queues, but there
   are some free resources available
2. There are not enough free resources at all for tx queues.

Both solutions are based in sharing tx queues, using __netif_tx_lock for
synchronization. In the second case, as there are not XDP TX queues to
share, network stack queues are used instead, but since we're taking
__netif_tx_lock, concurrent access to the queues is correctly protected.

The solution for this second case might affect performance both of XDP
traffic and normal traffice due to lock contention if both are used
intensively. That's why I call it a "last resort" fallback: it's not a
desirable situation, but at least we have XDP TX working.

Some tests has shown good results and indicate that the non-fallback
case is not being damaged by this changes. They are also promising for
the fallback cases. This is the test:
1. From another machine, send high amount of packets with pktgen, script
   samples/pktgen/pktgen_sample04_many_flows.sh
2. In the tested machine, run samples/bpf/xdp_rxq_info with arguments
   "-a XDP_TX --swapmac" and see the results
3. In the tested machine, run also pktgen_sample04 to create high TX
   normal traffic, and see how xdp_rxq_info results vary

Note that this test doesn't check the worst situations for the fallback
solutions because XDP_TX will only be executed from the same CPUs that
are processed by sfc, and not from every CPU in the system, so the
performance drop due to the highest locking contention doesn't happen.
I'd like to test that, as well, but I don't have access right now to a
proper environment.

Test results:

Without doing TX:
Before changes: ~2,900,000 pps
After changes, 1 queues/core: ~2,900,000 pps
After changes, 2 queues/core: ~2,900,000 pps
After changes, 8 queues/core: ~2,900,000 pps
After changes, borrowing from network stack: ~2,900,000 pps

With multiflow TX at the same time:
Before changes: ~1,700,000 - 2,900,000 pps
After changes, 1 queues/core: ~1,700,000 - 2,900,000 pps
After changes, 2 queues/core: ~1,700,000 pps
After changes, 8 queues/core: ~1,700,000 pps
After changes, borrowing from network stack: 1,150,000 pps

Sporadic "XDP TX failed (-5)" warnings are shown when running xdp program
and pktgen simultaneously. This was expected because XDP doesn't have any
buffering system if the NIC is under very high pressure. Thousands of
these warnings are shown in the case of borrowing net stack queues. As I
said before, this was also expected.


Íñigo Huguet (2):
  sfc: fallback for lack of xdp tx queues
  sfc: last resort fallback for lack of xdp tx queues

 drivers/net/ethernet/sfc/efx_channels.c | 98 ++++++++++++++++++-------
 drivers/net/ethernet/sfc/net_driver.h   |  8 ++
 drivers/net/ethernet/sfc/tx.c           | 29 ++++++--
 3 files changed, 99 insertions(+), 36 deletions(-)

-- 
2.31.1


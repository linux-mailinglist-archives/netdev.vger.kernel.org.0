Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C14C6E0B
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiB1NYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiB1NYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:24:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A24722657A
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 05:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646054600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pcWVZFaQv8747a8IR5DNV4E0If3NxbpNdLv77ZiXvu8=;
        b=SX2bqLoJjU/a++bxY8lcmLRXhWFRNip/sJFuPVlZHVHNU5RLsdEwY3EfDyemf0KuEJwZDU
        lwcgILniVy3FqHWQXlCJZ9L/LNJFHG+xV0ECyRCN1I+c2iYsY/I2MjAJG7CX6vfTFKfqUX
        agAktNcCNRrt5Fx6qZjQrsbO1wX4DM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-8Z_Al73UPwqaEN_MgW0OXQ-1; Mon, 28 Feb 2022 08:23:17 -0500
X-MC-Unique: 8Z_Al73UPwqaEN_MgW0OXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F0D21006AAA;
        Mon, 28 Feb 2022 13:23:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 865AC842DE;
        Mon, 28 Feb 2022 13:23:14 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH v2 net-next 0/2] sfc: optimize RXQs count and affinities
Date:   Mon, 28 Feb 2022 14:22:52 +0100
Message-Id: <20220228132254.25787-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sfc driver one RX queue per physical core was allocated by default.
Later on, IRQ affinities were set spreading the IRQs in all NUMA local
CPUs.

However, with that default configuration it result in a non very optimal
configuration in many modern systems. Specifically, in systems with hyper
threading and 2 NUMA nodes, affinities are set in a way that IRQs are
handled by all logical cores of one same NUMA node. Handling IRQs from
both hyper threading siblings has no benefit, and setting affinities to one
queue per physical core is neither a very good idea because there is a
performance penalty for moving data across nodes (I was able to check it
with some XDP tests using pktgen).

This patches reduce the default number of channels to one per physical
core in the local NUMA node. Then, they set IRQ affinities to CPUs in
the local NUMA node only. This way we save hardware resources since
channels are limited resources. We also leave more room for XDP_TX
channels without hitting driver's limit of 32 channels per interface.

Running performance tests using iperf with a SFC9140 device showed no
performance penalty for reducing the number of channels.

RX XDP tests showed that performance can go down to less than half if
the IRQ is handled by a CPU in a different NUMA node, which doesn't
happen with the new defaults from this patches.

v2: changed variables declaration order to meet reverse Xmas tree
convention

Íñigo Huguet (2):
  sfc: default config to 1 channel/core in local NUMA node only
  sfc: set affinity hints in local NUMA node only

 drivers/net/ethernet/sfc/efx_channels.c | 62 +++++++++++++++++--------
 1 file changed, 43 insertions(+), 19 deletions(-)

-- 
2.34.1


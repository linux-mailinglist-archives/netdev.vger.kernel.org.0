Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEC949FCAB
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiA1PTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:19:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240219AbiA1PTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643383178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GylVe8UcyI7oiHHoQCKKLImSJuDi5QTU8DDcK7Ikh40=;
        b=TZQZ2ZfdK5ru2i1rbDZAcrIqFdmnOk4WVw87f019//FNUbiVcmkemeWwmRumBRPR/jfghl
        prP+ezzsd8qqmEnWF2g06yvffbNUnfeVXESAlliFioFR+8DF46a/+G4oT4W1ycuxlFEiez
        nFNKEVfL8vK12GCPSu15aWxWTTtcO6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-TB_Ey9XjNpK6rlq4NQzp9A-1; Fri, 28 Jan 2022 10:19:36 -0500
X-MC-Unique: TB_Ey9XjNpK6rlq4NQzp9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA2F584B9A5;
        Fri, 28 Jan 2022 15:19:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 004AF79A19;
        Fri, 28 Jan 2022 15:19:32 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 0/2] sfc: optimize RXQs count and affinities
Date:   Fri, 28 Jan 2022 16:19:20 +0100
Message-Id: <20220128151922.1016841-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Íñigo Huguet (2):
  sfc: default config to 1 channel/core in local NUMA node only
  sfc: set affinity hints in local NUMA node only

 drivers/net/ethernet/sfc/efx_channels.c | 62 +++++++++++++++++--------
 1 file changed, 43 insertions(+), 19 deletions(-)

-- 
2.31.1


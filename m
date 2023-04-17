Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2386E4795
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjDQMYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDQMYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:24:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91626E9D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681734095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UoZHzg38lYRU038fq8iVgnN+aH9aQi+SKq1StiePsIk=;
        b=ChXtUEDBL4jRKAh1VQj8aPSyLiSVfq4xbGjUK1etebp1/mDY8JytxMyqr4JUZdhCRMWZEJ
        V9QpYoHWT8krQtnwyzs7Hyk0XTJSJiaYQPy4pVHhCERKl2BfdyWvxK6vWcfCwKLs6dU/+N
        rhC2yCVd7PGxqFzXSl9Hb0cSTFUXyeY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-4os7Ef5LPPaYuqM_VDlL4w-1; Mon, 17 Apr 2023 08:21:34 -0400
X-MC-Unique: 4os7Ef5LPPaYuqM_VDlL4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75F5985A588;
        Mon, 17 Apr 2023 12:21:34 +0000 (UTC)
Received: from ovpn-242-143.nrt.redhat.com (unknown [10.64.242.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9932251FF;
        Mon, 17 Apr 2023 12:21:33 +0000 (UTC)
From:   Seiji Nishikawa <snishika@redhat.com>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, Seiji Nishikawa <snishika@redhat.com>
Subject: [PATCH] net: vmxnet3: Fix NULL pointer dereference in vmxnet3_rq_rx_complete()
Date:   Mon, 17 Apr 2023 21:21:27 +0900
Message-Id: <20230417122127.178549-1-snishika@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When vmxnet3_rq_create() fails to allocate rq->data_ring.base due to page
allocation failure, subsequent call to vmxnet3_rq_rx_complete() can result in
NULL pointer dereference.

To fix this bug, check not only that rxDataRingUsed is true but also that
adapter->rxdataring_enabled is true before calling memcpy() in
vmxnet3_rq_rx_complete().

[1728352.477993] ethtool: page allocation failure: order:9, mode:0x6000c0(GFP_KERNEL), nodemask=(null),cpuset=/,mems_allowed=0
...
[1728352.478009] Call Trace:
[1728352.478028]  dump_stack+0x41/0x60
[1728352.478035]  warn_alloc.cold.120+0x7b/0x11b
[1728352.478038]  ? _cond_resched+0x15/0x30
[1728352.478042]  ? __alloc_pages_direct_compact+0x15f/0x170
[1728352.478043]  __alloc_pages_slowpath+0xcd3/0xd10
[1728352.478047]  __alloc_pages_nodemask+0x2e2/0x320
[1728352.478049]  __dma_direct_alloc_pages.constprop.25+0x8a/0x120
[1728352.478053]  dma_direct_alloc+0x5a/0x2a0
[1728352.478056]  vmxnet3_rq_create.part.57+0x17c/0x1f0 [vmxnet3]
...
[1728352.478188] vmxnet3 0000:0b:00.0 ens192: rx data ring will be disabled
...
[1728352.515347] BUG: unable to handle kernel NULL pointer dereference at 0000000000000034
...
[1728352.515440] RIP: 0010:memcpy_orig+0x54/0x130
...
[1728352.515655] Call Trace:
[1728352.515665]  <IRQ>
[1728352.515672]  vmxnet3_rq_rx_complete+0x419/0xef0 [vmxnet3]
[1728352.515690]  vmxnet3_poll_rx_only+0x31/0xa0 [vmxnet3]
...

Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index da488cbb0542..f2b76ee866a4 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1504,7 +1504,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				goto rcd_done;
 			}
 
-			if (rxDataRingUsed) {
+			if (rxDataRingUsed && adapter->rxdataring_enabled) {
 				size_t sz;
 
 				BUG_ON(rcd->len > rq->data_ring.desc_size);
-- 
2.39.2


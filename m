Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1865230C0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiEKKgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbiEKKgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:36:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D787F2DD52
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652265377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SiSbzUBv0vk1QApHrqyXD9HFU3i+13sT6kRePERojio=;
        b=B0vvFRLnVgc4tI74f51M1q8ceUq/nRnlcn66tRNftxn+r3PU/cQ0i1W7anjms8m2eekf9q
        D/PrlLKlzpFtVF6dAYky39JQZYJjv02mx6nhKwzhsio7lcNy/PYBHKjo9Rbj/jMzO+yecH
        4sqL39filZS9tW8tpQd//cfWwoIlHaE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-ljXjJZU0MH2L3-Bfw-EesQ-1; Wed, 11 May 2022 06:36:12 -0400
X-MC-Unique: ljXjJZU0MH2L3-Bfw-EesQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C10D384F80A;
        Wed, 11 May 2022 10:36:12 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3641D400E115;
        Wed, 11 May 2022 10:36:10 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        bhutchings@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Liang Li <liali@redhat.com>
Subject: [PATCH net-next 1/2] sfc: fix memory leak on mtd_probe
Date:   Wed, 11 May 2022 12:36:03 +0200
Message-Id: <20220511103604.37962-2-ihuguet@redhat.com>
In-Reply-To: <20220511103604.37962-1-ihuguet@redhat.com>
References: <20220511103604.37962-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases there is no mtd partitions that can be probed, so the mtd
partitions list stays empty. This happens, for example, in SFC9220
devices on the second port of the NIC.

The memory for the mtd partitions is deallocated in efx_mtd_remove,
recovering the address of the first element of efx->mtd_list and then
deallocating it. But if the list is empty, the address passed to kfree
doesn't point to the memory allocated for the mtd partitions, but to the
list head itself. Despite this hasn't caused other problems other than
the memory leak, this is obviously incorrect.

This patch deallocates the memory during mtd_probe in the case that
there are no probed partitions, avoiding the leak.

This was detected with kmemleak, output example:
unreferenced object 0xffff88819cfa0000 (size 46560):
  comm "kworker/0:2", pid 48435, jiffies 4364987018 (age 45.924s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000000f8e92d9>] kmalloc_order_trace+0x19/0x130
    [<0000000042a03844>] efx_ef10_mtd_probe+0x12d/0x320 [sfc]
    [<000000004555654f>] efx_pci_probe.cold+0x4e1/0x6db [sfc]
    [<00000000b03d5126>] local_pci_probe+0xde/0x170
    [<00000000376cc8d9>] work_for_cpu_fn+0x51/0xa0
    [<00000000141f8de9>] process_one_work+0x8cb/0x1590
    [<00000000cb2d8065>] worker_thread+0x707/0x1010
    [<000000001ef4b9f6>] kthread+0x364/0x420
    [<0000000014767137>] ret_from_fork+0x22/0x30

Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10.c        | 5 +++++
 drivers/net/ethernet/sfc/siena/siena.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c9ee5011803f..15a229731296 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3579,6 +3579,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 		n_parts++;
 	}
 
+	if (n_parts == 0) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
 fail:
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 741313aff1d1..32467782e8ef 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -943,6 +943,11 @@ static int siena_mtd_probe(struct efx_nic *efx)
 		nvram_types >>= 1;
 	}
 
+	if (n_parts == 0) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = siena_mtd_get_fw_subtypes(efx, parts, n_parts);
 	if (rc)
 		goto fail;
-- 
2.34.1


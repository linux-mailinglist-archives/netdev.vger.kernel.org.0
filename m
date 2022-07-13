Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF40457325E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiGMJVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbiGMJVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:21:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 054D2F2E3B
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657704094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Oz0N+QsU06DLhZQte7+5atP5TvWBFGl9kj65WCB06k8=;
        b=fEamxsemtGeSxq/MUvb/Qi6p4RYMJBjggP0vveMhGtpPaS2w6zCAugQ4BI+u/mhkV62eS+
        A1UV/cCa3jkMhFMXf7mSHdI5ETgw71KF8mEczjAjj+NrazqBEtH+2gkfk/GijvL8OmwxuY
        RDe+U/4s3rX0AzK16gtgiDfAQECOtVM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-dXxASUGVMMeegl6U6A8bxw-1; Wed, 13 Jul 2022 05:21:25 -0400
X-MC-Unique: dXxASUGVMMeegl6U6A8bxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AD9E811E76;
        Wed, 13 Jul 2022 09:21:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB5C9C04482;
        Wed, 13 Jul 2022 09:21:22 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        sshah@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Ma Yuying <yuma@redhat.com>
Subject: [PATCH net] sfc: fix kernel panic when creating VF
Date:   Wed, 13 Jul 2022 11:21:16 +0200
Message-Id: <20220713092116.21238-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating VFs a kernel panic can happen when calling to
efx_ef10_try_update_nic_stats_vf.

When releasing a DMA coherent buffer, sometimes, I don't know in what
specific circumstances, it has to unmap memory with vunmap. It is
disallowed to do that in IRQ context or with BH disabled. Otherwise, we
hit this line in vunmap, causing the crash:
  BUG_ON(in_interrupt());

This patch reenables BH to release the buffer.

Log messages when the bug is hit:
 kernel BUG at mm/vmalloc.c:2727!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 6 PID: 1462 Comm: NetworkManager Kdump: loaded Tainted: G          I      --------- ---  5.14.0-119.el9.x86_64 #1
 Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS 2.8.2 08/27/2020
 RIP: 0010:vunmap+0x2e/0x30
 ...skip...
 Call Trace:
  __iommu_dma_free+0x96/0x100
  efx_nic_free_buffer+0x2b/0x40 [sfc]
  efx_ef10_try_update_nic_stats_vf+0x14a/0x1c0 [sfc]
  efx_ef10_update_stats_vf+0x18/0x40 [sfc]
  efx_start_all+0x15e/0x1d0 [sfc]
  efx_net_open+0x5a/0xe0 [sfc]
  __dev_open+0xe7/0x1a0
  __dev_change_flags+0x1d7/0x240
  dev_change_flags+0x21/0x60
  ...skip...

Fixes: d778819609a2 ("sfc: DMA the VF stats only when requested")
Reported-by: Ma Yuying <yuma@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 186cb28c03bd..8b62ce21aff3 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1932,7 +1932,10 @@ static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
 
 	efx_update_sw_stats(efx, stats);
 out:
+	/* releasing a DMA coherent buffer with BH disabled can panic */
+	spin_unlock_bh(&efx->stats_lock);
 	efx_nic_free_buffer(efx, &stats_buf);
+	spin_lock_bh(&efx->stats_lock);
 	return rc;
 }
 
-- 
2.34.1


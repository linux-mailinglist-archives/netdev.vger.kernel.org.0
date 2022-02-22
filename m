Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0754BF7A7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiBVMCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiBVMC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:02:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CC02180E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645531322; x=1677067322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7sfhBlDXqoF4USnYs/Zw05QturZAb6oqbYahKFO2vU=;
  b=Gv4qYOGyUrseiOjFlkkZdQCNX1PiJkY/XlBokMDunHv6xmMppqkXxtNw
   gkyB0QufSG78DnKKITv6aAm7Mdg0DAeliHzfUKPlYPoKxzrJXxTfv0JUB
   yTqnRszi6SbIB/EpVQjrGB/jZoOArmY491ApBX0sgo0MhsVpQgYMdlgZZ
   FNsUatjCDTacaEeI0QRStJJsvqO2zYGaVFsafSzuPPSLzWBVW6+Lwt/Rq
   pm0QJ6zM1TAH583NsefGP8TGHAwvUJDoEAp+Hg7Yz8GhbcL7eTt/etlsO
   nRP/OgS2YdL+lpNz0SbETwbqZOIbFvNXY01OnCptLzoar6UJwrrGx124j
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="338117842"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="338117842"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:02:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="490772577"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:01:59 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V6 2/5] vhost_vdpa: don't setup irq offloading when irq_num < 0
Date:   Tue, 22 Feb 2022 19:54:25 +0800
Message-Id: <20220222115428.998334-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220222115428.998334-1-lingshan.zhu@intel.com>
References: <20220222115428.998334-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When irq number is negative(e.g., -EINVAL), the virtqueue
may be disabled or the virtqueues are sharing a device irq.
In such case, we should not setup irq offloading for a virtqueue.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 851539807bc9..8f53a8478c28 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -97,8 +97,11 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	irq = ops->get_vq_irq(vdpa, qid);
+	if (irq < 0)
+		return;
+
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	if (!vq->call_ctx.ctx || irq < 0)
+	if (!vq->call_ctx.ctx)
 		return;
 
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
-- 
2.27.0


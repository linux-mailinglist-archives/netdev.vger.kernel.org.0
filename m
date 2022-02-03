Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3A14A7FE3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349409AbiBCHfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:35:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:32422 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236619AbiBCHfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 02:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643873708; x=1675409708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o/kK3Kx73a+PbxgC531tJEeKezp5FnAFLjDWQaYT3Z4=;
  b=Y9gzUazVBhXOyn8UuRmqE9I+HStybvb6vpIPbGWohpAXphQWLuDi4Vq1
   coAf34+DA/6tXe3ZSGCAFZX2lrEZnjhcgb46kVn4JNqBzjMoNOX9Q2T1a
   odRHoV1N2qjK+izD91cot8G2/bnAbQhnbbK8RG4ifysUHjzlVjTbvMMbk
   iH4nOHtlbQSqmAzJxxkR4zBOvrpnVF61TAzoNakQEGkc0JWKMa6kLL2u6
   wsG9IO0r+8Rr/4eqiNbBVTwP4GEG5Q3viQWGYgDJdnt9tsSMHhnSPxNc/
   J+41Fq1er0ucPpF41j4i67UzCK/nPKQU3qmbYxYt6ZszXI8migZvfceaP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="311397577"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="311397577"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:35:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="771703693"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:54 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 3/4] vhost_vdpa: don't setup irq offloading when irq_num < 0
Date:   Thu,  3 Feb 2022 15:27:34 +0800
Message-Id: <20220203072735.189716-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220203072735.189716-1-lingshan.zhu@intel.com>
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When irq number is negative(e.g., -EINVAL), the virtqueue
may be disabled or the virtqueues are sharing a device irq.
In such case, we should not setup irq offloading for a virtqueue.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 851539807bc9..c4fcacb0de3a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -96,6 +96,10 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	if (!ops->get_vq_irq)
 		return;
 
+	irq = ops->get_vq_irq(vdpa, qid);
+	if (irq < 0)
+		return;
+
 	irq = ops->get_vq_irq(vdpa, qid);
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 	if (!vq->call_ctx.ctx || irq < 0)
-- 
2.27.0


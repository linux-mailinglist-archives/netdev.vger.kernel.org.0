Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF72549B085
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574422AbiAYJhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:42501 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1574102AbiAYJcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 04:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643103136; x=1674639136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=305fK8tSqRCXLg4QAOScMdAdoUi93+U03hNstM48FgQ=;
  b=UnGhVVdb5OFUh105fkRZ8QeExpEEzIPyeVGGvPHV3Al/wA308nvaTrxK
   5nHfgK/fVvttU5/X6sGz0wDVRFibNoA8JnSHe7RoU4bdvO5z0mbotYtSk
   l+YveI4zGodsjL5TlAGCDCx8Xab/qEQTwViW4fEqQN4KkOB59YfX3sGSK
   4YYAfAeQga7Wh8F3hFQquQv6c4fAbc6Wi+M3LBvP3a7MGl5p/olTsQiIn
   GgLHvZWfLfJDP9sY97EzPI2Ou0XtHMIHRZIwOSdRAJo1d0YU9HXBM0jZF
   Uhu21NnOmQlSAyUolPdNDp3QKCh84Sfc2CK7A+lny2HOReeON3mgUhEZF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226240763"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="226240763"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="520318840"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:05 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 3/4] vhost_vdpa: don't setup irq offloading when irq_num < 0
Date:   Tue, 25 Jan 2022 17:17:43 +0800
Message-Id: <20220125091744.115996-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125091744.115996-1-lingshan.zhu@intel.com>
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
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
 drivers/vhost/vdpa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 851539807bc9..909891d518e8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -96,6 +96,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	if (!ops->get_vq_irq)
 		return;
 
+	if (irq < 0)
+		return;
+
 	irq = ops->get_vq_irq(vdpa, qid);
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 	if (!vq->call_ctx.ctx || irq < 0)
-- 
2.27.0


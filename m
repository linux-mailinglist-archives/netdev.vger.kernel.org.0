Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE049CA26
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiAZM4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:56:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:29543 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241575AbiAZM4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643201778; x=1674737778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o/kK3Kx73a+PbxgC531tJEeKezp5FnAFLjDWQaYT3Z4=;
  b=GmUKIF29OZksxEDmxlL5S4kya5Wxby18vVWPk9IexamBtmldnlyYx/3K
   q1zxdDa4LWnyLSyS5AebL0bx23DqVtj0H5r+J759HjILjgVO3UCZ9mmrf
   25KBIAs18sNmf5YlTohAQ5GqzrAypTqlXDhwmAXEqytNWUz7zrvL4ij+/
   MH3CsaCfDKvAdV1fBsVKqtFvjDLPEpPUkWHBe11mbtMcCm8TQax1uz2XX
   PL8HLMMs8WXgIyUg1UdCIHvimWbDo9L9vANi6r4lRG9AM4lwPeJX/XJHy
   bf0wRV+bO0GSnLDO5TxF9V7UNCL7OxE2QpUeSbw4dALEGy/xv0M8Yf695
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244141268"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244141268"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520783500"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:16 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 3/4] vhost_vdpa: don't setup irq offloading when irq_num < 0
Date:   Wed, 26 Jan 2022 20:49:11 +0800
Message-Id: <20220126124912.90205-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126124912.90205-1-lingshan.zhu@intel.com>
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
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


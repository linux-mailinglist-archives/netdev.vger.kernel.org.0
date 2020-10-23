Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD006296CFC
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462469AbgJWKl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:41:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:29272 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370785AbgJWKl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 06:41:29 -0400
IronPort-SDR: u36iE/5KAlCxzVMuB3Ba1nj/CEi5pzLzzVVo0Ue8AYTx+TZF2LCUfYJgGMuXsERE+2Mtn5BdOz
 PVUp+0ECBv1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="146948653"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="146948653"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:41:25 -0700
IronPort-SDR: p1stJnjA9sdvbFNUoF8RFqrzjWe/EG44qKXxMAZNQ+TKZYTvvEzG5tpTN8EgUevQaAtm2gOVxJ
 cvJ5XyQr9yPg==
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="467030690"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:41:22 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] vdpa: handle irq bypass register failure case
Date:   Fri, 23 Oct 2020 18:40:46 +0800
Message-Id: <20201023104046.404794-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LKP considered variable 'ret' in vhost_vdpa_setup_vq_irq() as
a unused variable, so suggest we remove it. Actually it stores
return value of irq_bypass_register_producer(), but we did not
check it, we should handle the failure case.

This commit will print a message if irq bypass register producer
fail, in this case, vqs still remain functional.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/vhost/vdpa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 62a9bb0efc55..d6b2c3bd1b01 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -107,6 +107,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
 	vq->call_ctx.producer.irq = irq;
 	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
+	if (unlikely(ret))
+		dev_info(&v->dev, "vq %u, irq bypass producer (token %p) registration fails, ret =  %d\n",
+			 qid, vq->call_ctx.producer.token, ret);
 	spin_unlock(&vq->call_ctx.ctx_lock);
 }
 
-- 
2.18.4


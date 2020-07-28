Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2331F2300C7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgG1E3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:29:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:29130 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbgG1E3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 00:29:03 -0400
IronPort-SDR: TH4EolS7SDb+QyN4/EyskwpOxxqlEEnts/CfZTh+UzWGH+z1PwSIOcYCgu1DLeRVrm2EDOok5D
 ABWXEoysMyDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="149012930"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="149012930"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 21:29:03 -0700
IronPort-SDR: J8eqJtVRdYESO58oiEPppSanX8UBLje4JhyfJoDDzZmzVrOfakrL4H5zODBJsv05d2tn2/us3P
 qK0kk5d7oiLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="290037382"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2020 21:28:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 6/6] irqbypass: do not start cons/prod when failed connect
Date:   Tue, 28 Jul 2020 12:24:05 +0800
Message-Id: <20200728042405.17579-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200728042405.17579-1-lingshan.zhu@intel.com>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If failed to connect, there is no need to start consumer nor
producer.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 virt/lib/irqbypass.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28fda42e471b..c9bb3957f58a 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -40,17 +40,21 @@ static int __connect(struct irq_bypass_producer *prod,
 	if (prod->add_consumer)
 		ret = prod->add_consumer(prod, cons);
 
-	if (!ret) {
-		ret = cons->add_producer(cons, prod);
-		if (ret && prod->del_consumer)
-			prod->del_consumer(prod, cons);
-	}
+	if (ret)
+		goto err_add_consumer;
+
+	ret = cons->add_producer(cons, prod);
+	if (ret)
+		goto err_add_producer;
 
 	if (cons->start)
 		cons->start(cons);
 	if (prod->start)
 		prod->start(prod);
-
+err_add_producer:
+	if (prod->del_consumer)
+		prod->del_consumer(prod, cons);
+err_add_consumer:
 	return ret;
 }
 
-- 
2.18.4


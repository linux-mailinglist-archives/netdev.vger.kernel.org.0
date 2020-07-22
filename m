Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53A12295CA
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbgGVKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:13:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:19155 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgGVKNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:13:32 -0400
IronPort-SDR: w9TM/dskPB03Sct0iDWOkHizkuT2MNnubHY2XJGYYzS8RsIrTYVbIm6Jz+aYuChqGyRd1/sqL6
 NJQ3y3TG3I6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="151627944"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="151627944"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 03:13:31 -0700
IronPort-SDR: tR4Q+Bj4ejvjaEK9W9I+bMTpIRjV8ZXto3nfrMvjgxndZevx5muHkiyq//U+FXbCkaY3u7nYeA
 NsQ3rYPeO/IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="392634963"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2020 03:13:29 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 6/6] irqbypass: do not start cons/prod when failed connect
Date:   Wed, 22 Jul 2020 18:08:59 +0800
Message-Id: <20200722100859.221669-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200722100859.221669-1-lingshan.zhu@intel.com>
References: <20200722100859.221669-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If failed to connect, there is no need to start consumer nor
producer.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
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


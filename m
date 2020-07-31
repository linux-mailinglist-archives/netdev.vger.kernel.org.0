Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1BE233F9B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgGaHA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:00:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:29369 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731565AbgGaHAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:00:09 -0400
IronPort-SDR: 4pamdowrK+Ke7lROdxBxR82m0I4ykIlfRbXe++iTmgkGuwk+L/0LtAgXXyGOmzfE7dLgdx9ECN
 dsfvPgAuGQNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="151708821"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="151708821"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:00:04 -0700
IronPort-SDR: NrQsvBYIsgnp9zzEAs4Usmlzpr2E/5ra9bmfQ2bAsUCKVbQlXKqwGtuzwXVerY/kDBOTFEvFJT
 +e6ukkFaGFHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="273136743"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga007.fm.intel.com with ESMTP; 31 Jul 2020 00:00:00 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 6/6] irqbypass: do not start cons/prod when failed connect
Date:   Fri, 31 Jul 2020 14:55:33 +0800
Message-Id: <20200731065533.4144-7-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200731065533.4144-1-lingshan.zhu@intel.com>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
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


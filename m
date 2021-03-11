Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A752F338108
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhCKXAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:00:42 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:56902 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhCKXAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 18:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615503612; x=1647039612;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f4kw6VKDxqZ6aK5je+CShKYL/i9tWOOhWCfFur47MZU=;
  b=FSm5ATYQqb4y2rXKxPhQZqyuI+y/xR7VDshNqRoJetc71oEWfxbLwBI8
   6PXGZnU7zo9cOttXPmBFJuS2skAujpAP8vp/owX6qvxDwfhRpiPPcqZFI
   qYBFcALzERJacqqNlXf6joe0UaNwnziCCn0dFSs2h/H/ZDLOYOJQwTy6S
   0=;
IronPort-HdrOrdr: A9a23:hblugKnnQPn8kG+AHnwCCxgN7sfpDfKS3DAbvn1ZSRFFG/Gwve
 rGppsm/DXzjyscX2xlpMuJP7OOTWiZ2Zl+54QQOrnKZniChEKDKoZ+4Yz+hwDxAiGWzJ846Y
 5Me7VzYeeQMXFUlsD/iTPUL/8F4P2qtJ+lnv3fyXAFd3AJV4hF4x1iAgiWVm1aLTMnObMBD5
 aX6sdKoDCtEE5nF/iTPXUOU+jdq9CjrvuPCnQ7LiQ64wqDhy7A0tDHOiWfty1zbxp/hZ0m8W
 TDjjXj4LSiv/yR2nbnpgnuxqUTvNPgz9dZbfb86fQ9G3HLkQanZINoRr2EsnQUmYiUmTEXrO
 U=
X-IronPort-AV: E=Sophos;i="5.81,241,1610409600"; 
   d="scan'208";a="92295156"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 11 Mar 2021 23:00:00 +0000
Received: from EX13D12EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 1C690A22E0;
        Thu, 11 Mar 2021 22:59:59 +0000 (UTC)
Received: from dev-dsk-andyhsu-1c-d6833dcf.eu-west-1.amazon.com (10.43.160.27)
 by EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 22:59:55 +0000
From:   ChiaHao Hsu <andyhsu@amazon.com>
To:     <netdev@vger.kernel.org>
CC:     <wei.liu@kernel.org>, <paul@xen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andyhsu@amazon.com>,
        <xen-devel@lists.xenproject.org>
Subject: [net-next 1/2] xen-netback: add module parameter to disable ctrl-ring
Date:   Thu, 11 Mar 2021 22:59:44 +0000
Message-ID: <20210311225944.24198-1-andyhsu@amazon.com>
X-Mailer: git-send-email 2.23.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D42UWB003.ant.amazon.com (10.43.161.45) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support live migration of guests between kernels
that do and do not support 'feature-ctrl-ring', we add a
module parameter that allows the feature to be disabled
at run time, instead of using hardcode value.
The default value is enable.

Signed-off-by: ChiaHao Hsu <andyhsu@amazon.com>
---
 drivers/net/xen-netback/common.h  |  2 ++
 drivers/net/xen-netback/netback.c |  6 ++++++
 drivers/net/xen-netback/xenbus.c  | 23 ++++++++++++++---------
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 4a16d6e33c09..bfb7a3054917 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -276,6 +276,7 @@ struct backend_info {
 	u8 have_hotplug_status_watch:1;
 
 	const char *hotplug_script;
+	bool ctrl_ring_enabled;
 };
 
 struct xenvif {
@@ -413,6 +414,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 
 irqreturn_t xenvif_interrupt(int irq, void *dev_id);
 
+extern bool control_ring;
 extern bool separate_tx_rx_irq;
 extern bool provides_xdp_headroom;
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 39a01c2a3058..a119ae673862 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -48,6 +48,12 @@
 
 #include <asm/xen/hypercall.h>
 
+/* Provide an option to disable control ring which is used to pass
+ * large quantities of data from frontend to backend.
+ */
+bool control_ring = true;
+module_param(control_ring, bool, 0644);
+
 /* Provide an option to disable split event channels at load time as
  * event channels are limited resource. Split event channels are
  * enabled by default.
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index a5439c130130..9801b8d10239 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -755,10 +755,12 @@ static void connect(struct backend_info *be)
 	xen_register_watchers(dev, be->vif);
 	read_xenbus_vif_flags(be);
 
-	err = connect_ctrl_ring(be);
-	if (err) {
-		xenbus_dev_fatal(dev, err, "connecting control ring");
-		return;
+	if (be->ctrl_ring_enabled) {
+		err = connect_ctrl_ring(be);
+		if (err) {
+			xenbus_dev_fatal(dev, err, "connecting control ring");
+			return;
+		}
 	}
 
 	/* Use the number of queues requested by the frontend */
@@ -1123,11 +1125,14 @@ static int netback_probe(struct xenbus_device *dev,
 	if (err)
 		pr_debug("Error writing multi-queue-max-queues\n");
 
-	err = xenbus_printf(XBT_NIL, dev->nodename,
-			    "feature-ctrl-ring",
-			    "%u", true);
-	if (err)
-		pr_debug("Error writing feature-ctrl-ring\n");
+	be->ctrl_ring_enabled = READ_ONCE(control_ring);
+	if (be->ctrl_ring_enabled) {
+		err = xenbus_printf(XBT_NIL, dev->nodename,
+				    "feature-ctrl-ring",
+				    "%u", true);
+		if (err)
+			pr_debug("Error writing feature-ctrl-ring\n");
+	}
 
 	backend_switch_state(be, XenbusStateInitWait);
 
-- 
2.23.3


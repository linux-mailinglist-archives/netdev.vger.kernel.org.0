Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8631592C3
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgBKPST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:19 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62417 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgBKPSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434294; x=1612970294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnqPsiulblNDXF4SzB8Y1qoMe0wXSSOQnh9rSfIjUUM=;
  b=N4SbZWVUTf9XnR+dwXWxjcaUxCA6wgT7HfOtNzz6/NELPRCKYFCQ2Al4
   eUZENrc4tnEp5RfppyIErbQDtkwpcKSHdDpXrl0Dhc0bNvv4QHBYwDULY
   oP+qmvqpU6p/hovDwSzy+ZrbypIxfksk18HJP9law+pnPT4P0qZr8Lxdr
   I=;
IronPort-SDR: LwaYTOFBAPZplsb6Q7CKc7soVjdWwZy1ZfL+q3E7U2lf8uJSKIgIX30HNIC1veveIRBPf8lR9/
 WLO+ftr92dLg==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="24354287"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Feb 2020 15:18:14 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 3C05EA1F91;
        Tue, 11 Feb 2020 15:18:13 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:58 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1236.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:58 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id BE7BB81D44; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 12/12] net: ena: ena-com.c: prevent NULL pointer dereference
Date:   Tue, 11 Feb 2020 15:17:51 +0000
Message-ID: <20200211151751.29718-13-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200211151751.29718-1-sameehj@amazon.com>
References: <20200211151751.29718-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

comp_ctx can be NULL in a very rare case when an admin command is executed
during the execution of ena_remove().

The bug scenario is as follows:

* ena_destroy_device() sets the comp_ctx to be NULL
* An admin command is executed before executing unregister_netdev(),
  this can still happen because our device can still receive callbacks
  from the netdev infrastructure such as ethtool commands.
* When attempting to access the comp_ctx, the bug occurs since it's set
  to NULL

Fix:
Added a check that comp_ctx is not NULL

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 0f93d1092..1fb58f9ad 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -200,6 +200,11 @@ static void comp_ctxt_release(struct ena_com_admin_queue *queue,
 static struct ena_comp_ctx *get_comp_ctxt(struct ena_com_admin_queue *queue,
 					  u16 command_id, bool capture)
 {
+	if (unlikely(!queue->comp_ctx)) {
+		pr_err("Completion context is NULL\n");
+		return NULL;
+	}
+
 	if (unlikely(command_id >= queue->q_depth)) {
 		pr_err("command id is larger than the queue size. cmd_id: %u queue size %d\n",
 		       command_id, queue->q_depth);
-- 
2.24.1.AMZN


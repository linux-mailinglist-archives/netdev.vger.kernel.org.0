Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15ADD14CC0B
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgA2OEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:04:55 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:58261 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgA2OEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:04:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580306694; x=1611842694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+NC7xruYEt4luvDBzD9BoOrfS+SmhYmic98nIY+vu7c=;
  b=aPKowMQGrEukB1XN6faHFcuBzytlfXSfAH/7zmLfo6B1oekizKHkn7eJ
   UEGhMxwy4y4It1SCUEti+FLVqiRHXZoJJYU0Ume6NsQ+yiObcXBndgSAf
   DRrhcDa6du2o2jQRX3fT8qYACA9ZegfEWjLBvzpGOdxzlLJrw6RxreE7D
   U=;
IronPort-SDR: VIo/T1ZEQL73n/fBszwucuFa3lZN3eV0GE+57ECvjXQWLOYRDKRNgEfreVGbRTlTKRSIqNwcZ/
 GxVrYlXd1RiA==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="21799052"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Jan 2020 14:04:42 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 72337A1F72;
        Wed, 29 Jan 2020 14:04:41 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 Jan 2020 14:04:25 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id B2E9F81D1C; Wed, 29 Jan 2020 14:04:24 +0000 (UTC)
From:   Sameeh Jubran <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 11/11] net: ena: ena-com.c: prevent NULL pointer dereference
Date:   Wed, 29 Jan 2020 14:04:22 +0000
Message-ID: <20200129140422.20166-12-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200129140422.20166-1-sameehj@amazon.com>
References: <20200129140422.20166-1-sameehj@amazon.com>
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
index 43ba30081..a7061718e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -209,6 +209,11 @@ static void comp_ctxt_release(struct ena_com_admin_queue *queue,
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


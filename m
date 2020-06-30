Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A8220EED7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgF3GxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:53:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18030 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730386AbgF3GxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 02:53:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593499988; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=W1WFauB24QzsXYsIDNGNiXwnbyJ1ubjxkU3r8nRtgzg=; b=akDMBqUqcV8aJiEmwoNKs1sOCzJijRI7as+Et0WN6s1v2UuxLrPDHRpxan80+iAiV5IOsEzs
 594BLKWSzsXlpcU3MkFJidlYkw144lTOzH5EGv75phiArgEuBEZ7/qD8HW16KyVA2N5xq4NM
 azd8js3E8GVTFlFSyvg0SVU/ypI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5efae14bf3deea03f3128600 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 30 Jun 2020 06:52:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B53ECC433CB; Tue, 30 Jun 2020 06:52:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from cjhuang-station.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CD37C433C8;
        Tue, 30 Jun 2020 06:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CD37C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cjhuang@codeaurora.org
From:   Carl Huang <cjhuang@codeaurora.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: [PATCH v2] net: qrtr: free flow in __qrtr_node_release
Date:   Tue, 30 Jun 2020 14:52:51 +0800
Message-Id: <1593499971-9212-1-git-send-email-cjhuang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow is allocated in qrtr_tx_wait, but not freed when qrtr node
is released. (*slot) becomes NULL after radix_tree_iter_delete is
called in __qrtr_node_release. The fix is to save (*slot) to a
vairable and then free it.

This memory leak is catched when kmemleak is enabled in kernel,
the report looks like below:

unreferenced object 0xffffa0de69e08420 (size 32):
  comm "kworker/u16:3", pid 176, jiffies 4294918275 (age 82858.876s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 28 84 e0 69 de a0 ff ff  ........(..i....
    28 84 e0 69 de a0 ff ff 03 00 00 00 00 00 00 00  (..i............
  backtrace:
    [<00000000e252af0a>] qrtr_node_enqueue+0x38e/0x400 [qrtr]
    [<000000009cea437f>] qrtr_sendmsg+0x1e0/0x2a0 [qrtr]
    [<000000008bddbba4>] sock_sendmsg+0x5b/0x60
    [<0000000003beb43a>] qmi_send_message.isra.3+0xbe/0x110 [qmi_helpers]
    [<000000009c9ae7de>] qmi_send_request+0x1c/0x20 [qmi_helpers]

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
---
 net/qrtr/qrtr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 2d8d613..0598813 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -166,6 +166,7 @@ static void __qrtr_node_release(struct kref *kref)
 {
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
 	struct radix_tree_iter iter;
+	struct qrtr_tx_flow *flow;
 	unsigned long flags;
 	void __rcu **slot;
 
@@ -181,8 +182,9 @@ static void __qrtr_node_release(struct kref *kref)
 
 	/* Free tx flow counters */
 	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
 		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
-		kfree(*slot);
+		kfree(flow);
 	}
 	kfree(node);
 }
-- 
2.7.4


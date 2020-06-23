Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021992047E3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731627AbgFWDWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:22:17 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:44560 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731122AbgFWDWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:22:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592882535; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=3HYTrvrUNR1mh57SvwgZsB4E0REHnl3MkUCvY+NvhH4=; b=m8+1PMwTFtHG9nE/UN+Vl8Yr1ICfgKtXpe0EvbOJnw7NTJtUVneIkLtOiGEd7catIfqVDmiz
 ifUFPzeDkNvjRzqHRJlzlCL105QYMK3jkR2w0r2pgNx+BBcJoyb9hbVZbg7BW9VkHzKUbqic
 oQFLgpyCAIbbgpKfN/s00ErapRY=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n14.prod.us-east-1.postgun.com with SMTP id
 5ef175650206ad41d1acd0f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Jun 2020 03:22:13
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 974C5C433C8; Tue, 23 Jun 2020 03:22:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from cjhuang-station.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15B4BC433C6;
        Tue, 23 Jun 2020 03:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 15B4BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cjhuang@codeaurora.org
From:   Carl Huang <cjhuang@codeaurora.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: [PATCH] net: qrtr: free flow in __qrtr_node_release
Date:   Tue, 23 Jun 2020 11:22:03 +0800
Message-Id: <1592882523-12870-1-git-send-email-cjhuang@codeaurora.org>
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
index 2d8d613..1855857 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -168,6 +168,7 @@ static void __qrtr_node_release(struct kref *kref)
 	struct radix_tree_iter iter;
 	unsigned long flags;
 	void __rcu **slot;
+	struct qrtr_tx_flow *flow;
 
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	if (node->nid != QRTR_EP_NID_AUTO)
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


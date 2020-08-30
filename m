Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF85256EAF
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 16:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgH3OlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 10:41:16 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:43765 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgH3Oj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 10:39:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598798365; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=YsxKBIKWbk9+hM99fxRravC3T6qT3Gy/CmU0L8pLAw0=; b=B5/piHQs/yOV17JkIrdbyM0F76xPkC0NVQHkk/rhJhZlaAacks50Kab50p36BlfyId1UA5jV
 Wm6Uqbet/+XxYvysBXraAhMVp3BcTWoKvFK5we6AJsx1KrujQ/rfZnYob9TVBBLz0PQ2HDCn
 xg5ro9Bftc/9HGFF285I4PtB93Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f4bb9f2c4154e1df2124dfe (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 30 Aug 2020 14:38:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83F08C43395; Sun, 30 Aug 2020 14:38:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from deesin-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: deesin)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36322C433C6;
        Sun, 30 Aug 2020 14:38:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36322C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=deesin@codeaurora.org
From:   Deepak Kumar Singh <deesin@codeaurora.org>
To:     bjorn.andersson@linaro.org, clew@codeaurora.org
Cc:     mathieu.poirier@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Necip Fazil Yildiran <necip@google.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH V1 1/4] net: qrtr: Do not send packets before hello negotiation
Date:   Sun, 30 Aug 2020 20:08:09 +0530
Message-Id: <1598798292-5971-2-git-send-email-deesin@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
References: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

There is a race where broadcast packets can be sent to a node that has
not sent the hello message to the remote processor. This breaks the
protocol expectation. Add a status variable to track when the hello
packet has been sent.

An alternative solution attempted was to remove the nodes from the
broadcast list until the hello packet is sent. This is not a valid
solution because hello messages are broadcasted if the ns is restarted
or started late. There needs to be a status variable separate from the
broadcast list.
---
 net/qrtr/qrtr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 90c558f8..d9858a1 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -115,6 +115,7 @@ static DEFINE_MUTEX(qrtr_port_lock);
  * @ep: endpoint
  * @ref: reference count for node
  * @nid: node id
+ * @hello_sent: hello packet sent to endpoint
  * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
  * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
  * @rx_queue: receive queue
@@ -125,6 +126,7 @@ struct qrtr_node {
 	struct qrtr_endpoint *ep;
 	struct kref ref;
 	unsigned int nid;
+	atomic_t hello_sent;
 
 	struct radix_tree_root qrtr_tx_flow;
 	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
@@ -335,6 +337,11 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	int rc = -ENODEV;
 	int confirm_rx;
 
+	if (!atomic_read(&node->hello_sent) && type != QRTR_TYPE_HELLO) {
+		kfree_skb(skb);
+		return rc;
+	}
+
 	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
 	if (confirm_rx < 0) {
 		kfree_skb(skb);
@@ -370,6 +377,8 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	 * confirm_rx flag if we dropped this one */
 	if (rc && confirm_rx)
 		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
+	if (!rc && type == QRTR_TYPE_HELLO)
+		atomic_inc(&node->hello_sent);
 
 	return rc;
 }
@@ -563,6 +572,7 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	skb_queue_head_init(&node->rx_queue);
 	node->nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
+	atomic_set(&node->hello_sent, 0);
 
 	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
 	mutex_init(&node->qrtr_tx_lock);
@@ -854,6 +864,8 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	mutex_lock(&qrtr_node_lock);
 	list_for_each_entry(node, &qrtr_all_nodes, item) {
+		if (node->nid == QRTR_EP_NID_AUTO)
+			continue;
 		skbn = skb_clone(skb, GFP_KERNEL);
 		if (!skbn)
 			break;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


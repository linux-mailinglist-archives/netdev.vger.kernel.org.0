Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9F467B3AF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbjAYNup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjAYNuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:50:44 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Jan 2023 05:50:41 PST
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84509193CD;
        Wed, 25 Jan 2023 05:50:41 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 25 Jan
 2023 16:48:35 +0300
Received: from KANASHIN1.fintech.ru (10.0.253.125) by Ex16-01.fintech.ru
 (10.0.10.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 25 Jan
 2023 16:48:34 +0300
From:   Natalia Petrova <n.petrova@fintech.ru>
To:     Manivannan Sadhasivam <mani@kernel.org>
CC:     Natalia Petrova <n.petrova@fintech.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH] net: qrtr: free memory on error path in radix_tree_insert()
Date:   Wed, 25 Jan 2023 16:48:31 +0300
Message-ID: <20230125134831.8090-1-n.petrova@fintech.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.125]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function radix_tree_insert() returns errors if the node hasn't
been initialized and added to the tree.

"kfree(node)" and return value "NULL" of node_get() help
to avoid using unclear node in other calls.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
---
 net/qrtr/ns.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 1990d496fcfc..e595079c2caf 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -83,7 +83,10 @@ static struct qrtr_node *node_get(unsigned int node_id)
 
 	node->id = node_id;
 
-	radix_tree_insert(&nodes, node_id, node);
+	if (radix_tree_insert(&nodes, node_id, node)) {
+		kfree(node);
+		return NULL;
+	}
 
 	return node;
 }
-- 
2.34.1


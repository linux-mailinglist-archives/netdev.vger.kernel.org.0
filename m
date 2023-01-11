Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F587665488
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjAKG0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjAKG0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:26:02 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04241EB0;
        Tue, 10 Jan 2023 22:25:58 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NsHkD0k8sz8RV6K;
        Wed, 11 Jan 2023 14:25:56 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 30B6Pkjg075836;
        Wed, 11 Jan 2023 14:25:46 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 11 Jan 2023 14:25:48 +0800 (CST)
Date:   Wed, 11 Jan 2023 14:25:48 +0800 (CST)
X-Zmail-TransId: 2b0363be566c67d92096
X-Mailer: Zmail v1.0
Message-ID: <202301111425483027624@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <santosh.shilimkar@oracle.com>, <kuba@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0IHYyXSBuZXQvcmRzOiB1c2Ugc3Ryc2NweSgpIHRvIGluc3RlYWQgb2Ygc3RybmNweSgp?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 30B6Pkjg075836
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 63BE5674.000 by FangMail milter!
X-FangMail-Envelope: 1673418356/4NsHkD0k8sz8RV6K/63BE5674.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63BE5674.000/4NsHkD0k8sz8RV6K
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL-terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
---
change for v2
 - Use the returns of strscpy to make the copy and the preceding 
BUG_ON() together.Thanks to Jakub Kicinski. 
---
 net/rds/stats.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rds/stats.c b/net/rds/stats.c
index 9e87da43c004..7018c67418f5 100644
--- a/net/rds/stats.c
+++ b/net/rds/stats.c
@@ -88,9 +88,7 @@ void rds_stats_info_copy(struct rds_info_iterator *iter,
 	size_t i;

 	for (i = 0; i < nr; i++) {
-		BUG_ON(strlen(names[i]) >= sizeof(ctr.name));
-		strncpy(ctr.name, names[i], sizeof(ctr.name) - 1);
-		ctr.name[sizeof(ctr.name) - 1] = '\0';
+		BUG_ON(strscpy(ctr.name, names[i], sizeof(ctr.name)) < 0);
 		ctr.value = values[i];

 		rds_info_copy(iter, &ctr, sizeof(ctr));
-- 
2.15.2

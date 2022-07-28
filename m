Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55D8583757
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbiG1DKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiG1DK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:10:26 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9034BC0;
        Wed, 27 Jul 2022 20:10:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VKdXSoX_1658977820;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VKdXSoX_1658977820)
          by smtp.aliyun-inc.com;
          Thu, 28 Jul 2022 11:10:21 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next v2] tls: rx: Fix unsigned comparison with less than zero
Date:   Thu, 28 Jul 2022 11:10:19 +0800
Message-Id: <20220728031019.32838-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return from the call to tls_rx_msg_size() is int, it can be
a negative error code, however this is being assigned to an
unsigned long variable 'sz', so making 'sz' an int.

Eliminate the following coccicheck warning:
./net/tls/tls_strp.c:211:6-8: WARNING: Unsigned expression compared with zero: sz < 0

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

Changes in v2:
--According to Jakub's suggestion
Keep the sorting of the variable lines from longest to shortest.

 net/tls/tls_strp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index b945288c312e..841e721a8ec4 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -187,9 +187,10 @@ static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
 			   unsigned int offset, size_t in_len)
 {
 	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
-	size_t sz, len, chunk;
 	struct sk_buff *skb;
 	skb_frag_t *frag;
+	size_t len, chunk;
+	int sz;
 
 	if (strp->msg_ready)
 		return 0;
-- 
2.20.1.7.g153144c


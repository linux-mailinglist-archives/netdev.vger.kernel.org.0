Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640514EE6FB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244785AbiDAD7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiDAD7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:59:05 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D921E7452;
        Thu, 31 Mar 2022 20:57:16 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 1 Apr 2022
 11:57:15 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 1 Apr
 2022 11:57:13 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/ipv4: fix potential NULL dereference in sisfb_post_sis300()
Date:   Fri, 1 Apr 2022 11:57:12 +0800
Message-ID: <1648785432-21824-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-124.meizu.com (172.16.1.124) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

psin and psl could be null without checking null and return, so
we need to dereference after checking.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 net/ipv4/igmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 2ad3c7b..d400080 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2569,7 +2569,7 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 	    copy_to_user(optval, msf, IP_MSFILTER_SIZE(0))) {
 		return -EFAULT;
 	}
-	if (len &&
+	if (len && psl &&
 	    copy_to_user(&optval->imsf_slist_flex[0], psl->sl_addr, len))
 		return -EFAULT;
 	return 0;
@@ -2608,7 +2608,7 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 	count = psl ? psl->sl_count : 0;
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
-	for (i = 0; i < copycount; i++, p++) {
+	for (i = 0; i < copycount && psin && psl; i++, p++) {
 		struct sockaddr_storage ss;
 
 		psin = (struct sockaddr_in *)&ss;
-- 
2.7.4


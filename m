Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A89C55D6F4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbiF1Dbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 23:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbiF1Dbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 23:31:47 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57184BC9;
        Mon, 27 Jun 2022 20:31:46 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LX98d6Rb7zkX1C;
        Tue, 28 Jun 2022 11:30:25 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 11:31:44 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shjy180909@gmail.com>,
        <david.lebrun@uclouvain.be>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] net: ipv6: unexport __init-annotated seg6_hmac_net_init()
Date:   Tue, 28 Jun 2022 11:31:34 +0800
Message-ID: <20220628033134.21088-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As commit 5801f064e351 ("net: ipv6: unexport __init-annotated seg6_hmac_init()"),
EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

This remove the EXPORT_SYMBOL to fix modpost warning:

WARNING: modpost: vmlinux.o(___ksymtab+seg6_hmac_net_init+0x0): Section mismatch in reference from the variable __ksymtab_seg6_hmac_net_init to the function .init.text:seg6_hmac_net_init()
The symbol seg6_hmac_net_init is exported and annotated __init
Fix this by removing the __init annotation of seg6_hmac_net_init or drop the export.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ipv6/seg6_hmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 6de01185cc68..d43c50a7310d 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -406,7 +406,6 @@ int __net_init seg6_hmac_net_init(struct net *net)
 
 	return rhashtable_init(&sdata->hmac_infos, &rht_params);
 }
-EXPORT_SYMBOL(seg6_hmac_net_init);
 
 void seg6_hmac_exit(void)
 {
-- 
2.17.1


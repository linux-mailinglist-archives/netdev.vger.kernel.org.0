Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01853D510
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 05:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348995AbiFDD2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 23:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiFDD2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 23:28:46 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F32F245B2;
        Fri,  3 Jun 2022 20:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=XL0red14pGxL6sCfZN
        8Z7IQ85QnVVwGdCx/2kOkLR0c=; b=OjrbsAM0XFEX76OcRz20q+j1/OZguFEYV1
        gt78V4wV7FAX9uUi4FJXX3SCNSQ1WvnykSdFFq6gDIN7VAC/+MgLv+plu2uWYFlj
        tfccXu5D4/PxMuH/OKlr7nn1vfiEUBRRNrFun/9RdJhgdE6qwFyJMFt02FjUefHg
        Vs73GtrQ8=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp9 (Coremail) with SMTP id DcCowACXv+NL0ZpiGY58Gw--.4359S4;
        Sat, 04 Jun 2022 11:28:16 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     hifoolno <553441439@qq.com>
Subject: [PATCH 2/2] SUNRPC: Fix infinite looping in rpc_clnt_iterate_for_each_xprt
Date:   Sat,  4 Jun 2022 11:28:10 +0800
Message-Id: <20220604032810.12602-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DcCowACXv+NL0ZpiGY58Gw--.4359S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr43ZFyDKFWxCFWkArWDJwb_yoW8Gry7p3
        4UGryruF1kKF47tw1Iyr4kua1I9w4fGF1UGFWkC3s8Ar1DJFykJw1Ikr4jvrZ2kFs5Gr1a
        gry2kw45Aa4kAa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_eHqrUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiTREWMFc7YPoNcAAAsx
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hifoolno <553441439@qq.com>

If there were less than 2 entries in the multipath list, then
xprt_iter_current_entry() would never advance beyond the
first entry, which is correct for round robin behaviour, but not
for the list iteration.

The end result would be infinite looping in rpc_clnt_iterate_for_each_xprt()
as we would never see the xprt == NULL condition fulfilled.

Signed-off-by: hifoolno <553441439@qq.com>
---
 net/sunrpc/xprtmultipath.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtmultipath.c b/net/sunrpc/xprtmultipath.c
index 1693f81aae37..23c3aae1bb5b 100644
--- a/net/sunrpc/xprtmultipath.c
+++ b/net/sunrpc/xprtmultipath.c
@@ -278,14 +278,12 @@ static
 struct rpc_xprt *xprt_iter_current_entry(struct rpc_xprt_iter *xpi)
 {
 	struct rpc_xprt_switch *xps = rcu_dereference(xpi->xpi_xpswitch);
-	struct list_head *head;
 
 	if (xps == NULL)
 		return NULL;
-	head = &xps->xps_xprt_list;
-	if (xpi->xpi_cursor == NULL || xps->xps_nxprts < 2)
-		return xprt_switch_find_first_entry(head);
-	return xprt_switch_find_current_entry(head, xpi->xpi_cursor);
+	return xprt_switch_set_next_cursor(&xps->xps_xprt_list,
+		&xpi->xpi_cursor,
+		find_next);
 }
 
 bool rpc_xprt_switch_has_addr(struct rpc_xprt_switch *xps,
-- 
2.17.1


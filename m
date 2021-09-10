Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A401406925
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 11:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhIJJep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 05:34:45 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57785 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231818AbhIJJeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 05:34:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UntYNdL_1631266409;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UntYNdL_1631266409)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Sep 2021 17:33:31 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, anna.schumaker@netapp.com,
        trond.myklebust@hammerspace.com, chuck.lever@oracle.com,
        bfields@fieldses.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] UNRPC: Return specific error code on kmalloc failure
Date:   Fri, 10 Sep 2021 17:33:24 +0800
Message-Id: <1631266404-29698-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the callers of this function only care about whether the
return value is null or not, we should still give a rigorous
error code.

Smatch tool warning:
net/sunrpc/auth_gss/svcauth_gss.c:784 gss_write_verf() warn: returning
-1 instead of -ENOMEM is sloppy

No functional change, just more standardized.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 3e776e3..7dba6a9 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -781,7 +781,7 @@ static inline u32 round_up_to_quad(u32 i)
 	svc_putnl(rqstp->rq_res.head, RPC_AUTH_GSS);
 	xdr_seq = kmalloc(4, GFP_KERNEL);
 	if (!xdr_seq)
-		return -1;
+		return -ENOMEM;
 	*xdr_seq = htonl(seq);
 
 	iov.iov_base = xdr_seq;
-- 
1.8.3.1


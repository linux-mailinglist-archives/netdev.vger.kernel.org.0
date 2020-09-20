Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2C27143C
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgITMQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 08:16:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33987 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbgITMQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 08:16:26 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2020 08:16:20 EDT
X-IronPort-AV: E=Sophos;i="5.77,282,1596492000"; 
   d="scan'208";a="468612193"
Received: from palace.lip6.fr ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 20 Sep 2020 14:08:58 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] RDS: drop double zeroing
Date:   Sun, 20 Sep 2020 13:26:19 +0200
Message-Id: <1600601186-7420-8-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sg_init_table zeroes its first argument, so the allocation of that argument
doesn't have to.

the semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,n,flags;
@@

x = 
- kcalloc
+ kmalloc_array
  (n,sizeof(*x),flags)
...
sg_init_table(x,n)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/rds/rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/rds/rdma.c b/net/rds/rdma.c
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -269,7 +269,7 @@ static int __rds_rdma_map(struct rds_soc
 		goto out;
 	} else {
 		nents = ret;
-		sg = kcalloc(nents, sizeof(*sg), GFP_KERNEL);
+		sg = kmalloc_array(nents, sizeof(*sg), GFP_KERNEL);
 		if (!sg) {
 			ret = -ENOMEM;
 			goto out;


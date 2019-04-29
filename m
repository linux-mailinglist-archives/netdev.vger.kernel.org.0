Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD3DBD2
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfD2GPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:15:33 -0400
Received: from www.osadl.org ([62.245.132.105]:41153 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfD2GPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 02:15:32 -0400
Received: from debian01.hofrr.at (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x3T6FCqA007063;
        Mon, 29 Apr 2019 08:15:12 +0200
From:   Nicholas Mc Guire <hofrat@osadl.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] rds: ib: force endiannes annotation
Date:   Mon, 29 Apr 2019 08:09:38 +0200
Message-Id: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
X-Mailer: git-send-email 2.1.4
X-Spam-Status: No, score=-1.9 required=6.0 tests=BAYES_00 autolearn=ham
        version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on www.osadl.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the endiannes is being handled correctly as indicated by the comment
above the offending line - sparse was unhappy with the missing annotation
as be64_to_cpu() expects a __be64 argument. To mitigate this annotation
issue forced annotation is introduced. Note that this patch has no impact
on the generated binary.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Problem located by an experimental coccinelle script to locate
patters that make sparse unhappy (false positives):
net/rds/ib_recv.c:827:23: warning: cast to restricted __le64

Patch was compile-tested with: x86_64_defconfig + RDS_RDMA=m

Patch was verified not to change the binary by diffing the
generated object code before and after applying the patch.

Patch is against 5.1-rc6 (localversion-next is 20190426)

 net/rds/ib_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 7055985..a070a2d 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -824,7 +824,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 	}
 
 	/* the congestion map is in little endian order */
-	uncongested = le64_to_cpu(uncongested);
+	uncongested = le64_to_cpu((__force __le64)uncongested);
 
 	rds_cong_map_updated(map, uncongested);
 }
-- 
2.1.4


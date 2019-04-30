Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10CEEF24
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 05:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbfD3DTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 23:19:01 -0400
Received: from www.osadl.org ([62.245.132.105]:53929 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729931AbfD3DTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 23:19:01 -0400
Received: from debian01.hofrr.at (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x3U3IZKT005484;
        Tue, 30 Apr 2019 05:18:35 +0200
From:   Nicholas Mc Guire <hofrat@osadl.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH V2] rds: ib: force endiannes annotation
Date:   Tue, 30 Apr 2019 05:12:57 +0200
Message-Id: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
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
all involved variables are changed to a consistent __le64 and the
 conversion to uint64_t delayed to the call to rds_cong_map_updated().

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Problem located by an experimental coccinelle script to locate
patters that make sparse unhappy (false positives):
net/rds/ib_recv.c:827:23: warning: cast to restricted __le64

V2: Edward Cree <ecree@solarflare.com> rejected the need for using __force
    here - instead solve the sparse issue by updating all of the involved
    variables - which results in an identical binary as well without using
    the __force "solution" to the sparse warning. Thanks !

Patch was compile-tested with: x86_64_defconfig + INFINIBAND=m, RDS_RDMA=m

Patch was verified not to change the binary by diffing the
generated object code before and after applying the patch.

Patch is against 5.1-rc6 (localversion-next is 20190429)

 net/rds/ib_recv.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 7055985..8946c89 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -772,7 +772,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 	unsigned long frag_off;
 	unsigned long to_copy;
 	unsigned long copied;
-	uint64_t uncongested = 0;
+	__le64 uncongested = 0;
 	void *addr;
 
 	/* catch completely corrupt packets */
@@ -789,7 +789,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 	copied = 0;
 
 	while (copied < RDS_CONG_MAP_BYTES) {
-		uint64_t *src, *dst;
+		__le64 *src, *dst;
 		unsigned int k;
 
 		to_copy = min(RDS_FRAG_SIZE - frag_off, PAGE_SIZE - map_off);
@@ -824,9 +824,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
 	}
 
 	/* the congestion map is in little endian order */
-	uncongested = le64_to_cpu(uncongested);
-
-	rds_cong_map_updated(map, uncongested);
+	rds_cong_map_updated(map, le64_to_cpu(uncongested));
 }
 
 static void rds_ib_process_recv(struct rds_connection *conn,
-- 
2.1.4


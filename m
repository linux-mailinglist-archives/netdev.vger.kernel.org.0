Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534892062CC
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391637AbgFWUe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:58 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:7938 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391629AbgFWUez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:55 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYrRc019540;
        Tue, 23 Jun 2020 13:34:54 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 07/12] cxgb4: fix SGE queue dump destination buffer context
Date:   Wed, 24 Jun 2020 01:51:37 +0530
Message-Id: <5ac3026f105af71095c7002506b756b52c0faf23.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data in destination buffer is expected to be be parsed in big
endian. So, use the right context.

Fixes following sparse warning:
cudbg_lib.c:2041:44: warning: incorrect type in assignment (different
base types)
cudbg_lib.c:2041:44:    expected unsigned long long [usertype]
cudbg_lib.c:2041:44:    got restricted __be64 [usertype]

Fixes: 736c3b94474e ("cxgb4: collect egress and ingress SGE queue contexts")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 7b9cd69f9844..d8ab8e366818 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1975,7 +1975,6 @@ int cudbg_collect_dump_context(struct cudbg_init *pdbg_init,
 	u8 mem_type[CTXT_INGRESS + 1] = { 0 };
 	struct cudbg_buffer temp_buff = { 0 };
 	struct cudbg_ch_cntxt *buff;
-	u64 *dst_off, *src_off;
 	u8 *ctx_buf;
 	u8 i, k;
 	int rc;
@@ -2044,8 +2043,11 @@ int cudbg_collect_dump_context(struct cudbg_init *pdbg_init,
 		}
 
 		for (j = 0; j < max_ctx_qid; j++) {
+			__be64 *dst_off;
+			u64 *src_off;
+
 			src_off = (u64 *)(ctx_buf + j * SGE_CTXT_SIZE);
-			dst_off = (u64 *)buff->data;
+			dst_off = (__be64 *)buff->data;
 
 			/* The data is stored in 64-bit cpu order.  Convert it
 			 * to big endian before parsing.
-- 
2.24.0


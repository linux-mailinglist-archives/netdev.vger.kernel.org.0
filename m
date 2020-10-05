Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF32283EED
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgJESnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:43:23 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:51788 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgJESnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 14:43:22 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 095IhFDK015506;
        Mon, 5 Oct 2020 11:43:16 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net v2] net/tls: sendfile fails with ktls offload
Date:   Tue,  6 Oct 2020 00:13:13 +0530
Message-Id: <20201005184313.3887-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At first when sendpage gets called, if there is more data, 'more' in
tls_push_data() gets set which later sets pending_open_record_frags, but
when there is no more data in file left, and last time tls_push_data()
gets called, pending_open_record_frags doesn't get reset. And later when
2 bytes of encrypted alert comes as sendmsg, it first checks for
pending_open_record_frags, and since this is set, it creates a record with
0 data bytes to encrypt, meaning record length is prepend_size + tag_size
only, which causes problem.
 We should set/reset pending_open_record_frags based on more bit.

Also incase if tls_do_allocation() fails, and if record len is only
prepend_size, then destroy the record.

v1->v2:
- handle tls_do_allocation() failure handling.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_device.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b74e2741f74f..f3efd53e31cf 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -463,17 +463,16 @@ static int tls_push_data(struct sock *sk,
 			if (!record)
 				break;
 handle_error:
-			if (record_type != TLS_RECORD_TYPE_DATA) {
-				/* avoid sending partial
-				 * record with type !=
-				 * application_data
-				 */
-				size = orig_size;
-				destroy_record(record);
-				ctx->open_record = NULL;
-			} else if (record->len > prot->prepend_size) {
+			/* avoid sending partial record with type !=
+			 * application_data
+			 */
+			if (record_type == TLS_RECORD_TYPE_DATA &&
+			    record->len > prot->prepend_size)
 				goto last_record;
-			}
+
+			size = orig_size;
+			destroy_record(record);
+			ctx->open_record = NULL;
 
 			break;
 		}
@@ -492,11 +491,11 @@ static int tls_push_data(struct sock *sk,
 		if (!size) {
 last_record:
 			tls_push_record_flags = flags;
-			if (more) {
-				tls_ctx->pending_open_record_frags =
-						!!record->num_frags;
+			/* set/clear pending_open_record_frags based on more */
+			tls_ctx->pending_open_record_frags = !!more;
+
+			if (more)
 				break;
-			}
 
 			done = true;
 		}
-- 
2.18.1


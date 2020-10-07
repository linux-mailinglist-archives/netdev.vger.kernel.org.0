Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1C9286783
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgJGSk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:40:29 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:21676 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgJGSk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:40:29 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 097IeMDB023806;
        Wed, 7 Oct 2020 11:40:23 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net v3] net/tls: sendfile fails with ktls offload
Date:   Thu,  8 Oct 2020 00:10:21 +0530
Message-Id: <20201007184021.27584-1-rohitm@chelsio.com>
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

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_device.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b74e2741f74f..cec86229a6a0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -418,14 +418,14 @@ static int tls_push_data(struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
-	int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
 	struct tls_record_info *record = ctx->open_record;
 	int tls_push_record_flags;
 	struct page_frag *pfrag;
 	size_t orig_size = size;
 	u32 max_open_record_len;
-	int copy, rc = 0;
+	bool more = false;
 	bool done = false;
+	int copy, rc = 0;
 	long timeo;
 
 	if (flags &
@@ -492,9 +492,8 @@ static int tls_push_data(struct sock *sk,
 		if (!size) {
 last_record:
 			tls_push_record_flags = flags;
-			if (more) {
-				tls_ctx->pending_open_record_frags =
-						!!record->num_frags;
+			if (flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE)) {
+				more = true;
 				break;
 			}
 
@@ -526,6 +525,8 @@ static int tls_push_data(struct sock *sk,
 		}
 	} while (!done);
 
+	tls_ctx->pending_open_record_frags = more;
+
 	if (orig_size - size > 0)
 		rc = orig_size - size;
 
-- 
2.18.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8C7276B33
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgIXHuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:50:39 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36626 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbgIXHuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:50:39 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08O7oRG2003610;
        Thu, 24 Sep 2020 00:50:28 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     vakul.garg@nxp.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] net/tls: sendfile fails with ktls offload
Date:   Thu, 24 Sep 2020 13:20:25 +0530
Message-Id: <20200924075025.11626-1-rohitm@chelsio.com>
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
 net/tls/tls_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b74e2741f74f..a02aadefd86e 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -492,11 +492,11 @@ static int tls_push_data(struct sock *sk,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB631DB7DD
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgETPOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:14:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60027 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726439AbgETPOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:14:14 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 May 2020 18:14:12 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04KFEC4o005725;
        Wed, 20 May 2020 18:14:12 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net] net/tls: Fix driver request resync
Date:   Wed, 20 May 2020 18:14:08 +0300
Message-Id: <20200520151408.8080-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

In driver request resync, the hardware requests a resynchronization
request at some TCP sequence number. If that TCP sequence number does
not point to a TLS record header, then the resync attempt has failed.

Failed resync should reset the resync request to avoid spurious resyncs
after the TCP sequence number has wrapped around.

Fix this by resetting the resync request when the TLS record header
sequence number is not before the requested sequence number.
As a result, drivers may be called with a sequence number that is not
equal to the requested sequence number.

Fixes: f953d33ba122 ("net/tls: add kernel-driven TLS RX resync")
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a562ebaaa33c..cbb13001b4a9 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -714,7 +714,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		seq += TLS_HEADER_SIZE - 1;
 		is_req_pending = resync_req;
 
-		if (likely(!is_req_pending) || req_seq != seq ||
+		if (likely(!is_req_pending) || before(seq, req_seq) ||
 		    !atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
 			return;
 		break;
-- 
2.21.0


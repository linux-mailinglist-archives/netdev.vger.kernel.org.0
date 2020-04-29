Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916601BE967
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD2U7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:59:38 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36243 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgD2U7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 16:59:37 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 011146ed;
        Wed, 29 Apr 2020 20:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=JMN3eQobRtPSWjOTCZKaKtdG4
        7w=; b=osxgbmb5wX0CaawVLx/OiVjfAfJrL6m7YZN5D+R9I/C4s5LDkjoRp+rV8
        rl+uwkLK1Q4JmxNguKHBzc/QtBn1NdqZC5LrEi0XQQ3QHSDix7PogNlCXKmn4o3e
        VaW6lKSyMyqoqgMHtrH3CZSJXG2sSVHTFXArMfb2uIMtq5U97Mph5mneA+5sW5mA
        FsDip0cQ3joEYX/aUFv79nTF7xjhy+cwtycjO2QuUlCaK73wwaAyx+B5lTymt/ZQ
        WACXhgYXRMfCUEZ7bBY+T26WSxUVY3vNrDsQ0YBQa5HANVo4e3BSjRo/WnSNLu19
        mwY4T90HinFYMAiljLVKt8LPWMAPg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 327c4750 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 29 Apr 2020 20:47:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH net 2/3] wireguard: queueing: cleanup ptr_ring in error path of packet_queue_init
Date:   Wed, 29 Apr 2020 14:59:21 -0600
Message-Id: <20200429205922.295361-3-Jason@zx2c4.com>
In-Reply-To: <20200429205922.295361-1-Jason@zx2c4.com>
References: <20200429205922.295361-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior, if the alloc_percpu of packet_percpu_multicore_worker_alloc
failed, the previously allocated ptr_ring wouldn't be freed. This commit
adds the missing call to ptr_ring_cleanup in the error case.

Reported-by: Sultan Alsawaf <sultan@kerneltoast.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/queueing.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/queueing.c b/drivers/net/wireguard/queueing.c
index 5c964fcb994e..71b8e80b58e1 100644
--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -35,8 +35,10 @@ int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
 		if (multicore) {
 			queue->worker = wg_packet_percpu_multicore_worker_alloc(
 				function, queue);
-			if (!queue->worker)
+			if (!queue->worker) {
+				ptr_ring_cleanup(&queue->ring, NULL);
 				return -ENOMEM;
+			}
 		} else {
 			INIT_WORK(&queue->work, function);
 		}
-- 
2.26.2


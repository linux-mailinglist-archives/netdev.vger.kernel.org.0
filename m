Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAAE4EB7D1
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbiC3Bda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiC3Bd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D93E16F6CE;
        Tue, 29 Mar 2022 18:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A4061221;
        Wed, 30 Mar 2022 01:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724DCC34111;
        Wed, 30 Mar 2022 01:31:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RH0saXTs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648603900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUinn6m3Z5J5lKblf52dVgCEjQFWpfmxs9yF3JGTgdI=;
        b=RH0saXTspWNr9uMwZM1ALcsyfRGaRXJ8OgylonY12+w3TLymgSgqQ3TUYrKzsF4NVDWtfV
        WB0+g0fsInzMa/0700+ysn5C0tTgjziuaeEEApc0e7fjtI5yLb/Gqu7dSHgDUfGU3O9yg1
        2f91BwemclhrlD5sBXUVuKYRWj6O1ts=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6981dbf4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Mar 2022 01:31:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        PaX Team <pageexec@freemail.hu>, stable@vger.kernel.org
Subject: [PATCH net 1/4] wireguard: queueing: use CFI-safe ptr_ring cleanup function
Date:   Tue, 29 Mar 2022 21:31:24 -0400
Message-Id: <20220330013127.426620-2-Jason@zx2c4.com>
In-Reply-To: <20220330013127.426620-1-Jason@zx2c4.com>
References: <20220330013127.426620-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We make too nuanced use of ptr_ring to entirely move to the skb_array
wrappers, but we at least should avoid the naughty function pointer cast
when cleaning up skbs. Otherwise RAP/CFI will honk at us. This patch
uses the __skb_array_destroy_skb wrapper for the cleanup, rather than
directly providing kfree_skb, which is what other drivers in the same
situation do too.

Reported-by: PaX Team <pageexec@freemail.hu>
Fixes: 886fcee939ad ("wireguard: receive: use ring buffer for incoming handshakes")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/queueing.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/queueing.c b/drivers/net/wireguard/queueing.c
index 1de413b19e34..8084e7408c0a 100644
--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -4,6 +4,7 @@
  */
 
 #include "queueing.h"
+#include <linux/skb_array.h>
 
 struct multicore_worker __percpu *
 wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr)
@@ -42,7 +43,7 @@ void wg_packet_queue_free(struct crypt_queue *queue, bool purge)
 {
 	free_percpu(queue->worker);
 	WARN_ON(!purge && !__ptr_ring_empty(&queue->ring));
-	ptr_ring_cleanup(&queue->ring, purge ? (void(*)(void*))kfree_skb : NULL);
+	ptr_ring_cleanup(&queue->ring, purge ? __skb_array_destroy_skb : NULL);
 }
 
 #define NEXT(skb) ((skb)->prev)
-- 
2.35.1


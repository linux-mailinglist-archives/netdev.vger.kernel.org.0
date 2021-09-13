Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3571240A0FA
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 00:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349808AbhIMWnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 18:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349291AbhIMWlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 18:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9A2160E8B;
        Mon, 13 Sep 2021 22:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572732;
        bh=85Ugcv1CuFxPU7L+yJ7K8z+QHwuNH2jYGdd8ioVW5Mk=;
        h=From:To:Cc:Subject:Date:From;
        b=JTM/MrgWgjNgXxl0HYA+3lwga0pJHI4VmeVH5S3R+zYB2KIBP0UJUk9lCxG/TyMZl
         JEWJgg2RiwCYUD5Mrcy2DXgUPxRrG6l4eidN/pLymIJnnfApt92WnddkhMk3y8htnM
         l1gE3y0vgYekL/+54IrEm0aKFKrgLLknVePsCHWdB/95r1rK7qbLOASpNVohk/EFo5
         BwVfOHTe/Gxlutm8/HpkYBsf/0jSqxYLCbTTdJ3GaOQgzKP+vHrPEgOKovuRcpozdH
         QdDYYj8lKhYBhF53Cqr3CPxY5qtCvxVQMcwC4jvKKFcF/bMdUJkBJCZVqOJs3kV7te
         XQnq7mjf9s0Dw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     eric.dumazet@gmail.com
Cc:     willemb@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net] net: stream: don't purge sk_error_queue without holding its lock
Date:   Mon, 13 Sep 2021 15:38:50 -0700
Message-Id: <20210913223850.660578-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_stream_kill_queues() can be called when there are still
outstanding skbs to transmit. Those skbs may try to queue
notifications to the error queue (e.g. timestamps).
If sk_stream_kill_queues() purges the queue without taking
its lock the queue may get corrupted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Sending as an RFC for review, compile-tested only.

Seems far more likely that I'm missing something than that
this has been broken forever and nobody noticed :S
---
 net/core/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index 4f1d4aa5fb38..7c585088f394 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -196,7 +196,7 @@ void sk_stream_kill_queues(struct sock *sk)
 	__skb_queue_purge(&sk->sk_receive_queue);
 
 	/* Next, the error queue. */
-	__skb_queue_purge(&sk->sk_error_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 
 	/* Next, the write queue. */
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
-- 
2.31.1


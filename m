Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07046D158E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 04:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjCaCXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 22:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCaCXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 22:23:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8C1CDF7
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 19:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 238BEB82B8B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8655EC433EF;
        Fri, 31 Mar 2023 02:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680229399;
        bh=lsr+0ulkaP5XZXXrcIWuG7vbtLhB54HSpcW3EcuHNXY=;
        h=From:To:Cc:Subject:Date:From;
        b=LTMgAbX98IOtNXydten3deS+rDVjOj+a9vICl4Qi0scsMEWE5V5NU9GPMzXFpw8uO
         9sS8IKDXkwS9pYcEfaFfK9QOFNsDW3BQ/v9FV4/0XameqcT1SgsTOJ/apga8xXZn/g
         sIUqZgM7RxQ1PJ0pTmjpVL5uhOmWlg5uHyus3pTJ924QKWlJagWBvTcQe1O7sdP5bi
         iqujvUTC4BdvN4xMSgS5TDphW/eR9p0B8HepB3WovmYVBECPd63S+swVduOPAElBzK
         08lq+hRUyBmgAFYL8X2IRgQ6HrN9EQ7Uqt7MwvvOt5ZvN08VHmJBp+JTnwVk3P/uhn
         OZcMA1rka7/2w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, leitao@debian.org,
        shemminger@linux.foundation.org
Subject: [PATCH net] net: don't let netpoll invoke NAPI if in xmit context
Date:   Thu, 30 Mar 2023 19:21:44 -0700
Message-Id: <20230331022144.2998493-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix") narrowed
down the region under netif_tx_trylock() inside netpoll_send_skb().
(At that point in time netif_tx_trylock() would lock all queues of
the device.) Taking the tx lock was problematic because driver's
cleanup method may take the same lock. So the change made us hold
the xmit lock only around xmit, and expected the driver to take
care of locking within ->ndo_poll_controller().

Unfortunately this only works if netpoll isn't itself called with
the xmit lock already held. Netpoll code is careful and uses
trylock(). The drivers, however, may be using plain lock().
Printing while holding the xmit lock is going to result in rare
deadlocks.

Luckily we record the xmit lock owners, so we can scan all the queues,
the same way we scan NAPI owners. If any of the xmit locks is held
by the local CPU we better not attempt any polling.

It would be nice if we could narrow down the check to only the NAPIs
and the queue we're trying to use. I don't see a way to do that now.

Reported-by: Roman Gushchin <roman.gushchin@linux.dev>
Fixes: 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: leitao@debian.org
CC: shemminger@linux.foundation.org
---
 net/core/netpoll.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index a089b704b986..e6a739b1afa9 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -137,6 +137,20 @@ static void queue_process(struct work_struct *work)
 	}
 }
 
+static int netif_local_xmit_active(struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
+
+		if (READ_ONCE(txq->xmit_lock_owner) == smp_processor_id())
+			return 1;
+	}
+
+	return 0;
+}
+
 static void poll_one_napi(struct napi_struct *napi)
 {
 	int work;
@@ -183,7 +197,10 @@ void netpoll_poll_dev(struct net_device *dev)
 	if (!ni || down_trylock(&ni->dev_lock))
 		return;
 
-	if (!netif_running(dev)) {
+	/* Some drivers will take the same locks in poll and xmit,
+	 * we can't poll if local CPU is already in xmit.
+	 */
+	if (!netif_running(dev) || netif_local_xmit_active(dev)) {
 		up(&ni->dev_lock);
 		return;
 	}
-- 
2.39.2


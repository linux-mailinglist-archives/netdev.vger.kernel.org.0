Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3353056B2CC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiGHGdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiGHGdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:33:16 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63DA24BDE;
        Thu,  7 Jul 2022 23:33:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657261992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wMj0rNqJktrmg9SQYqpgpSwCODUUJ7vqMo6vdS1piJY=;
        b=KDal/ch4EdfRRYIsG/hkoGvLojdMBXkdDy2BJADEFHbG5cMIaIjY7G3PfqQv0ktpMo33w9
        i/Eysa+oKPta5y55ZKJQp0okPFHs3dBnsnf+dWSHcOeUutEst1hHVefItXpzm0H2Q7CmyL
        9bx04Qcp84MuOFax4LjQIHrBRkNPjqs=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: rtnetlink: add rx_otherhost_dropped for struct rtnl_link_stats
Date:   Fri,  8 Jul 2022 14:32:57 +0800
Message-Id: <20220708063257.1192311-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")
introduce rx_otherhost_dropped, add rx_otherhost_dropped for struct
rtnl_link_stats to keep sync with struct rtnl_link_stats64.

As the same time, add BUILD_BUG_ON() in copy_rtnl_link_stats().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         | 36 +++++++-----------------------------
 2 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..fd6776d665c8 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -37,6 +37,7 @@ struct rtnl_link_stats {
 	__u32	tx_compressed;
 
 	__u32	rx_nohandler;
+	__u32   rx_otherhost_dropped;
 };
 
 /**
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f7..818649850b2c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -908,35 +908,13 @@ static unsigned int rtnl_dev_combine_flags(const struct net_device *dev,
 static void copy_rtnl_link_stats(struct rtnl_link_stats *a,
 				 const struct rtnl_link_stats64 *b)
 {
-	a->rx_packets = b->rx_packets;
-	a->tx_packets = b->tx_packets;
-	a->rx_bytes = b->rx_bytes;
-	a->tx_bytes = b->tx_bytes;
-	a->rx_errors = b->rx_errors;
-	a->tx_errors = b->tx_errors;
-	a->rx_dropped = b->rx_dropped;
-	a->tx_dropped = b->tx_dropped;
-
-	a->multicast = b->multicast;
-	a->collisions = b->collisions;
-
-	a->rx_length_errors = b->rx_length_errors;
-	a->rx_over_errors = b->rx_over_errors;
-	a->rx_crc_errors = b->rx_crc_errors;
-	a->rx_frame_errors = b->rx_frame_errors;
-	a->rx_fifo_errors = b->rx_fifo_errors;
-	a->rx_missed_errors = b->rx_missed_errors;
-
-	a->tx_aborted_errors = b->tx_aborted_errors;
-	a->tx_carrier_errors = b->tx_carrier_errors;
-	a->tx_fifo_errors = b->tx_fifo_errors;
-	a->tx_heartbeat_errors = b->tx_heartbeat_errors;
-	a->tx_window_errors = b->tx_window_errors;
-
-	a->rx_compressed = b->rx_compressed;
-	a->tx_compressed = b->tx_compressed;
-
-	a->rx_nohandler = b->rx_nohandler;
+	size_t i, n = sizeof(*b) / sizeof(u64);
+	const u64 *src = (const u64 *)b;
+	u32 *dst = (u32 *)a;
+
+	BUILD_BUG_ON(n != sizeof(*a) / sizeof(u32));
+	for (i = 0; i < n; i++)
+		dst[i] = src[i];
 }
 
 /* All VF info */
-- 
2.25.1


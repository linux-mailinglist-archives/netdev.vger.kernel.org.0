Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4BD481E6E
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbhL3RKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:10:19 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45802 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbhL3RKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:10:19 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id C406D200E7B8;
        Thu, 30 Dec 2021 18:10:17 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be C406D200E7B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640884217;
        bh=r0NP3M/rKZGq8PU2jxtFEQVh5CFrpUsVavTdEU8zpdU=;
        h=From:To:Cc:Subject:Date:From;
        b=ceJdn6uLXQ41iApaAMkl3Y7b86geuCtz1L+8kDk/FUDqZYNLRPbzn+LdoNfnNGMcu
         /MJd6IyYNy9ydZf3kiZTK1qz/bUw668NvikU88I2WJLAoiL7Lqe4cIRfDsWB3R4+Th
         xnjE0Ifc8LUHixZJyZEwGjOnOrBUQYfI2QvIzibLwlLXsKNvwXuY1pOjby5flkBjYk
         LHj2PhfzRrV5Tzk9cd6AZZmHPcLlN8GbLrHdXDaBDQwBQvKKfbbFCcJME8cnabNyQY
         UY8qLCJEypFibaLpAeDbRydu+7skspWshyg3mTg1UBcYc6NwqQsO2dVqfMubICrKMH
         RzF2aDDn5GFOQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, idosch@idosch.org, justin.iurman@uliege.be
Subject: [PATCH net-next v3] ipv6: ioam: Support for Queue depth data field
Date:   Thu, 30 Dec 2021 18:10:04 +0100
Message-Id: <20211230171004.16368-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
 - Report 'backlog' (bytes) instead of 'qlen' (number of packets)

v2:
 - Fix sparse warning (use rcu_dereference)

This patch adds support for the queue depth in IOAM trace data fields.

The draft [1] says the following:

   The "queue depth" field is a 4-octet unsigned integer field.  This
   field indicates the current length of the egress interface queue of
   the interface from where the packet is forwarded out.  The queue
   depth is expressed as the current amount of memory buffers used by
   the queue (a packet could consume one or more memory buffers,
   depending on its size).

An existing function (i.e., qdisc_qstats_qlen_backlog) is used to
retrieve the current queue length without reinventing the wheel.

Note: it was tested and qlen is increasing when an artificial delay is
added on the egress with tc.

  [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.7

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 122a3d47424c..e159eb4328a8 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -13,10 +13,12 @@
 #include <linux/ioam6.h>
 #include <linux/ioam6_genl.h>
 #include <linux/rhashtable.h>
+#include <linux/netdevice.h>
 
 #include <net/addrconf.h>
 #include <net/genetlink.h>
 #include <net/ioam6.h>
+#include <net/sch_generic.h>
 
 static void ioam6_ns_release(struct ioam6_namespace *ns)
 {
@@ -717,7 +719,19 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* queue depth */
 	if (trace->type.bit6) {
-		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		struct netdev_queue *queue;
+		struct Qdisc *qdisc;
+		__u32 qlen, backlog;
+
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
+			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		} else {
+			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
+			qdisc = rcu_dereference(queue->qdisc);
+			qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
+
+			*(__be32 *)data = cpu_to_be32(backlog);
+		}
 		data += sizeof(__be32);
 	}
 
-- 
2.25.1


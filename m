Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0C246AA69
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352625AbhLFVag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:30:36 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52542 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351740AbhLFVag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:30:36 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 582DF200DB97;
        Mon,  6 Dec 2021 22:18:15 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 582DF200DB97
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638825495;
        bh=hq+N8XP13+xww3ZKIXvs7H9qdg0Ckj8PhrXRfvMysA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tw5o7o+VXNEt5zN/8HvftT/1t0qbBODGBpqwtu5RE5S9vOwcax6wZFLm6PfoS0MZp
         dVDsNuGLkc2jIBYEEp4Vu6g1PKkS80xuVZ7vWtoa0kpO/VlHLXCR1vYGDp6HyxMT49
         lDH2vC8gcxXMytUbUsGKWtxiipW0e6b2ApzwEZzvcIgVfUCe6c4GGjvEVQBD76T4aA
         zUG0NCO/QzI2UO4sPeLJ/kHcwuV+OF1dSvfqBCztEq0vy0MqtVEoidh57niTTf9O5o
         dADJOfV6lTGMfFBX2gq5SZGOEAdogAP2eAM2ornJCpIoywN+9lzxpHOgM66mMGkBpY
         Be4gT+A9Zmz8w==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz, justin.iurman@uliege.be
Subject: [RFC net-next 1/2] ipv6: ioam: Support for Queue depth data field
Date:   Mon,  6 Dec 2021 22:17:57 +0100
Message-Id: <20211206211758.19057-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206211758.19057-1-justin.iurman@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is an attempt to support the queue depth in IOAM trace data
fields. Any feedback is appreciated, or any other idea if this one is
not correct.

The draft [1] says the following:

   The "queue depth" field is a 4-octet unsigned integer field.  This
   field indicates the current length of the egress interface queue of
   the interface from where the packet is forwarded out.  The queue
   depth is expressed as the current amount of memory buffers used by
   the queue (a packet could consume one or more memory buffers,
   depending on its size).

An existing function (i.e., qdisc_qstats_qlen_backlog) is used to
retrieve the current queue length without reinventing the wheel. Any
comment on that?

Right now, the number of skb's (qlen) is returned, which is not totally
correct compared to what the draft says: "a packet could consume one or
more memory buffers". Any idea on a solution to take this into account?

Note: it was tested and qlen is increasing when an artificial delay is
added on the egress with tc.

  [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.7

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 122a3d47424c..088eb2f877bc 100644
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
@@ -717,7 +719,17 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* queue depth */
 	if (trace->type.bit6) {
-		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		struct netdev_queue *queue;
+		__u32 qlen, backlog;
+
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
+			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		} else {
+			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
+			qdisc_qstats_qlen_backlog(queue->qdisc, &qlen, &backlog);
+
+			*(__be32 *)data = cpu_to_be32(qlen);
+		}
 		data += sizeof(__be32);
 	}
 
-- 
2.25.1


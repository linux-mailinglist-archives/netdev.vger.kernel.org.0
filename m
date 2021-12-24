Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8055447EF42
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 14:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352793AbhLXNuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 08:50:13 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60218 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352790AbhLXNuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 08:50:13 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 7A10D200DB95;
        Fri, 24 Dec 2021 14:50:10 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7A10D200DB95
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640353810;
        bh=iGUik2846XcvRO6lVlBbeWkGWmbcaFkTSrac5c4Y7r8=;
        h=From:To:Cc:Subject:Date:From;
        b=mG1EFpoVEwdKri0AIxfyJq8jNK5zaLODkrC2lgs+PksyQQOmrTv6M+IWd+PnPmh4P
         rDxQgfHZqtx3U/p6suDK+1ZN2p4pnm41WIeHJ+JKgUbCvimupcr5w8GnV4bmOhNf50
         jX/9p1msTdN66werJ/pv/lGYrTd4OvtF1roRtUQphc5yS0YR6CQkS6ly1JT7EHBnIL
         nVGDTspWKMOjqz9F85WPZFwKguiLmf9Ht75U52h2k6lP0kr3q6Erb0dlHkzfrAp9ks
         DdARtXBa08bfN3sM9YVHNnMUfVeDYAk9dQSkw9ySWALM36lPLXeLZW99EQCn1mprDk
         VTR9h6Kz/+bug==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data field
Date:   Fri, 24 Dec 2021 14:50:00 +0100
Message-Id: <20211224135000.9291-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 122a3d47424c..969a5adbaf5c 100644
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
+			*(__be32 *)data = cpu_to_be32(qlen);
+		}
 		data += sizeof(__be32);
 	}
 
-- 
2.25.1


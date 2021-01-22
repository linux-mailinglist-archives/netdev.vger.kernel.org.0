Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BC52FFF3F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbhAVJcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbhAVJOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:14:54 -0500
X-Greylist: delayed 423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Jan 2021 01:02:48 PST
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B96FC061786;
        Fri, 22 Jan 2021 01:02:48 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id B0D46101B21F1;
        Fri, 22 Jan 2021 09:54:59 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 8D6116017D32;
        Fri, 22 Jan 2021 09:54:59 +0100 (CET)
X-Mailbox-Line: From a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c Mon Sep 17 00:00:00 2001
Message-Id: <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
In-Reply-To: <cover.1611304190.git.lukas@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 22 Jan 2021 09:47:01 +0100
Subject: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress handling
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sch_handle_egress() returns either the skb or NULL to signal to its
caller __dev_queue_xmit() whether a packet should continue to be
processed.

The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
NULL pointer deref right at its top.

But the compiler doesn't know that.  So if sch_handle_egress() signals
success by returning the skb, the "if (!skb) goto out;" statement
results in a gratuitous NULL pointer check in the Assembler output.

Avoid by telling the compiler that __dev_queue_xmit() is never passed a
NULL skb.  This also eliminates another gratuitous NULL pointer check in
__dev_queue_xmit()
  qdisc_pkt_len_init()
    skb_header_pointer()
      __skb_header_pointer()

The speedup is barely measurable:
Before: 1877 1875 1878 1874 1882 1873 Mb/sec
After:  1877 1877 1880 1883 1888 1886 Mb/sec

However we're about to add a netfilter egress hook to __dev_queue_xmit()
and without the micro-optimization, it will result in a performance
degradation which is indeed measurable:
With netfilter hook:               1853 1852 1850 1848 1849 1851 Mb/sec
With netfilter hook + micro-optim: 1874 1877 1881 1875 1876 1876 Mb/sec

The performance degradation is caused by a JNE instruction ("if (skb)")
being flipped to a JE instruction ("if (!skb)") once the netfilter hook
is added.  The micro-optimization removes the test and jump instructions
altogether.

Measurements were performed on a Core i7-3615QM.  Reproducer:
ip link add dev foo type dummy
ip link set dev foo up
tc qdisc add dev foo clsact
tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'
modprobe pktgen
echo "add_device foo" > /proc/net/pktgen/kpktgend_3
samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Thomas Graf <tgraf@suug.ch>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7afbb642e203..4c16b9932823 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4072,6 +4072,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
  *      the BH enable code must have IRQs enabled so that it will not deadlock.
  *          --BLG
  */
+__attribute__((nonnull(1)))
 static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
-- 
2.29.2


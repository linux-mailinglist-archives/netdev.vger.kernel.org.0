Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11F54B5138
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353995AbiBNNKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:10:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244267AbiBNNKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:10:41 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09404EA0F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 05:10:32 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V4S1jRv_1644844229;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4S1jRv_1644844229)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 21:10:30 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     dsahern@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH net] vrf: fix incorrect dereferencing of skb->cb
Date:   Mon, 14 Feb 2022 21:10:29 +0800
Message-Id: <1644844229-54977-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

There is a failed test case in vrf scenario, it can be reproduced
with script:

./vrf_route_leaking.sh -t ipv6_ping_frag

Which output is similar to following:

TEST: Basic IPv6 connectivity			[ OK ]
TEST: Ping received ICMP Packet too big		[FAIL]

The direct cause of this issue is because the Packet too big in ICMPv6
is sent by the message whose source address is IPv6 loopback address and
is discarded dues to its input interface is not the local loopback device.
But the root cause is there's a bug that affects the correct source
address selection.

In the above case the calling stack is as follows:

    icmp6_send+1
    ip6_fragment+543
    ip6_output+98
    vrf_ip6_local_out+78
    vrf_xmit+424
    dev_hard_start_xmit+221
    __dev_queue_xmit+2792
    ip6_finish_output2+705
    ip6_output+98
    ip6_forward+1464
    ipv6_rcv+67

To be more specific:

ipv6_rcv()
	init skb->cb as struct inet6_skb_parm
...
__dev_queue_xmit()
	qdisc_pkt_len_init()
	init skb->cb as struct qdisc_skb_cb
...
vrf_xmit
	fill skb->cb to zero.
...
ip6_fragment()
icmp6_send()
	treats skb->cb as struct inet6_skb_parm.

icmp6_send() will try to use original input interface in IP6CB for
selecting a more meaningful source address, we should keep the old IP6CB
rather than overwrite it.

This patch try remove the memset and make the struct qdisc_skb_cb
contains inet_skb_parm/inet6_skb_parm, which makes it possible to read
the correct IP6CB in icmp6_send() without any changes in that case.

One problem is that the size of struct qdisc_skb_cb has increased,
the original skb->cb cannnot fit struct bpf_skb_data_end anymore, which
requires increase the size of skb->cb. This patch try increase it by the
union size of inet_skb_parm/inet6_skb_parm, which is 24.

struct bpf_skb_data_end {
	struct qdisc_skb_cb qdisc_cb;
	void *data_meta;
	void *data_end;
};

Fixes: ee201011c1e1 ("vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit")
Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 drivers/net/vrf.c         | 2 --
 include/linux/skbuff.h    | 2 +-
 include/net/sch_generic.h | 7 +++++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index e0b1ab9..a3601d0 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -498,7 +498,6 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 	/* strip the ethernet header added for pass through VRF device */
 	__skb_pull(skb, skb_network_offset(skb));
 
-	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	ret = vrf_ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		dev->stats.tx_errors++;
@@ -581,7 +580,6 @@ static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 					       RT_SCOPE_LINK);
 	}
 
-	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 	ret = vrf_ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		vrf_dev->stats.tx_errors++;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a5adbf6..0328d05 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -811,7 +811,7 @@ struct sk_buff {
 	 * want to keep them across layers you have to do a skb_clone()
 	 * first. This is owned by whoever has the skb queued ATM.
 	 */
-	char			cb[48] __aligned(8);
+	char			cb[72] __aligned(8);
 
 	union {
 		struct {
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396..64cb250 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -19,6 +19,7 @@
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
+#include <net/ip.h>
 
 struct Qdisc_ops;
 struct qdisc_walker;
@@ -440,6 +441,12 @@ struct tcf_proto {
 };
 
 struct qdisc_skb_cb {
+	union {
+		struct inet_skb_parm	h4;
+#if IS_ENABLED(CONFIG_IPV6)
+		struct inet6_skb_parm	h6;
+#endif
+	} header;
 	struct {
 		unsigned int		pkt_len;
 		u16			slave_dev_queue_mapping;
-- 
1.8.3.1


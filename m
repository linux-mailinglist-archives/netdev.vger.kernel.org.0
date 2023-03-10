Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D386B50C0
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 20:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjCJTLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 14:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjCJTLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 14:11:22 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23901112A56
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 11:11:12 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5411f21f849so3468787b3.16
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 11:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678475471;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dFudy1u5kOVBTHMuFEj7/79Owqa9uZlPNyWRs3DLmtU=;
        b=boXNHQlDq9G1zPr+uqpF1ijynaI28YInPBv8xrJP/Vi4Qof4Mki7rTfHl+uYHue1ku
         ZcfeO3m+H8vPzkbzqrP/mWTqJQ+4MANAbD81ZI63rOyIfmms5YanpgCMwbDCxsv7X8A7
         bGzLfrd/q2bLtBGX+hJnGg7Hdfi0YgBRsRu6nC2C8vZyo8OFhDj2kppYiL3pHUsnLQeY
         Ex2Kyq3uP2rAQtrobxjzEjhbFDleJL3HI83EI4PdxyrsoBvbeB0hU5YwSwiQFOYPUtbP
         ovbxTTTJd3kHmMsS7ov756mSelvZdUnqy+r638urTUnk/tgx7KR7MEREOACjSIiGA80Y
         k8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678475471;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dFudy1u5kOVBTHMuFEj7/79Owqa9uZlPNyWRs3DLmtU=;
        b=3wvrb6HxxkhRzwNAwEnB1mqPz18uVEjN3IoN8l5b8JQ7NpQamCy4jk2t4lyEZ//6lU
         rdrgGDDWTA1f6sgJ45ykuZRWQ9AEuXcOUlb7/mOfzsYAdM2crssI70JQL4n35zPp+BAN
         MLCIupGI0K/sAI3b/Bg4jbN+7yqtxCpHXf2FgIA3eMu8tDI+KOvrTeFuFxXJkDcPCsuy
         bC2EXrCbuNrElVUsvV8LQIvzJPTgrfjYVDKrqZyMnDd4ilMwAOWIVobWS7gQhWod+6m5
         qzInH4lPKkUgDgCrvX99klPKGNcjcr4V/H0AbItEGwEpAoq88fse9FyC4Ioc0l2qYQGe
         XaZA==
X-Gm-Message-State: AO0yUKVCDBnFJI0LMu16CwWFriDNQOUyTbs7mSNEpRaZEzcWi8ufqi2c
        EoANPvEDo4D5lloXIyVHKfFo1Thwh1Wx4w==
X-Google-Smtp-Source: AK7set8ajY1p+9pymnQaPFibwt3AS3VixNdW8KrYsDUCorrVZK0mabwWRBYyNlac8ZqSrdqVbjSqCrWkqAT06A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:145:b0:ac2:a7a7:23c3 with SMTP
 id p5-20020a056902014500b00ac2a7a723c3mr11398392ybh.12.1678475471380; Fri, 10
 Mar 2023 11:11:11 -0800 (PST)
Date:   Fri, 10 Mar 2023 19:11:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310191109.2384387-1-edumazet@google.com>
Subject: [PATCH net] net: tunnels: annotate lockless accesses to dev->needed_headroom
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IP tunnels can apparently update dev->needed_headroom
in their xmit path.

This patch takes care of three tunnels xmit, and also the
core LL_RESERVED_SPACE() and LL_RESERVED_SPACE_EXTRA()
helpers.

More changes might be needed for completeness.

BUG: KCSAN: data-race in ip_tunnel_xmit / ip_tunnel_xmit

read to 0xffff88815b9da0ec of 2 bytes by task 888 on cpu 1:
ip_tunnel_xmit+0x1270/0x1730 net/ipv4/ip_tunnel.c:803
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246

write to 0xffff88815b9da0ec of 2 bytes by task 2379 on cpu 0:
ip_tunnel_xmit+0x1294/0x1730 net/ipv4/ip_tunnel.c:804
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip6_finish_output2+0x9bc/0xc50 net/ipv6/ip6_output.c:134
__ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
ip6_finish_output+0x39a/0x4e0 net/ipv6/ip6_output.c:206
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip6_output+0xeb/0x220 net/ipv6/ip6_output.c:227
dst_output include/net/dst.h:444 [inline]
NF_HOOK include/linux/netfilter.h:302 [inline]
mld_sendpack+0x438/0x6a0 net/ipv6/mcast.c:1820
mld_send_cr net/ipv6/mcast.c:2121 [inline]
mld_ifc_work+0x519/0x7b0 net/ipv6/mcast.c:2653
process_one_work+0x3e6/0x750 kernel/workqueue.c:2390
worker_thread+0x5f2/0xa10 kernel/workqueue.c:2537
kthread+0x1ac/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

value changed: 0x0dd4 -> 0x0e14

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 2379 Comm: kworker/0:0 Not tainted 6.3.0-rc1-syzkaller-00002-g8ca09d5fa354-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: mld mld_ifc_work

Fixes: 8eb30be0352d ("ipv6: Create ip6_tnl_xmit")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |  6 ++++--
 net/ipv4/ip_tunnel.c      | 12 ++++++------
 net/ipv6/ip6_tunnel.c     |  4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6a14b7b117668ca2c8b1f914ecb49fb4311784ab..470085b121d3c241e8045416e9d0426eb8a43850 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -297,9 +297,11 @@ struct hh_cache {
  * relationship HH alignment <= LL alignment.
  */
 #define LL_RESERVED_SPACE(dev) \
-	((((dev)->hard_header_len+(dev)->needed_headroom)&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 #define LL_RESERVED_SPACE_EXTRA(dev,extra) \
-	((((dev)->hard_header_len+(dev)->needed_headroom+(extra))&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom) + (extra)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 
 struct header_ops {
 	int	(*create) (struct sk_buff *skb, struct net_device *dev,
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index de90b09dfe78fc4510985dd436c017d3c46f054c..2541083d49ad66fcc6c4485abb4bd96c50dc0989 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -614,10 +614,10 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
-	if (headroom > dev->needed_headroom)
-		dev->needed_headroom = headroom;
+	if (headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		goto tx_dropped;
 	}
@@ -800,10 +800,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		DEV_STATS_INC(dev, tx_dropped);
 		kfree_skb(skb);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 47b6607a13706ef415e0b19f38014700e673da84..5e80e517f071013410349d1fd93afc00a394e284 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1240,8 +1240,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	 */
 	max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
 			+ dst->header_len + t->hlen;
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
-- 
2.40.0.rc1.284.g88254d51c5-goog


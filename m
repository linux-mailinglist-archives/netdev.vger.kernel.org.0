Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA23C212E
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhGIJHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:07:40 -0400
Received: from relay.sw.ru ([185.231.240.75]:59432 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhGIJHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 05:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=vxFf38SOUahWQtSH3d9qMh/k+xeLcgZ7RGmybH79yIc=; b=mngrbbURItm3FXQH2kV
        C6sMNJ8ZKZ1Rcgn8AwClMOawXSDMYnkMUSLKug5oyv6PWiiRtWG406V84IMUjprOK1XAeuR6ChICW
        E5Kj0MwqbfClATHWP49vcn14KxG0lcFqlzQKRzakHJYCRsCtqQVEYmKkuixY+AAvFyak9uAU/Is=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m1mRK-003Pl0-TM; Fri, 09 Jul 2021 12:04:54 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH IPV6 v2 2/4] ipv6: use new helper skb_expand_head() in
 ip6_xmit()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
 <cover.1625818825.git.vvs@virtuozzo.com>
Message-ID: <64dd5cd2-cfd9-60b3-ae1c-39470ff75256@virtuozzo.com>
Date:   Fri, 9 Jul 2021 12:04:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1625818825.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this way can be changed:
pptp_xmit
vrf_finish_output
ax25_transmit_buffer
ax25_rt_build_path
bpf_out_neigh_v6
bpf_out_neigh_v4
ip_finish_output2
ip6_tnl_xmit
ipip6_tunnel_xmit
ip_vs_prepare_tunneled_skb

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_output.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6c5f85f..9418802 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -278,25 +278,21 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
 	int seg_len = skb->len;
-	int hlimit = -1;
+	int delta, hlimit = -1;
 	u32 mtu;
 
 	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dst->dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
-	if (unlikely(skb_headroom(skb) < head_room)) {
-		struct sk_buff *skb2 = skb_realloc_headroom(skb, head_room);
-		if (!skb2) {
-			IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
+	delta = head_room - skb_headroom(skb);
+	if (unlikely(delta > 0)) {
+		skb = skb_expand_head(skb, delta);
+		if (!skb) {
+			IP6_INC_STATS(net, ip6_dst_idev(dst),
 				      IPSTATS_MIB_OUTDISCARDS);
-			kfree_skb(skb);
 			return -ENOBUFS;
 		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	if (opt) {
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A159C6E2C9F
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDNW56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNW54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:57:56 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CE56EBB;
        Fri, 14 Apr 2023 15:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=lssmBvj3EeZlOY8aEHtOGRejH1m2tX9CXkzecQJXsQg=; b=CNjxiIFt6OgKhYuIyt1BNVAt4V
        hW/RINRa+ZNF0Bcyclk8qIgfUADruoIA3AJVmnOROVb5DHY2Ff5uNlGBWzcPuYwm5KvbFdFA2auv2
        YOyuXrtzY82tNcBUdV/URRSEuNJvW8ZVxKtbXTXgQIPsA7soSiQr5bJdD3E0UVcWNkRMgBmdsKA7Y
        8YmuVQFb2kanEyCKvK2/4+sToB8a1UvPoZ4Br44Ovn8/oL1TT0z/ehFnRZs4JPAdShLWgkVdoO1o4
        bmZ6EVb+151CVrJumWWYZv6HGymMJQfEpqSgWE2KXblJSgR8Ow1ipi1zaRMH9R4aB/E9urVLOYVz1
        TyW4K5TQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pnSMT-000LN5-Vo; Sat, 15 Apr 2023 00:57:46 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pnSMT-0004he-GL; Sat, 15 Apr 2023 00:57:45 +0200
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
References: <20230413025350.79809-1-laoar.shao@gmail.com>
 <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net> <874jpj2682.fsf@toke.dk>
 <ee52c2e4-4199-da40-8e86-57ef4085c968@iogearbox.net> <875y9yzbuy.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c68bf723-3406-d177-49b4-6d5b485048de@iogearbox.net>
Date:   Sat, 15 Apr 2023 00:57:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <875y9yzbuy.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26875/Fri Apr 14 09:23:27 2023)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 6:07 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
[...]
> https://git.openwrt.org/?p=project/qosify.git;a=blob;f=README

Thanks for the explanation, that sounds reasonable and this should ideally
be part of the commit msg! Yafang, Toke, how about we craft it the following
way then to support this case:

 From f6c83e5e55c5eb9da8acd19369c688acf53951db Mon Sep 17 00:00:00 2001
Message-Id: <f6c83e5e55c5eb9da8acd19369c688acf53951db.1681512637.git.daniel@iogearbox.net>
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat, 15 Apr 2023 00:30:27 +0200
Subject: [PATCH bpf-next] bpf: Set skb redirect and from_ingress info in __bpf_tx_skb
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There are some use-cases where it is desirable to use bpf_redirect()
in combination with ifb device, which currently is not supported, for
example, around filtering inbound traffic with BPF to then push it to
ifb which holds the qdisc for shaping in contrast to doing that on the
egress device.

Toke mentions the following case related to OpenWrt:

   Because there's not always a single egress on the other side. These are
   mainly home routers, which tend to have one or more WiFi devices bridged
   to one or more ethernet ports on the LAN side, and a single upstream WAN
   port. And the objective is to control the total amount of traffic going
   over the WAN link (in both directions), to deal with bufferbloat in the
   ISP network (which is sadly still all too prevalent).

   In this setup, the traffic can be split arbitrarily between the links
   on the LAN side, and the only "single bottleneck" is the WAN link. So we
   install both egress and ingress shapers on this, configured to something
   like 95-98% of the true link bandwidth, thus moving the queues into the
   qdisc layer in the router. It's usually necessary to set the ingress
   bandwidth shaper a bit lower than the egress due to being "downstream"
   of the bottleneck link, but it does work surprisingly well.

   We usually use something like a matchall filter to put all ingress
   traffic on the ifb, so doing the redirect from BPF has not been an
   immediate requirement thus far. However, it does seem a bit odd that this
   is not possible, and we do have a BPF-based filter that layers on top of
   this kind of setup, which currently uses u32 as the ingress filter and
   so it could presumably be improved to use BPF instead if that was
   available.

Reported-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Reported-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://git.openwrt.org/?p=project/qosify.git;a=blob;f=README
Link: https://lore.kernel.org/bpf/875y9yzbuy.fsf@toke.dk
---
  include/linux/skbuff.h | 9 +++++++++
  net/core/filter.c      | 1 +
  2 files changed, 10 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ff7ad331fb82..2bbf9245640a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5049,6 +5049,15 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
  	skb->redirected = 0;
  }

+static inline void skb_set_redirected_noclear(struct sk_buff *skb,
+					      bool from_ingress)
+{
+	skb->redirected = 1;
+#ifdef CONFIG_NET_REDIRECT
+	skb->from_ingress = from_ingress;
+#endif
+}
+
  static inline bool skb_csum_is_sctp(struct sk_buff *skb)
  {
  	return skb->csum_not_inet;
diff --git a/net/core/filter.c b/net/core/filter.c
index 1d6f165923bf..27ba616aaa1a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2111,6 +2111,7 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
  	}

  	skb->dev = dev;
+	skb_set_redirected_noclear(skb, skb->tc_at_ingress);
  	skb_clear_tstamp(skb);

  	dev_xmit_recursion_inc();
-- 
2.21.0

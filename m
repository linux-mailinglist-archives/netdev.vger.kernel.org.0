Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21AD46E8B6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhLINCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:02:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:49364 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbhLINCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:02:30 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvJ0f-0003SM-BA; Thu, 09 Dec 2021 13:58:53 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvJ0f-0008fN-1q; Thu, 09 Dec 2021 13:58:53 +0100
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
 <1ef23d3b-fe49-213b-6b60-127393b24e84@iogearbox.net>
 <20211208221924.v4gqpkzzrbhgi2xe@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b7989f8a-3f04-5186-a9f1-50f101575cfa@iogearbox.net>
Date:   Thu, 9 Dec 2021 13:58:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211208221924.v4gqpkzzrbhgi2xe@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26378/Thu Dec  9 10:21:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 11:19 PM, Martin KaFai Lau wrote:
> On Wed, Dec 08, 2021 at 08:27:45PM +0100, Daniel Borkmann wrote:
>> On 12/8/21 9:30 AM, Martin KaFai Lau wrote:
>>> On Wed, Dec 08, 2021 at 12:18:46AM -0800, Martin KaFai Lau wrote:
>>>> On Tue, Dec 07, 2021 at 10:48:53PM +0100, Daniel Borkmann wrote:
>> [...]
>>>>> One other thing I wonder, BPF progs at host-facing veth's tc ingress which
>>>>> are not aware of skb->tstamp will then see a tstamp from future given we
>>>>> intentionally bypass the net_timestamp_check() and might get confused (or
>>>>> would confuse higher-layer application logic)? Not quite sure yet if they
>>>>> would be the only affected user.
>>>> Considering the variety of clock used in skb->tstamp (real/mono, and also
>>>> tai in SO_TXTIME),  in general I am not sure if the tc-bpf can assume anything
>>>> in the skb->tstamp now.
>>
>> But today that's either only 0 or real via __net_timestamp() if skb->tstamp is
>> read at bpf@ingress@veth@host, no?
> I think I was trying to say the CLOCK_REALTIME in __sk_buff->tstamp
> is not practically useful in bpf@ingress other than an increasing number.
> No easy way to get the 'now' in CLOCK_REALTIME to compare with
> in order to learn if it is future or current time.  Setting
> it based on bpf_ktime_get_ns() in MONO is likely broken currently
> regardless of the skb is forwarded or delivered locally.
> 
> We have a use case that wants to change the forwarded EDT
> in bpf@ingress@veth@host before forwarding.  If it needs to
> keep __sk_buff->tstamp as the 'now' CLOCK_REALTIME in ingress,
> it needs to provide a separate way for the bpf to check/change
> the forwarded EDT.
> 
> Daniel, do you have suggestion on where to temporarily store
> the forwarded EDT so that the bpf@ingress can access?

Hm, was thinking maybe moving skb->skb_mstamp_ns into the shared info as
in skb_hwtstamps(skb)->skb_mstamp_ns could work. In other words, as a union
with hwtstamp to not bloat it further. And TCP stack as well as everything
else (like sch_fq) could switch to it natively (hwtstamp might only be used
on RX or TX completion from driver side if I'm not mistaken).

But then while this would solve the netns transfer, we would run into the
/same/ issue again when implementing a hairpinning LB where we loop from RX
to TX given this would have to be cleared somewhere again if driver populates
hwtstamp, so not really feasible and bloating shared info with a second
tstamp would bump it by one cacheline. :(

A cleaner BUT still non-generic solution compared to the previous diff I could
think of might be the below. So no change in behavior in general, but if the
bpf@ingress@veth@host needs to access the original tstamp, it could do so
via existing mapping we already have in BPF, and then it could transfer it
for all or certain traffic (up to the prog) via BPF code setting ...

   skb->tstamp = skb->hwtstamp

... and do the redirect from there to the phys dev with BPF_F_KEEP_TSTAMP
flag. Minimal intrusive, but unfortunately only accessible for BPF. Maybe use
of skb_hwtstamps(skb)->nststamp could be extended though (?)

Thanks,
Daniel

  include/linux/skbuff.h   | 14 +++++++++++++-
  include/uapi/linux/bpf.h |  1 +
  net/core/filter.c        | 37 ++++++++++++++++++++++---------------
  net/core/skbuff.c        |  2 +-
  4 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cb7e697d47..b7c72fe7e1bb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -418,7 +418,10 @@ static inline bool skb_frag_must_loop(struct page *p)
   * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
   */
  struct skb_shared_hwtstamps {
-	ktime_t	hwtstamp;
+	union {
+		ktime_t	hwtstamp;
+		ktime_t	nststamp;
+	};
  };

  /* Definitions for tx_flags in struct skb_shared_info */
@@ -3711,6 +3714,15 @@ int skb_mpls_dec_ttl(struct sk_buff *skb);
  struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
  			     gfp_t gfp);

+static inline void skb_xfer_tstamp(struct sk_buff *skb)
+{
+	/* initns might still need access to the original
+	 * skb->tstamp from a netns, e.g. for EDT.
+	 */
+	skb_hwtstamps(skb)->nststamp = skb->tstamp;
+	skb->tstamp = 0;
+}
+
  static inline int memcpy_from_msg(void *data, struct msghdr *msg, int len)
  {
  	return copy_from_iter_full(data, len, &msg->msg_iter) ? 0 : -EFAULT;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15e25f5..12d10ab8bff7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5157,6 +5157,7 @@ enum {
  /* BPF_FUNC_clone_redirect and BPF_FUNC_redirect flags. */
  enum {
  	BPF_F_INGRESS			= (1ULL << 0),
+	BPF_F_KEEP_TSTAMP		= (1ULL << 1),
  };

  /* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
diff --git a/net/core/filter.c b/net/core/filter.c
index 6102f093d59a..e233b998387c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2097,7 +2097,8 @@ static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
  	return ret;
  }

-static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
+static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb,
+			       bool keep_tstamp)
  {
  	int ret;

@@ -2108,7 +2109,8 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
  	}

  	skb->dev = dev;
-	skb->tstamp = 0;
+	if (!keep_tstamp)
+		skb_xfer_tstamp(skb);

  	dev_xmit_recursion_inc();
  	ret = dev_queue_xmit(skb);
@@ -2136,7 +2138,8 @@ static int __bpf_redirect_no_mac(struct sk_buff *skb, struct net_device *dev,
  	skb_pop_mac_header(skb);
  	skb_reset_mac_len(skb);
  	return flags & BPF_F_INGRESS ?
-	       __bpf_rx_skb_no_mac(dev, skb) : __bpf_tx_skb(dev, skb);
+	       __bpf_rx_skb_no_mac(dev, skb) :
+	       __bpf_tx_skb(dev, skb, flags & BPF_F_KEEP_TSTAMP);
  }

  static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
@@ -2150,7 +2153,8 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,

  	bpf_push_mac_rcsum(skb);
  	return flags & BPF_F_INGRESS ?
-	       __bpf_rx_skb(dev, skb) : __bpf_tx_skb(dev, skb);
+	       __bpf_rx_skb(dev, skb) :
+	       __bpf_tx_skb(dev, skb, flags & BPF_F_KEEP_TSTAMP);
  }

  static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
@@ -2177,7 +2181,6 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
  	}

  	skb->dev = dev;
-	skb->tstamp = 0;

  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
  		skb = skb_expand_head(skb, hh_len);
@@ -2275,7 +2278,6 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
  	}

  	skb->dev = dev;
-	skb->tstamp = 0;

  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
  		skb = skb_expand_head(skb, hh_len);
@@ -2367,7 +2369,7 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
  #endif /* CONFIG_INET */

  static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
-				struct bpf_nh_params *nh)
+				struct bpf_nh_params *nh, bool keep_tstamp)
  {
  	struct ethhdr *ethh = eth_hdr(skb);

@@ -2380,6 +2382,8 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
  	skb_pull(skb, sizeof(*ethh));
  	skb_unset_mac_header(skb);
  	skb_reset_network_header(skb);
+	if (!keep_tstamp)
+		skb_xfer_tstamp(skb);

  	if (skb->protocol == htons(ETH_P_IP))
  		return __bpf_redirect_neigh_v4(skb, dev, nh);
@@ -2392,9 +2396,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,

  /* Internal, non-exposed redirect flags. */
  enum {
-	BPF_F_NEIGH	= (1ULL << 1),
-	BPF_F_PEER	= (1ULL << 2),
-	BPF_F_NEXTHOP	= (1ULL << 3),
+	BPF_F_NEIGH	= (1ULL << 2),
+	BPF_F_PEER	= (1ULL << 3),
+	BPF_F_NEXTHOP	= (1ULL << 4),
  #define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH | BPF_F_PEER | BPF_F_NEXTHOP)
  };

@@ -2468,8 +2472,9 @@ int skb_do_redirect(struct sk_buff *skb)
  		return -EAGAIN;
  	}
  	return flags & BPF_F_NEIGH ?
-	       __bpf_redirect_neigh(skb, dev, flags & BPF_F_NEXTHOP ?
-				    &ri->nh : NULL) :
+	       __bpf_redirect_neigh(skb, dev,
+				    flags & BPF_F_NEXTHOP ? &ri->nh : NULL,
+				    flags & BPF_F_KEEP_TSTAMP) :
  	       __bpf_redirect(skb, dev, flags);
  out_drop:
  	kfree_skb(skb);
@@ -2480,7 +2485,8 @@ BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
  {
  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);

-	if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
+	if (unlikely(flags & (~(BPF_F_INGRESS | BPF_F_KEEP_TSTAMP) |
+			      BPF_F_REDIRECT_INTERNAL)))
  		return TC_ACT_SHOT;

  	ri->flags = flags;
@@ -2523,10 +2529,11 @@ BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, params,
  {
  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);

-	if (unlikely((plen && plen < sizeof(*params)) || flags))
+	if (unlikely((plen && plen < sizeof(*params)) ||
+		     (flags & ~BPF_F_KEEP_TSTAMP)))
  		return TC_ACT_SHOT;

-	ri->flags = BPF_F_NEIGH | (plen ? BPF_F_NEXTHOP : 0);
+	ri->flags = BPF_F_NEIGH | (plen ? BPF_F_NEXTHOP : 0) | flags;
  	ri->tgt_index = ifindex;

  	BUILD_BUG_ON(sizeof(struct bpf_redir_neigh) != sizeof(struct bpf_nh_params));
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba2f38246f07..782b152a000c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5472,7 +5472,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)

  	ipvs_reset(skb);
  	skb->mark = 0;
-	skb->tstamp = 0;
+	skb_xfer_tstamp(skb);
  }
  EXPORT_SYMBOL_GPL(skb_scrub_packet);

-- 
2.21.0



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F009F1C9590
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgEGPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:54:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:54908 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgEGPy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:54:59 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWirD-00080B-VR; Thu, 07 May 2020 17:54:44 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWirD-000Uj4-Fm; Thu, 07 May 2020 17:54:43 +0200
Subject: Re: [PATCH v3] net: bpf: permit redirect from ingress L3 to egress L2
 devices at near max mtu
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <CANP3RGduts2FJ2M5MLcf23GaRa=-fwUC7oPf-S4zp39f63jHMg@mail.gmail.com>
 <20200507023606.111650-1-zenczykowski@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ae1e5602-a2fd-661b-155c-d32ff0059ce6@iogearbox.net>
Date:   Thu, 7 May 2020 17:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200507023606.111650-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25805/Thu May  7 14:14:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/20 4:36 AM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> __bpf_skb_max_len(skb) is used from:
>    bpf_skb_adjust_room
>    __bpf_skb_change_tail
>    __bpf_skb_change_head
> 
> but in the case of forwarding we're likely calling these functions
> during receive processing on ingress and bpf_redirect()'ing at
> a later point in time to egress on another interface, thus these
> mtu checks are for the wrong device (input instead of output).
> 
> This is particularly problematic if we're receiving on an L3 1500 mtu
> cellular interface, trying to add an L2 header and forwarding to
> an L3 mtu 1500 mtu wifi/ethernet device (which is thus L2 1514).
> 
> The mtu check prevents us from adding the 14 byte ethernet header prior
> to forwarding the packet.
> 
> After the packet has already been redirected, we'd need to add
> an additional 2nd ebpf program on the target device's egress tc hook,
> but then we'd also see non-redirected traffic and have no easy
> way to tell apart normal egress with ethernet header packets
> from forwarded ethernet headerless packets.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>   net/core/filter.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7d6ceaa54d21..5c8243930462 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3159,8 +3159,9 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>   
>   static u32 __bpf_skb_max_len(const struct sk_buff *skb)
>   {
> -	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> -			  SKB_MAX_ALLOC;
> +	if (skb_at_tc_ingress(skb) || !skb->dev)
> +		return SKB_MAX_ALLOC;
> +	return skb->dev->mtu + skb->dev->hard_header_len;
>   }

But then why even have any MTU check in the first place? Above would basically
break for the case where I'd have a one-legged load-balancer. skb comes in at
tc ingress, we adjust its size and are allowed to do so up to SKB_MAX_ALLOC.
Then we redirect it out through the same device through bpf where it came from.

I suppose we are the ones responsible to assert here that it doesn't exceed MTU.
There are 3 cases when skb exits the prog on tc ingress or egress: i) we redirect
via ingress, then ii) we redirect via egress, and iii) we just do tc_act_ok. Case
i) is asserted already via ____dev_forward_skb() today. If we fix/relax the
__bpf_skb_max_len(), we would also need to assert the other two locations,
something hacked up like the below. And on this it probably makes sense to expose
the current MTU, but that can be optional.

Thoughts?

Thanks,
Daniel

 From 95464f75ed8d520b9ff068b72687a422465686cd Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 7 May 2020 16:46:30 +0200
Subject: [PATCH] bpf: xxx

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
  include/linux/netdevice.h | 25 +++++++++++++++++++++++--
  include/uapi/linux/bpf.h  |  1 +
  net/core/dev.c            | 24 +++---------------------
  net/core/filter.c         | 22 +++++++++++++++++-----
  4 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5a8d40f1ffe2..19770744d5b5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3787,8 +3787,29 @@ int xdp_umem_query(struct net_device *dev, u16 queue_id);

  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
  int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
-bool is_skb_forwardable(const struct net_device *dev,
-			const struct sk_buff *skb);
+
+static __always_inline bool is_skb_size_ok(const struct net_device *dev,
+					   const struct sk_buff *skb)
+{
+	static const u32 vlan_header_len = 4;
+
+	if (skb->len <= dev->mtu + dev->hard_header_len + vlan_header_len)
+		return true;
+
+	/* If TSO is enabled, we don't care about the length as the packet
+	 * could be forwarded without being segmented before.
+	 */
+	return skb_is_gso(skb);
+}
+
+static __always_inline bool is_skb_forwardable(const struct net_device *dev,
+					       const struct sk_buff *skb)
+{
+	if (unlikely(!(dev->flags & IFF_UP)))
+		return false;
+
+	return is_skb_size_ok(dev, skb);
+}

  static __always_inline int ____dev_forward_skb(struct net_device *dev,
  					       struct sk_buff *skb)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b3643e27e264..0239e415a469 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3370,6 +3370,7 @@ struct __sk_buff {
  	__u32 gso_segs;
  	__bpf_md_ptr(struct bpf_sock *, sk);
  	__u32 gso_size;
+	__u32 mtu;
  };

  struct bpf_tunnel_key {
diff --git a/net/core/dev.c b/net/core/dev.c
index afff16849c26..b3bf738fc36f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2100,27 +2100,6 @@ static inline void net_timestamp_set(struct sk_buff *skb)
  			__net_timestamp(SKB);			\
  	}							\

-bool is_skb_forwardable(const struct net_device *dev, const struct sk_buff *skb)
-{
-	unsigned int len;
-
-	if (!(dev->flags & IFF_UP))
-		return false;
-
-	len = dev->mtu + dev->hard_header_len + VLAN_HLEN;
-	if (skb->len <= len)
-		return true;
-
-	/* if TSO is enabled, we don't care about the length as the packet
-	 * could be forwarded without being segmented before
-	 */
-	if (skb_is_gso(skb))
-		return true;
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(is_skb_forwardable);
-
  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
  {
  	int ret = ____dev_forward_skb(dev, skb);
@@ -3786,8 +3765,11 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
  	case TC_ACT_OK:
  	case TC_ACT_RECLASSIFY:
  		skb->tc_index = TC_H_MIN(cl_res.classid);
+		if (unlikely(!is_skb_size_ok(dev, skb)))
+			goto drop;
  		break;
  	case TC_ACT_SHOT:
+drop:
  		mini_qdisc_qstats_cpu_drop(miniq);
  		*ret = NET_XMIT_DROP;
  		kfree_skb(skb);
diff --git a/net/core/filter.c b/net/core/filter.c
index dfaf5df13722..54db75bf15c5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2037,10 +2037,11 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
  {
  	int ret;

-	if (dev_xmit_recursion()) {
+	if (unlikely(!is_skb_forwardable(dev, skb)))
+		goto drop;
+	if (unlikely(dev_xmit_recursion())) {
  		net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
-		kfree_skb(skb);
-		return -ENETDOWN;
+		goto drop;
  	}

  	skb->dev = dev;
@@ -2051,6 +2052,10 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
  	dev_xmit_recursion_dec();

  	return ret;
+drop:
+	atomic_long_inc(&dev->rx_dropped);
+	kfree_skb(skb);
+	return -EIO;
  }

  static int __bpf_redirect_no_mac(struct sk_buff *skb, struct net_device *dev,
@@ -3148,8 +3153,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,

  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
  {
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
+	return SKB_MAX_ALLOC;
  }

  BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
@@ -7831,6 +7835,14 @@ static u32 tc_cls_act_convert_ctx_access(enum bpf_access_type type,
  				      bpf_target_off(struct net_device, ifindex, 4,
  						     target_size));
  		break;
+	case offsetof(struct __sk_buff, mtu):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, dev),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct sk_buff, dev));
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+				      bpf_target_off(struct net_device, mtu, 4,
+						     target_size));
+		break;
  	default:
  		return bpf_convert_ctx_access(type, si, insn_buf, prog,
  					      target_size);
-- 
2.21.0

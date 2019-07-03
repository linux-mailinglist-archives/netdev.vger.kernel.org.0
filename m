Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEF15DCEC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 05:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfGCD2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 23:28:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44900 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727368AbfGCD2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 23:28:18 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A3FACB18341EC7883529;
        Wed,  3 Jul 2019 11:28:16 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 3 Jul 2019
 11:28:12 +0800
Subject: Re: [PATCH net-next] skbuff: increase verbosity when dumping skb data
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <herbert@gondor.apana.org.au>, <eric.dumazet@gmail.com>,
        <saeedm@mellanox.com>, Willem de Bruijn <willemb@google.com>
References: <20190702193927.116668-1-willemdebruijn.kernel@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <254abb52-e201-eb12-d6c2-6bd96e505871@huawei.com>
Date:   Wed, 3 Jul 2019 11:28:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190702193927.116668-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/3 3:39, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> skb_warn_bad_offload and netdev_rx_csum_fault trigger on hard to debug
> issues. Dump more state and the header.
> 
> Optionally dump the entire packet and linear segment. This is required
> to debug checksum bugs that may include bytes past skb_tail_pointer().
> 
> Both call sites call this function inside a net_ratelimit() block.
> Limit full packet log further to a hard limit of can_dump_full (5).
> 
> Based on an earlier patch by Cong Wang, see link below.
> 
> Link: https://patchwork.ozlabs.org/patch/1000841/
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/linux/skbuff.h |   1 +
>  net/core/dev.c         |  16 ++-----
>  net/core/skbuff.c      | 103 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 108 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index b5d427b149c92..48b08549a8b78 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1024,6 +1024,7 @@ static inline bool skb_unref(struct sk_buff *skb)
>  void skb_release_head_state(struct sk_buff *skb);
>  void kfree_skb(struct sk_buff *skb);
>  void kfree_skb_list(struct sk_buff *segs);
> +void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
>  void skb_tx_error(struct sk_buff *skb);
>  void consume_skb(struct sk_buff *skb);
>  void __consume_stateless_skb(struct sk_buff *skb);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 58529318b3a94..fc676b2610e3c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2900,12 +2900,10 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
>  		else
>  			name = netdev_name(dev);
>  	}
> -	WARN(1, "%s: caps=(%pNF, %pNF) len=%d data_len=%d gso_size=%d "
> -	     "gso_type=%d ip_summed=%d\n",
> +	skb_dump(KERN_WARNING, skb, false);
> +	WARN(1, "%s: caps=(%pNF, %pNF)\n",
>  	     name, dev ? &dev->features : &null_features,
> -	     skb->sk ? &skb->sk->sk_route_caps : &null_features,
> -	     skb->len, skb->data_len, skb_shinfo(skb)->gso_size,
> -	     skb_shinfo(skb)->gso_type, skb->ip_summed);
> +	     skb->sk ? &skb->sk->sk_route_caps : &null_features);
>  }
>  
>  /*
> @@ -3124,13 +3122,7 @@ void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
>  {
>  	if (net_ratelimit()) {
>  		pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
> -		if (dev)
> -			pr_err("dev features: %pNF\n", &dev->features);
> -		pr_err("skb len=%u data_len=%u pkt_type=%u gso_size=%u gso_type=%u nr_frags=%u ip_summed=%u csum=%x csum_complete_sw=%d csum_valid=%d csum_level=%u\n",
> -		       skb->len, skb->data_len, skb->pkt_type,
> -		       skb_shinfo(skb)->gso_size, skb_shinfo(skb)->gso_type,
> -		       skb_shinfo(skb)->nr_frags, skb->ip_summed, skb->csum,
> -		       skb->csum_complete_sw, skb->csum_valid, skb->csum_level);
> +		skb_dump(KERN_ERR, skb, true);
>  		dump_stack();
>  	}
>  }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 5323441a12ccf..5d501066d00ca 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -707,6 +707,109 @@ void kfree_skb_list(struct sk_buff *segs)
>  }
>  EXPORT_SYMBOL(kfree_skb_list);
>  
> +/* Dump skb information and contents.
> + *
> + * Must only be called from net_ratelimit()-ed paths.
> + *
> + * Dumps up to can_dump_full whole packets if full_pkt, headers otherwise.
> + */
> +void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
> +{
> +	static atomic_t can_dump_full = ATOMIC_INIT(5);
> +	struct skb_shared_info *sh = skb_shinfo(skb);
> +	struct net_device *dev = skb->dev;
> +	struct sock *sk = skb->sk;
> +	struct sk_buff *list_skb;
> +	bool has_mac, has_trans;
> +	int headroom, tailroom;
> +	int i, len, seg_len;
> +
> +	if (full_pkt)
> +		full_pkt = atomic_dec_if_positive(&can_dump_full) >= 0;
> +
> +	if (full_pkt)
> +		len = skb->len;

Minor question:
Here we set the len to skb->len if full_pkt is true when skb_dump is
called with frag_list skb and full_pkt being true below, which may
cause some problem?

Maybe change the definition to:
void skb_dump(const char *level, const struct sk_buff *skb, int len, bool full_pkt)


skb_dump(KERN_ERR, skb, skb->len, true);

> +	else
> +		len = min_t(int, skb->len, MAX_HEADER + 128);
> +
> +	headroom = skb_headroom(skb);
> +	tailroom = skb_tailroom(skb);
> +
> +	has_mac = skb_mac_header_was_set(skb);
> +	has_trans = skb_transport_header_was_set(skb);
> +
> +	printk("%sskb len=%u headroom=%u headlen=%u tailroom=%u\n"
> +	       "mac=(%d,%d) net=(%d,%d) trans=%d\n"
> +	       "shinfo(txflags=%u nr_frags=%u gso(size=%hu type=%u segs=%hu))\n"
> +	       "csum(0x%x ip_summed=%u complete_sw=%u valid=%u level=%u)\n"
> +	       "hash(0x%x sw=%u l4=%u) proto=0x%04x pkttype=%u iif=%d\n",
> +	       level, skb->len, headroom, skb_headlen(skb), tailroom,
> +	       has_mac ? skb->mac_header : -1,
> +	       has_mac ? skb_mac_header_len(skb) : -1,
> +	       skb->network_header,
> +	       has_trans ? skb_network_header_len(skb) : -1,
> +	       has_trans ? skb->transport_header : -1,
> +	       sh->tx_flags, sh->nr_frags,
> +	       sh->gso_size, sh->gso_type, sh->gso_segs,
> +	       skb->csum, skb->ip_summed, skb->csum_complete_sw,
> +	       skb->csum_valid, skb->csum_level,
> +	       skb->hash, skb->sw_hash, skb->l4_hash,
> +	       ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
> +
> +	if (dev)
> +		printk("%sdev name=%s feat=0x%pNF\n",
> +		       level, dev->name, &dev->features);
> +	if (sk)
> +		printk("%ssk family=%hu type=%hu proto=%hu\n",
> +		       level, sk->sk_family, sk->sk_type, sk->sk_protocol);
> +
> +	if (full_pkt && headroom)
> +		print_hex_dump(level, "skb headroom: ", DUMP_PREFIX_OFFSET,
> +			       16, 1, skb->head, headroom, false);
> +
> +	seg_len = min_t(int, skb_headlen(skb), len);
> +	if (seg_len)
> +		print_hex_dump(level, "skb linear:   ", DUMP_PREFIX_OFFSET,
> +			       16, 1, skb->data, seg_len, false);
> +	len -= seg_len;
> +
> +	if (full_pkt && tailroom)
> +		print_hex_dump(level, "skb tailroom: ", DUMP_PREFIX_OFFSET,
> +			       16, 1, skb_tail_pointer(skb), tailroom, false);
> +
> +	for (i = 0; len && i < skb_shinfo(skb)->nr_frags; i++) {
> +		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
> +		u32 p_off, p_len, copied;
> +		struct page *p;
> +		u8 *vaddr;
> +
> +		skb_frag_foreach_page(frag, frag->page_offset,
> +				      skb_frag_size(frag), p, p_off, p_len,
> +				      copied) {
> +			seg_len = min_t(int, p_len, len);
> +			vaddr = kmap_atomic(p);
> +			print_hex_dump(level, "skb frag:     ",
> +				       DUMP_PREFIX_OFFSET,
> +				       16, 1, vaddr + p_off, seg_len, false);
> +			kunmap_atomic(vaddr);
> +			len -= seg_len;
> +			if (!len)
> +				break;
> +		}
> +	}
> +
> +	if (len && skb_has_frag_list(skb)) {
> +		printk("skb fraglist:\n");
> +		skb_walk_frags(skb, list_skb) {
> +			if (len <= 0)
> +				break;
> +			skb_dump(level, list_skb, len);

Here we call skb_dump passing len as full_pkt.

Maybe call it with skb_dump(level, list_skb, len, full_pkt);

> +			len -= list_skb->len;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(skb_dump);
> +
>  /**
>   *	skb_tx_error - report an sk_buff xmit error
>   *	@skb: buffer that triggered an error
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE71280B85
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733290AbgJBAHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:07:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:59758 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731525AbgJBAHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 20:07:49 -0400
IronPort-SDR: dJcHYcJJv1mcbSw7i/kHCS8c9vWGwTTaKtjy22X6RCot0TKj6dGcIBWumBTElHbGaiQx7hoOnc
 RGOlP6G3yqxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="142268231"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="142268231"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 17:07:47 -0700
IronPort-SDR: lvUZsNB6PPyJarpZrpju9SOZJL7OPYbLgeITlBuTe1MBJkZTigTu7UqQ97yjK/P/uGYdpEgoL2
 HOPXR7HyS5WA==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="294641290"
Received: from vuongn2x-mobl.amr.corp.intel.com ([10.255.228.170])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 17:07:47 -0700
Date:   Thu, 1 Oct 2020 17:07:45 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@vuongn2x-mobl.amr.corp.intel.com
To:     Stephen Rothwell <sfr@canb.auug.org.au>
cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net
 tree
In-Reply-To: <20201001134936.305b51c6@canb.auug.org.au>
Message-ID: <alpine.OSX.2.23.453.2010011700410.40522@vuongn2x-mobl.amr.corp.intel.com>
References: <20201001134936.305b51c6@canb.auug.org.au>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 1 Oct 2020, Stephen Rothwell wrote:

> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>  net/mptcp/protocol.c
>
> between commit:
>
>  917944da3bfc ("mptcp: Consistently use READ_ONCE/WRITE_ONCE with msk->ack_seq")
>
> from the net tree and commit:
>
>  8268ed4c9d19 ("mptcp: introduce and use mptcp_try_coalesce()")
>  ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue.")
>
> from the net-next tree.
>
> I fixed it up (I think - see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
>

Hi Stephen,

I am fine with introducing the WRITE_ONCE() in __mptcp_move_skb() as your 
conflict resolution does, or I can submit a patch later to add the 
WRITE_ONCE() in that location. The latter is what I suggested to David 
when submitting the patch to the net tree.

Thanks,

Mat


>
> diff --cc net/mptcp/protocol.c
> index 5d747c6a610e,34c037731f35..000000000000
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@@ -112,64 -112,205 +112,205 @@@ static int __mptcp_socket_create(struc
>  	return 0;
>  }
>
> - static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
> - 			     struct sk_buff *skb,
> - 			     unsigned int offset, size_t copy_len)
> + static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
> + {
> + 	sk_drops_add(sk, skb);
> + 	__kfree_skb(skb);
> + }
> +
> + static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
> + 			       struct sk_buff *from)
> + {
> + 	bool fragstolen;
> + 	int delta;
> +
> + 	if (MPTCP_SKB_CB(from)->offset ||
> + 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
> + 		return false;
> +
> + 	pr_debug("colesced seq %llx into %llx new len %d new end seq %llx",
> + 		 MPTCP_SKB_CB(from)->map_seq, MPTCP_SKB_CB(to)->map_seq,
> + 		 to->len, MPTCP_SKB_CB(from)->end_seq);
> + 	MPTCP_SKB_CB(to)->end_seq = MPTCP_SKB_CB(from)->end_seq;
> + 	kfree_skb_partial(from, fragstolen);
> + 	atomic_add(delta, &sk->sk_rmem_alloc);
> + 	sk_mem_charge(sk, delta);
> + 	return true;
> + }
> +
> + static bool mptcp_ooo_try_coalesce(struct mptcp_sock *msk, struct sk_buff *to,
> + 				   struct sk_buff *from)
> + {
> + 	if (MPTCP_SKB_CB(from)->map_seq != MPTCP_SKB_CB(to)->end_seq)
> + 		return false;
> +
> + 	return mptcp_try_coalesce((struct sock *)msk, to, from);
> + }
> +
> + /* "inspired" by tcp_data_queue_ofo(), main differences:
> +  * - use mptcp seqs
> +  * - don't cope with sacks
> +  */
> + static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
>  {
>  	struct sock *sk = (struct sock *)msk;
> - 	struct sk_buff *tail;
> + 	struct rb_node **p, *parent;
> + 	u64 seq, end_seq, max_seq;
> + 	struct sk_buff *skb1;
> + 	int space;
> +
> + 	seq = MPTCP_SKB_CB(skb)->map_seq;
> + 	end_seq = MPTCP_SKB_CB(skb)->end_seq;
> + 	space = tcp_space(sk);
> + 	max_seq = space > 0 ? space + msk->ack_seq : msk->ack_seq;
> +
> + 	pr_debug("msk=%p seq=%llx limit=%llx empty=%d", msk, seq, max_seq,
> + 		 RB_EMPTY_ROOT(&msk->out_of_order_queue));
> + 	if (after64(seq, max_seq)) {
> + 		/* out of window */
> + 		mptcp_drop(sk, skb);
> + 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_NODSSWINDOW);
> + 		return;
> + 	}
>
> - 	__skb_unlink(skb, &ssk->sk_receive_queue);
> + 	p = &msk->out_of_order_queue.rb_node;
> + 	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUE);
> + 	if (RB_EMPTY_ROOT(&msk->out_of_order_queue)) {
> + 		rb_link_node(&skb->rbnode, NULL, p);
> + 		rb_insert_color(&skb->rbnode, &msk->out_of_order_queue);
> + 		msk->ooo_last_skb = skb;
> + 		goto end;
> + 	}
>
> - 	skb_ext_reset(skb);
> - 	skb_orphan(skb);
> - 	WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
> + 	/* with 2 subflows, adding at end of ooo queue is quite likely
> + 	 * Use of ooo_last_skb avoids the O(Log(N)) rbtree lookup.
> + 	 */
> + 	if (mptcp_ooo_try_coalesce(msk, msk->ooo_last_skb, skb)) {
> + 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOMERGE);
> + 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUETAIL);
> + 		return;
> + 	}
>
> - 	tail = skb_peek_tail(&sk->sk_receive_queue);
> - 	if (offset == 0 && tail) {
> - 		bool fragstolen;
> - 		int delta;
> + 	/* Can avoid an rbtree lookup if we are adding skb after ooo_last_skb */
> + 	if (!before64(seq, MPTCP_SKB_CB(msk->ooo_last_skb)->end_seq)) {
> + 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUETAIL);
> + 		parent = &msk->ooo_last_skb->rbnode;
> + 		p = &parent->rb_right;
> + 		goto insert;
> + 	}
>
> - 		if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
> - 			kfree_skb_partial(skb, fragstolen);
> - 			atomic_add(delta, &sk->sk_rmem_alloc);
> - 			sk_mem_charge(sk, delta);
> + 	/* Find place to insert this segment. Handle overlaps on the way. */
> + 	parent = NULL;
> + 	while (*p) {
> + 		parent = *p;
> + 		skb1 = rb_to_skb(parent);
> + 		if (before64(seq, MPTCP_SKB_CB(skb1)->map_seq)) {
> + 			p = &parent->rb_left;
> + 			continue;
> + 		}
> + 		if (before64(seq, MPTCP_SKB_CB(skb1)->end_seq)) {
> + 			if (!after64(end_seq, MPTCP_SKB_CB(skb1)->end_seq)) {
> + 				/* All the bits are present. Drop. */
> + 				mptcp_drop(sk, skb);
> + 				MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
> + 				return;
> + 			}
> + 			if (after64(seq, MPTCP_SKB_CB(skb1)->map_seq)) {
> + 				/* partial overlap:
> + 				 *     |     skb      |
> + 				 *  |     skb1    |
> + 				 * continue traversing
> + 				 */
> + 			} else {
> + 				/* skb's seq == skb1's seq and skb covers skb1.
> + 				 * Replace skb1 with skb.
> + 				 */
> + 				rb_replace_node(&skb1->rbnode, &skb->rbnode,
> + 						&msk->out_of_order_queue);
> + 				mptcp_drop(sk, skb1);
> + 				MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
> + 				goto merge_right;
> + 			}
> + 		} else if (mptcp_ooo_try_coalesce(msk, skb1, skb)) {
> + 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOMERGE);
>  			return;
>  		}
> + 		p = &parent->rb_right;
>  	}
>
> - 	skb_set_owner_r(skb, sk);
> - 	__skb_queue_tail(&sk->sk_receive_queue, skb);
> - 	MPTCP_SKB_CB(skb)->offset = offset;
> - }
> + insert:
> + 	/* Insert segment into RB tree. */
> + 	rb_link_node(&skb->rbnode, parent, p);
> + 	rb_insert_color(&skb->rbnode, &msk->out_of_order_queue);
>
> - static void mptcp_stop_timer(struct sock *sk)
> - {
> - 	struct inet_connection_sock *icsk = inet_csk(sk);
> + merge_right:
> + 	/* Remove other segments covered by skb. */
> + 	while ((skb1 = skb_rb_next(skb)) != NULL) {
> + 		if (before64(end_seq, MPTCP_SKB_CB(skb1)->end_seq))
> + 			break;
> + 		rb_erase(&skb1->rbnode, &msk->out_of_order_queue);
> + 		mptcp_drop(sk, skb1);
> + 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
> + 	}
> + 	/* If there is no skb after us, we are the last_skb ! */
> + 	if (!skb1)
> + 		msk->ooo_last_skb = skb;
>
> - 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
> - 	mptcp_sk(sk)->timer_ival = 0;
> + end:
> + 	skb_condense(skb);
> + 	skb_set_owner_r(skb, sk);
>  }
>
> - /* both sockets must be locked */
> - static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
> - 				    struct sock *ssk)
> + static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
> + 			     struct sk_buff *skb, unsigned int offset,
> + 			     size_t copy_len)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
> - 	u64 dsn = mptcp_subflow_get_mapped_dsn(subflow);
> + 	struct sock *sk = (struct sock *)msk;
> + 	struct sk_buff *tail;
>
> - 	/* revalidate data sequence number.
> - 	 *
> - 	 * mptcp_subflow_data_available() is usually called
> - 	 * without msk lock.  Its unlikely (but possible)
> - 	 * that msk->ack_seq has been advanced since the last
> - 	 * call found in-sequence data.
> + 	__skb_unlink(skb, &ssk->sk_receive_queue);
> +
> + 	skb_ext_reset(skb);
> + 	skb_orphan(skb);
> +
> + 	/* the skb map_seq accounts for the skb offset:
> + 	 * mptcp_subflow_get_mapped_dsn() is based on the current tp->copied_seq
> + 	 * value
>  	 */
> - 	if (likely(dsn == msk->ack_seq))
> + 	MPTCP_SKB_CB(skb)->map_seq = mptcp_subflow_get_mapped_dsn(subflow);
> + 	MPTCP_SKB_CB(skb)->end_seq = MPTCP_SKB_CB(skb)->map_seq + copy_len;
> + 	MPTCP_SKB_CB(skb)->offset = offset;
> +
> + 	if (MPTCP_SKB_CB(skb)->map_seq == msk->ack_seq) {
> + 		/* in sequence */
> -		msk->ack_seq += copy_len;
> ++		WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
> + 		tail = skb_peek_tail(&sk->sk_receive_queue);
> + 		if (tail && mptcp_try_coalesce(sk, tail, skb))
> + 			return true;
> +
> + 		skb_set_owner_r(skb, sk);
> + 		__skb_queue_tail(&sk->sk_receive_queue, skb);
>  		return true;
> + 	} else if (after64(MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq)) {
> + 		mptcp_data_queue_ofo(msk, skb);
> + 		return false;
> + 	}
>
> - 	subflow->data_avail = 0;
> - 	return mptcp_subflow_data_available(ssk);
> + 	/* old data, keep it simple and drop the whole pkt, sender
> + 	 * will retransmit as needed, if needed.
> + 	 */
> + 	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
> + 	mptcp_drop(sk, skb);
> + 	return false;
> + }
> +
> + static void mptcp_stop_timer(struct sock *sk)
> + {
> + 	struct inet_connection_sock *icsk = inet_csk(sk);
> +
> + 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
> + 	mptcp_sk(sk)->timer_ival = 0;
>  }
>
>  static void mptcp_check_data_fin_ack(struct sock *sk)
>

--
Mat Martineau
Intel

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1DB27F83A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 05:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgJADtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 23:49:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43343 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgJADtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 23:49:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1zds39sxz9sTs;
        Thu,  1 Oct 2020 13:49:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601524178;
        bh=AGb82oIvilqjQ4RyNnBQ/75lbtR5jPycsZgAXY7Q+34=;
        h=Date:From:To:Cc:Subject:From;
        b=UtU8xdkY5NlpcxFYCuarMPxhXkiFfTG9+DXck2lCM3mhnIFGj50aew7QStrbNtITe
         /uSw3+Xln/gpfKSaQ+kV1VsIVkYsoQNe00buHhySC/wu9FucUzc76QEKKH6KLgco4F
         NUVgF2ly/ehjsF5+i2IBU0C2zGLpMa0N1HM3gTBnMi73ceaOs5YXwsV/qktlnLmTek
         pTW1LT3QRvpcSnJfPTSV2HkR1/zFXCanWjrnbzmfwvuqUDr9ZDdyMhJEDIDfzPG/U+
         AV2bH6R9X1NyYGDpabme5rDCPG6hw4rRPzFAdvQoMpj7CkTWJerjyA6Jao2c+lfsxx
         FnPioZRQIbw4g==
Date:   Thu, 1 Oct 2020 13:49:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201001134936.305b51c6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HEv+g/4XKNk=U/3cwuW5gKI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/HEv+g/4XKNk=U/3cwuW5gKI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mptcp/protocol.c

between commit:

  917944da3bfc ("mptcp: Consistently use READ_ONCE/WRITE_ONCE with msk->ack=
_seq")

from the net tree and commit:

  8268ed4c9d19 ("mptcp: introduce and use mptcp_try_coalesce()")
  ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue.")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/mptcp/protocol.c
index 5d747c6a610e,34c037731f35..000000000000
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@@ -112,64 -112,205 +112,205 @@@ static int __mptcp_socket_create(struc
  	return 0;
  }
 =20
- static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
- 			     struct sk_buff *skb,
- 			     unsigned int offset, size_t copy_len)
+ static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
+ {
+ 	sk_drops_add(sk, skb);
+ 	__kfree_skb(skb);
+ }
+=20
+ static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
+ 			       struct sk_buff *from)
+ {
+ 	bool fragstolen;
+ 	int delta;
+=20
+ 	if (MPTCP_SKB_CB(from)->offset ||
+ 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
+ 		return false;
+=20
+ 	pr_debug("colesced seq %llx into %llx new len %d new end seq %llx",
+ 		 MPTCP_SKB_CB(from)->map_seq, MPTCP_SKB_CB(to)->map_seq,
+ 		 to->len, MPTCP_SKB_CB(from)->end_seq);
+ 	MPTCP_SKB_CB(to)->end_seq =3D MPTCP_SKB_CB(from)->end_seq;
+ 	kfree_skb_partial(from, fragstolen);
+ 	atomic_add(delta, &sk->sk_rmem_alloc);
+ 	sk_mem_charge(sk, delta);
+ 	return true;
+ }
+=20
+ static bool mptcp_ooo_try_coalesce(struct mptcp_sock *msk, struct sk_buff=
 *to,
+ 				   struct sk_buff *from)
+ {
+ 	if (MPTCP_SKB_CB(from)->map_seq !=3D MPTCP_SKB_CB(to)->end_seq)
+ 		return false;
+=20
+ 	return mptcp_try_coalesce((struct sock *)msk, to, from);
+ }
+=20
+ /* "inspired" by tcp_data_queue_ofo(), main differences:
+  * - use mptcp seqs
+  * - don't cope with sacks
+  */
+ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *=
skb)
  {
  	struct sock *sk =3D (struct sock *)msk;
- 	struct sk_buff *tail;
+ 	struct rb_node **p, *parent;
+ 	u64 seq, end_seq, max_seq;
+ 	struct sk_buff *skb1;
+ 	int space;
+=20
+ 	seq =3D MPTCP_SKB_CB(skb)->map_seq;
+ 	end_seq =3D MPTCP_SKB_CB(skb)->end_seq;
+ 	space =3D tcp_space(sk);
+ 	max_seq =3D space > 0 ? space + msk->ack_seq : msk->ack_seq;
+=20
+ 	pr_debug("msk=3D%p seq=3D%llx limit=3D%llx empty=3D%d", msk, seq, max_se=
q,
+ 		 RB_EMPTY_ROOT(&msk->out_of_order_queue));
+ 	if (after64(seq, max_seq)) {
+ 		/* out of window */
+ 		mptcp_drop(sk, skb);
+ 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_NODSSWINDOW);
+ 		return;
+ 	}
 =20
- 	__skb_unlink(skb, &ssk->sk_receive_queue);
+ 	p =3D &msk->out_of_order_queue.rb_node;
+ 	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUE);
+ 	if (RB_EMPTY_ROOT(&msk->out_of_order_queue)) {
+ 		rb_link_node(&skb->rbnode, NULL, p);
+ 		rb_insert_color(&skb->rbnode, &msk->out_of_order_queue);
+ 		msk->ooo_last_skb =3D skb;
+ 		goto end;
+ 	}
 =20
- 	skb_ext_reset(skb);
- 	skb_orphan(skb);
- 	WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
+ 	/* with 2 subflows, adding at end of ooo queue is quite likely
+ 	 * Use of ooo_last_skb avoids the O(Log(N)) rbtree lookup.
+ 	 */
+ 	if (mptcp_ooo_try_coalesce(msk, msk->ooo_last_skb, skb)) {
+ 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOMERGE);
+ 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUETAIL);
+ 		return;
+ 	}
 =20
- 	tail =3D skb_peek_tail(&sk->sk_receive_queue);
- 	if (offset =3D=3D 0 && tail) {
- 		bool fragstolen;
- 		int delta;
+ 	/* Can avoid an rbtree lookup if we are adding skb after ooo_last_skb */
+ 	if (!before64(seq, MPTCP_SKB_CB(msk->ooo_last_skb)->end_seq)) {
+ 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOQUEUETAIL);
+ 		parent =3D &msk->ooo_last_skb->rbnode;
+ 		p =3D &parent->rb_right;
+ 		goto insert;
+ 	}
 =20
- 		if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
- 			kfree_skb_partial(skb, fragstolen);
- 			atomic_add(delta, &sk->sk_rmem_alloc);
- 			sk_mem_charge(sk, delta);
+ 	/* Find place to insert this segment. Handle overlaps on the way. */
+ 	parent =3D NULL;
+ 	while (*p) {
+ 		parent =3D *p;
+ 		skb1 =3D rb_to_skb(parent);
+ 		if (before64(seq, MPTCP_SKB_CB(skb1)->map_seq)) {
+ 			p =3D &parent->rb_left;
+ 			continue;
+ 		}
+ 		if (before64(seq, MPTCP_SKB_CB(skb1)->end_seq)) {
+ 			if (!after64(end_seq, MPTCP_SKB_CB(skb1)->end_seq)) {
+ 				/* All the bits are present. Drop. */
+ 				mptcp_drop(sk, skb);
+ 				MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
+ 				return;
+ 			}
+ 			if (after64(seq, MPTCP_SKB_CB(skb1)->map_seq)) {
+ 				/* partial overlap:
+ 				 *     |     skb      |
+ 				 *  |     skb1    |
+ 				 * continue traversing
+ 				 */
+ 			} else {
+ 				/* skb's seq =3D=3D skb1's seq and skb covers skb1.
+ 				 * Replace skb1 with skb.
+ 				 */
+ 				rb_replace_node(&skb1->rbnode, &skb->rbnode,
+ 						&msk->out_of_order_queue);
+ 				mptcp_drop(sk, skb1);
+ 				MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
+ 				goto merge_right;
+ 			}
+ 		} else if (mptcp_ooo_try_coalesce(msk, skb1, skb)) {
+ 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_OFOMERGE);
  			return;
  		}
+ 		p =3D &parent->rb_right;
  	}
 =20
- 	skb_set_owner_r(skb, sk);
- 	__skb_queue_tail(&sk->sk_receive_queue, skb);
- 	MPTCP_SKB_CB(skb)->offset =3D offset;
- }
+ insert:
+ 	/* Insert segment into RB tree. */
+ 	rb_link_node(&skb->rbnode, parent, p);
+ 	rb_insert_color(&skb->rbnode, &msk->out_of_order_queue);
 =20
- static void mptcp_stop_timer(struct sock *sk)
- {
- 	struct inet_connection_sock *icsk =3D inet_csk(sk);
+ merge_right:
+ 	/* Remove other segments covered by skb. */
+ 	while ((skb1 =3D skb_rb_next(skb)) !=3D NULL) {
+ 		if (before64(end_seq, MPTCP_SKB_CB(skb1)->end_seq))
+ 			break;
+ 		rb_erase(&skb1->rbnode, &msk->out_of_order_queue);
+ 		mptcp_drop(sk, skb1);
+ 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
+ 	}
+ 	/* If there is no skb after us, we are the last_skb ! */
+ 	if (!skb1)
+ 		msk->ooo_last_skb =3D skb;
 =20
- 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
- 	mptcp_sk(sk)->timer_ival =3D 0;
+ end:
+ 	skb_condense(skb);
+ 	skb_set_owner_r(skb, sk);
  }
 =20
- /* both sockets must be locked */
- static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
- 				    struct sock *ssk)
+ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
+ 			     struct sk_buff *skb, unsigned int offset,
+ 			     size_t copy_len)
  {
  	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(ssk);
- 	u64 dsn =3D mptcp_subflow_get_mapped_dsn(subflow);
+ 	struct sock *sk =3D (struct sock *)msk;
+ 	struct sk_buff *tail;
 =20
- 	/* revalidate data sequence number.
- 	 *
- 	 * mptcp_subflow_data_available() is usually called
- 	 * without msk lock.  Its unlikely (but possible)
- 	 * that msk->ack_seq has been advanced since the last
- 	 * call found in-sequence data.
+ 	__skb_unlink(skb, &ssk->sk_receive_queue);
+=20
+ 	skb_ext_reset(skb);
+ 	skb_orphan(skb);
+=20
+ 	/* the skb map_seq accounts for the skb offset:
+ 	 * mptcp_subflow_get_mapped_dsn() is based on the current tp->copied_seq
+ 	 * value
  	 */
- 	if (likely(dsn =3D=3D msk->ack_seq))
+ 	MPTCP_SKB_CB(skb)->map_seq =3D mptcp_subflow_get_mapped_dsn(subflow);
+ 	MPTCP_SKB_CB(skb)->end_seq =3D MPTCP_SKB_CB(skb)->map_seq + copy_len;
+ 	MPTCP_SKB_CB(skb)->offset =3D offset;
+=20
+ 	if (MPTCP_SKB_CB(skb)->map_seq =3D=3D msk->ack_seq) {
+ 		/* in sequence */
 -		msk->ack_seq +=3D copy_len;
++		WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
+ 		tail =3D skb_peek_tail(&sk->sk_receive_queue);
+ 		if (tail && mptcp_try_coalesce(sk, tail, skb))
+ 			return true;
+=20
+ 		skb_set_owner_r(skb, sk);
+ 		__skb_queue_tail(&sk->sk_receive_queue, skb);
  		return true;
+ 	} else if (after64(MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq)) {
+ 		mptcp_data_queue_ofo(msk, skb);
+ 		return false;
+ 	}
 =20
- 	subflow->data_avail =3D 0;
- 	return mptcp_subflow_data_available(ssk);
+ 	/* old data, keep it simple and drop the whole pkt, sender
+ 	 * will retransmit as needed, if needed.
+ 	 */
+ 	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
+ 	mptcp_drop(sk, skb);
+ 	return false;
+ }
+=20
+ static void mptcp_stop_timer(struct sock *sk)
+ {
+ 	struct inet_connection_sock *icsk =3D inet_csk(sk);
+=20
+ 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
+ 	mptcp_sk(sk)->timer_ival =3D 0;
  }
 =20
  static void mptcp_check_data_fin_ack(struct sock *sk)

--Sig_/HEv+g/4XKNk=U/3cwuW5gKI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl91UdAACgkQAVBC80lX
0Gz4Bgf+J0QZpbjcwfY6mMQdickY94A7OHkQxgCcR5QtKBubNx3uXmIwei4IFT9T
ly6Jei3Z1sGVnFumuZDKlsqXnwwJxT8XKA2FZkxyqFuVQuCTN1BLXIscMfo019IA
En3YR1+ObFVt6NRfeVLmiMKWZZErkRNkzoE9qho3S+rdZbuLU9tngupy8PiB/hrc
zHU16iDBlO/lZz7E31iGrE4NZWvi2YM3J+TwdAGh7M8qqCAtBUoSMEVjmqTRBy4I
R/+y2b8L9Ec2b/X93Pty1MYTrvXOp5ynfvUj/Z1AXGE8gKtjEyIJKCTdy5alXRoz
P8Or9QpwHUuTMCvvCGWWeZXcdslcNg==
=73X4
-----END PGP SIGNATURE-----

--Sig_/HEv+g/4XKNk=U/3cwuW5gKI--

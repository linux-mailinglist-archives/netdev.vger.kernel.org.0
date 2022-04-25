Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E3650E928
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbiDYTKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiDYTKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4212408C
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 12:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F94BB81A03
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD1EC385A4;
        Mon, 25 Apr 2022 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650913645;
        bh=c9aVgaKByWzbJk8FJJBLMLLsiimAFYjHNDJjIlDoYhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/YnSatVVkxUN61AdBzLFdQqgkqMAg0gJ0ZxnyBvIbz8thsH7QsnmliGF+O2/hl1X
         6Hduh7PAm4YQ/o8MQFkR5Yvv2ix2+tQ1fXgDPOvjSZiR0CUP5f6BlhzgocN6XP1FLW
         q6rTzjTUo2mX7iuZBCZ13DSi8Oa1s9ar00NzRXb/FXh316d3s5WkOojSA2NrtZhQgb
         k0WqFPCGCz44Gqw/UpUdtGeQLQwfWLp3WkWFk/GoWdx/z9GCZBl+6aFm7rGnvDaHHq
         ru941psVTY/6lirggjqfoUCmwVWZUgTShxH81YlxKvGcx6rqnzNE4dTcbk+NtNGS1R
         Rnq+s9IggemVA==
Date:   Mon, 25 Apr 2022 12:07:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
Message-ID: <20220425120724.32af0cc3@kernel.org>
In-Reply-To: <20220410161042.183540-2-xiyou.wangcong@gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
        <20220410161042.183540-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Apr 2022 09:10:39 -0700 Cong Wang wrote:
> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +		 sk_read_actor_t recv_actor)
> +{
> +	struct sk_buff *skb;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	u32 seq =3D tp->copied_seq;
> +	u32 offset;
> +	int copied =3D 0;
> +
> +	if (sk->sk_state =3D=3D TCP_LISTEN)
> +		return -ENOTCONN;
> +	while ((skb =3D tcp_recv_skb(sk, seq, &offset, true)) !=3D NULL) {
> +		if (offset < skb->len) {
> +			int used;
> +			size_t len;
> +
> +			len =3D skb->len - offset;
> +			used =3D recv_actor(desc, skb, offset, len);
> +			if (used <=3D 0) {
> +				if (!copied)
> +					copied =3D used;
> +				break;
> +			}
> +			if (WARN_ON_ONCE(used > len))
> +				used =3D len;
> +			seq +=3D used;
> +			copied +=3D used;
> +			offset +=3D used;
> +
> +			if (offset !=3D skb->len)
> +				continue;
> +		}
> +		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> +			kfree_skb(skb);
> +			++seq;
> +			break;
> +		}
> +		kfree_skb(skb);
> +		if (!desc->count)
> +			break;
> +		WRITE_ONCE(tp->copied_seq, seq);
> +	}
> +	WRITE_ONCE(tp->copied_seq, seq);
> +
> +	tcp_rcv_space_adjust(sk);
> +
> +	/* Clean up data we have read: This will do ACK frames. */
> +	if (copied > 0)
> +		tcp_cleanup_rbuf(sk, copied);
> +
> +	return copied;
> +}
> +EXPORT_SYMBOL(tcp_read_skb);

I started prototyping a similar patch for TLS a while back but I have
two functions - one to get the skb and another to consume it. I thought
that's better for TLS, otherwise skbs stuck in the middle layer are not
counted towards the rbuf. Any thoughts on structuring the API that way?
I guess we can refactor that later, since TLS TCP-only we don't need
proto_ops plumbing there.

Overall =F0=9F=91=8D for adding such API.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D11580FDF
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiGZJ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 05:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGZJ1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 05:27:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DAAF2ED77
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 02:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658827666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzRJTY2BkWcD6N1x9s7TLi4RG0IqV7Akjb1ii3ncrMg=;
        b=LVw0GgQUFxpxbwkbdYlXi+gsK0jFf0xFapgPgpDdzGkbltQsmMNfCA197/jJlv9r4j9b45
        L7jIVBhU0a4PMb7khtfSx24aDN05K65CxxQ8bqf1xRdJiv0VIq1uO91iUy1HapMo1U+yWB
        HROZTDMWALKHYDarR3Au5DKpTXXjx0E=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-zvsKU0B7Nh68dP4hYmJ7ew-1; Tue, 26 Jul 2022 05:27:41 -0400
X-MC-Unique: zvsKU0B7Nh68dP4hYmJ7ew-1
Received: by mail-qv1-f71.google.com with SMTP id mu18-20020a056214329200b0047447848e30so3345215qvb.3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 02:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZzRJTY2BkWcD6N1x9s7TLi4RG0IqV7Akjb1ii3ncrMg=;
        b=ndismZZ07+ElcuC73aGnoo0lWcGDitX/HTIRKgxf5td48rMFwRX1DFJvNrsqdzFFDF
         zw8aOuDY6S96MYysyPjUbgsa3f3uOSIFvwu8qQK21Gg8D0/tecE5s9fCKdt2b39bUq2H
         1hi8D5xxj/RtTzGO5Pp9j7JhlFPZ0qkXlmwoE41V6vl99sZKS6L28c8KrjpzAKkCGTFA
         UD8sv0pxix1T6ALRXRl4bhpZV6Wzl9eQq4Cn7kz92YUj/7heM8Bcu4iuu7HR85WCg06y
         Hvl3laQOoJMExbO5j/4dTzvhJIj2HM5OI/QRv1n5jRkslLEvhRikempA+CO0k9hbrUJB
         GNFA==
X-Gm-Message-State: AJIora9CTU+4DoOk1x3bdGNKCKL2oC07iQ1xhLfBN5oayCT4ihpDKXE3
        ZrRAAnW5AoOXwkBtQ1/nJur0YndgtBcWShdqmVTX5a8tFJN1ScACTS4rR7q3PPQT7KqS/63j0AR
        NAjx7IXRREDKeD1qB
X-Received: by 2002:a05:620a:1a09:b0:6b6:63a3:7291 with SMTP id bk9-20020a05620a1a0900b006b663a37291mr4299894qkb.317.1658827660872;
        Tue, 26 Jul 2022 02:27:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uzxFN59ptq8TG2U6Wp5I2dV43iVKW6EQdPS2Z6JNeAU95WYPvcEfN3qQbyoHB/APM/KR8scg==
X-Received: by 2002:a05:620a:1a09:b0:6b6:63a3:7291 with SMTP id bk9-20020a05620a1a0900b006b663a37291mr4299877qkb.317.1658827660386;
        Tue, 26 Jul 2022 02:27:40 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id x7-20020ac87007000000b0031636caa40bsm8994801qtm.65.2022.07.26.02.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:27:39 -0700 (PDT)
Message-ID: <506b4478378d5bdcdf4a43bd6e2b48dd0dcd6b5d.camel@redhat.com>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, borisp@nvidia.com,
        john.fastabend@gmail.com, maximmi@nvidia.com, tariqt@nvidia.com,
        vfedorenko@novek.ru
Date:   Tue, 26 Jul 2022 11:27:36 +0200
In-Reply-To: <20220722235033.2594446-8-kuba@kernel.org>
References: <20220722235033.2594446-1-kuba@kernel.org>
         <20220722235033.2594446-8-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-07-22 at 16:50 -0700, Jakub Kicinski wrote:
> TLS is a relatively poor fit for strparser. We pause the input
> every time a message is received, wait for a read which will
> decrypt the message, start the parser, repeat. strparser is
> built to delineate the messages, wrap them in individual skbs
> and let them float off into the stack or a different socket.
> TLS wants the data pages and nothing else. There's no need
> for TLS to keep cloning (and occasionally skb_unclone()'ing)
> the TCP rx queue.
> 
> This patch uses a pre-allocated skb and attaches the skbs
> from the TCP rx queue to it as frags. TLS is careful never
> to modify the input skb without CoW'ing / detaching it first.
> 
> Since we call TCP rx queue cleanup directly we also get back
> the benefit of skb deferred free.
> 
> Overall this results in a 6% gain in my benchmarks.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I'm sorry for the incremental feedback, I have a few minor comment
below, hopefully nothing blocking.

> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> ---
>  include/net/tls.h  |  19 +-
>  net/tls/tls.h      |  24 ++-
>  net/tls/tls_main.c |  20 +-
>  net/tls/tls_strp.c | 484 +++++++++++++++++++++++++++++++++++++++++++--
>  net/tls/tls_sw.c   |  80 ++++----
>  5 files changed, 558 insertions(+), 69 deletions(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 181c496b01b8..abb050b0df83 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -108,18 +108,33 @@ struct tls_sw_context_tx {
>  	unsigned long tx_bitmask;
>  };
>  
> +struct tls_strparser {
> +	struct sock *sk;
> +
> +	u32 mark : 8;
> +	u32 stopped : 1;
> +	u32 copy_mode : 1;
> +	u32 msg_ready : 1;
> +
> +	struct strp_msg stm;
> +
> +	struct sk_buff *anchor;
> +	struct work_struct work;
> +};
> +
>  struct tls_sw_context_rx {
>  	struct crypto_aead *aead_recv;
>  	struct crypto_wait async_wait;
> -	struct strparser strp;
>  	struct sk_buff_head rx_list;	/* list of decrypted 'data' records */
>  	void (*saved_data_ready)(struct sock *sk);
>  
> -	struct sk_buff *recv_pkt;
>  	u8 reader_present;
>  	u8 async_capable:1;
>  	u8 zc_capable:1;
>  	u8 reader_contended:1;
> +
> +	struct tls_strparser strp;
> +
>  	atomic_t decrypt_pending;
>  	/* protect crypto_wait with decrypt_pending*/
>  	spinlock_t decrypt_compl_lock;
> diff --git a/net/tls/tls.h b/net/tls/tls.h
> index 154a3773e785..0e840a0c3437 100644
> --- a/net/tls/tls.h
> +++ b/net/tls/tls.h
> @@ -1,4 +1,5 @@
>  /*
> + * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>

It's a little strange to me the above line ??! digging this file
history, you created it out of include/net/tls.h and the latter was
originally authored by Dave Watson (modulo ENOCOFFEE here...)

[...]

> diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
> index d9bb4f23f01a..b945288c312e 100644
> --- a/net/tls/tls_strp.c
> +++ b/net/tls/tls_strp.c
> @@ -1,37 +1,493 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2016 Tom Herbert <tom@herbertland.com> */

Same here ...

>  #include <linux/skbuff.h>
> +#include <linux/workqueue.h>
> +#include <net/strparser.h>
> +#include <net/tcp.h>
> +#include <net/sock.h>
> +#include <net/tls.h>
>  
>  #include "tls.h"
>  
> -struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx)
> +static struct workqueue_struct *tls_strp_wq;
> +
> +static void tls_strp_abort_strp(struct tls_strparser *strp, int err)
> +{
> +	if (strp->stopped)
> +		return;
> +
> +	strp->stopped = 1;
> +
> +	/* Report an error on the lower socket */
> +	strp->sk->sk_err = -err;
> +	sk_error_report(strp->sk);
> +}
> +
> +static void tls_strp_anchor_free(struct tls_strparser *strp)
>  {
> +	struct skb_shared_info *shinfo = skb_shinfo(strp->anchor);
> +
> +	DEBUG_NET_WARN_ON_ONCE(atomic_read(&shinfo->dataref) != 1);
> +	shinfo->frag_list = NULL;
> +	consume_skb(strp->anchor);
> +	strp->anchor = NULL;
> +}
> +
> +/* Create a new skb with the contents of input copied to its page frags */
> +static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
> +{
> +	struct strp_msg *rxm;
>  	struct sk_buff *skb;
> +	int i, err, offset;
> +
> +	skb = alloc_skb_with_frags(0, strp->anchor->len, TLS_PAGE_ORDER,
> +				   &err, strp->sk->sk_allocation);
> +	if (!skb)
> +		return NULL;
> +
> +	offset = strp->stm.offset;
> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
>  
> -	skb = ctx->recv_pkt;
> -	ctx->recv_pkt = NULL;
> +		WARN_ON_ONCE(skb_copy_bits(strp->anchor, offset,
> +					   skb_frag_address(frag),
> +					   skb_frag_size(frag)));
> +		offset += skb_frag_size(frag);
> +	}
> +
> +	skb_copy_header(skb, strp->anchor);
> +	rxm = strp_msg(skb);
> +	rxm->offset = 0;
>  	return skb;
>  }
>  
> +/* Steal the input skb, input msg is invalid after calling this function */
> +struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx)
> +{
> +	struct tls_strparser *strp = &ctx->strp;
> +
> +#ifdef CONFIG_TLS_DEVICE
> +	DEBUG_NET_WARN_ON_ONCE(!strp->anchor->decrypted);
> +#else
> +	/* This function turns an input into an output,
> +	 * that can only happen if we have offload.
> +	 */
> +	WARN_ON(1);
> +#endif
> +
> +	if (strp->copy_mode) {
> +		struct sk_buff *skb;
> +
> +		/* Replace anchor with an empty skb, this is a little
> +		 * dangerous but __tls_cur_msg() warns on empty skbs
> +		 * so hopefully we'll catch abuses.
> +		 */
> +		skb = alloc_skb(0, strp->sk->sk_allocation);
> +		if (!skb)
> +			return NULL;
> +
> +		swap(strp->anchor, skb);
> +		return skb;
> +	}
> +
> +	return tls_strp_msg_make_copy(strp);
> +}
> +
> +/* Force the input skb to be in copy mode. The data ownership remains
> + * with the input skb itself (meaning unpause will wipe it) but it can
> + * be modified.
> + */
>  int tls_strp_msg_cow(struct tls_sw_context_rx *ctx)
>  {
> -	struct sk_buff *unused;
> -	int nsg;
> +	struct tls_strparser *strp = &ctx->strp;
> +	struct sk_buff *skb;
> +
> +	if (strp->copy_mode)
> +		return 0;
> +
> +	skb = tls_strp_msg_make_copy(strp);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	tls_strp_anchor_free(strp);
> +	strp->anchor = skb;
> +
> +	tcp_read_done(strp->sk, strp->stm.full_len);
> +	strp->copy_mode = 1;
> +
> +	return 0;
> +}
> +
> +/* Make a clone (in the skb sense) of the input msg to keep a reference
> + * to the underlying data. The reference-holding skbs get placed on
> + * @dst.
> + */
> +int tls_strp_msg_hold(struct tls_strparser *strp, struct sk_buff_head *dst)
> +{
> +	struct skb_shared_info *shinfo = skb_shinfo(strp->anchor);
> +
> +	if (strp->copy_mode) {
> +		struct sk_buff *skb;
> +
> +		WARN_ON_ONCE(!shinfo->nr_frags);
> +
> +		/* We can't skb_clone() the anchor, it gets wiped by unpause */
> +		skb = alloc_skb(0, strp->sk->sk_allocation);
> +		if (!skb)
> +			return -ENOMEM;
> +
> +		__skb_queue_tail(dst, strp->anchor);
> +		strp->anchor = skb;
> +	} else {
> +		struct sk_buff *iter, *clone;
> +		int chunk, len, offset;
> +
> +		offset = strp->stm.offset;
> +		len = strp->stm.full_len;
> +		iter = shinfo->frag_list;
> +
> +		while (len > 0) {
> +			if (iter->len <= offset) {
> +				offset -= iter->len;
> +				goto next;
> +			}
> +
> +			chunk = iter->len - offset;
> +			offset = 0;
> +
> +			clone = skb_clone(iter, strp->sk->sk_allocation);
> +			if (!clone)
> +				return -ENOMEM;
> +			__skb_queue_tail(dst, clone);
> +
> +			len -= chunk;
> +next:
> +			iter = iter->next;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void tls_strp_flush_anchor_copy(struct tls_strparser *strp)
> +{
> +	struct skb_shared_info *shinfo = skb_shinfo(strp->anchor);
> +	int i;
> +
> +	DEBUG_NET_WARN_ON_ONCE(atomic_read(&shinfo->dataref) != 1);
> +
> +	for (i = 0; i < shinfo->nr_frags; i++)
> +		__skb_frag_unref(&shinfo->frags[i], false);
> +	shinfo->nr_frags = 0;
> +	strp->copy_mode = 0;
> +}
> +
> +static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
> +			   unsigned int offset, size_t in_len)
> +{
> +	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
> +	size_t sz, len, chunk;
> +	struct sk_buff *skb;
> +	skb_frag_t *frag;
> +
> +	if (strp->msg_ready)
> +		return 0;
> +
> +	skb = strp->anchor;
> +	frag = &skb_shinfo(skb)->frags[skb->len / PAGE_SIZE];

I'm wondering if TSOv2 GRO packets can reach here? Even without TSO v2,
I *think* the TCP stack is allowed to grow queued skbs above 64K via
tcp_queue_rcv()/tcp_try_coalesce().

> +
> +	len = in_len;
> +	/* First make sure we got the header */
> +	if (!strp->stm.full_len) {
> +		/* Assume one page is more than enough for headers */
> +		chunk =	min_t(size_t, len, PAGE_SIZE - skb_frag_size(frag));
> +		WARN_ON_ONCE(skb_copy_bits(in_skb, offset,
> +					   skb_frag_address(frag) +
> +					   skb_frag_size(frag),
> +					   chunk));
> +
> +		sz = tls_rx_msg_size(strp, strp->anchor);
> +		if (sz < 0) {
> +			desc->error = sz;
> +			return 0;
> +		}
> +
> +		/* We may have over-read, sz == 0 is guaranteed under-read */
> +		if (sz > 0)
> +			chunk =	min_t(size_t, chunk, sz - skb->len);
> +
> +		skb->len += chunk;
> +		skb->data_len += chunk;
> +		skb_frag_size_add(frag, chunk);
> +		frag++;
> +		len -= chunk;
> +		offset += chunk;
> +
> +		strp->stm.full_len = sz;
> +		if (!strp->stm.full_len)
> +			goto read_done;
> +	}
> +
> +	/* Load up more data */
> +	while (len && strp->stm.full_len > skb->len) {
> +		chunk =	min_t(size_t, len, strp->stm.full_len - skb->len);
> +		chunk = min_t(size_t, chunk, PAGE_SIZE - skb_frag_size(frag));
> +		WARN_ON_ONCE(skb_copy_bits(in_skb, offset,
> +					   skb_frag_address(frag) +
> +					   skb_frag_size(frag),
> +					   chunk));
> +
> +		skb->len += chunk;
> +		skb->data_len += chunk;
> +		skb_frag_size_add(frag, chunk);
> +		frag++;
> +		len -= chunk;
> +		offset += chunk;
> +	}
> +
> +	if (strp->stm.full_len == skb->len) {
> +		desc->count = 0;
> +
> +		strp->msg_ready = 1;
> +		tls_rx_msg_ready(strp);
> +	}
> +
> +read_done:
> +	return in_len - len;
> +}
> +
> +static int tls_strp_read_copyin(struct tls_strparser *strp)
> +{
> +	struct socket *sock = strp->sk->sk_socket;
> +	read_descriptor_t desc;
> +
> +	desc.arg.data = strp;
> +	desc.error = 0;
> +	desc.count = 1; /* give more than one skb per call */
> +
> +	/* sk should be locked here, so okay to do read_sock */
> +	sock->ops->read_sock(strp->sk, &desc, tls_strp_copyin);

If you are concerned by indirect calls/retpoline, you can use directly
tcp_read_sock here, as read_sock is always tcp_read_sock since commit
965b57b469a589d64d81b1688b38dcb537011bb0. Or you can use
indirect_call_wrapper.h

> +
> +	return desc.error;
> +}
> +
> +static int tls_strp_read_short(struct tls_strparser *strp)
> +{
> +	struct skb_shared_info *shinfo;
> +	struct page *page;
> +	int need_spc, len;
> +
> +	/* If the rbuf is small or rcv window has collapsed to 0 we need
> +	 * to read the data out. Otherwise the connection will stall.
> +	 * Without pressure threshold of INT_MAX will never be ready.
> +	 */
> +	if (likely(!tcp_epollin_ready(strp->sk, INT_MAX)))
> +		return 0;
> +
> +	shinfo = skb_shinfo(strp->anchor);
> +	shinfo->frag_list = NULL;
> +
> +	/* If we don't know the length go max plus page for cipher overhead */
> +	need_spc = strp->stm.full_len ?: TLS_MAX_PAYLOAD_SIZE + PAGE_SIZE;
> +
> +	for (len = need_spc; len > 0; len -= PAGE_SIZE) {
> +		page = alloc_page(strp->sk->sk_allocation);
> +		if (!page) {
> +			tls_strp_flush_anchor_copy(strp);
> +			return -ENOMEM;
> +		}
> +
> +		skb_fill_page_desc(strp->anchor, shinfo->nr_frags++,
> +				   page, 0, 0);
> +	}
> +
> +	strp->copy_mode = 1;
> +	strp->stm.offset = 0;
> +
> +	strp->anchor->len = 0;
> +	strp->anchor->data_len = 0;
> +	strp->anchor->truesize = round_up(need_spc, PAGE_SIZE);
> +
> +	tls_strp_read_copyin(strp);
> +
> +	return 0;
> +}
> +
> +static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
> +{
> +	struct tcp_sock *tp = tcp_sk(strp->sk);
> +	struct sk_buff *first;
> +	u32 offset;
> +
> +	first = tcp_recv_skb(strp->sk, tp->copied_seq, &offset);
> +	if (WARN_ON_ONCE(!first))
> +		return;
> +
> +	/* Bestow the state onto the anchor */
> +	strp->anchor->len = offset + len;
> +	strp->anchor->data_len = offset + len;
> +	strp->anchor->truesize = offset + len;
> +
> +	skb_shinfo(strp->anchor)->frag_list = first;
> +
> +	skb_copy_header(strp->anchor, first);
> +	strp->anchor->destructor = NULL;
> +
> +	strp->stm.offset = offset;
> +}
> +
> +void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
> +{
> +	struct strp_msg *rxm;
> +	struct tls_msg *tlm;
> +
> +	DEBUG_NET_WARN_ON_ONCE(!strp->msg_ready);
> +	DEBUG_NET_WARN_ON_ONCE(!strp->stm.full_len);
> +
> +	if (!strp->copy_mode && force_refresh) {
> +		if (WARN_ON(tcp_inq(strp->sk) < strp->stm.full_len))
> +			return;
> +
> +		tls_strp_load_anchor_with_queue(strp, strp->stm.full_len);
> +	}
> +
> +	rxm = strp_msg(strp->anchor);
> +	rxm->full_len	= strp->stm.full_len;
> +	rxm->offset	= strp->stm.offset;
> +	tlm = tls_msg(strp->anchor);
> +	tlm->control	= strp->mark;
> +}
> +
> +/* Called with lock held on lower socket */
> +static int tls_strp_read_sock(struct tls_strparser *strp)
> +{
> +	int sz, inq;
> +
> +	inq = tcp_inq(strp->sk);
> +	if (inq < 1)
> +		return 0;
> +
> +	if (unlikely(strp->copy_mode))
> +		return tls_strp_read_copyin(strp);
> +
> +	if (inq < strp->stm.full_len)
> +		return tls_strp_read_short(strp);
> +
> +	if (!strp->stm.full_len) {
> +		tls_strp_load_anchor_with_queue(strp, inq);
> +
> +		sz = tls_rx_msg_size(strp, strp->anchor);
> +		if (sz < 0) {
> +			tls_strp_abort_strp(strp, sz);
> +			return sz;
> +		}
> +
> +		strp->stm.full_len = sz;
> +
> +		if (!strp->stm.full_len || inq < strp->stm.full_len)
> +			return tls_strp_read_short(strp);
> +	}
> +
> +	strp->msg_ready = 1;
> +	tls_rx_msg_ready(strp);
> +
> +	return 0;
> +}
> +
> +void tls_strp_check_rcv(struct tls_strparser *strp)
> +{
> +	if (unlikely(strp->stopped) || strp->msg_ready)
> +		return;
> +
> +	if (tls_strp_read_sock(strp) == -ENOMEM)
> +		queue_work(tls_strp_wq, &strp->work);
> +}
> +
> +/* Lower sock lock held */
> +void tls_strp_data_ready(struct tls_strparser *strp)
> +{
> +	/* This check is needed to synchronize with do_tls_strp_work.
> +	 * do_tls_strp_work acquires a process lock (lock_sock) whereas
> +	 * the lock held here is bh_lock_sock. The two locks can be
> +	 * held by different threads at the same time, but bh_lock_sock
> +	 * allows a thread in BH context to safely check if the process
> +	 * lock is held. In this case, if the lock is held, queue work.
> +	 */
> +	if (sock_owned_by_user_nocheck(strp->sk)) {
> +		queue_work(tls_strp_wq, &strp->work);
> +		return;
> +	}
> +
> +	tls_strp_check_rcv(strp);
> +}
> +
> +static void tls_strp_work(struct work_struct *w)
> +{
> +	struct tls_strparser *strp =
> +		container_of(w, struct tls_strparser, work);
> +
> +	lock_sock(strp->sk);
> +	tls_strp_check_rcv(strp);
> +	release_sock(strp->sk);
> +}
> +
> +void tls_strp_msg_done(struct tls_strparser *strp)
> +{
> +	WARN_ON(!strp->stm.full_len);
> +
> +	if (likely(!strp->copy_mode))
> +		tcp_read_done(strp->sk, strp->stm.full_len);
> +	else
> +		tls_strp_flush_anchor_copy(strp);
> +
> +	strp->msg_ready = 0;
> +	memset(&strp->stm, 0, sizeof(strp->stm));
> +
> +	tls_strp_check_rcv(strp);
> +}
> +
> +void tls_strp_stop(struct tls_strparser *strp)
> +{
> +	strp->stopped = 1;
> +}
> +
> +int tls_strp_init(struct tls_strparser *strp, struct sock *sk)
> +{
> +	memset(strp, 0, sizeof(*strp));
> +
> +	strp->sk = sk;
> +
> +	strp->anchor = alloc_skb(0, GFP_KERNEL);
> +	if (!strp->anchor)
> +		return -ENOMEM;
> +
> +	INIT_WORK(&strp->work, tls_strp_work);
>  
> -	nsg = skb_cow_data(ctx->recv_pkt, 0, &unused);
> -	if (nsg < 0)
> -		return nsg;
>  	return 0;
>  }
>  
> -int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
> -		      struct sk_buff_head *dst)
> +/* strp must already be stopped so that tls_strp_recv will no longer be called.
> + * Note that tls_strp_done is not called with the lower socket held.
> + */
> +void tls_strp_done(struct tls_strparser *strp)
>  {
> -	struct sk_buff *clone;
> +	WARN_ON(!strp->stopped);
>  
> -	clone = skb_clone(skb, sk->sk_allocation);
> -	if (!clone)
> +	cancel_work_sync(&strp->work);
> +	tls_strp_anchor_free(strp);
> +}
> +
> +int __init tls_strp_dev_init(void)
> +{
> +	tls_strp_wq = create_singlethread_workqueue("kstrp");

I guess it's better to change the name to avoid confusing with plain
strparser ?!?

Out of sheer ignorance and not related to this patch: If I read
correctly, the above means that multiple tls flows on top of different
TCP sockets will use a single CPU, isn't that a relevant bottle-neck?
isn't enough to rely on queue_work() to submit the work on the same CPU
that just did the TCP stack processing? 

> +	if (unlikely(!tls_strp_wq))
>  		return -ENOMEM;
> -	__skb_queue_tail(dst, clone);
> +
>  	return 0;
>  }
> +
> +void tls_strp_dev_exit(void)
> +{
> +	destroy_workqueue(tls_strp_wq);
> +}
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index bd4486819e64..0fc24a5ce208 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1283,7 +1283,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
>  
>  static int
>  tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
> -		long timeo)
> +		bool released, long timeo)
>  {
>  	struct tls_context *tls_ctx = tls_get_ctx(sk);
>  	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
> @@ -1297,7 +1297,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
>  			return sock_error(sk);
>  
>  		if (!skb_queue_empty(&sk->sk_receive_queue)) {
> -			__strp_unpause(&ctx->strp);
> +			tls_strp_check_rcv(&ctx->strp);
>  			if (tls_strp_msg_ready(ctx))
>  				break;
>  		}
> @@ -1311,6 +1311,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
>  		if (nonblock || !timeo)
>  			return -EAGAIN;
>  
> +		released = true;
>  		add_wait_queue(sk_sleep(sk), &wait);
>  		sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
>  		sk_wait_event(sk, &timeo,
> @@ -1325,6 +1326,8 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
>  			return sock_intr_errno(timeo);
>  	}
>  
> +	tls_strp_msg_load(&ctx->strp, released);
> +
>  	return 1;
>  }
>  
> @@ -1570,7 +1573,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
>  	clear_skb = NULL;
>  
>  	if (unlikely(darg->async)) {
> -		err = tls_strp_msg_hold(sk, skb, &ctx->async_hold);
> +		err = tls_strp_msg_hold(&ctx->strp, &ctx->async_hold);
>  		if (err)
>  			__skb_queue_tail(&ctx->async_hold, darg->skb);
>  		return err;
> @@ -1734,9 +1737,7 @@ static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
>  
>  static void tls_rx_rec_done(struct tls_sw_context_rx *ctx)
>  {
> -	consume_skb(ctx->recv_pkt);
> -	ctx->recv_pkt = NULL;
> -	__strp_unpause(&ctx->strp);
> +	tls_strp_msg_done(&ctx->strp);
>  }
>  
>  /* This function traverses the rx_list in tls receive context to copies the
> @@ -1823,7 +1824,7 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
>  	return copied ? : err;
>  }
>  
> -static void
> +static bool
>  tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
>  		       size_t len_left, size_t decrypted, ssize_t done,
>  		       size_t *flushed_at)
> @@ -1831,14 +1832,14 @@ tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
>  	size_t max_rec;
>  
>  	if (len_left <= decrypted)
> -		return;
> +		return false;
>  
>  	max_rec = prot->overhead_size - prot->tail_size + TLS_MAX_PAYLOAD_SIZE;
>  	if (done - *flushed_at < SZ_128K && tcp_inq(sk) > max_rec)
> -		return;
> +		return false;
>  
>  	*flushed_at = done;
> -	sk_flush_backlog(sk);
> +	return sk_flush_backlog(sk);
>  }
>  
>  static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
> @@ -1916,6 +1917,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  	long timeo;
>  	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
>  	bool is_peek = flags & MSG_PEEK;
> +	bool released = true;
>  	bool bpf_strp_enabled;
>  	bool zc_capable;
>  
> @@ -1952,7 +1954,8 @@ int tls_sw_recvmsg(struct sock *sk,
>  		struct tls_decrypt_arg darg;
>  		int to_decrypt, chunk;
>  
> -		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, timeo);
> +		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, released,
> +				      timeo);
>  		if (err <= 0) {
>  			if (psock) {
>  				chunk = sk_msg_recvmsg(sk, psock, msg, len,
> @@ -1968,8 +1971,8 @@ int tls_sw_recvmsg(struct sock *sk,
>  
>  		memset(&darg.inargs, 0, sizeof(darg.inargs));
>  
> -		rxm = strp_msg(ctx->recv_pkt);
> -		tlm = tls_msg(ctx->recv_pkt);
> +		rxm = strp_msg(tls_strp_msg(ctx));
> +		tlm = tls_msg(tls_strp_msg(ctx));
>  
>  		to_decrypt = rxm->full_len - prot->overhead_size;
>  
> @@ -2008,8 +2011,9 @@ int tls_sw_recvmsg(struct sock *sk,
>  		}
>  
>  		/* periodically flush backlog, and feed strparser */
> -		tls_read_flush_backlog(sk, prot, len, to_decrypt,
> -				       decrypted + copied, &flushed_at);
> +		released = tls_read_flush_backlog(sk, prot, len, to_decrypt,
> +						  decrypted + copied,
> +						  &flushed_at);
>  
>  		/* TLS 1.3 may have updated the length by more than overhead */
>  		rxm = strp_msg(darg.skb);
> @@ -2020,7 +2024,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  			bool partially_consumed = chunk > len;
>  			struct sk_buff *skb = darg.skb;
>  
> -			DEBUG_NET_WARN_ON_ONCE(darg.skb == ctx->recv_pkt);
> +			DEBUG_NET_WARN_ON_ONCE(darg.skb == tls_strp_msg(ctx));
>  
>  			if (async) {
>  				/* TLS 1.2-only, to_decrypt must be text len */
> @@ -2034,6 +2038,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  			}
>  
>  			if (bpf_strp_enabled) {
> +				released = true;
>  				err = sk_psock_tls_strp_read(psock, skb);
>  				if (err != __SK_PASS) {
>  					rxm->offset = rxm->offset + rxm->full_len;
> @@ -2140,7 +2145,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>  		struct tls_decrypt_arg darg;
>  
>  		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
> -				      timeo);
> +				      true, timeo);
>  		if (err <= 0)
>  			goto splice_read_end;
>  
> @@ -2204,19 +2209,17 @@ bool tls_sw_sock_is_readable(struct sock *sk)
>  		!skb_queue_empty(&ctx->rx_list);
>  }
>  
> -static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
> +int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb)
>  {
>  	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
>  	struct tls_prot_info *prot = &tls_ctx->prot_info;
>  	char header[TLS_HEADER_SIZE + MAX_IV_SIZE];
> -	struct strp_msg *rxm = strp_msg(skb);
> -	struct tls_msg *tlm = tls_msg(skb);
>  	size_t cipher_overhead;
>  	size_t data_len = 0;
>  	int ret;
>  
>  	/* Verify that we have a full TLS header, or wait for more data */
> -	if (rxm->offset + prot->prepend_size > skb->len)
> +	if (strp->stm.offset + prot->prepend_size > skb->len)
>  		return 0;
>  
>  	/* Sanity-check size of on-stack buffer. */
> @@ -2226,11 +2229,11 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
>  	}
>  
>  	/* Linearize header to local buffer */
> -	ret = skb_copy_bits(skb, rxm->offset, header, prot->prepend_size);
> +	ret = skb_copy_bits(skb, strp->stm.offset, header, prot->prepend_size);
>  	if (ret < 0)
>  		goto read_failure;
>  
> -	tlm->control = header[0];
> +	strp->mark = header[0];
>  
>  	data_len = ((header[4] & 0xFF) | (header[3] << 8));
>  
> @@ -2257,7 +2260,7 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
>  	}
>  
>  	tls_device_rx_resync_new_rec(strp->sk, data_len + TLS_HEADER_SIZE,
> -				     TCP_SKB_CB(skb)->seq + rxm->offset);
> +				     TCP_SKB_CB(skb)->seq + strp->stm.offset);
>  	return data_len + TLS_HEADER_SIZE;
>  
>  read_failure:
> @@ -2266,14 +2269,11 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
>  	return ret;
>  }
>  
> -static void tls_queue(struct strparser *strp, struct sk_buff *skb)
> +void tls_rx_msg_ready(struct tls_strparser *strp)
>  {
> -	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
> -	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
> -
> -	ctx->recv_pkt = skb;
> -	strp_pause(strp);
> +	struct tls_sw_context_rx *ctx;
>  
> +	ctx = container_of(strp, struct tls_sw_context_rx, strp);
>  	ctx->saved_data_ready(strp->sk);
>  }
>  
> @@ -2283,7 +2283,7 @@ static void tls_data_ready(struct sock *sk)
>  	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
>  	struct sk_psock *psock;
>  
> -	strp_data_ready(&ctx->strp);
> +	tls_strp_data_ready(&ctx->strp);
>  
>  	psock = sk_psock_get(sk);
>  	if (psock) {
> @@ -2359,13 +2359,11 @@ void tls_sw_release_resources_rx(struct sock *sk)
>  	kfree(tls_ctx->rx.iv);
>  
>  	if (ctx->aead_recv) {
> -		kfree_skb(ctx->recv_pkt);
> -		ctx->recv_pkt = NULL;
>  		__skb_queue_purge(&ctx->rx_list);
>  		crypto_free_aead(ctx->aead_recv);
> -		strp_stop(&ctx->strp);
> +		tls_strp_stop(&ctx->strp);
>  		/* If tls_sw_strparser_arm() was not called (cleanup paths)
> -		 * we still want to strp_stop(), but sk->sk_data_ready was
> +		 * we still want to tls_strp_stop(), but sk->sk_data_ready was
>  		 * never swapped.
>  		 */
>  		if (ctx->saved_data_ready) {
> @@ -2380,7 +2378,7 @@ void tls_sw_strparser_done(struct tls_context *tls_ctx)
>  {
>  	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
>  
> -	strp_done(&ctx->strp);
> +	tls_strp_done(&ctx->strp);
>  }
>  
>  void tls_sw_free_ctx_rx(struct tls_context *tls_ctx)
> @@ -2453,8 +2451,6 @@ void tls_sw_strparser_arm(struct sock *sk, struct tls_context *tls_ctx)
>  	rx_ctx->saved_data_ready = sk->sk_data_ready;
>  	sk->sk_data_ready = tls_data_ready;
>  	write_unlock_bh(&sk->sk_callback_lock);
> -
> -	strp_check_rcv(&rx_ctx->strp);
>  }
>  
>  void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
> @@ -2474,7 +2470,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>  	struct tls_sw_context_rx *sw_ctx_rx = NULL;
>  	struct cipher_context *cctx;
>  	struct crypto_aead **aead;
> -	struct strp_callbacks cb;
>  	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
>  	struct crypto_tfm *tfm;
>  	char *iv, *rec_seq, *key, *salt, *cipher_name;
> @@ -2708,12 +2703,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>  			crypto_info->version != TLS_1_3_VERSION &&
>  			!!(tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC);
>  
> -		/* Set up strparser */
> -		memset(&cb, 0, sizeof(cb));
> -		cb.rcv_msg = tls_queue;
> -		cb.parse_msg = tls_read_size;
> -
> -		strp_init(&sw_ctx_rx->strp, sk, &cb);
> +		tls_strp_init(&sw_ctx_rx->strp, sk);
>  	}
>  
>  	goto out;


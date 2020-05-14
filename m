Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77FE1D3725
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgENQ5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:57:30 -0400
Received: from smtp4.emailarray.com ([65.39.216.22]:24926 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgENQ53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:57:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2020 12:57:29 EDT
Received: (qmail 57254 invoked by uid 89); 14 May 2020 16:50:48 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 14 May 2020 16:50:48 -0000
Date:   Thu, 14 May 2020 09:50:45 -0700
From:   Jonathan Lemon <bsd@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
Message-ID: <20200514165045.sk6zjlhsfzxbo6mb@bsd-mbp>
References: <20200513192532.4058934-1-andriin@fb.com>
 <20200513192532.4058934-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513192532.4058934-2-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:25:27PM -0700, Andrii Nakryiko wrote:
> +static struct bpf_ringbuf *bpf_ringbuf_restore_from_rec(void *meta_ptr)
> +{
> +	unsigned long addr = (unsigned long)meta_ptr;
> +	unsigned long off = *(u32 *)(meta_ptr + 4) << PAGE_SHIFT;
> +
> +	return (void*)((addr & PAGE_MASK) - off);
> +}
> +
> +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> +{
> +	unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> +	u32 len, pg_off;
> +	void *meta_ptr;
> +
> +	if (unlikely(size > UINT_MAX))
> +		return NULL;

Size should be 30 bits, not UINT_MAX, since 2 bits are reserved.

> +
> +	len = round_up(size + RINGBUF_META_SZ, 8);
> +	cons_pos = READ_ONCE(rb->consumer_pos);
> +
> +	if (in_nmi()) {
> +		if (!spin_trylock_irqsave(&rb->spinlock, flags))
> +			return NULL;
> +	} else {
> +		spin_lock_irqsave(&rb->spinlock, flags);
> +	}
> +
> +	prod_pos = rb->producer_pos;
> +	new_prod_pos = prod_pos + len;
> +
> +	/* check for out of ringbuf space by ensuring producer position
> +	 * doesn't advance more than (ringbuf_size - 1) ahead
> +	 */
> +	if (new_prod_pos - cons_pos > rb->mask) {
> +		spin_unlock_irqrestore(&rb->spinlock, flags);
> +		return NULL;
> +	}
> +
> +	meta_ptr = rb->data + (prod_pos & rb->mask);
> +	pg_off = bpf_ringbuf_rec_pg_off(rb, meta_ptr);
> +
> +	WRITE_ONCE(*(u32 *)meta_ptr, RINGBUF_BUSY_BIT | size);
> +	WRITE_ONCE(*(u32 *)(meta_ptr + 4), pg_off);

Or define a 64bit word in the structure and use:

        WRITE_ONCE(*(u64 *)meta_ptr, rec.header);


> +
> +	/* ensure length prefix is written before updating producer positions */
> +	smp_wmb();
> +	WRITE_ONCE(rb->producer_pos, new_prod_pos);
> +
> +	spin_unlock_irqrestore(&rb->spinlock, flags);
> +
> +	return meta_ptr + RINGBUF_META_SZ;
> +}
> +
> +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> +}
> +

--
Jonathan

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD81430AE03
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhBARgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:36:44 -0500
Received: from verein.lst.de ([213.95.11.211]:42304 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232005AbhBARgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 12:36:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C74656736F; Mon,  1 Feb 2021 18:35:48 +0100 (CET)
Date:   Mon, 1 Feb 2021 18:35:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: Re: [PATCH v3 net-next  01/21] iov_iter: Introduce new procedures
 for copy to iter/pages
Message-ID: <20210201173548.GA12960@lst.de>
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-2-borisp@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201100509.27351-2-borisp@mellanox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 12:04:49PM +0200, Boris Pismenny wrote:
> +static __always_inline __must_check
> +size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
> +{
> +	if (unlikely(!check_copy_size(addr, bytes, true)))
> +		return 0;
> +	else
> +		return _ddp_copy_to_iter(addr, bytes, i);
> +}

No need for the else after a return, and the normal kernel convention
double underscores for magic internal functions.

But more importantly: does this belong into the generic header without
and comments what the ddp means and when it should be used?

> +static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)

Overly long line.  But we're also looking into generic helpers for
this kind of things, not sure if they made it to linux-next in the
meantime, but please check.

> +size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
> +{
> +	const char *from = addr;
> +	if (unlikely(iov_iter_is_pipe(i)))
> +		return copy_pipe_to_iter(addr, bytes, i);
> +	if (iter_is_iovec(i))
> +		might_fault();
> +	iterate_and_advance(i, bytes, v,
> +		copyout(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
> +		ddp_memcpy_to_page(v.bv_page, v.bv_offset,
> +				   (from += v.bv_len) - v.bv_len, v.bv_len),
> +		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
> +		)
> +
> +	return bytes;
> +}

This bloats every kernel build, so please move it into a conditionally
built file.  And please document the whole thing.

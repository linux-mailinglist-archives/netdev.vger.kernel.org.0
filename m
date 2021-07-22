Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4E73D24A9
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhGVMv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhGVMv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:51:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA10C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ICspZ4RtR4pacnzopZdqHgYYQgygGGPfu1yVd4wOaSg=; b=rxQjWUNZDon69dFNIgGXn/IUOm
        vYpFphyRtEdN4Yab6lFV8jrj7rGS7RvkA5zy+YsILsQ47ZCZVTU1CQsYMy+YOjQknw30Zzc8ktuCD
        wMbOIEoKfDrIYBoedf+F5FVwDjHsHkjOdpI4CwsuIF2lMTe2r6IQthdj+ugXh3NgWMqxwvVsA0kAt
        g+CfpB0IQE12t0Bv/VU983XsEZ8qQyDx61kCRlg6AKbroK7oq10xnvJlgmuQYNkdg5hB7Viw/UWnj
        oVaM9pWmfHgJyYjln2QQd5BgwKW1rCaclq/NuGF/MwjP4jgB5M1aFZfASTjGpvzRqfDx+SE/kJO8i
        kN7AOq+w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Yn7-00AIKg-6g; Thu, 22 Jul 2021 13:31:16 +0000
Date:   Thu, 22 Jul 2021 14:31:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
Message-ID: <YPlzHTnoxDinpOsP@infradead.org>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-3-borisp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722110325.371-3-borisp@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#ifdef CONFIG_ULP_DDP
> +size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
> +#endif
>  size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
>  bool _copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
>  size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
> @@ -145,6 +148,16 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
>  		return _copy_to_iter(addr, bytes, i);
>  }
>  
> +#ifdef CONFIG_ULP_DDP
> +static __always_inline __must_check
> +size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
> +{
> +	if (unlikely(!check_copy_size(addr, bytes, true)))
> +		return 0;
> +	return _ddp_copy_to_iter(addr, bytes, i);
> +}
> +#endif

There is no need to ifdef out externs with conditional implementations,
or inlines using them.

> +#ifdef CONFIG_ULP_DDP
> +static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)

Overly long line.

> +	char *to = kmap_atomic(page);
> +
> +	if (to + offset != from)
> +		memcpy(to + offset, from, len);
> +
> +	kunmap_atomic(to);

This looks completely bogus to any casual read, so please document why
it makes sense.  And no, a magic, unexplained ddp in the name does not
count as explanation at all.  Please think about a more useful name.

Can this ever write to user page?  If yes it needs a flush_dcache_page.

Last but not least: kmap_atomic is deprecated except for the very
rate use case where it is actually called from atomic context.  Please
use kmap_local_page instead.

> +#ifdef CONFIG_CRYPTO_HASH
> +	struct ahash_request *hash = hashp;
> +	struct scatterlist sg;
> +	size_t copied;
> +
> +	copied = ddp_copy_to_iter(addr, bytes, i);
> +	sg_init_one(&sg, addr, copied);
> +	ahash_request_set_crypt(hash, &sg, NULL, copied);
> +	crypto_ahash_update(hash);
> +	return copied;
> +#else
> +	return 0;
> +#endif

What is the point of this stub?  To me it looks extremely dangerous.

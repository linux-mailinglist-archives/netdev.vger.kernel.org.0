Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F70CF7E4
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfD3MDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727465AbfD3MD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 08:03:28 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5781F20835;
        Tue, 30 Apr 2019 12:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625806;
        bh=vfCr04KFuWTnfRIx5YFbzxFml3k6X036yCo56FLgZHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JV95ZyezEgr2kzNrEuLil5pkzkqEL+QJXmM8eMx0gozO8Hty8hRwiQUnvITXu+MNW
         /TO4ACMbTIsFza+bLXSh33ZElmvqbbD2Lu+SHn0q83lDt9L5/3rVYfbjuNqGQUI9S+
         h66Nn25wjDLCBFUhOOXOrUusqUqAiBXR0jRxXwpM=
Date:   Tue, 30 Apr 2019 15:03:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH v13 16/20] IB/mlx4, arm64: untag user pointers in
 mlx4_get_umem_mr
Message-ID: <20190430120321.GF6705@mtr-leonro.mtl.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <1e2824fd77e8eeb351c6c6246f384d0d89fd2d58.1553093421.git.andreyknvl@google.com>
 <20190429180915.GZ6705@mtr-leonro.mtl.com>
 <20190430111625.GD29799@arrakis.emea.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430111625.GD29799@arrakis.emea.arm.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 12:16:25PM +0100, Catalin Marinas wrote:
> (trimmed down the cc list slightly as the message bounces)
>
> On Mon, Apr 29, 2019 at 09:09:15PM +0300, Leon Romanovsky wrote:
> > On Wed, Mar 20, 2019 at 03:51:30PM +0100, Andrey Konovalov wrote:
> > > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > > pass tagged user pointers (with the top byte set to something else other
> > > than 0x00) as syscall arguments.
> > >
> > > mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
> > > only by done with untagged pointers.
> > >
> > > Untag user pointers in this function.
> > >
> > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > ---
> > >  drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
> > > index 395379a480cb..9a35ed2c6a6f 100644
> > > --- a/drivers/infiniband/hw/mlx4/mr.c
> > > +++ b/drivers/infiniband/hw/mlx4/mr.c
> > > @@ -378,6 +378,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> > >  	 * again
> > >  	 */
> > >  	if (!ib_access_writable(access_flags)) {
> > > +		unsigned long untagged_start = untagged_addr(start);
> > >  		struct vm_area_struct *vma;
> > >
> > >  		down_read(&current->mm->mmap_sem);
> > > @@ -386,9 +387,9 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> > >  		 * cover the memory, but for now it requires a single vma to
> > >  		 * entirely cover the MR to support RO mappings.
> > >  		 */
> > > -		vma = find_vma(current->mm, start);
> > > -		if (vma && vma->vm_end >= start + length &&
> > > -		    vma->vm_start <= start) {
> > > +		vma = find_vma(current->mm, untagged_start);
> > > +		if (vma && vma->vm_end >= untagged_start + length &&
> > > +		    vma->vm_start <= untagged_start) {
> > >  			if (vma->vm_flags & VM_WRITE)
> > >  				access_flags |= IB_ACCESS_LOCAL_WRITE;
> > >  		} else {
> > > --
> >
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>
> Thanks for the review.
>
> > Interesting, the followup question is why mlx4 is only one driver in IB which
> > needs such code in umem_mr. I'll take a look on it.
>
> I don't know. Just using the light heuristics of find_vma() shows some
> other places. For example, ib_umem_odp_get() gets the umem->address via
> ib_umem_start(). This was previously set in ib_umem_get() as called from
> mlx4_get_umem_mr(). Should the above patch have just untagged "start" on
> entry?

ODP flows are not applicable to any driver except mlx5.
According to commit message of d8f9cc328c88 ("IB/mlx4: Mark user
MR as writable if actual virtual memory is writable"), the code in its
current form needed to deal with different mappings between RDMA memory
requested and VMA memory underlined.

>
> BTW, what's the provenience of such "start" address here? Is it
> something that the user would have malloc()'ed? We try to impose some
> restrictions one what is allowed to be tagged in user so that we don't
> have to untag the addresses in the kernel. For example, if it was the
> result of an mmap() on the device file, we don't allow tagging.

The *_reg_user_mr() is called from userspace through ibv_reg_mr() call [1]
and this is how "address" and access flags are provided.

Right now, the address should point to memory accessible by
get_user_pages(), however mmap-ed memory uses remap_pfn_range()
to provide such pages which makes them unusable for get_user_pages().

I would be glad to see this is a current limitation of RDMA stack and
not as a final design decision.

[1] https://linux.die.net/man/3/ibv_reg_mr

>
> Thanks.
>
> --
> Catalin

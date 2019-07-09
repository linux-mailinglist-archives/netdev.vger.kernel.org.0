Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB26348E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 12:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfGIKwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 06:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfGIKwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 06:52:50 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B166E20861;
        Tue,  9 Jul 2019 10:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562669569;
        bh=0biULROYmb8Xl0/f2Mn3rj7GU0ovDebV6dSE3M/OE6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FsHtz8IwrywvKSQWdu3VAIDmd9e4756ZremNqBKErdFK9/4jvoPI5aEHGbaNMHGbE
         XCOCy1cT/y39npOHtSjkNub4fXe95sdC7YDe5OQaVR8SAyp0Z6MuuXplioxu1lkcVB
         HESWgScb9Mtmxv/7Aes7KboCFzr+Os9roeJ+2n9k=
Date:   Tue, 9 Jul 2019 13:52:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Message-ID: <20190709105245.GP7034@mtr-leonro.mtl.com>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
 <20190708091503.14723-2-michal.kalderon@marvell.com>
 <20190709070244.GH7034@mtr-leonro.mtl.com>
 <MN2PR18MB31825FB2CCC56C47763C9D0DA1F10@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB31825FB2CCC56C47763C9D0DA1F10@MN2PR18MB3182.namprd18.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 10:29:36AM +0000, Michal Kalderon wrote:
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> >
> > On Mon, Jul 08, 2019 at 12:14:58PM +0300, Michal Kalderon wrote:
> > > Create some common API's for adding entries to a xa_mmap.
> > > Searching for an entry and freeing one.
> > >
> > > The code was copied from the efa driver almost as is, just renamed
> > > function to be generic and not efa specific.
> > >
> > > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> > > ---
> > >  drivers/infiniband/core/device.c      |   1 +
> > >  drivers/infiniband/core/rdma_core.c   |   1 +
> > >  drivers/infiniband/core/uverbs_cmd.c  |   1 +
> > >  drivers/infiniband/core/uverbs_main.c | 105
> > ++++++++++++++++++++++++++++++++++
> > >  include/rdma/ib_verbs.h               |  32 +++++++++++
> > >  5 files changed, 140 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/core/device.c
> > > b/drivers/infiniband/core/device.c
> > > index 8a6ccb936dfe..a830c2c5d691 100644
> > > --- a/drivers/infiniband/core/device.c
> > > +++ b/drivers/infiniband/core/device.c
> > > @@ -2521,6 +2521,7 @@ void ib_set_device_ops(struct ib_device *dev,
> > const struct ib_device_ops *ops)
> > >  	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
> > >  	SET_DEVICE_OP(dev_ops, map_phys_fmr);
> > >  	SET_DEVICE_OP(dev_ops, mmap);
> > > +	SET_DEVICE_OP(dev_ops, mmap_free);
> > >  	SET_DEVICE_OP(dev_ops, modify_ah);
> > >  	SET_DEVICE_OP(dev_ops, modify_cq);
> > >  	SET_DEVICE_OP(dev_ops, modify_device); diff --git
> > > a/drivers/infiniband/core/rdma_core.c
> > > b/drivers/infiniband/core/rdma_core.c
> > > index ccf4d069c25c..7166741834c8 100644
> > > --- a/drivers/infiniband/core/rdma_core.c
> > > +++ b/drivers/infiniband/core/rdma_core.c
> > > @@ -817,6 +817,7 @@ static void ufile_destroy_ucontext(struct
> > ib_uverbs_file *ufile,
> > >  	rdma_restrack_del(&ucontext->res);
> > >
> > >  	ib_dev->ops.dealloc_ucontext(ucontext);
> > > +	rdma_user_mmap_entries_remove_free(ucontext);
> > >  	kfree(ucontext);
> > >
> > >  	ufile->ucontext = NULL;
> > > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > > b/drivers/infiniband/core/uverbs_cmd.c
> > > index 7ddd0e5bc6b3..44c0600245e4 100644
> > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > @@ -254,6 +254,7 @@ static int ib_uverbs_get_context(struct
> > > uverbs_attr_bundle *attrs)
> > >
> > >  	mutex_init(&ucontext->per_mm_list_lock);
> > >  	INIT_LIST_HEAD(&ucontext->per_mm_list);
> > > +	xa_init(&ucontext->mmap_xa);
> > >
> > >  	ret = get_unused_fd_flags(O_CLOEXEC);
> > >  	if (ret < 0)
> > > diff --git a/drivers/infiniband/core/uverbs_main.c
> > > b/drivers/infiniband/core/uverbs_main.c
> > > index 11c13c1381cf..37507cc27e8c 100644
> > > --- a/drivers/infiniband/core/uverbs_main.c
> > > +++ b/drivers/infiniband/core/uverbs_main.c
> > > @@ -965,6 +965,111 @@ int rdma_user_mmap_io(struct ib_ucontext
> > > *ucontext, struct vm_area_struct *vma,  }
> > > EXPORT_SYMBOL(rdma_user_mmap_io);
> > >
> > > +static inline u64
> > > +rdma_user_mmap_get_key(const struct rdma_user_mmap_entry
> > *entry) {
> > > +	return (u64)entry->mmap_page << PAGE_SHIFT; }
> > > +
> > > +struct rdma_user_mmap_entry *
> > > +rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64
> > > +len) {
> > > +	struct rdma_user_mmap_entry *entry;
> > > +	u64 mmap_page;
> > > +
> > > +	mmap_page = key >> PAGE_SHIFT;
> > > +	if (mmap_page > U32_MAX)
> > > +		return NULL;
> > > +
> > > +	entry = xa_load(&ucontext->mmap_xa, mmap_page);
> > > +	if (!entry || rdma_user_mmap_get_key(entry) != key ||
> > > +	    entry->length != len)
> > > +		return NULL;
> > > +
> > > +	ibdev_dbg(ucontext->device,
> > > +		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx]
> > removed\n",
> > > +		  entry->obj, key, entry->address, entry->length);
> > > +
> > > +	return entry;
> > > +}
> > > +EXPORT_SYMBOL(rdma_user_mmap_entry_get);
> >
> > Please add function description in kernel doc format for all newly
> > EXPORT_SYMBOL() functions you introduced in RDMA/core.
> Ok. Could you give me a reference to an example? Where should the
> Documentation be added to?

Above function in *.c file.

For example, see function rdma_set_ack_timeout():
https://patchwork.kernel.org/patch/10778827/

Thanks

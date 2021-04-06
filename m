Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA33553E6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343994AbhDFMa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:30:56 -0400
Received: from verein.lst.de ([213.95.11.211]:54291 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343946AbhDFMau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 08:30:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4387D68B02; Tue,  6 Apr 2021 14:30:35 +0200 (CEST)
Date:   Tue, 6 Apr 2021 14:30:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 01/10] RDMA: Add access flags to
 ib_alloc_mr() and ib_mr_pool_init()
Message-ID: <20210406123034.GA28930@lst.de>
References: <20210405052404.213889-1-leon@kernel.org> <20210405052404.213889-2-leon@kernel.org> <c21edd64-396c-4c7c-86f8-79045321a528@acm.org> <YGvwUI022t/rJy5U@unreal> <20210406052717.GA4835@lst.de> <YGv4niuc31WnqpEJ@unreal> <20210406121312.GK7405@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406121312.GK7405@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 09:13:12AM -0300, Jason Gunthorpe wrote:
> So we broadly have two choice
>  1) Diverge the kernel and user interfaces and make the RDMA drivers
>     special case all the kernel stuff to force
>     ACCESS_RELAXED_ORDERING when they are building MRs and processing
>     FMR WQE's
>  2) Keep the two interfaces the same and push the
>     ACCESS_RELAXED_ORDERING to a couple of places in the ULPs so the
>     drivers see a consistent API
> 
> They are both poor choices, but I think #2 has a greater chance of
> everyone doing their parts correctly.

No, 1 is the only sensible choice.  The userspace verbs interface is
a mess and should not inflict pain on the kernel in any way.  We've moved
away from a lot of the idiotic "Verbs API" concepts with things like
how we handle the global lkey, the new CQ API and the RDMA R/W
abstraction and that massively helped the kernel ecosystem.

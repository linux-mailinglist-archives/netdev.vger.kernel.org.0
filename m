Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280D3328137
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 15:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhCAOpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 09:45:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236529AbhCAOp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 09:45:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 101366146D;
        Mon,  1 Mar 2021 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614609888;
        bh=gi3PWvwXbOKCcgAcvlCDXJn1emBHZl2qG3u8e58yiyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aP/ibswuZgNlJxIClWLKfrz+hdXFDZY1U+Z+D4jx9gP0WREwOpwU0i+ptJaOru/cx
         YXmRkvebFMxHXXYKpa10USfXDiIB6uP1nMrBgPrOeue6/G2mlnJUnobTvVcUEMuX2e
         QyAY7o6yx347EqM9iEEpHJZwWphuMD+rT3Kz+28KND6qPM6erb8/lpUnNuJ8T+ut9y
         yt6o2T/i6JEdr/CVGHYfJ8bOCcKGwRJ5X5KZJm7691lND2FUhGiNeHeTq0WBZxD003
         +NzgHtY//Ff6MLof1knCgHae6oe48FKOJTUPjY8CS/G3oEHhEWMQ7P8anpRf4QuZ9h
         6MNfCTet9KZXw==
Date:   Mon, 1 Mar 2021 16:44:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, Mark Bloch <mbloch@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        target-devel@vger.kernel.org,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Message-ID: <YDz93aAERZkdFM2x@unreal>
References: <20210301070420.439400-1-leon@kernel.org>
 <20210301124834.GE4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301124834.GE4247@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 08:48:34AM -0400, Jason Gunthorpe wrote:
> On Mon, Mar 01, 2021 at 09:04:20AM +0200, Leon Romanovsky wrote:
> > @@ -884,7 +884,7 @@ static void gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
> >
> >  static void gid_table_release_one(struct ib_device *ib_dev)
> >  {
> > -	unsigned int p;
> > +	u32 p;
> >
> >  	rdma_for_each_port (ib_dev, p) {
> >  		release_gid_table(ib_dev, ib_dev->port_data[p].cache.gid);
> > @@ -895,7 +895,7 @@ static void gid_table_release_one(struct ib_device *ib_dev)
> >  static int _gid_table_setup_one(struct ib_device *ib_dev)
> >  {
> >  	struct ib_gid_table *table;
> > -	unsigned int rdma_port;
> > +	u32 rdma_port;
> >
> >  	rdma_for_each_port (ib_dev, rdma_port) {
>
> Why are we changing this? 'unsigned int' is the right type for port
> numbers

I prefer to see same types in all places. We use u32 for HW data and
netlink, so it makes sense to have it everywhere. Also, at least for me,
the u32 is more explicit than "unsigned int".

So when Mark asked me which type to use, I said u32.

Thanks

>
> Jason

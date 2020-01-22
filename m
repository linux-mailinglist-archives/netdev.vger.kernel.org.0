Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83B8145718
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVNvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:51:09 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E0A8207FF;
        Wed, 22 Jan 2020 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579701069;
        bh=tcZHDM99QoFQOxxJ4h7OdxVHKxgYRJsVQqjvLbTCI+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XTBdixTYoz1AFppk0E0cmAFV/xzq0k+osDAGvJ/bOhRylMCWwTjdLakL4OJ7XYZOy
         nhPIbXWD6o1wiObp3LW/PZtJr6MuCndKGJYD8l2jarmkzmGL5nb4iAnOPO46C0k/tK
         ZMXHV/gD0i6JvtXYqyQGMr+BOV4EH5gdZycFbHrc=
Date:   Wed, 22 Jan 2020 15:51:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next-mlx5 02/13] net/mlx5: Add new driver lib for
 mappings unique ids to data
Message-ID: <20200122135105.GE7018@unreal>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
 <1579623382-6934-3-git-send-email-paulb@mellanox.com>
 <20200121190420.GM51881@unreal>
 <85bf4ee7-e006-18ea-d643-8b9001066cbf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85bf4ee7-e006-18ea-d643-8b9001066cbf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 12:17:44PM +0000, Paul Blakey wrote:
>
> On 1/21/2020 9:04 PM, Leon Romanovsky wrote:
> > On Tue, Jan 21, 2020 at 06:16:11PM +0200, Paul Blakey wrote:
> >> Add a new interface for mapping data to a given id range (max_id),
> >> and back again. It supports variable sized data, and different
> >> allocators, and read/write locks.
> >>
> >> This mapping interface also supports delaying the mapping removal via
> >> a workqueue. This is for cases where we need the mapping to have
> >> some grace period in regards to finding it back again, for example
> >> for packets arriving from hardware that were marked with by a rule
> >> with an old mapping that no longer exists.
> >>
> >> We also provide a first implementation of the interface is idr_mapping
> >> that uses idr for the allocator and a mutex lock for writes
> >> (add/del, but not for find).
> >>
> >> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> >> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> >> Reviewed-by: Mark Bloch <markb@mellanox.com>
> >> ---
> > I have many issues with this patch, but two main are:
> > 1. This is general implementation without proper documentation and test
> > which doesn't belong to driver code.
> > 2. It looks very similar to already existing code, for example xarray.
> >
> > Thanks
> This data structure uses idr (currently wrapper for xarray) but also a
> hash table, refcount, and
> generic allocators.
> The hashtable is used on top of the idr to find if data added to the
> mapping already exists, if it
> does it updates a refcount.
> We also have some special delayed removal for our use case.
> The addition to xarray is translation from data to hash function. It is
> something that doesn't exist
> and needs extra code. IDR was chosen as being simplified interface of
> xarray and it is good enough
> in our case.
>
> The mlx5 is first user of such library, once the other user will arrive,
> we will be happy to
> collaborate in order to make it generic.

Makes sense, thanks.

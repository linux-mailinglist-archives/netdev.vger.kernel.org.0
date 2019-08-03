Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642BE804D2
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 09:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfHCHGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 03:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfHCHGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 03:06:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08D01206A2;
        Sat,  3 Aug 2019 07:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564816009;
        bh=pPLKovyN1NMpp946XJreXv1Y0yg1S4P9Y162ukSMn64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rlojk96gVoiyivb+U7yrIkDTuHtioqnhmcEmMjAk1MQVJmXSmgcGRpi/2JLag+Dd6
         M19hr//PiOu9iNAJPJwAfgv2wtT5dx2nyCeRHoSIIHS1qKxvoiJQ2X4AR13zqgfnZk
         KxaPAYdBHbY01Ff9SDG1UhnB5NnA5pYpWqC1XkA0=
Date:   Sat, 3 Aug 2019 09:06:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     john.hubbard@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, Jan Kara <jack@suse.cz>,
        kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, rds-devel@oss.oracle.com,
        linux-rdma@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>,
        x86@kernel.org, amd-gfx@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mihaela Muraru <mihaela.muraru21@gmail.com>,
        xen-devel@lists.xenproject.org, devel@lists.orangefs.org,
        linux-media@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        John Hubbard <jhubbard@nvidia.com>,
        intel-gfx@lists.freedesktop.org,
        Kishore KP <kishore.p@techveda.org>,
        linux-block@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        linux-rpi-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Sidong Yang <realwakka@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org,
        Eric Anholt <eric@anholt.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 15/34] staging/vc04_services: convert put_page() to
 put_user_page*()
Message-ID: <20190803070621.GA2508@kroah.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-16-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802022005.5117-16-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 07:19:46PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Eric Anholt <eric@anholt.net>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mihaela Muraru <mihaela.muraru21@gmail.com>
> Cc: Suniel Mahesh <sunil.m@techveda.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Sidong Yang <realwakka@gmail.com>
> Cc: Kishore KP <kishore.p@techveda.org>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  .../vc04_services/interface/vchiq_arm/vchiq_2835_arm.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

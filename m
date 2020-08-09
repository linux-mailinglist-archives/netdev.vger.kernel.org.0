Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76923FD14
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 09:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHIHEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 03:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgHIHEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 03:04:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9032206C3;
        Sun,  9 Aug 2020 07:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596956688;
        bh=RXegfO8sfwtCPziOMzKjff9+mTWukqMXNBxcvA/PHQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbjJliggcdbohvw04zRJ7b4Y/r/cKmbBRJpasZ3n26KOioJjq7UsNclBR2x1bdeDt
         xlZbQXEruW13ZQFEm4tdU81P2XkQOrQ3i7WDcpzgrxamnx1xDAOLngh0sHZGNMUP4D
         1sgz5yxpQG0vFOT6X9NqnS70c7StKKboPX/plznY=
Date:   Sun, 9 Aug 2020 10:04:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Leadford <leadford.jack@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200809070440.GA1653394@unreal>
References: <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200801053833.GK75549@unreal>
 <20200802221020.GN24045@ziepe.ca>
 <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
 <20200802222843.GP24045@ziepe.ca>
 <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
 <20200803230627.GQ24045@ziepe.ca>
 <ff066616-3bb8-b6c8-d329-7de5ab8ee982@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff066616-3bb8-b6c8-d329-7de5ab8ee982@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 03:57:33PM -0700, Jack Leadford wrote:
> Hello!
>
> Thanks to Jason for getting this conversation back on track.
>
> Yes: in general, {} or a partial initializer /will/ zero padding bits.
>
> However, there is a bug in some versions of GCC where {} will /not/ zero
> padding bits; actually, Jason's test program in this mail
> https://lore.kernel.org/lkml/20200731143604.GF24045@ziepe.ca/
> has the right ingredients to trigger the bug, but the GCC
> versions used are outside of the bug window. :)
>
> For more details on these cases and more (including said GCC bug), see my
> paper at:
>
> https://www.nccgroup.com/us/about-us/newsroom-and-events/blog/2019/october/padding-the-struct-how-a-compiler-optimization-can-disclose-stack-memory/
>
> Hopefully this paper can serve as a helpful reference when these cases are
> encountered in the kernel.

I read the paper and didn't find exact GCC version, only remark that it
was before GCC 7.

So my question, why is this case different from any other GCC bugs?
AFAIK, we don't add kernel code to overcome GCC bugs which exist in
specific versions, which already were fixed.

More on that, this paper talks about specific flow which doesn't exist
in the discussed patch.

Thanks

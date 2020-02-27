Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC7C1717D1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgB0MtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbgB0MtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 07:49:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A36324697;
        Thu, 27 Feb 2020 12:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582807753;
        bh=4FV306+YSxyEDrfkOQdy4IOprID1ZRXPJiAZ6ov4ztM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J4cybJLDagJq400SbAVtqE7f4OAvGcCWgAzJ+sEsj2ZcggR5Ex5tiKYqMdpwX107c
         4Oau8plE8llO+C4lCSLOPUf3ijiFyg1nzK1faBYHjszS8dA5YbvCUT50uvZ8tOqC/W
         N2Rs/lfK2W5pAi+RzGUzY9ns0iNF3qdDs0fMojm4=
Date:   Thu, 27 Feb 2020 13:49:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 4.4-stable] slip: stop double free sl->dev in slip_open
Message-ID: <20200227124911.GA1007215@kroah.com>
References: <20200222094649.10933-1-yangerkun@huawei.com>
 <4e89e339-e161-fd8e-85e0-e59cdcc9688f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e89e339-e161-fd8e-85e0-e59cdcc9688f@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 11:06:48AM +0800, yangerkun wrote:
> cc David and netdev mail list too.
> 
> On 2020/2/22 17:46, yangerkun wrote:
> > After commit e4c157955483 ("slip: Fix use-after-free Read in slip_open"),
> > we will double free sl->dev since sl_free_netdev will free sl->dev too.
> > It's fine for mainline since sl_free_netdev in mainline won't free
> > sl->dev.
> > 
> > Signed-off-by: yangerkun <yangerkun@huawei.com>
> > ---
> >   drivers/net/slip/slip.c | 1 -
> >   1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> > index ef6b25ec75a1..7fe9183fad0e 100644
> > --- a/drivers/net/slip/slip.c
> > +++ b/drivers/net/slip/slip.c
> > @@ -861,7 +861,6 @@ err_free_chan:
> >   	tty->disc_data = NULL;
> >   	clear_bit(SLF_INUSE, &sl->flags);
> >   	sl_free_netdev(sl->dev);
> > -	free_netdev(sl->dev);
> >   err_exit:
> >   	rtnl_unlock();
> > 
> 

What commit causes this only to be needed on the 4.4-stable tree?  Can
you please list it in the commit log so that we know this?

And this is only for 4.4.y, not 4.9.y or anything else?  Why?

thanks,

greg k-h

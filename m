Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83BD3D1454
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhGUQCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhGUQCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 12:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD87361245;
        Wed, 21 Jul 2021 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626885771;
        bh=7Ck9rmVTo0t8tKebV85ikRdarggjaTaFgG9+KzhlPfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tEmHwzxBsUjnSAXt2vJ8e4mCZv5m3gwjhIliEOoWRX2M0d/zw4yTMTUMTBkKLsmpW
         zhINgPE9/Le84ZnGk3qcxQvMbSjFabOPJhN6h/51r6PJLfHnbSJErryzih7tm7Vnl/
         5eZp1FI+rlL6NVTx7t+fB53FVV9mUwVy3sGwuSuxMOjLnReHG8nh+qB8g5zFmVWQYn
         960R7mhklWCUVtH8Pm9mkjxfyyHT811REVn2sX3Y2TDmq3oeqLYiUbe/PPXG7aaVA8
         KQ8rG65IgqXiqT6AeGoTz8tGHKGsq4rHi1BHlN1tjksNS6nIHVqjPpG3x+qUjznxOr
         SJvkXYfuExqPA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m6FIh-0001Y8-Le; Wed, 21 Jul 2021 18:42:27 +0200
Date:   Wed, 21 Jul 2021 18:42:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>, linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] usb: hso: fix error handling code of
 hso_create_net_device
Message-ID: <YPhOcwiEUW+cchJ1@hovoldconsulting.com>
References: <20210714091327.677458-1-mudongliangabcd@gmail.com>
 <YPfOZp7YoagbE+Mh@kroah.com>
 <CAD-N9QVi=TvS6sM+jcOf=Y5esECtRgTMgdFW+dqB-R_BuNv6AQ@mail.gmail.com>
 <YPgwkEHzmxSPSLVA@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPgwkEHzmxSPSLVA@hovoldconsulting.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 04:34:56PM +0200, Johan Hovold wrote:
> On Wed, Jul 21, 2021 at 04:17:01PM +0800, Dongliang Mu wrote:
> > On Wed, Jul 21, 2021 at 3:36 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Jul 14, 2021 at 05:13:22PM +0800, Dongliang Mu wrote:
> > > > The current error handling code of hso_create_net_device is
> > > > hso_free_net_device, no matter which errors lead to. For example,
> > > > WARNING in hso_free_net_device [1].
> > > >
> > > > Fix this by refactoring the error handling code of
> > > > hso_create_net_device by handling different errors by different code.
> > > >
> > > > [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
> > > >
> > > > Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> > > > Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > ---
> > > > v1->v2: change labels according to the comment of Dan Carpenter
> > > > v2->v3: change the style of error handling labels
> > > >  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
> > > >  1 file changed, 23 insertions(+), 10 deletions(-)
> > >
> > > Please resend the whole series, not just one patch of the series.
> > > Otherwise it makes it impossible to determine what patch from what
> > > series should be applied in what order.
> > >
> > 
> > Done. Please review the resend v3 patches.
> > 
> > > All of these are now dropped from my queue, please fix up and resend.
> 
> A version of this patch has already been applied to net-next.

That was apparently net (not net-next).

> No idea which version that was or why the second patch hasn't been
> applied yet.
> 
> Dongliang, if you're resending something here it should first be rebased
> on linux-next (net-next).

And the resend of v3 of both patches has now also been applied to
net-next.

Hopefully there are no conflicts between v2 and v3 but we'll see soon.

Johan

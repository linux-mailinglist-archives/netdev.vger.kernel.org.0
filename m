Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB848DDB1
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiAMSbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:31:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiAMSbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 13:31:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D751B821C1
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 18:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F855C36AE9;
        Thu, 13 Jan 2022 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642098674;
        bh=jS3mb/cF7QiTrSw/zmNRIJSKy2BaMLddK+XUDua+9bE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QsmLqKFJ1d9ZrCPoMe0O4BIHFttRmP+BHpBmVOPyoEGUuLmjNGltiYM/B/3nWIGCF
         wwwwoqB6hLr6/YzfI2ROYSNoUjOqc+riCh5qwhL6o+PYRXRvbQXysmf5aG7b78GTgp
         MXxSq7j0HeRHZ/RxeS6LbFIah0Z6Hm404EVShmwlHNYomFZftZiJr3WGfCa0owHzib
         KqPEmHMAJzod/x4dk0sYTHB9zk3sS8zpmETdod8Sn6HfXp74HKk18259jxnAfeEiUA
         23MGgqtDTL8fdhxv1XGpwzJQsiHl+tTNNGL3X3FZXJCLSommHuIh0P12R4QpP7+RT/
         +b8flCsHIEc3A==
Date:   Thu, 13 Jan 2022 10:31:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net-next PATCH] octeontx2-pf: Change receive buffer size using
 ethtool
Message-ID: <20220113103113.59e4836d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CALHRZuouqa76eNYgYe5qs71oHqdZ0OeE_P1UYJU8uaaG0-qAyw@mail.gmail.com>
References: <1642006975-17580-1-git-send-email-sbhatta@marvell.com>
        <20220112110314.358d5295@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CALHRZuouqa76eNYgYe5qs71oHqdZ0OeE_P1UYJU8uaaG0-qAyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 12:07:42 +0530 sundeep subbaraya wrote:
> > Should we use rx_buf_len = 0 as a way for users to reset the rxbuf len
> > to the default value? I think that would be handy.
> >  
> Before this patch we calculate each receive buffer based on mtu set by user.
> Now user can use rx-buf-len but the old mtu based calculation is also there.
> Here I am using rx_buf_len == 0 as a switch to calculate buffer length
> using mtu or
> just use length set by user. So here I am not setting rx_buf_len to some
> default value.
> 
> > > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > > @@ -66,6 +66,8 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
> > >                   netdev->mtu, new_mtu);
> > >       netdev->mtu = new_mtu;
> > >
> > > +     pf->hw.rbuf_len = 0;  
> >
> > Why reset the buf len on mtu change?
> >  
> As explained above buffer size will be calculated using mtu
> now instead of rx-buf-len from ethtool.

IIUC you're saying that the way to get back to the default buffer size
is to change the MTU?

It was discussed on the list in the past in the context of RSS
indirection tables and the conclusion was that we should not reset
explicit user configuration (in case of RSS indir table this means
user-set table survives change in the number of queues).

Having one config reset another is pretty painful to deal with for 
the users. I had to fix many cases of this sort of problem in the
production env I'm working with. Turning one knob resets other knobs 
so it takes multiple runs of the config daemon (chef or alike) to
get to the target configuration.

In my mind if user has set the rx-buf-len it should survive all other
config changes. User can reset to default by setting rx-buf-len to 0.
It should be possible to set rx-buf-len and mtu in any order and have
the same result.

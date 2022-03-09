Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15784D393F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiCISxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiCISxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:53:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098AA182BF8;
        Wed,  9 Mar 2022 10:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9038861797;
        Wed,  9 Mar 2022 18:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C080C340E8;
        Wed,  9 Mar 2022 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646851938;
        bh=+DArKuMQB9BQkZlj+Yn2vhSYyPx0dFjihiD/ugKfs0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNwOz/O350LawkZ11VLNBaL29p5mLGQfBB9ek/jPonM2muArkMoSvGSE2iq+2g12I
         /nqelezUJclPT0eBHTnJmhXU1OqI+YF6Qcl9VhqiM75nq9nOXWVdaRfYTT/Gr6IzSk
         H1U2gADjw9Z4EXphZxYh7qe4CIlRg8louWTLmzdaSNr4SF5WIpBooX1lVRvC9zNzSu
         KDoNnpgnaS2sSB0TBKejk5kYdEJOBkBuejNt0/vQM5o2mfJEHtXtBp99L9LU9mHDjg
         6dfRL012U0mlSinfdHoag68biryeVsHI4846od/XzU7Gg7r66SOwpphjJ8se5mWsdk
         j5pebiOooB5tA==
Date:   Wed, 9 Mar 2022 20:52:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, mst@redhat.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yij3XqLpOu18Kw8A@unreal>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yicalf1I6oBytbse@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 09:57:57AM +0100, Greg KH wrote:
> On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > On Mon, 07 Mar 2022, Greg KH wrote:
> > 
> > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > 
> > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > capture possible future race conditions which may pop up over time.
> > > > 
> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  	int i;
> > > >  
> > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > +		/* No workers should run here by design. However, races have
> > > > +		 * previously occurred where drivers have been unable to flush
> > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > +		 * corruption in those cases does seem preferable.
> > > > +		 */
> > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > 
> > > So you are trading one syzbot triggered issue for another one in the
> > > future?  :)
> > > 
> > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > you want that to happen?
> > 
> > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> 
> Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> has resulted in a huge number of kernel fixes because of that.
> 
> > > And what happens if the mutex is locked _RIGHT_ after you checked it?
> > > You still have a race...
> > 
> > No, we miss a warning that one time.  Memory is still protected.
> 
> Then don't warn on something that doesn't matter.  This line can be
> dropped as there's nothing anyone can do about it, right?

Greg, at least two other reviewers said that this line shouldn't be at
all.

https://lore.kernel.org/all/CACGkMEsjmCNQPjxPjXL0WUfbMg8ARnumEp4yjUxqznMKR1nKSQ@mail.gmail.com/
https://lore.kernel.org/all/YiG61RqXFvq%2Ft0fB@unreal/
https://lore.kernel.org/all/YiETnIcfZCLb63oB@unreal/

Thanks

> 
> thanks,
> 
> greg k-h

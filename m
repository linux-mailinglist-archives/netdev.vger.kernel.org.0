Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA934D12F5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345264AbiCHI7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345259AbiCHI7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B74E3C4AF;
        Tue,  8 Mar 2022 00:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DF69B817D4;
        Tue,  8 Mar 2022 08:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA6AC340EB;
        Tue,  8 Mar 2022 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646729880;
        bh=g8JnrciyA5hVe9iyiMja39wfKFTI4eghy2XVxEq8voQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t/s29xuMklvlvsfmHRfDg9OiclbQlbVZX8uChLs/iNDYVHYxBhBhmcB/RTVBN8DrM
         sg4pdWLQEckaaK6banT+xBdd6RHSBthFqKnhND6G/1OFKtgE+z7J909kFBLzLQWXKQ
         pqo+UZmD8jNT0P7y8UJ53GCHfD2zkk2UVSkJViy8=
Date:   Tue, 8 Mar 2022 09:57:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yicalf1I6oBytbse@kroah.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YicPXnNFHpoJHcUN@google.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> On Mon, 07 Mar 2022, Greg KH wrote:
> 
> > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > during virtqueue clean-up and we mitigate the reported issues.
> > > 
> > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > capture possible future race conditions which may pop up over time.
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/vhost/vhost.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  	int i;
> > >  
> > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > +		/* No workers should run here by design. However, races have
> > > +		 * previously occurred where drivers have been unable to flush
> > > +		 * all work properly prior to clean-up.  Without a successful
> > > +		 * flush the guest will malfunction, but avoiding host memory
> > > +		 * corruption in those cases does seem preferable.
> > > +		 */
> > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > 
> > So you are trading one syzbot triggered issue for another one in the
> > future?  :)
> > 
> > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > you want that to happen?
> 
> No, Syzbot doesn't report warnings, only BUGs and memory corruption.

Has it changed?  Last I looked, it did trigger on WARN_* calls, which
has resulted in a huge number of kernel fixes because of that.

> > And what happens if the mutex is locked _RIGHT_ after you checked it?
> > You still have a race...
> 
> No, we miss a warning that one time.  Memory is still protected.

Then don't warn on something that doesn't matter.  This line can be
dropped as there's nothing anyone can do about it, right?

thanks,

greg k-h

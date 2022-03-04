Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C474CCEE8
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiCDHOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238804AbiCDHLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:11:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB808190C14;
        Thu,  3 Mar 2022 23:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75862B8277B;
        Fri,  4 Mar 2022 07:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE489C36AE2;
        Fri,  4 Mar 2022 07:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646377690;
        bh=yQYBzWouNWOyD9zM5WtI9fIV8Tp/PcZjsK5VYT69gEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2dtgef9seu1rfUTmGaIXrWAUcOn2Gy1WhrcXurBrEpz4hhDxdQg7EuNpftnUXTtq
         JBjN5h0HVmLOkCA8JyqebsGSz1ffWON8GKhccz7Q5MuDxS0yeif3v1gVvhTo9iy6Z4
         Yw6NZHCj6bSAU0PEYw//6qnMTd2WRw8pJiHKGe6JiSFkn463dtBONTLAz/3Kg2qOg6
         AdlvY4hZkaePiNMTjfX3xpLCbwh6s4cGOiFALYCVSglUJl2L8ebgwYO1lzaPPco9Q0
         Vz3MokG1wkJrp38nUB/wBYXbGjM1z0dCF6Rn3lWXwku46vZjTmVwOoV0nx1hn+/02I
         9AGKhomxWLQYw==
Date:   Fri, 4 Mar 2022 09:08:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held
 whilst clean-up in progress
Message-ID: <YiG61RqXFvq/t0fB@unreal>
References: <20220303151929.2505822-1-lee.jones@linaro.org>
 <YiETnIcfZCLb63oB@unreal>
 <20220303155645-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303155645-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 04:01:06PM -0500, Michael S. Tsirkin wrote:
> On Thu, Mar 03, 2022 at 09:14:36PM +0200, Leon Romanovsky wrote:
> > On Thu, Mar 03, 2022 at 03:19:29PM +0000, Lee Jones wrote:
> > > All workers/users should be halted before any clean-up should take place.
> > > 
> > > Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/vhost/vhost.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index bbaff6a5e21b8..d935d2506963f 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  	int i;
> > >  
> > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > +		/* Ideally all workers should be stopped prior to clean-up */
> > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > +
> > >  		mutex_lock(&dev->vqs[i]->mutex);
> > 
> > I know nothing about vhost, but this construction and patch looks
> > strange to me.
> > 
> > If all workers were stopped, you won't need mutex_lock(). The mutex_lock
> > here suggests to me that workers can still run here.
> > 
> > Thanks
> 
> 
> "Ideally" here is misleading, we need a bigger detailed comment
> along the lines of:
> 
> /* 
>  * By design, no workers can run here. But if there's a bug and the
>  * driver did not flush all work properly then they might, and we
>  * encountered such bugs in the past.  With no proper flush guest won't
>  * work correctly but avoiding host memory corruption in this case
>  * sounds like a good idea.
>  */

This description looks better, but the check is inherently racy.
Why don't you add a comment and mutex_lock()? The WARN_ON here is
more distraction than actual help.

Thanks

> 
> > >  		if (dev->vqs[i]->error_ctx)
> > >  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > -- 
> > > 2.35.1.574.g5d30c73bfb-goog
> > > 
> 

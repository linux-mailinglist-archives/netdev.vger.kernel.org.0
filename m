Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485624CAA23
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbiCBQ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiCBQ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 198192DAA4
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646238520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7eEfPBvyCQz7KlzEw024f3+wwx9DN1COWUQbQ4CRIAA=;
        b=OjLkUrpYUcqG+mvNZzXA9HpFix1dfyST+VSksZlg5IuUOwZPJ+2M1cl2w3FT64rau617YF
        dD321knhxABbIb6GUYZnNdaxspbd2Rrf88fLMp1mkjHJ+nCFpo0pVOKjX0bGKOR6Z/mJMt
        gm1SzRoPdvtL+BhQ/NW6bNafVnjo1BM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-yZJMyVDIM1a0Zq-tBLsVTA-1; Wed, 02 Mar 2022 11:28:39 -0500
X-MC-Unique: yZJMyVDIM1a0Zq-tBLsVTA-1
Received: by mail-wr1-f69.google.com with SMTP id t8-20020adfa2c8000000b001e8f6889404so845694wra.0
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 08:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7eEfPBvyCQz7KlzEw024f3+wwx9DN1COWUQbQ4CRIAA=;
        b=CGcA2sDVZ72detR1PTm4r912Et7SbeAOdDVZSqyZvPbapwVTcyXqDt24dYq108Icbf
         Z5IJLF1aICWh4bklVyGMPsqeEM+1ZrHJA8e7Ugm/tJ+mg6Qjtr+g27xn14H3u7HyaUmg
         7vdCbc+uo0hzPy2FWpgHvLYGG4bHJt4+wdZH3tRq11IPW25/tF3y9jeHkNTeRumo5rP6
         4SGbkGjZucQZwFi31auWtIdqFOG8CAYQ93+c1myY0FQVf44lWah8t+sSwDVlkTX8gGXU
         fM0ydXy2KsP5zrbnHRJIR3INfuqU6AM3BRuTNqtENsAPdH7RFupmgbyoOZNswAuNMZrs
         gIdA==
X-Gm-Message-State: AOAM530KLksEQsRumcMW30tu58rMbAtS0gr629n+VZk6yZ7Dkb1L8Cwg
        Rsq8dFWe/EJ0qXJQxlBYw9X8eB5C9+PU0gKF9f3KAJSrtKhYEn5uCxOXw4aXQ1yNuCDFxO4Y58H
        w3q8f4mfQHtT2fJzM
X-Received: by 2002:a05:6000:1a52:b0:1f0:2d62:2bbb with SMTP id t18-20020a0560001a5200b001f02d622bbbmr3097907wry.614.1646238517709;
        Wed, 02 Mar 2022 08:28:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyul2MSo2n7QpL85LxwCnbq2CCgtDPP6CoPZDNaTpNW2WppDgvCCshQp5K2HZYQsvSsIG9RAQ==
X-Received: by 2002:a05:6000:1a52:b0:1f0:2d62:2bbb with SMTP id t18-20020a0560001a5200b001f02d622bbbmr3097869wry.614.1646238516965;
        Wed, 02 Mar 2022 08:28:36 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id o18-20020a05600c511200b00352ec3b4c5asm8910926wms.7.2022.03.02.08.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:28:36 -0800 (PST)
Date:   Wed, 2 Mar 2022 17:28:31 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <CAGxU2F4cUDrMzoHH1NT5_ivxBPgEE8HOzP5s_Bt5JURRaSsLdQ@mail.gmail.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
 <Yh+F1gkCGoYF2lMV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+F1gkCGoYF2lMV@google.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 2, 2022 at 3:57 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
>
> > On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > >
> > > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > >
> > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > >
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > ---
> > > > >  drivers/vhost/vhost.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > > > --- a/drivers/vhost/vhost.c
> > > > > +++ b/drivers/vhost/vhost.c
> > > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > >         int i;
> > > > >
> > > > >         for (i = 0; i < dev->nvqs; ++i) {
> > > > > +               mutex_lock(&dev->vqs[i]->mutex);
> > > > >                 if (dev->vqs[i]->error_ctx)
> > > > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > > >                 if (dev->vqs[i]->kick)
> > > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > >                 if (dev->vqs[i]->call_ctx.ctx)
> > > > >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > > >                 vhost_vq_reset(dev, dev->vqs[i]);
> > > > > +               mutex_unlock(&dev->vqs[i]->mutex);
> > > > >         }
> > > >
> > > > So this is a mitigation plan but the bug is still there though
> > > > we don't know exactly what it is.  I would prefer adding something like
> > > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> > >
> > > As a rework to this, or as a subsequent patch?
> >
> > Can be a separate patch.
> >
> > > Just before the first lock I assume?
> >
> > I guess so, yes.
>
> No problem.  Patch to follow.
>
> I'm also going to attempt to debug the root cause, but I'm new to this
> subsystem to it might take a while for me to get my head around.

IIUC the root cause should be the same as the one we solved here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9

The worker was not stopped before calling vhost_dev_cleanup(). So while 
the worker was still running we were going to free memory or initialize 
fields while it was still using virtqueue.

Cheers,
Stefano


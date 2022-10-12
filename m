Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B225FBF7A
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 05:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJLDT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 23:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLDT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 23:19:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4477675FFB
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 20:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665544765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOaaFXQ5HbQDaFq6CPpJibOKm0dV0yh95piJEg5lniE=;
        b=SfB7w1wAgMvwR23vDyruz0hBBtZCQu1PsdvpkKz31BwjpFBMvJw+F2+NgGqxW5bkqVcU0l
        bLfoBpw9WeKPWkGi8rAdbBq4Cyl8rk3aWKZ6wuJcozICl1I3szvowWny0ThjVxpQG1vv3J
        FDHDB5/IAd+ZavSQrriqjI/34o7S62A=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-W5vcUtyUPCOqCESIVOQVUw-1; Tue, 11 Oct 2022 23:19:23 -0400
X-MC-Unique: W5vcUtyUPCOqCESIVOQVUw-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-131d9821d9cso7768749fac.6
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 20:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOaaFXQ5HbQDaFq6CPpJibOKm0dV0yh95piJEg5lniE=;
        b=uORk2/kbtNrkXNr4mWZDwV6RGFD43/6sXdxhWoPb7WPQXEjycVV/srmtC4O0I1CFse
         625pQmn+gZCnz8JzLsE8Fvh7r1u0PgOvvAyeMT5Uc1o7wo2fTIF6Gas4nGIrHa7UJSFJ
         BdQMRUTvFz/TIKV5qfoPyQ3BDWOzbtmxfl4MpuOfUuS9J6rb5CrOeTJzy9AwzQ2Rg+4l
         QE1MnsE3Y5uLX+892+ATmot5XfZj8GG+CCgAexFpjHtVSctCMqiOuUG8e3HPylvtFggZ
         XwtwKMPK6v97aRt/zj0+sZ4EcMUfdqWSQR8Pq0HoP3H6WdnQvI7FUNtzBc4+z+pnipms
         Km/Q==
X-Gm-Message-State: ACrzQf1ZQraVvSOutDHIl9C2agQ9p81xORPICghTSqkbx5L0ec6wYiKT
        2ly+7XhCIKHG7NSTtv/g5GCylPR/BJCoLnscGQ6nFULcNYiW9XRiB5OGBq1nCSjzRlv9SsU72B7
        MhKtAvziIrUZ8Pu8pxiFNjWx04xWabgIN
X-Received: by 2002:a05:6870:eca8:b0:132:df46:5c66 with SMTP id eo40-20020a056870eca800b00132df465c66mr1244862oab.280.1665544763211;
        Tue, 11 Oct 2022 20:19:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6qJaZpVxXnQiPwfFosnIoFxQE+RoEjCck72xQmCK6o3Rr2sv7KUlah5pfDE4RhfHDQ8LL1KDZIJ/qaW+A38I0=
X-Received: by 2002:a05:6870:eca8:b0:132:df46:5c66 with SMTP id
 eo40-20020a056870eca800b00132df465c66mr1244845oab.280.1665544762964; Tue, 11
 Oct 2022 20:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220905045341.66191-1-jasowang@redhat.com> <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
 <20220907034407-mutt-send-email-mst@kernel.org> <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
 <20220908011858-mutt-send-email-mst@kernel.org> <c8cd9a2e-3480-6ca5-96fa-4b5bd2c1174a@redhat.com>
 <20221009160520-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221009160520-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 12 Oct 2022 11:19:12 +0800
Message-ID: <CACGkMEscu+mUBff1JUW4QxkyV33MwRP7VPSZ2-OXp5=pJaHC6Q@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command waiting loop
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 1:11 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Oct 09, 2022 at 01:58:53PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/9/8 13:19, Michael S. Tsirkin =E5=86=99=E9=81=93:
> > > On Thu, Sep 08, 2022 at 10:21:45AM +0800, Jason Wang wrote:
> > > > =E5=9C=A8 2022/9/7 15:46, Michael S. Tsirkin =E5=86=99=E9=81=93:
> > > > > On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
> > > > > > On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
> > > > > > > On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com=
> wrote:
> > > > > > > > On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
> > > > > > > > > On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@re=
dhat.com> wrote:
> > > > > > > > > > On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wr=
ote:
> > > > > > > > > > > Adding cond_resched() to the command waiting loop for=
 a better
> > > > > > > > > > > co-operation with the scheduler. This allows to give =
CPU a breath to
> > > > > > > > > > > run other task(workqueue) instead of busy looping whe=
n preemption is
> > > > > > > > > > > not allowed.
> > > > > > > > > > >
> > > > > > > > > > > What's more important. This is a must for some vDPA p=
arent to work
> > > > > > > > > > > since control virtqueue is emulated via a workqueue f=
or those parents.
> > > > > > > > > > >
> > > > > > > > > > > Fixes: bda324fd037a ("vdpasim: control virtqueue supp=
ort")
> > > > > > > > > > That's a weird commit to fix. so it fixes the simulator=
?
> > > > > > > > > Yes, since the simulator is using a workqueue to handle c=
ontrol virtueue.
> > > > > > > > Uhmm... touching a driver for a simulator's sake looks a li=
ttle weird.
> > > > > > > Simulator is not the only one that is using a workqueue (but =
should be
> > > > > > > the first).
> > > > > > >
> > > > > > > I can see  that the mlx5 vDPA driver is using a workqueue as =
well (see
> > > > > > > mlx5_vdpa_kick_vq()).
> > > > > > >
> > > > > > > And in the case of VDUSE, it needs to wait for the response f=
rom the
> > > > > > > userspace, this means cond_resched() is probably a must for t=
he case
> > > > > > > like UP.
> > > > > > >
> > > > > > > > Additionally, if the bug is vdpasim, I think it's better to=
 try to
> > > > > > > > solve it there, if possible.
> > > > > > > >
> > > > > > > > Looking at vdpasim_net_work() and vdpasim_blk_work() it loo=
ks like
> > > > > > > > neither needs a process context, so perhaps you could rewor=
k it to run
> > > > > > > > the work_fn() directly from vdpasim_kick_vq(), at least for=
 the control
> > > > > > > > virtqueue?
> > > > > > > It's possible (but require some rework on the simulator core)=
. But
> > > > > > > considering we have other similar use cases, it looks better =
to solve
> > > > > > > it in the virtio-net driver.
> > > > > > I see.
> > > > > >
> > > > > > > Additionally, this may have better behaviour when using for t=
he buggy
> > > > > > > hardware (e.g the control virtqueue takes too long to respond=
). We may
> > > > > > > consider switching to use interrupt/sleep in the future (but =
not
> > > > > > > suitable for -net).
> > > > > > Agreed. Possibly a timeout could be useful, too.
> > > > > >
> > > > > > Cheers,
> > > > > >
> > > > > > Paolo
> > > > > Hmm timeouts are kind of arbitrary.
> > > > > regular drivers basically derive them from hardware
> > > > > behaviour but with a generic driver like virtio it's harder.
> > > > > I guess we could add timeout as a config field, have
> > > > > device make a promise to the driver.
> > > > >
> > > > > Making the wait interruptible seems more reasonable.
> > > >
> > > > Yes, but I think we still need this patch for -net and -stable.
> > > >
> > > > Thanks
> > > I was referring to Paolo's idea of having a timeout.
> >
> >
> > Ok, I think we're fine with this patch. Any chance to merge this or do =
I
> > need to resend?
> >
> > Thanks
>
> Last question: do we want cpu_relax here now? Or is cond_resched
> sufficient?

(Have answered in another thread)

I think we need cpu_relax() since there could be no high priority task
in the current cpu so we still need to relax.

Thanks

>
> >
> > >
>


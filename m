Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D160077B
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJQHPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiJQHPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:15:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A76101F0
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665990926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPJ0zMzH+/+WqE+Q9hXMqr+6tdiNkx5DCmG8+/nVPjA=;
        b=PpVQNCUfenkyJKX1EWLMzbY7PmoCvMPw8b4dKomzk430mHmsNFcMGC9u+X3MQRqMjUiMr+
        6Wd0yjMDZHqmkx0749w9xEDHg8SAd3XZFMYjx4HFQmh28KG2cAdhr1uF5kdcxYmGfc2sZW
        t/6VpNX+oh0d2Kv/x+ZgdvrjatEuaDE=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-198-pQg9HDYLP0GwKYZo9vKTOA-1; Mon, 17 Oct 2022 03:15:25 -0400
X-MC-Unique: pQg9HDYLP0GwKYZo9vKTOA-1
Received: by mail-oi1-f199.google.com with SMTP id bm8-20020a0568081a8800b003544ba66e7bso3644745oib.18
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iPJ0zMzH+/+WqE+Q9hXMqr+6tdiNkx5DCmG8+/nVPjA=;
        b=0Tsvt6SzCU8v002BCMVo5B6fsjIH1pJ+dQSBUsly2V65ULExtS6CPdmbOVdIE/4w2P
         25BXB/k5OYAZv9NRL4kwEGDXYkVwWTUETlVCHQM8nFTNKkPqIar+4bz30CJpg6CQdfcn
         cGK/yD+FSRodJvqnVM+eM24vITY+vk73wQCrXaFdUyprI24Un0nzymQvj6Y1RFJGtrzh
         0TZk6nuyRMPYaFW0QfHqqh5eH3TR+LzkVodKbnGRDdhEwOsLvE6GIl0wWcrH752INA+X
         XJedENq0tv4Mv8lDnFUOTibt4HDTlNOrOCs/2dLeGOM1YououONAbSQWIQ9BVwCi/htP
         zNGg==
X-Gm-Message-State: ACrzQf3mZMGlgSQG5Qqm5XoAjK8MBbtGPvELS9tHHDE8cXEfjYv3u0q0
        VKi1b8ab5jo5OxDcHyxehDCt0vu3yQA1owdAicqNYtj+l6JLCjnqNjErgHH7LfRLHfVZCe5IoxC
        osqjdZjoinFMF9jpqWzJdFGg2dYK6LEUY
X-Received: by 2002:a9d:7dcf:0:b0:661:dc25:ba0 with SMTP id k15-20020a9d7dcf000000b00661dc250ba0mr4363908otn.201.1665990924506;
        Mon, 17 Oct 2022 00:15:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6PRVlb4SMRZS+7oWQMjNwL9+//CGJE+DrIL1IAik9PhPKTnJpbrhNsRHBWEsjTXVM1VPXKWZW9Hq3yWLjAgaI=
X-Received: by 2002:a9d:7dcf:0:b0:661:dc25:ba0 with SMTP id
 k15-20020a9d7dcf000000b00661dc250ba0mr4363898otn.201.1665990924270; Mon, 17
 Oct 2022 00:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220905045341.66191-1-jasowang@redhat.com> <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
 <20220907034407-mutt-send-email-mst@kernel.org> <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
 <20220908011858-mutt-send-email-mst@kernel.org> <c8cd9a2e-3480-6ca5-96fa-4b5bd2c1174a@redhat.com>
 <20221009160520-mutt-send-email-mst@kernel.org> <CACGkMEscu+mUBff1JUW4QxkyV33MwRP7VPSZ2-OXp5=pJaHC6Q@mail.gmail.com>
In-Reply-To: <CACGkMEscu+mUBff1JUW4QxkyV33MwRP7VPSZ2-OXp5=pJaHC6Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 17 Oct 2022 15:15:12 +0800
Message-ID: <CACGkMEurGrbj6E5xzLN_uAe9bhFaYtrUu-4fqNP=aumiQi9bzQ@mail.gmail.com>
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
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 11:19 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, Oct 11, 2022 at 1:11 AM Michael S. Tsirkin <mst@redhat.com> wrote=
:
> >
> > On Sun, Oct 09, 2022 at 01:58:53PM +0800, Jason Wang wrote:
> > >
> > > =E5=9C=A8 2022/9/8 13:19, Michael S. Tsirkin =E5=86=99=E9=81=93:
> > > > On Thu, Sep 08, 2022 at 10:21:45AM +0800, Jason Wang wrote:
> > > > > =E5=9C=A8 2022/9/7 15:46, Michael S. Tsirkin =E5=86=99=E9=81=93:
> > > > > > On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
> > > > > > > On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
> > > > > > > > On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.c=
om> wrote:
> > > > > > > > > On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
> > > > > > > > > > On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@=
redhat.com> wrote:
> > > > > > > > > > > On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang =
wrote:
> > > > > > > > > > > > Adding cond_resched() to the command waiting loop f=
or a better
> > > > > > > > > > > > co-operation with the scheduler. This allows to giv=
e CPU a breath to
> > > > > > > > > > > > run other task(workqueue) instead of busy looping w=
hen preemption is
> > > > > > > > > > > > not allowed.
> > > > > > > > > > > >
> > > > > > > > > > > > What's more important. This is a must for some vDPA=
 parent to work
> > > > > > > > > > > > since control virtqueue is emulated via a workqueue=
 for those parents.
> > > > > > > > > > > >
> > > > > > > > > > > > Fixes: bda324fd037a ("vdpasim: control virtqueue su=
pport")
> > > > > > > > > > > That's a weird commit to fix. so it fixes the simulat=
or?
> > > > > > > > > > Yes, since the simulator is using a workqueue to handle=
 control virtueue.
> > > > > > > > > Uhmm... touching a driver for a simulator's sake looks a =
little weird.
> > > > > > > > Simulator is not the only one that is using a workqueue (bu=
t should be
> > > > > > > > the first).
> > > > > > > >
> > > > > > > > I can see  that the mlx5 vDPA driver is using a workqueue a=
s well (see
> > > > > > > > mlx5_vdpa_kick_vq()).
> > > > > > > >
> > > > > > > > And in the case of VDUSE, it needs to wait for the response=
 from the
> > > > > > > > userspace, this means cond_resched() is probably a must for=
 the case
> > > > > > > > like UP.
> > > > > > > >
> > > > > > > > > Additionally, if the bug is vdpasim, I think it's better =
to try to
> > > > > > > > > solve it there, if possible.
> > > > > > > > >
> > > > > > > > > Looking at vdpasim_net_work() and vdpasim_blk_work() it l=
ooks like
> > > > > > > > > neither needs a process context, so perhaps you could rew=
ork it to run
> > > > > > > > > the work_fn() directly from vdpasim_kick_vq(), at least f=
or the control
> > > > > > > > > virtqueue?
> > > > > > > > It's possible (but require some rework on the simulator cor=
e). But
> > > > > > > > considering we have other similar use cases, it looks bette=
r to solve
> > > > > > > > it in the virtio-net driver.
> > > > > > > I see.
> > > > > > >
> > > > > > > > Additionally, this may have better behaviour when using for=
 the buggy
> > > > > > > > hardware (e.g the control virtqueue takes too long to respo=
nd). We may
> > > > > > > > consider switching to use interrupt/sleep in the future (bu=
t not
> > > > > > > > suitable for -net).
> > > > > > > Agreed. Possibly a timeout could be useful, too.
> > > > > > >
> > > > > > > Cheers,
> > > > > > >
> > > > > > > Paolo
> > > > > > Hmm timeouts are kind of arbitrary.
> > > > > > regular drivers basically derive them from hardware
> > > > > > behaviour but with a generic driver like virtio it's harder.
> > > > > > I guess we could add timeout as a config field, have
> > > > > > device make a promise to the driver.
> > > > > >
> > > > > > Making the wait interruptible seems more reasonable.
> > > > >
> > > > > Yes, but I think we still need this patch for -net and -stable.
> > > > >
> > > > > Thanks
> > > > I was referring to Paolo's idea of having a timeout.
> > >
> > >
> > > Ok, I think we're fine with this patch. Any chance to merge this or d=
o I
> > > need to resend?
> > >
> > > Thanks
> >
> > Last question: do we want cpu_relax here now? Or is cond_resched
> > sufficient?
>
> (Have answered in another thread)
>
> I think we need cpu_relax() since there could be no high priority task
> in the current cpu so we still need to relax.
>
> Thanks

Michael, does this answer make sense? If yes, would you like to ack the pat=
ch?

Thanks

>
> >
> > >
> > > >
> >


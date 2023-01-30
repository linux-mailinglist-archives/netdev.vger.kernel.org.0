Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE46A6803E7
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 03:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbjA3Cy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 21:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjA3Cy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 21:54:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06171A962
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 18:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675047249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AoWdEZ/yaqGT1OqdQO6pBxjycLMtTjr9F9A+c/G6+CA=;
        b=AX53HzzkFTPwoiKWdAAsNJg9sTXDk6Ykz8xhlC/y7ZaAjpIQnI7oW4+aU5es+K8CxzURso
        IGBFgxl3LUqqd5hH3qaZxY2x0Ah2SwibYybVHeOP1ynL+Lee3HC1B22G5WJOfMq6cuXB9Y
        udajCFKxv+J+nS9XV8+DgPp9MRuKxWs=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-341-Pdfte14MOtyG_yxTbf986A-1; Sun, 29 Jan 2023 21:54:06 -0500
X-MC-Unique: Pdfte14MOtyG_yxTbf986A-1
Received: by mail-oi1-f199.google.com with SMTP id eb8-20020a056808634800b0036e1f34427aso4727296oib.18
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 18:54:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AoWdEZ/yaqGT1OqdQO6pBxjycLMtTjr9F9A+c/G6+CA=;
        b=yQw7ZsXaoVbA8DusZfdga6IANXtWW2P7Ec1D9OUYvBLTcQJU2fbpvH+YzUEf7ZxOrG
         ceBV877ID2OKqsjxVUbBWBQkkuzpvPw9eN5BTsu81F8vQwQEyWuHyqVXrztd9+0NfU0w
         wxYdh9jf3IlGpGYH55YzvnTjkZ+O5aT97nBXcVfrVzbKLQTjiK23eQtYtkpDAIIJfgUa
         qaEO+JfON0NlD055zOg0O/b7Ld6cYsprsJz86ibVrDqk6shtMV8fv6KL2z2RJ/273/i1
         8oWwXuoU/CniUvDoescfPWqMo7ywT23Zk6KGZOWntIyet9Iitzc3l5qAZukpg7cmVhB3
         ADDw==
X-Gm-Message-State: AFqh2krNNEKA1uai4tSn0QCCO2PE7+ddnJsqhVU/8yNVKcnuHCFp3aNI
        hcV19vHc27SgFPyit8f5c5N1NvdlC4ewPfjT5QsI8C9uH7cmQhSNzb1nnHulWZr1RjFEo18OkhX
        DmGsiTpDb4oPj2rotPcA+1t9NX8iQjCRF
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id y14-20020a056871010e00b0015b96b59916mr3924707oab.280.1675047246054;
        Sun, 29 Jan 2023 18:54:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsSDrlerEmQE1VEMn77eC3aqReXKoMWvV9fgiOn+UzniPxIf7XVG7PGoMpqj9eTq8Xhc6S1kAzs4zktcxe9SuY=
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id
 y14-20020a056871010e00b0015b96b59916mr3924703oab.280.1675047245754; Sun, 29
 Jan 2023 18:54:05 -0800 (PST)
MIME-Version: 1.0
References: <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org> <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org> <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org> <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org> <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
 <20230129022809-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230129022809-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 30 Jan 2023 10:53:54 +0800
Message-ID: <CACGkMEuya+_2P8d4hokoyL_LKGdVzyCC1nDwOCdZb0=+2rjKPQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 3:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Jan 29, 2023 at 01:48:49PM +0800, Jason Wang wrote:
> > On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > > > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> > > > >
> > > > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat=
.com> wrote:
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > =E5=9C=A8 2022/12/27 17:38, Michael S. Tsirkin =E5=86=99=
=E9=81=93:
> > > > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wr=
ote:
> > > > > > > > > >> =E5=9C=A8 2022/12/27 15:33, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
> > > > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang =
wrote:
> > > > > > > > > >>>>> But device is still going and will later use the bu=
ffers.
> > > > > > > > > >>>>>
> > > > > > > > > >>>>> Same for timeout really.
> > > > > > > > > >>>> Avoiding infinite wait/poll is one of the goals, ano=
ther is to sleep.
> > > > > > > > > >>>> If we think the timeout is hard, we can start from t=
he wait.
> > > > > > > > > >>>>
> > > > > > > > > >>>> Thanks
> > > > > > > > > >>> If the goal is to avoid disrupting traffic while CVQ =
is in use,
> > > > > > > > > >>> that sounds more reasonable. E.g. someone is turning =
on promisc,
> > > > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > > > >>
> > > > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > > > >>
> > > > > > > > > >>
> > > > > > > > > >>> things we should be careful to address then:
> > > > > > > > > >>> 1- debugging. Currently it's easy to see a warning if=
 CPU is stuck
> > > > > > > > > >>>      in a loop for a while, and we also get a backtra=
ce.
> > > > > > > > > >>>      E.g. with this - how do we know who has the RTNL=
?
> > > > > > > > > >>>      We need to integrate with kernel/watchdog.c for =
good results
> > > > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > > > >>
> > > > > > > > > >> That's fine, will consider this.
> > > > > > > >
> > > > > > > > So after some investigation, it seems the watchdog.c doesn'=
t help. The
> > > > > > > > only export helper is touch_softlockup_watchdog() which tri=
es to avoid
> > > > > > > > triggering the lockups warning for the known slow path.
> > > > > > >
> > > > > > > I never said you can just use existing exporting APIs. You'll=
 have to
> > > > > > > write new ones :)
> > > > > >
> > > > > > Ok, I thought you wanted to trigger similar warnings as a watch=
dog.
> > > > > >
> > > > > > Btw, I wonder what kind of logic you want here. If we switch to=
 using
> > > > > > sleep, there won't be soft lockup anymore. A simple wait + time=
out +
> > > > > > warning seems sufficient?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > I'd like to avoid need to teach users new APIs. So watchdog setup=
 to apply
> > > > > to this driver. The warning can be different.
> > > >
> > > > Right, so it looks to me the only possible setup is the
> > > > watchdog_thres. I plan to trigger the warning every watchdog_thres =
* 2
> > > > second (as softlockup did).
> > > >
> > > > And I think it would still make sense to fail, we can start with a
> > > > very long timeout like 1 minutes and break the device. Does this ma=
ke
> > > > sense?
> > > >
> > > > Thanks
> > >
> > > I'd say we need to make this manageable then.
> >
> > Did you mean something like sysfs or module parameters?
>
> No I'd say pass it with an ioctl.
>
> > > Can't we do it normally
> > > e.g. react to an interrupt to return to userspace?
> >
> > I didn't get the meaning of this. Sorry.
> >
> > Thanks
>
> Standard way to handle things that can timeout and where userspace
> did not supply the time is to block until an interrupt
> then return EINTR.

Well this seems to be a huge change, ioctl(2) doesn't say it can
return EINTR now.

Actually, a driver timeout is used by other drivers when using
controlq/adminq (e.g i40e). Starting from a sane value (e.g 1 minutes
to avoid false negatives) seems to be a good first step.

> Userspace controls the timeout by
> using e.g. alarm(2).

Not used in iproute2 after a git grep.

Thanks

>
>
> > >
> > >
> > >
> > > > >
> > > > >
> > > > > > >
> > > > > > > > And before the patch, we end up with a real infinite loop w=
hich could
> > > > > > > > be caught by RCU stall detector which is not the case of th=
e sleep.
> > > > > > > > What we can do is probably do a periodic netdev_err().
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > Only with a bad device.
> > > > > > >
> > > > > > > > > >>
> > > > > > > > > >>
> > > > > > > > > >>> 2- overhead. In a very common scenario when device is=
 in hypervisor,
> > > > > > > > > >>>      programming timers etc has a very high overhead,=
 at bootup
> > > > > > > > > >>>      lots of CVQ commands are run and slowing boot do=
wn is not nice.
> > > > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > > > >>
> > > > > > > > > >> Then we go back to the question of choosing a good tim=
eout for poll. And
> > > > > > > > > >> poll seems problematic in the case of UP, scheduler mi=
ght not have the
> > > > > > > > > >> chance to run.
> > > > > > > > > > Poll just a bit :) Seriously I don't know, but at least=
 check once
> > > > > > > > > > after kick.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > I think it is what the current code did where the conditi=
on will be
> > > > > > > > > check before trying to sleep in the wait_event().
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >>> 3- suprise removal. need to wake up thread in some wa=
y. what about
> > > > > > > > > >>>      other cases of device breakage - is there a chan=
ce this
> > > > > > > > > >>>      introduces new bugs around that? at least enumer=
ate them please.
> > > > > > > > > >>
> > > > > > > > > >> The current code did:
> > > > > > > > > >>
> > > > > > > > > >> 1) check for vq->broken
> > > > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > > > >>
> > > > > > > > > >> So we won't end up with a never woke up process which =
should be fine.
> > > > > > > > > >>
> > > > > > > > > >> Thanks
> > > > > > > > > >
> > > > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure =
that is a good
> > > > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > > > >
> > > > > > > > > But consider we will start from a wait first, I will limi=
t the changes
> > > > > > > > > in virtio-net without bothering virtio core.
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >>>
> > > > > > >
> > > > >
> > >
>


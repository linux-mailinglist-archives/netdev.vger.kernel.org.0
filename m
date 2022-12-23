Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8264654D2F
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 09:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbiLWIGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 03:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiLWIGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 03:06:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C46131ED8
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 00:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671782736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFLWsQNHsge6wGJfAl0mL7hIz5gRpomgqSOVA8QczgI=;
        b=cdUhUEBPHntU2nGQVEl1UfgNl0sYazbvqQnfkUkVbfAVrru2Cw/uvN3O3IIqRe7qmyjHH9
        ougPrumUDv7VQzc7hW+24UxcAM89UoM97HE/1gjDa8aJA3WuIK/JMNdMeOUNCR8S5h6efD
        Pm+cpSIfCyoPX1XkgCE353HePWpHfsk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-70-xo4B5NcoMhG_imM5p8-MRg-1; Fri, 23 Dec 2022 03:05:35 -0500
X-MC-Unique: xo4B5NcoMhG_imM5p8-MRg-1
Received: by mail-ed1-f71.google.com with SMTP id h8-20020a056402280800b0046af59e0986so3205618ede.22
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 00:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFLWsQNHsge6wGJfAl0mL7hIz5gRpomgqSOVA8QczgI=;
        b=nlNHAPdCRjh/Q4vEXoc7mHAyWLjtX72PRva+7oNUiHEmGFwVvzZRn4q3Ssze6uaGKY
         LJrJdJLc2kB7b2kz8meeScJh7CHaOEqDXHWw9gUhD3Yoi1JuiI6COeKFMIxDabdpqpSR
         qSRRPvjwgJ3KAGGfmTpgJZTzW491w32LYjzhrL8ok/zJ1l0TThcX9ohjr29OcYS0//z0
         odPzKhaiMNp00AlH4kCvLqFVl/DAdgxUavdM9aY9My4rVAUjVk1P9c2fFcpJXuJNw8BJ
         qdG9qUlK0moaqzJCZKXYhGEZI3CC+1MY505yu0dCH8u0xVhd/SDM8mDbsa4yFvYwX4pp
         f8mw==
X-Gm-Message-State: AFqh2kqLicqbcOghLVEx+ChzRfXdjP2rK9ZGVoHAdapFXZehbZ4mVQXl
        ssgWcSA2XfM0TLHaRaX43TqESJ/hvRYwGNCT5hVnfb0sja+GPKyjSnLoGZsEsxZC1J8+J9IVgTQ
        A3bqWC5eGgKgG60DEY7suReBlINFEOfbP
X-Received: by 2002:aa7:ccd6:0:b0:46b:fb7d:2188 with SMTP id y22-20020aa7ccd6000000b0046bfb7d2188mr812691edt.395.1671782733842;
        Fri, 23 Dec 2022 00:05:33 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsf+vA7wmRUinz14o+jRWMIhgxxiT4IeIrvDnetlxJiJT3eULqs5z5czOZ67qTTD+ZSFFK6EfJKzK4pDFoGaJg=
X-Received: by 2002:aa7:ccd6:0:b0:46b:fb7d:2188 with SMTP id
 y22-20020aa7ccd6000000b0046bfb7d2188mr812690edt.395.1671782733588; Fri, 23
 Dec 2022 00:05:33 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJaqyWetutMj=GrR+ieS265_aRr7OhoP+7O5rWgPnP+ZAyxbPg@mail.gmail.com> <CACGkMEvs6QenyQNR0GyJ81PgT-w2fy7Rag-JkJ7xNGdNZLGSfQ@mail.gmail.com>
In-Reply-To: <CACGkMEvs6QenyQNR0GyJ81PgT-w2fy7Rag-JkJ7xNGdNZLGSfQ@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 23 Dec 2022 09:04:56 +0100
Message-ID: <CAJaqyWfJriGB1aLJ8BWZnnZ+fYrpwpkwxSAmKhzmYE72VWBvEA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 4:04 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, Dec 22, 2022 at 5:19 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Thu, Dec 22, 2022 at 7:05 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > We used to busy waiting on the cvq command this tends to be
> > > problematic since:
> > >
> > > 1) CPU could wait for ever on a buggy/malicous device
> > > 2) There's no wait to terminate the process that triggers the cvq
> > >    command
> > >
> > > So this patch switch to use sleep with a timeout (1s) instead of busy
> > > polling for the cvq command forever. This gives the scheduler a breath
> > > and can let the process can respond to a signal.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/net/virtio_net.c | 15 ++++++++-------
> > >  1 file changed, 8 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 8225496ccb1e..69173049371f 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
> > >         vi->rx_mode_work_enabled = false;
> > >         spin_unlock_bh(&vi->rx_mode_lock);
> > >
> > > +       virtqueue_wake_up(vi->cvq);
> > >         flush_work(&vi->rx_mode_work);
> > >  }
> > >
> > > @@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
> > >         return !oom;
> > >  }
> > >
> > > +static void virtnet_cvq_done(struct virtqueue *cvq)
> > > +{
> > > +       virtqueue_wake_up(cvq);
> > > +}
> > > +
> > >  static void skb_recv_done(struct virtqueue *rvq)
> > >  {
> > >         struct virtnet_info *vi = rvq->vdev->priv;
> > > @@ -2024,12 +2030,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
> > >         if (unlikely(!virtqueue_kick(vi->cvq)))
> > >                 return vi->ctrl->status == VIRTIO_NET_OK;
> > >
> > > -       /* Spin for a response, the kick causes an ioport write, trapping
> > > -        * into the hypervisor, so the request should be handled immediately.
> > > -        */
> > > -       while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > > -              !virtqueue_is_broken(vi->cvq))
> > > -               cpu_relax();
> > > +       virtqueue_wait_for_used(vi->cvq, &tmp);
> > >
> > >         return vi->ctrl->status == VIRTIO_NET_OK;
> > >  }
> > > @@ -3524,7 +3525,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >
> > >         /* Parameters for control virtqueue, if any */
> > >         if (vi->has_cvq) {
> > > -               callbacks[total_vqs - 1] = NULL;
> > > +               callbacks[total_vqs - 1] = virtnet_cvq_done;
> >
> > If we're using CVQ callback, what is the actual use of the timeout?
>
> Because we can't sleep forever since locks could be held like RTNL_LOCK.
>

Right, rtnl_lock kind of invalidates it for a general case.

But do all of the commands need to take rtnl_lock? For example I see
how we could remove it from ctrl_announce, so lack of ack may not be
fatal for it. Assuming a buggy device, we can take some cvq commands
out of this fatal situation.

This series already improves the current situation and my suggestion
(if it's worth it) can be applied on top of it, so it is not a blocker
at all.

> >
> > I'd say there is no right choice neither in the right timeout value
> > nor in the action to take.
>
> In the next version, I tend to put BAD_RING() to prevent future requests.
>
> > Why not simply trigger the cmd and do all
> > the changes at command return?
>
> I don't get this, sorry.
>

It's actually expanding the first point so you already answered it :).

Thanks!

> >
> > I suspect the reason is that it complicates the code. For example,
> > having the possibility of many in flight commands, races between their
> > completion, etc.
>
> Actually the cvq command was serialized through RTNL_LOCK, so we don't
> need to worry about this.
>
> In the next version I can add ASSERT_RTNL().
>
> Thanks
>
> > The virtio standard does not even cover unordered
> > used commands if I'm not wrong.
> >
> > Is there any other fundamental reason?
> >
> > Thanks!
> >
> > >                 names[total_vqs - 1] = "control";
> > >         }
> > >
> > > --
> > > 2.25.1
> > >
> >
>


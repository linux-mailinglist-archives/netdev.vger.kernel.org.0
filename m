Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7596C7B72
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjCXJbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCXJbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:31:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6850423A54
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679650261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJlH9otWhMZcJiElSwL7jmGaIVB1DaHJ04Oz3GP+kqo=;
        b=cI5ri+wH7lxStIcS8vyJUNht+WFJZnU6JmKkB1MhEKSUQqeUVDvDsQh/KzmW7/tiqZwRUf
        cvdbo2ocowdDmJYZ5UVsh1ZzJToiTrOpnBcbFiAwNCaBt0RTphpWRZDLRs9Y3+qAYJIUB+
        VkjYW5bpTa/jBtQ3l7CIOyRQ1Z2a2Oc=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-jM3ElrtwMkyh1AErvMJG3Q-1; Fri, 24 Mar 2023 05:31:00 -0400
X-MC-Unique: jM3ElrtwMkyh1AErvMJG3Q-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-541942bfdccso13105837b3.14
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679650260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJlH9otWhMZcJiElSwL7jmGaIVB1DaHJ04Oz3GP+kqo=;
        b=7ZbNDD7vyRgUQ2TaxJUiQQy27UT2N5A3LDNELcNb6h3vuwqZ0PG4fi5JV4icUvnGxa
         UBZp3jlzXUiFL9Uy2mB0klIjOgHhR25kWu3urx01Ble+L1SuR+NljIoE0pBqxV/AQ+Av
         pX6yqbEm7MMmLDJIzVUFdsw82/DnhCzQmz8v9vf1/v3Lby1uqQivoNXnejK/z9QPVuXJ
         JdgG2B3olEGwV1T3toJWRk7YvGPHgSmSQQugUrQbn7idagwCltelCvrmXDXQ7iUnSx5Q
         /7+V6altIYT26mkxZ1/FJXn01meafqC7jQ3rNvMBOtamID2Q84q7eT4elCqFeP34FI9S
         rpJw==
X-Gm-Message-State: AAQBX9dJtKnL3G8VUJKScX/NG3O/rH7tIQOOTPCTVp/3bV8/7lVNVcGt
        mibgy7VbgNpFp1MYGR1RK50k7WNxApb1ceGAEfvnbAh9uiL4sYpjKvDeP1H/XiqkSy0RV/tyj2n
        h6iN8ImQalzIKJdPqG19kj6ICwxyn8H1u
X-Received: by 2002:a81:c444:0:b0:544:a67b:8be0 with SMTP id s4-20020a81c444000000b00544a67b8be0mr724229ywj.3.1679650260056;
        Fri, 24 Mar 2023 02:31:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350YVXApSr3DKRq01E/v59zifPTYg5WRHMqtsDqWatxGa/N8zzftHhpu9f8TwhoduQDEp4ASSab/oYJN7kHsE3ZU=
X-Received: by 2002:a81:c444:0:b0:544:a67b:8be0 with SMTP id
 s4-20020a81c444000000b00544a67b8be0mr724222ywj.3.1679650259851; Fri, 24 Mar
 2023 02:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000708b1005f79acf5c@google.com> <CAGxU2F4ZiNEyrZzEJnYjYDz6CxniPGNW7AwyMLPLTxA2UbBWhA@mail.gmail.com>
 <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
 <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com> <46ba9b55-c6ff-925c-d51a-8da9d1abd2f2@sberdevices.ru>
In-Reply-To: <46ba9b55-c6ff-925c-d51a-8da9d1abd2f2@sberdevices.ru>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Fri, 24 Mar 2023 10:30:48 +0100
Message-ID: <CAGxU2F4KF=YGQkGJygurNyK=KU-pxPomAbr_v3eNvgMmwKQxmQ@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in virtio_transport_purge_skbs
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 10:10=E2=80=AFAM Arseniy Krasnov
<avkrasnov@sberdevices.ru> wrote:
> On 24.03.2023 12:06, Stefano Garzarella wrote:
> > On Fri, Mar 24, 2023 at 9:55=E2=80=AFAM Stefano Garzarella <sgarzare@re=
dhat.com> wrote:
> >>
> >> On Fri, Mar 24, 2023 at 9:31=E2=80=AFAM Stefano Garzarella <sgarzare@r=
edhat.com> wrote:
> >>>
> >>> Hi Bobby,
> >>> can you take a look at this report?
> >>>
> >>> It seems related to the changes we made to support skbuff.
> >>
> >> Could it be a problem of concurrent access to pkt_queue ?
> >>
> >> IIUC we should hold pkt_queue.lock when we call skb_queue_splice_init(=
)
> >> and remove pkt_list_lock. (or hold pkt_list_lock when calling
> >> virtio_transport_purge_skbs, but pkt_list_lock seems useless now that
> >> we use skbuff)
> >>
> >
> > In the previous patch was missing a hunk, new one attached:
> >
> > #syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linu=
x.git fff5a5e7f528
> >
> > --- a/net/vmw_vsock/vsock_loopback.c
> > +++ b/net/vmw_vsock/vsock_loopback.c
> > @@ -15,7 +15,6 @@
> >  struct vsock_loopback {
> >         struct workqueue_struct *workqueue;
> >
> > -       spinlock_t pkt_list_lock; /* protects pkt_list */
> >         struct sk_buff_head pkt_queue;
> >         struct work_struct pkt_work;
> >  };
> > @@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *sk=
b)
> >         struct vsock_loopback *vsock =3D &the_vsock_loopback;
> >         int len =3D skb->len;
> >
> > -       spin_lock_bh(&vsock->pkt_list_lock);
> >         skb_queue_tail(&vsock->pkt_queue, skb);
> Hello Stefano and Bobby,
>
> Small remark, may be here we can use virtio_vsock_skb_queue_tail() instea=
d of skb_queue_tail().
> skb_queue_tail() disables irqs during spinlock access, while  virtio_vsoc=
k_skb_queue_tail()
> uses spin_lock_bh(). vhost and virtio transports use virtio_vsock_skb_que=
ue_tail().
>

Yep, but this shouldn't be related.
I would make this change in a separate patch. ;-)

Thanks,
Stefano


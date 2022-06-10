Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8855546B2A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349930AbiFJQ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245441AbiFJQz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:55:59 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A372F660
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:55:58 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id x38so2124869ybd.9
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8MXmjtpRfIxwcwc7y+xo5axaJXjza99CVzvE1CrLJRI=;
        b=bgt7SVNh+TwNPxhgV3yb7XHMWJAo6MNucdlJ0caato+KCJi6CeiV2OVXzjQdYEeAVw
         +kqjmbExf7bhABraxQxguCsq9PY/7FdS/nippLpQas89j83fChYSA+Sv46EsnXBwiD57
         sDhmQekh8sk2rvwQbc5gnkaNYX65G47bJL5Xy5JG0KngsDnOn46cCgxpHC0Hjm5SHWYV
         CBGOQYx0ksSl8gyNGafOHbxJTRTQc+C8rFJ6O8Fge1/h/aKpUibtUXywfXrbjp37hsog
         16PrfqWPOOxzUdsgrbe6mjTcMFYwTLsICzTuYAKn2BVAE4bcRkun77+qB0Fj0Cs2IP1r
         IbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8MXmjtpRfIxwcwc7y+xo5axaJXjza99CVzvE1CrLJRI=;
        b=CTiyNOqJ3KIw9qKzh32R+Dazg8vcMqOF5Pcrkc9k6ZQjAG9FWgnyIYr+rR+uVAWPZE
         /2LrFvj/ugg7VTygEyx1u3tC45fZs/uXUF0NdNbO3SYupINAHyrpaylIhRSGOpzMTO5C
         mAkeBHaHfhHUw8NTZmG8BDIoWYOuVcM9kU7dvlbWoE+MSSROGVgC6LUx7mBI6hFDZPuw
         tzLh3CgDBKx6BD37D5nIOqlyGY3TarlzU9bV6L4cBWfgibHIIA0m8gdwu1YbOxP2NFzU
         3CiYUfJ1ssRuCbAXfiRqkvg8CdL6XAHF5SuV6XlHAvTsRTsTMGlNAFNLOVM9yZMjcXHg
         UPAA==
X-Gm-Message-State: AOAM533p8O5zx+w1e/I0NpVBT4RQV7dyKwsZ72WN8y1FW6xdqhGL3boV
        1jTyeP7qTsEA+Vc+D+cj7cdoRdqX0tbxMyOqNmWj4IiJhv0Olw==
X-Google-Smtp-Source: ABdhPJyS8+Va+4h1aZ/hweAj1xdgCMTPAx+JLHUda7xQdp6/8TdYxfAHT4fhn0Smewx+lCcAqaNuxuJNpeWtgTlbYfk=
X-Received: by 2002:a25:aa32:0:b0:65c:af6a:3502 with SMTP id
 s47-20020a25aa32000000b0065caf6a3502mr46009854ybi.598.1654880157232; Fri, 10
 Jun 2022 09:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220610110749.110881-1-soenke.huster@eknoes.de>
 <CANn89i+YHqMddY68Qk1rZexqhYYX9gah-==WGttFbp4urLS7Qg@mail.gmail.com> <9f214837-dc68-ef1a-0199-27d6af582115@eknoes.de>
In-Reply-To: <9f214837-dc68-ef1a-0199-27d6af582115@eknoes.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jun 2022 09:55:45 -0700
Message-ID: <CANn89iKS7npfHvBJNP2PBtR9RAQGsVdykELX8mK8DQbFbLeybA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: RFCOMM: Use skb_trim to trim checksum
To:     =?UTF-8?Q?S=C3=B6nke_Huster?= <soenke.huster@eknoes.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 8:35 AM S=C3=B6nke Huster <soenke.huster@eknoes.de>=
 wrote:
>
> Hi Eric,
>
> On 10.06.22 15:59, Eric Dumazet wrote:
> > On Fri, Jun 10, 2022 at 4:08 AM Soenke Huster <soenke.huster@eknoes.de>=
 wrote:
> >>
> >> As skb->tail might be zero, it can underflow. This leads to a page
> >> fault: skb_tail_pointer simply adds skb->tail (which is now MAX_UINT)
> >> to skb->head.
> >>
> >>     BUG: unable to handle page fault for address: ffffed1021de29ff
> >>     #PF: supervisor read access in kernel mode
> >>     #PF: error_code(0x0000) - not-present page
> >>     RIP: 0010:rfcomm_run+0x831/0x4040 (net/bluetooth/rfcomm/core.c:175=
1)
> >>
> >> By using skb_trim instead of the direct manipulation, skb->tail
> >> is reset. Thus, the correct pointer to the checksum is used.
> >>
> >> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> >> ---
> >> v2: Clarified how the bug triggers, minimize code change
> >>
> >>  net/bluetooth/rfcomm/core.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> >> index 7324764384b6..443b55edb3ab 100644
> >> --- a/net/bluetooth/rfcomm/core.c
> >> +++ b/net/bluetooth/rfcomm/core.c
> >> @@ -1747,7 +1747,7 @@ static struct rfcomm_session *rfcomm_recv_frame(=
struct rfcomm_session *s,
> >>         type =3D __get_type(hdr->ctrl);
> >>
> >>         /* Trim FCS */
> >> -       skb->len--; skb->tail--;
> >> +       skb_trim(skb, skb->len - 1);
> >>         fcs =3D *(u8 *)skb_tail_pointer(skb);
> >>
> >>         if (__check_fcs(skb->data, type, fcs)) {
> >> --
> >> 2.36.1
> >>
> >
> > Again, I do not see how skb->tail could possibly zero at this point.
> >
> > If it was, skb with illegal layout has been queued in the first place,
> > we need to fix the producer, not the consumer.
> >
>
> Sorry, I thought that might be a right place as there is not much code in=
 the kernel
> that manipulates ->tail directly.
>
> > A driver missed an skb_put() perhaps.
> >
>
> I am using the (I guess quite unused) virtio_bt driver, and figured out t=
hat the following
> fixes the bug:
>
> --- a/drivers/bluetooth/virtio_bt.c
> +++ b/drivers/bluetooth/virtio_bt.c
> @@ -219,7 +219,7 @@ static void virtbt_rx_work(struct work_struct *work)
>         if (!skb)
>                 return;
>
> -       skb->len =3D len;
> +       skb_put(skb, len);

Removing skb->len=3Dlen seems about right.
But skb_put() should be done earlier.

We are approaching the skb producer :)

Now you have to find/check who added this illegal skb in the virt queue.

Maybe virtbt_add_inbuf() ?

Also there is kernel info leak I think.

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index 67c21263f9e0f250f0719b8e7f1fe15b0eba5ee0..c9b832c447ee451f027430b284d=
7bb246f6ecb24
100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -37,6 +37,9 @@ static int virtbt_add_inbuf(struct virtio_bluetooth *vbt)
        if (!skb)
                return -ENOMEM;

+       skb_put(skb, 1000);
+       memset(skb->data, 0, 1000);
+
        sg_init_one(sg, skb->data, 1000);

        err =3D virtqueue_add_inbuf(vq, sg, 1, skb, GFP_KERNEL);


>         virtbt_rx_handle(vbt, skb);
>
>         if (virtbt_add_inbuf(vbt) < 0)
>
> I guess this is the root cause? I just used Bluetooth for a while in the =
VM
> and no error occurred, everything worked fine.
>
> > Can you please dump the skb here  ?
> >
> > diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> > index 7324764384b6773074032ad671777bf86bd3360e..358ccb4fe7214aea0bb4084=
188c7658316fe0ff7
> > 100644
> > --- a/net/bluetooth/rfcomm/core.c
> > +++ b/net/bluetooth/rfcomm/core.c
> > @@ -1746,6 +1746,11 @@ static struct rfcomm_session
> > *rfcomm_recv_frame(struct rfcomm_session *s,
> >         dlci =3D __get_dlci(hdr->addr);
> >         type =3D __get_type(hdr->ctrl);
> >
> > +       if (!skb->tail) {
> > +               DO_ONCE_LITE(skb_dump(KERN_ERR, skb, false));
> > +               kfree_skb(skb);
> > +               return s;
> > +       }
> >         /* Trim FCS */
> >         skb->len--; skb->tail--;
> >         fcs =3D *(u8 *)skb_tail_pointer(skb);
>
> If it might still help:
>
> skb len=3D4 headroom=3D9 headlen=3D4 tailroom=3D1728
> mac=3D(-1,-1) net=3D(0,-1) trans=3D-1
> shinfo(txflags=3D0 nr_frags=3D0 gso(size=3D0 type=3D0 segs=3D0))
> csum(0x0 ip_summed=3D0 complete_sw=3D0 valid=3D0 level=3D0)
> hash(0x0 sw=3D0 l4=3D0) proto=3D0x0000 pkttype=3D0 iif=3D0
> skb linear:   00000000: 03 3f 01 1c
>

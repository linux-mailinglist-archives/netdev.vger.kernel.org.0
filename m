Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D9A428500
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhJKCHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233549AbhJKCHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633917909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dt3W97nn3nLieRHcwrHXkZHoe+y8SxklSbymQfso1QE=;
        b=De8W9ydjpOM6FchOpHJRXT+DP043yoGNWdJiCoRRfjW2znQU7SQs2R3CzUYBuNZWvhbcRQ
        XppcF2+Z+UwII6zWo0k6x8A+dKunhWDEO3gcg6vBn99iIVAQs3dBLNAf7wiOrSyY4Owd1t
        L6xTJIm0yF9q1Qq7MsuLrZgVxUMzfII=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-2dGlr2IdOvGZR9mTK9I1aA-1; Sun, 10 Oct 2021 22:05:08 -0400
X-MC-Unique: 2dGlr2IdOvGZR9mTK9I1aA-1
Received: by mail-lf1-f70.google.com with SMTP id s8-20020ac25c48000000b003faf62e104eso11396540lfp.22
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 19:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dt3W97nn3nLieRHcwrHXkZHoe+y8SxklSbymQfso1QE=;
        b=bvAR7G9XTxL8TQY0/AqdcoJXxdRcsDsFc4B13YdOFY5PiTC58PX6cWhBUlZjQxqh+B
         m1hnGJKCBKPdz9Ve/o52INGTNoABbcNEwwbJXMfOmOQx9R8h3rsDddzxUYGed+cFKWwe
         jXEgvTA90n+tOoe6AMw0UEYiFH9lk5QcQ1vopr4BxhbkRctMTjmhvGwY16MVDsrip+3P
         LY1V9/RFzmnx/2vOcfoqxGdJXP6FnEIHjsBys/idUJAG41025wGDAbY/hmYaZl/GtEQY
         58MvGONjVfSn/Z1INVxI0FhTZiXFWGke0mxf9/aMJLuX/Bwdci8em+lv0Ox/NPyEjnuB
         ky+A==
X-Gm-Message-State: AOAM532YFyEFNKBr99cu2vCQyR5kSg9vVc2ZQEhY/i8i1s9wmq6dF3X+
        UZ8LH9e71cEchpDz6nE2iRqDpWrsJaCcCx2GarO7b4KH7A8iVzlcB5SosEHdLTIKHSELU9Brm0T
        V6akvi0saREF2elyOdKC67LIkSqmt77wu
X-Received: by 2002:a2e:8099:: with SMTP id i25mr8180065ljg.277.1633917906331;
        Sun, 10 Oct 2021 19:05:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkDiR/BGptgc+pbWgE/RLAuwXL6JyrQ0fkP5KqdZaKCoCdI7ytGhHRzptoWN+ks5B3l30AvuWSt/eeqfwAjQw=
X-Received: by 2002:a2e:8099:: with SMTP id i25mr8180041ljg.277.1633917906102;
 Sun, 10 Oct 2021 19:05:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211009091604.84141-1-mst@redhat.com>
In-Reply-To: <20211009091604.84141-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 11 Oct 2021 10:04:55 +0800
Message-ID: <CACGkMEsjxm9u8QvQ9c9f34v1WWhGkbwPE-2BgAkRjd+zB6V-AQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Corentin_No=C3=ABl?= <corentin.noel@collabora.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 5:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> commit 126285651b7f ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netde=
v/net")
> accidentally reverted the effect of
> commit 1a8024239da ("virtio-net: fix for skb_over_panic inside big mode")
> on drivers/net/virtio_net.c
>
> As a result, users of crosvm (which is using large packet mode)
> are experiencing crashes with 5.14-rc1 and above that do not
> occur with 5.13.
>
> Crash trace:
>
> [   61.346677] skbuff: skb_over_panic: text:ffffffff881ae2c7 len:3762 put=
:3762 head:ffff8a5ec8c22000 data:ffff8a5ec8c22010 tail:0xec2 end:0xec0 dev:=
<NULL>
> [   61.369192] kernel BUG at net/core/skbuff.c:111!
> [   61.372840] invalid opcode: 0000 [#1] SMP PTI
> [   61.374892] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.14.0-rc1 linux=
-v5.14-rc1-for-mesa-ci.tar.bz2 #1
> [   61.376450] Hardware name: ChromiumOS crosvm, BIOS 0
>
> ..
>
> [   61.393635] Call Trace:
> [   61.394127]  <IRQ>
> [   61.394488]  skb_put.cold+0x10/0x10
> [   61.395095]  page_to_skb+0xf7/0x410
> [   61.395689]  receive_buf+0x81/0x1660
> [   61.396228]  ? netif_receive_skb_list_internal+0x1ad/0x2b0
> [   61.397180]  ? napi_gro_flush+0x97/0xe0
> [   61.397896]  ? detach_buf_split+0x67/0x120
> [   61.398573]  virtnet_poll+0x2cf/0x420
> [   61.399197]  __napi_poll+0x25/0x150
> [   61.399764]  net_rx_action+0x22f/0x280
> [   61.400394]  __do_softirq+0xba/0x257
> [   61.401012]  irq_exit_rcu+0x8e/0xb0
> [   61.401618]  common_interrupt+0x7b/0xa0
> [   61.402270]  </IRQ>
>
> See
> https://lore.kernel.org/r/5edaa2b7c2fe4abd0347b8454b2ac032b6694e2c.camel%=
40collabora.com
> for the report.
>
> Apply the original 1a8024239da ("virtio-net: fix for skb_over_panic insid=
e big mode")
> again, the original logic still holds:
>
> In virtio-net's large packet mode, there is a hole in the space behind
> buf.
>
>     hdr_padded_len - hdr_len
>
> We must take this into account when calculating tailroom.
>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there'=
s sufficient tailroom")
> Fixes: 126285651b7f ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netde=
v/net")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reported-by: Corentin No=C3=ABl <corentin.noel@collabora.com>
> Tested-by: Corentin No=C3=ABl <corentin.noel@collabora.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

>
> David, I think we need this in stable, too.
>
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 096c2ac6b7a6..6b0812f44bbf 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct virtnet_inf=
o *vi,
>          * add_recvbuf_mergeable() + get_mergeable_buf_len()
>          */
>         truesize =3D headroom ? PAGE_SIZE : truesize;
> -       tailroom =3D truesize - len - headroom;
> +       tailroom =3D truesize - len - headroom - (hdr_padded_len - hdr_le=
n);
>         buf =3D p - headroom;
>
>         len -=3D hdr_len;
> --
> MST
>


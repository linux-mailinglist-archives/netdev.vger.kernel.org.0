Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F373F5539B6
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 20:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiFUStu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 14:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiFUStt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 14:49:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FA913CD1;
        Tue, 21 Jun 2022 11:49:48 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id c2so23927019lfk.0;
        Tue, 21 Jun 2022 11:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aEnsPeErZcC5jVv5Awt5r/RpqBvV6Kpv5CxzsPjVvW8=;
        b=Q5A4+TLhxLzF1NBCX35KxXuQRmqMEDUNnrzAb/6kfQdp3pNjSWYhRBuKMBErf3tgLz
         G0Y+PXk89wr/236vsFxEhNKH2pwM/nrlltJLB/607vbcnv/DtqXDHn8TL6SHUrcNUbw+
         NH8jONuO19kTJZC7t4/mjPBMoyF/NhKUWNfDlQVCDgocb9sYw+WuBClDaj2zW7PNh7N4
         85xbNAhRbs/dw2e8VrhapevdR+FeCUNaoGTs2dhdMQYzs/Zp7XoW3Lrlqr+ed+zVtsiU
         udQ4iOcJVOQYti2QqWSAddmHyfETbn0eu7OoDxI2WzxjKnYGJmT1SFMsCXg7lVqrE5X3
         jwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aEnsPeErZcC5jVv5Awt5r/RpqBvV6Kpv5CxzsPjVvW8=;
        b=jALZ2KlaIJaLiAeORvKcOBMXTw5c3Gb5q06AviMGeNF2jbyBDPTsD3kBxi+MP9Lypn
         ngvlAsxie1U6s5Ec1uKoZLEtFee0aOlPBCpzjx4AxzOjWIs7OxVwVq/nFwJjmHRrzr8h
         +yxp9h5Z4fcKam/G0qcnsg2TJQHtNzGck7cVq5Ab+Aw8UxNwyZAFMoD7GjgSymbQMmqh
         Dxe/FbGOBW/P3nmqU6q+fpoqD3XEOlqo+AXFiR3XC5tm/+DQuDT+es+NhtqapTD4rrIa
         qpy438zKHkx4f9FyKjuG23yRoQxX06vV7ik3/DKzrd9oanjrW9AflYHO7TaA1gdatHsR
         3CNw==
X-Gm-Message-State: AJIora+Vg4iN7vmIYg25/Eqhsf2X2rKJkytPTGy3mFWCghBxFPoFygN3
        u5Ei0Pbc33Zp7HeVwVFMQAzSUeTUznqCKT3nDNI=
X-Google-Smtp-Source: AGRyM1up9WArEZ+K1i2P8+mDJg7jSKMOv6F/P5BN96Q59RrLzvARhQ5s8mONP9IXw0k0so/DG/nyYQAN11b0Cizl9FY=
X-Received: by 2002:a05:6512:1307:b0:47f:67ab:4064 with SMTP id
 x7-20020a056512130700b0047f67ab4064mr8775354lfu.106.1655837386687; Tue, 21
 Jun 2022 11:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220607134709.373344-1-lee.jones@linaro.org> <YrHX9pj/f0tkqJis@google.com>
 <CABBYNZKniL5Y8r0ztFC0s2PEx3GA5YtKeG7of_vMRvqArjeMpw@mail.gmail.com>
In-Reply-To: <CABBYNZKniL5Y8r0ztFC0s2PEx3GA5YtKeG7of_vMRvqArjeMpw@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Jun 2022 11:49:35 -0700
Message-ID: <CABBYNZKBUUSTrTc3gp8muSUO1SwQVpZ=kwLk0=W_nzeHJgDU=g@mail.gmail.com>
Subject: Re: [PATCH 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

On Tue, Jun 21, 2022 at 11:35 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Lee,
>
> On Tue, Jun 21, 2022 at 7:38 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Tue, 07 Jun 2022, Lee Jones wrote:
> >
> > > This change prevents a use-after-free caused by one of the worker
> > > threads starting up (see below) *after* the final channel reference
> > > has been put() during sock_close() but *before* the references to the
> > > channel have been destroyed.
> > >
> > >   refcount_t: increment on 0; use-after-free.
> > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> > >
> > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14=
.234-00003-g1fb6d0bd49a4-dirty #28
> > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google =
Inc. MSM sm8150 Flame DVT (DT)
> > >   Workqueue: hci0 hci_rx_work
> > >   Call trace:
> > >    dump_backtrace+0x0/0x378
> > >    show_stack+0x20/0x2c
> > >    dump_stack+0x124/0x148
> > >    print_address_description+0x80/0x2e8
> > >    __kasan_report+0x168/0x188
> > >    kasan_report+0x10/0x18
> > >    __asan_load4+0x84/0x8c
> > >    refcount_dec_and_test+0x20/0xd0
> > >    l2cap_chan_put+0x48/0x12c
> > >    l2cap_recv_frame+0x4770/0x6550
> > >    l2cap_recv_acldata+0x44c/0x7a4
> > >    hci_acldata_packet+0x100/0x188
> > >    hci_rx_work+0x178/0x23c
> > >    process_one_work+0x35c/0x95c
> > >    worker_thread+0x4cc/0x960
> > >    kthread+0x1a8/0x1c4
> > >    ret_from_fork+0x10/0x18
> > >
> > > Cc: stable@kernel.org
> > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: linux-bluetooth@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  net/bluetooth/l2cap_core.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > No reply for 2 weeks.
> >
> > Is this patch being considered at all?
> >
> > Can I help in any way?
>
> Could you please resend to trigger CI, looks like CI missed this one
> for some reason.

Btw, it would be great to have a test for this sort of fix so CI
reproduce and thus we avoid reintroducing it:

https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/tools/l2cap-tester.=
c

>
> >
> > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > index ae78490ecd3d4..82279c5919fd8 100644
> > > --- a/net/bluetooth/l2cap_core.c
> > > +++ b/net/bluetooth/l2cap_core.c
> > > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> > >
> > >       BT_DBG("chan %p", chan);
> > >
> > > -     write_lock(&chan_list_lock);
> > >       list_del(&chan->global_l);
> > > -     write_unlock(&chan_list_lock);
> > >
> > >       kfree(chan);
> > >  }
> > > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> > >  {
> > >       BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> > >
> > > +     write_lock(&chan_list_lock);
> > >       kref_put(&c->kref, l2cap_chan_destroy);
> > > +     write_unlock(&chan_list_lock);
> > >  }
> > >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> > >
> >
> > --
> > Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> > Principal Technical Lead - Developer Services
> > Linaro.org =E2=94=82 Open source software for Arm SoCs
> > Follow Linaro: Facebook | Twitter | Blog
>
>
>
> --
> Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz

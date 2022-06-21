Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68622553993
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 20:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiFUSgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 14:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiFUSgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 14:36:05 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07787255B5;
        Tue, 21 Jun 2022 11:36:04 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id i18so10187732lfu.8;
        Tue, 21 Jun 2022 11:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PS4K/kn6NjTOzcvIzP8OtIS0qJRtLD3yztBTOV02sn0=;
        b=Nq5uuomhRWpTGO5FdD6ZpSa4orNR0MwFc72q0jeWthe6EygDTAoquDA7zuLlBZGodf
         IUpoAwirz8aJze/1c24QdNHFglnC/sjYb8zNoktRXoRPf9O6Ez5LlAzte3UqM0zKN+VD
         YzKuVqeofQ0K7md8ZX4biOGanq1y8kUTBfIbjFbok4QSQ4ow6lFx0zk0o12LBwwopiTE
         SGJx9APggg3RXKy6mQjlgZvAUaF/GYXCikTZdE3KWfF5vV1qoWgzHSAU6v1kmuV0vQht
         zllSuQu5xi8vc8l7enQJSjQqAie22nuFJNAdLLvRVtcUqFr3xKNXtx5zGN5HjXZC2cfV
         sVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PS4K/kn6NjTOzcvIzP8OtIS0qJRtLD3yztBTOV02sn0=;
        b=l+zJaGJSHx3nFVOouOEq2suM6n3/4Ni/OS4w0nMTqKPivKEZ61kZ/FdD0b27qFg5/i
         jswEK3E5tiSgVXlfAtCxewtE+zf+vxemdrO2XleBXeHbRa08rC3RNMYzTPZx18sDcjXJ
         7H3GQZMbcgMxrZ62D3Jho6HYbAi0TVhilVaqkDnlQoyGQmFvcYE8/7tk/Mqj3yZJxOmD
         PrSyak0x+qqgOqbuc0OQsEn2hpUx7/0+jgC3WpHrpwM2oKATvW6l5tG4ZXX61qrC8vHS
         jvlSRQteVN55PrF99H8zifai++2ZOzQCDjIR0zgeUZYCMaWxzEu7N2erF6L8f170a99U
         NqYw==
X-Gm-Message-State: AJIora+NGSdFteohKAcfndqTD91QEN5cg9kXLRsDEQxrbtQ4HSAPXOxb
        skg8+wFK6Zqvj7ym/Sl67L/48d2L+9EeJbTsiCk=
X-Google-Smtp-Source: AGRyM1saO3ekyPYvPVEk/8JJxJyEo1kLCKqH6Kzv9ytrVjroEiwKVpa9pdmKB2tTW5G77v/3hY33HkdbULtR+DuvCAw=
X-Received: by 2002:a05:6512:31d4:b0:479:78d:9c96 with SMTP id
 j20-20020a05651231d400b00479078d9c96mr17716632lfe.121.1655836562193; Tue, 21
 Jun 2022 11:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220607134709.373344-1-lee.jones@linaro.org> <YrHX9pj/f0tkqJis@google.com>
In-Reply-To: <YrHX9pj/f0tkqJis@google.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Jun 2022 11:35:50 -0700
Message-ID: <CABBYNZKniL5Y8r0ztFC0s2PEx3GA5YtKeG7of_vMRvqArjeMpw@mail.gmail.com>
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

On Tue, Jun 21, 2022 at 7:38 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Tue, 07 Jun 2022, Lee Jones wrote:
>
> > This change prevents a use-after-free caused by one of the worker
> > threads starting up (see below) *after* the final channel reference
> > has been put() during sock_close() but *before* the references to the
> > channel have been destroyed.
> >
> >   refcount_t: increment on 0; use-after-free.
> >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> >
> >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.2=
34-00003-g1fb6d0bd49a4-dirty #28
> >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google In=
c. MSM sm8150 Flame DVT (DT)
> >   Workqueue: hci0 hci_rx_work
> >   Call trace:
> >    dump_backtrace+0x0/0x378
> >    show_stack+0x20/0x2c
> >    dump_stack+0x124/0x148
> >    print_address_description+0x80/0x2e8
> >    __kasan_report+0x168/0x188
> >    kasan_report+0x10/0x18
> >    __asan_load4+0x84/0x8c
> >    refcount_dec_and_test+0x20/0xd0
> >    l2cap_chan_put+0x48/0x12c
> >    l2cap_recv_frame+0x4770/0x6550
> >    l2cap_recv_acldata+0x44c/0x7a4
> >    hci_acldata_packet+0x100/0x188
> >    hci_rx_work+0x178/0x23c
> >    process_one_work+0x35c/0x95c
> >    worker_thread+0x4cc/0x960
> >    kthread+0x1a8/0x1c4
> >    ret_from_fork+0x10/0x18
> >
> > Cc: stable@kernel.org
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: linux-bluetooth@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  net/bluetooth/l2cap_core.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> No reply for 2 weeks.
>
> Is this patch being considered at all?
>
> Can I help in any way?

Could you please resend to trigger CI, looks like CI missed this one
for some reason.

>
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index ae78490ecd3d4..82279c5919fd8 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> >
> >       BT_DBG("chan %p", chan);
> >
> > -     write_lock(&chan_list_lock);
> >       list_del(&chan->global_l);
> > -     write_unlock(&chan_list_lock);
> >
> >       kfree(chan);
> >  }
> > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> >  {
> >       BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> >
> > +     write_lock(&chan_list_lock);
> >       kref_put(&c->kref, l2cap_chan_destroy);
> > +     write_unlock(&chan_list_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> >
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Principal Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog



--=20
Luiz Augusto von Dentz

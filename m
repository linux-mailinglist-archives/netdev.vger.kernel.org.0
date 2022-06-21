Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B22553A77
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353536AbiFUTYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353471AbiFUTYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:24:31 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CACFD79;
        Tue, 21 Jun 2022 12:24:30 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id e4so16648731ljl.1;
        Tue, 21 Jun 2022 12:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SzbRZclLn5zcgAoX4UVrNKMYPPeiHD1b5mDc+zmUFrg=;
        b=jmp0t22R7oy9n0kQjharDPOYcL1+ZH6N7LnNmGSddftvd00ZYPw5xzFnbiyGUErE59
         jUA6Ndc8h9W+9SeXan2MlMkxGkmo+KW4PP3Z9sayzuphzVtPK1BeQ2Kb2lupDx26BWwG
         1WegMzR5UmrSSMq9tpRRjn4AjaS+mQimUVAKrjd8bdDW9zLgPt8BkOfLw2whaJh/lF1Z
         QARaRuGT9v9FrW21bgRTHpU9/enkyWDTpWTW9TGK6ImWTM+2gaRqt/psDnWmaoHqZtKg
         mQW9VQckhYWVdDwyvMrPbOH2kJU7NXAb9kXm9jTzBlXJILGrT+YHQ97HuRrS1FIBi0PW
         O/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SzbRZclLn5zcgAoX4UVrNKMYPPeiHD1b5mDc+zmUFrg=;
        b=XLfPWjNjDZiTbHZXhQG1xevdGj+4O3q581yAZWzAZNOJHmF2DtQlT7M3WyplCa22fs
         yd4jrNBmIjibCgu68mfQ0FmmlItZlVGDPzQeUq5X4LAICowsxzCMOZbs9sjyoIPuAS7i
         PkDxC5fu1DdCarPaiQ0zu+Kp3ZFUN4bB6H3tK5+oI31owJdzhtgCYG5LSnaa2Aug53Vs
         IPi9JVzeExb0ilZWmlbC0TnCW21OVrTm4u6hKAUdQLNaw6M7ypgeS70n7B3RoDfECdaC
         gyQiUOypTR+3UglGZcOQz+A30+3/JHG56MZmdn2X5UkFnzgeGFpxj3gNNewGNmt35IEj
         9vBQ==
X-Gm-Message-State: AJIora/UptjnyxRfRZJJLQS9qy46r2mqJEx2UTdFvs594XuaqFaSC8uo
        T0H7jQnrIYhzwacXSVjMngEHNeeJ3bv/6Mt65KE=
X-Google-Smtp-Source: AGRyM1sKovitpta7JlY4sFe+lZK/Zt32MdiRLGKZIF1thKCVLoldV7rl9LxIqt6gDu4iva+HzCyFUp3o2Wr/3wNCYaw=
X-Received: by 2002:a2e:a783:0:b0:255:9c38:c79 with SMTP id
 c3-20020a2ea783000000b002559c380c79mr14569060ljf.432.1655839468614; Tue, 21
 Jun 2022 12:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220607134709.373344-1-lee.jones@linaro.org> <YrHX9pj/f0tkqJis@google.com>
 <CABBYNZKniL5Y8r0ztFC0s2PEx3GA5YtKeG7of_vMRvqArjeMpw@mail.gmail.com> <YrIaNPfHozsAplR+@google.com>
In-Reply-To: <YrIaNPfHozsAplR+@google.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Jun 2022 12:24:17 -0700
Message-ID: <CABBYNZKMufvomzGJWGrNOS=sBnyjsU-wa5DxtxbvXzsW0TndBw@mail.gmail.com>
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

On Tue, Jun 21, 2022 at 12:21 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Tue, 21 Jun 2022, Luiz Augusto von Dentz wrote:
>
> > Hi Lee,
> >
> > On Tue, Jun 21, 2022 at 7:38 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Tue, 07 Jun 2022, Lee Jones wrote:
> > >
> > > > This change prevents a use-after-free caused by one of the worker
> > > > threads starting up (see below) *after* the final channel reference
> > > > has been put() during sock_close() but *before* the references to t=
he
> > > > channel have been destroyed.
> > > >
> > > >   refcount_t: increment on 0; use-after-free.
> > > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/70=
5
> > > >
> > > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.=
14.234-00003-g1fb6d0bd49a4-dirty #28
> > > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Googl=
e Inc. MSM sm8150 Flame DVT (DT)
> > > >   Workqueue: hci0 hci_rx_work
> > > >   Call trace:
> > > >    dump_backtrace+0x0/0x378
> > > >    show_stack+0x20/0x2c
> > > >    dump_stack+0x124/0x148
> > > >    print_address_description+0x80/0x2e8
> > > >    __kasan_report+0x168/0x188
> > > >    kasan_report+0x10/0x18
> > > >    __asan_load4+0x84/0x8c
> > > >    refcount_dec_and_test+0x20/0xd0
> > > >    l2cap_chan_put+0x48/0x12c
> > > >    l2cap_recv_frame+0x4770/0x6550
> > > >    l2cap_recv_acldata+0x44c/0x7a4
> > > >    hci_acldata_packet+0x100/0x188
> > > >    hci_rx_work+0x178/0x23c
> > > >    process_one_work+0x35c/0x95c
> > > >    worker_thread+0x4cc/0x960
> > > >    kthread+0x1a8/0x1c4
> > > >    ret_from_fork+0x10/0x18
> > > >
> > > > Cc: stable@kernel.org
> > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > Cc: linux-bluetooth@vger.kernel.org
> > > > Cc: netdev@vger.kernel.org
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  net/bluetooth/l2cap_core.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > No reply for 2 weeks.
> > >
> > > Is this patch being considered at all?
> > >
> > > Can I help in any way?
> >
> > Could you please resend to trigger CI, looks like CI missed this one
> > for some reason.
>
> Should I submit it as I did before?  Or did I miss a mailing address?

Just resend, you can tag with RESEND, looks like the original one got
stuck in CI since only 1 test was run:

https://patchwork.kernel.org/project/bluetooth/patch/20220607134709.373344-=
1-lee.jones@linaro.org/

> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Principal Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog



--=20
Luiz Augusto von Dentz

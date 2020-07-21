Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE816227754
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 06:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgGUEPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 00:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUEPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 00:15:39 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A05C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 21:15:38 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x9so22538735ljc.5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 21:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2XZxj+k5M3SbwJWgs6F3dfK3dlt5a5giFtyy/ppMg2E=;
        b=GByAOPs6PhYmc0hbwRBjhHOjCOCDAwMfUIdW+NCevFJiT+CUQz1BeixmMdv60HERgr
         F2XvFxhpSwB/NUl07mOudVFBUQEz6hYQ8OJUXmWroiNwEWZXv95m+2imCdBZc5lurY5j
         XM8BuAculLrZx9BA9JrHAJ7q3fYYOtrTXyUCzvXvFt1izV/7QgPsDb/C2Qi6htTFvOzB
         neuOihLp/2GIDXwb8wSkVKhBFWMtf9G09fbW/FH5BdQr1k5tTSB4PCL8oU/rw2DJNVju
         FMe4YkyLT9tENaH1fe4C6SIs33+/lJNxm7+RG/0DZDhmuwUQS0y/BSvMD6H4MrJA3tl0
         zvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2XZxj+k5M3SbwJWgs6F3dfK3dlt5a5giFtyy/ppMg2E=;
        b=REiKCBWdZxknIEjFCAgzLMYNPoUTLJckp8kDB0JujXF/sjEkKm1MpvHkqGHS0ydS82
         siQZnM8tBdA5WsX8cep0qpN05bsnR71XcLx+rVGWXie8PbbCalqucLXngmMvrz9EvYzs
         ClHEpjjxtync1PVrJkRhgl5HHGaerfuzbq63dcw4TJZHGOcUdvCkJgS5JwuTzztFM0iP
         yyvIeXyrdJXW2pG6HcMfYdKJbc2DiDcBpPOCTkukd4+zCGEbzCoCMXWEwJv//f8ZHGUe
         Cc46zzD7ccGqY0XSEyQSYRBIJ4EcBGTtrK3GuFZXljEQSewYyuMISHGfxIh0aH9Z5GRQ
         U0PA==
X-Gm-Message-State: AOAM531gegcDQFNf6R7zhsaaNVNuL/QvfZCMBNaWbT7AGCdUdsFl+3fA
        DWicidXI3LdADDg5+RLn4wWLRF9lLEoCP0R1VV8=
X-Google-Smtp-Source: ABdhPJx1INt3GCmRFWKjzKbK4oF8xpiMnoA9SmcQqziGRRWIjtcOJ5dLY+Dsi4prfkZP82eHne8dogRt6yipuNiT4qg=
X-Received: by 2002:a2e:9943:: with SMTP id r3mr10777412ljj.280.1595304937290;
 Mon, 20 Jul 2020 21:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200718064921.9280-1-ap420073@gmail.com> <20200720105721.4e034f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200720105721.4e034f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 21 Jul 2020 13:15:26 +0900
Message-ID: <CAMArcTUmb8biZUDxf_7BpYKVW-MyQuZK4mk0D0fBhFp_E143Xg@mail.gmail.com>
Subject: Re: [PATCH net] netdevsim: fix unbalaced locking in nsim_create()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, jiri@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 at 02:57, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,
Thank you for your review!

> On Sat, 18 Jul 2020 06:49:21 +0000 Taehee Yoo wrote:
> > In the nsim_create(), rtnl_lock() is called before nsim_bpf_init().
> > If nsim_bpf_init() is failed, rtnl_unlock() should be called,
> > but it isn't called.
> > So, unbalanced locking would occur.
> >
> > Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  drivers/net/netdevsim/netdev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> > index 2908e0a0d6e1..b2a67a88b6ee 100644
> > --- a/drivers/net/netdevsim/netdev.c
> > +++ b/drivers/net/netdevsim/netdev.c
> > @@ -316,8 +316,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
> >  err_ipsec_teardown:
> >       nsim_ipsec_teardown(ns);
> >       nsim_bpf_uninit(ns);
> > -     rtnl_unlock();
> >  err_free_netdev:
>
> Could you rename this label err_unlock, since it's not pointing to
> free_netdev any more?
>

I will send a v2 patch to change the label name.

Thanks a lot!
Taehee Yoo

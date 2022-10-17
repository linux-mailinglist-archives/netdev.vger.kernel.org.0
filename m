Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4409F6012F2
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJQPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJQPtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:49:16 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B765F659CF;
        Mon, 17 Oct 2022 08:49:15 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id o22so6866306qkl.8;
        Mon, 17 Oct 2022 08:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c1hr660YTne5HWG47TPibAhxpQ0b+WJkg6fuMvgqI+4=;
        b=zdUsJqHJJcoFQvqffAq4sBuoSw/VJr03atjS33OHW2fSPB0F/iyZtm7RtxJA8SKPMX
         tgIHX5miRYKzYFOJ+LsXsTMZKZlGmv50mMAiPwQvdhm5G29NRijTrTeM5E4moBZKT0D5
         dH8f08NTQs6r9UM7v0k2S2yjxL6a+U1nQIT64jhLggvvVdoBZptY3pU2kuOWi1W2WxFS
         Fe7TuB5AeQYF31w8KTKRGKLenS9MwAFeD3jXoOMpJg+tRkUyiHfVwLFnQJAyTmeGDbhM
         FmsYko8AS+mCsjYQcsaI0RJLTi8Jx+7Bfd2ahSAnrPFwgm0ceBEtaWdwEic9V7+0uxq2
         UiXQ==
X-Gm-Message-State: ACrzQf0/C3QibntNtSr1fagqmhnh/vxD7c+rAyDEMt+gqssbNpFaQ99l
        kAmuWPSsOqeUcky5GholY3Y4nqKkyQqtAQ==
X-Google-Smtp-Source: AMsMyM44AuelNG1tg1KdSqSnF9F28nFZzaRzuNfze+Yx35BH5JoziwtFgDEXSzF5W+CCKSAG/yOqMg==
X-Received: by 2002:a05:620a:b05:b0:6ee:cb0e:3c94 with SMTP id t5-20020a05620a0b0500b006eecb0e3c94mr8002708qkg.379.1666021754734;
        Mon, 17 Oct 2022 08:49:14 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id m21-20020a05620a24d500b006bb82221013sm149076qkn.0.2022.10.17.08.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 08:49:13 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id 81so13762198ybf.7;
        Mon, 17 Oct 2022 08:49:13 -0700 (PDT)
X-Received: by 2002:a25:687:0:b0:6c2:2b0c:26e with SMTP id 129-20020a250687000000b006c22b0c026emr9748099ybg.202.1666021753122;
 Mon, 17 Oct 2022 08:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220902215737.981341-1-sean.anderson@seco.com>
 <20220902215737.981341-6-sean.anderson@seco.com> <CAMuHMdWqTtjuOvDo9qxgDVpm+RBGm7BEgpdqVRH1n_dLGoYLTA@mail.gmail.com>
 <086a6f02-4495-510e-9fc5-64f95e7d55f6@seco.com>
In-Reply-To: <086a6f02-4495-510e-9fc5-64f95e7d55f6@seco.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 17 Oct 2022 17:49:01 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW-E4ykVdCugCyJt7_uKZZHyc=jStiL7DOiq2RZr6GTvQ@mail.gmail.com>
Message-ID: <CAMuHMdW-E4ykVdCugCyJt7_uKZZHyc=jStiL7DOiq2RZr6GTvQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 05/14] net: fman: Map the base address once
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Mon, Oct 17, 2022 at 5:34 PM Sean Anderson <sean.anderson@seco.com> wrote:
> On 10/17/22 11:15 AM, Geert Uytterhoeven wrote:
> > On Sat, Sep 3, 2022 at 12:00 AM Sean Anderson <sean.anderson@seco.com> wrote:
> >> We don't need to remap the base address from the resource twice (once in
> >> mac_probe() and again in set_fman_mac_params()). We still need the
> >> resource to get the end address, but we can use a single function call
> >> to get both at once.
> >>
> >> While we're at it, use platform_get_mem_or_io and devm_request_resource
> >> to map the resource. I think this is the more "correct" way to do things
> >> here, since we use the pdev resource, instead of creating a new one.
> >> It's still a bit tricky, since we need to ensure that the resource is a
> >> child of the fman region when it gets requested.
> >>
> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> Acked-by: Camelia Groza <camelia.groza@nxp.com>
> >
> > Thanks for your patch, which is now commit 262f2b782e255b79
> > ("net: fman: Map the base address once") in v6.1-rc1.
> >
> >> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> >> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> >> @@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
> >>
> >>         if (mac_dev)
> >>                 return sprintf(buf, "%llx",
> >> -                               (unsigned long long)mac_dev->res->start);
> >> +                               (unsigned long long)mac_dev->vaddr);
> >
> > On 32-bit:
> >
> >     warning: cast from pointer to integer of different size
> > [-Wpointer-to-int-cast]
> >
> > Obviously you should cast to "uintptr_t" or "unsigned long" instead,
> > and change the "%llx" to "%p" or "%lx"...
>
> Isn't there a %px for this purpose?

Yes there is.  But if it makes sense to use that depends on the
still to be answered questions at the bottom...

> > However, taking a closer look:
> >   1. The old code exposed a physical address to user space, the new
> >      code exposes the mapped virtual address.
> >      Is that change intentional?
>
> No, this is not intentional. So to make this backwards-compatible, I
> suppose I need a virt_to_phys?

I think virt_to_phys() will work only on real memory, not on MMIO,
so you may need to reintroduce the resource again.

> >   2. Virtual addresses are useless in user space.
> >      Moreover, addresses printed by "%p" are obfuscated, as this is
> >      considered a security issue. Likewise for working around this by
> >      casting to an integer.
>
> Yes, you're right that this probably shouldn't be exposed to userspace.
>
> > What's the real purpose of dpaa_eth_show_addr()?
>
> I have no idea. This is a question for Madalin.
>
> > Perhaps it should be removed?
>
> That would be reasonable IMO.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

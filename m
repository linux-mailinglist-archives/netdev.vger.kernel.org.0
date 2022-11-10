Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E70623D8F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiKJIfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiKJIfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:35:08 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C900209A9
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:35:07 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id 4so939052pli.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WeH2eaOlpEA3LlrfxBH2typ2PZr7QTSJ4rpiCpv6i+s=;
        b=BfXldw6XUdE4ff6PWX1bmYergvMBL6c45K8ZYWDHZ6UMkXpQX6Duq6jw8fczKQmHBt
         cxGI1t14DtgKtREB2v54kkuct8SzaPg/8xVxojy+3jT0ojkK5GLRoRTfSAjs5ZWOns7j
         P6XEZmF5E/qmWUVSjt2WDFoEqg06ZwsIBVa+6XU4VFl5NARYwlxijeNIFoJ9gRQYERR3
         X57elZ5HsN/3aPIbVeUQEnhUeGiStoStv7euOPSzWdwrAI5PP+aeg7+aQvh8NxmsxFyt
         IsBqaEYbwiUTckNEE7QPC702Qy6l/oonVLMq8KADU3u/AiiJsrePtpfh6pg1fGynaoCs
         17UA==
X-Gm-Message-State: ACrzQf0Vg3C2NpS7YBq4ww3c0A/RIIg/1ZcFB4H270Nwd1mcqGD0fGcN
        LlnTd6WnIVGjZJ2GhxAW+SdtvfS9f+Ep3pllvT4=
X-Google-Smtp-Source: AMsMyM7XEYQIRiRHJiEuyue42MRyTdFpYspA7oYFU4PHEAroy48uNW2zx2Z6lgwJcAVwc+COVLp35yc9vfke5wT29pA=
X-Received: by 2002:a17:903:185:b0:187:2430:d39e with SMTP id
 z5-20020a170903018500b001872430d39emr54933039plg.65.1668069306664; Thu, 10
 Nov 2022 00:35:06 -0800 (PST)
MIME-Version: 1.0
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal> <20221109122641.781b30d9@kernel.org>
In-Reply-To: <20221109122641.781b30d9@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 10 Nov 2022 17:34:55 +0900
Message-ID: <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 10 nov. 2022 at 05:26, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 9 Nov 2022 19:52:13 +0200 Leon Romanovsky wrote:
> > On Tue, Nov 08, 2022 at 12:57:54PM +0900, Vincent Mailhol wrote:
> > > If ethtool_ops::get_drvinfo() callback isn't set,
> > > ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> > > ethtool_drvinfo::bus_info fields.
> > >
> > > However, if the driver provides the callback function, those two
> > > fields are not touched. This means that the driver has to fill these
> > > itself.
> >
> > Can you please point to such drivers?
>
> What you mean by "such drivers" is not clear from the quoted context,
> at least to me.

An example:
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/broadcom/bnx2.c#L7041

This driver wants to set fw_version but needs to also fill the driver
name and bus_info. My patch will enable *such drivers* to only fill
the fw_version and delegate the rest to the core.

> > One can argue that they don't need to touch these fields in a first
> > place and ethtool_drvinfo should always overwrite them.
>
> Quite likely most driver prints to .driver and .bus_info can be dropped
> with this patch in place. Then again, I'm suspecting it's a bit of a
> chicken and an egg problem with people adding new drivers not having
> an incentive to add the print in the core and people who want to add
> the print in the core not having any driver that would benefit.
> Therefore I'd lean towards accepting Vincent's patch as is even if
> the submission can likely be more thorough and strict.

If we can agree that no drivers should ever print .driver and
.bus_info, then I am fine to send a clean-up patch to remove all this
after this one gets accepted. However, I am not willing to invest time
for nothing. So would one of you be ready to sign-off such a  clean-up
patch?

> While I'm typing - I've used dev_driver_string() to get the driver
> name in the past. Perhaps something to consider?

I am not sure of that one. If dev->dev.parent->driver is not set, it
defaults to dev_bus_name() which is .bus_info, isn't it?
https://elixir.bootlin.com/linux/latest/source/drivers/base/core.c#L2181

 For the end user, it might be better to display an empty driver name
in 'ethtool -i' rather than reporting the bus_info twice?

I mean, if you ask me for my opinion, then my answer is "I am not
sure". If you have confidence that dev_driver_string() is better, then
I will send a v2 right away.


Yours sincerely,
Vincent Mailhol

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01E6241AE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKJLnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKJLnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:43:39 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F0514D14
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:43:37 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id b11so1351935pjp.2
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YaRoGvSI78lF49S/1KoEdFdL3Cf7IOUEqDLgBtlB3JY=;
        b=vdOvuU1fvyrO7Js/DuQMBKrc4av1FsoIrx2w8zEXFH9pNhGi/e6+1LJKKbRLIrYRk3
         kVSqLOmOXYeFq/ppatqSYkMk9ML6ukHKzrinntseun2Irkit+HMp5Yn6wuLBkts7dcl6
         A08kxaXlhuQjDDrWRFXp9QpVCsAEwnxPc6jhB1adx49cawK/HeroO8JR0XgBkuEPaT4Z
         uTDqkRyDgRe66fcDVO1bcgXiA7htbz+6ZMudMSSIs0RchYuQTfyCuzuo4JY+G2ZksfI5
         9YmNoVjKHTlV1weNu+OuWlEBBwrFchFHO6b4mHknZc/mU2SKWZQyOPBjexX4mlIJe7eO
         kCLw==
X-Gm-Message-State: ACrzQf24Fx1m3tvpyh3Iewr7o9a2VYg05Bt7+QoCBErFB68ESBLtncga
        CWyl6BYC5eLlK84NwY858uDaGz58hTfDZMNsXBo=
X-Google-Smtp-Source: AMsMyM6tUA63LDYbHrhg597LSas1mAxFNlKtX+jARXTGonuiQkdZ7xLZr+fgf0URkWUawzinA/9bTuUt+RWx1hyQnV8=
X-Received: by 2002:a17:903:185:b0:187:2430:d39e with SMTP id
 z5-20020a170903018500b001872430d39emr55377424plg.65.1668080616595; Thu, 10
 Nov 2022 03:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal> <20221109122641.781b30d9@kernel.org>
 <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com> <Y2zASloeKjMMCgyw@unreal>
In-Reply-To: <Y2zASloeKjMMCgyw@unreal>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 10 Nov 2022 20:43:25 +0900
Message-ID: <CAMZ6RqJ8P=WUCQQSZ=A_g0brdwDazqCDMUhU+_NN5NWajLFZng@mail.gmail.com>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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

On Thu. 10 Nov. 2022 at 18:11, Leon Romanovsky <leon@kernel.org> wrote:
> On Thu, Nov 10, 2022 at 05:34:55PM +0900, Vincent MAILHOL wrote:
> > On Thu. 10 nov. 2022 at 05:26, Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 9 Nov 2022 19:52:13 +0200 Leon Romanovsky wrote:
> > > > On Tue, Nov 08, 2022 at 12:57:54PM +0900, Vincent Mailhol wrote:
> > > > > If ethtool_ops::get_drvinfo() callback isn't set,
> > > > > ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> > > > > ethtool_drvinfo::bus_info fields.
> > > > >
> > > > > However, if the driver provides the callback function, those two
> > > > > fields are not touched. This means that the driver has to fill these
> > > > > itself.
> > > >
> > > > Can you please point to such drivers?
> > >
> > > What you mean by "such drivers" is not clear from the quoted context,
> > > at least to me.
> >
> > An example:
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/broadcom/bnx2.c#L7041
> >
> > This driver wants to set fw_version but needs to also fill the driver
> > name and bus_info. My patch will enable *such drivers* to only fill
> > the fw_version and delegate the rest to the core.
>
> Sorry for being misleading, It looks like I typed only part of the sentence
> which I had in my mind. I wanted to see if any driver exists which prints
> drv_name and bus_info different from default.
>
> >
> > > > One can argue that they don't need to touch these fields in a first
> > > > place and ethtool_drvinfo should always overwrite them.
> > >
> > > Quite likely most driver prints to .driver and .bus_info can be dropped
> > > with this patch in place. Then again, I'm suspecting it's a bit of a
> > > chicken and an egg problem with people adding new drivers not having
> > > an incentive to add the print in the core and people who want to add
> > > the print in the core not having any driver that would benefit.
> > > Therefore I'd lean towards accepting Vincent's patch as is even if
> > > the submission can likely be more thorough and strict.
> >
> > If we can agree that no drivers should ever print .driver and
> > .bus_info, then I am fine to send a clean-up patch to remove all this
> > after this one gets accepted. However, I am not willing to invest time
> > for nothing. So would one of you be ready to sign-off such a  clean-up
> > patch?
>
> I will be happy to see such patch and will review it, but can't add sign-off
> as I'm not netdev maintainer.

Well, if you want to review, just have a look at:
  $ git grep -W "get_drvinfo(struct"

Unless some driver names their callback function in some non standard
way, that should be pretty it. Regardless, this will give you a fair
representation of the current situation.

There are a few nuances. For example, some drivers use dev_name() for
the .bus_info, while some others use pci_name(). I am not sure if this
makes a difference... Also, there are many hardcoded names for .driver
and I do not have the courage to check all of them. I am OK to blindly
remove all that mess but no more.


Yours sincerely,
Vincent Mailhol

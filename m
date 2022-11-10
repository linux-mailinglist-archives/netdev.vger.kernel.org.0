Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F233624847
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiKJRW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiKJRWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:22:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E762C64EA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE5AB8226B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F30C433D6;
        Thu, 10 Nov 2022 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668100936;
        bh=NpZPiweEgymfb/t4JkZAY5MZBrj1M6SBK3/oCslSQTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aby4h6x2Mp/gKah0yHmgjHjOxkWwbe44Sn4UaAWEU3cHwBSI5A6u/kgBeOlKKnU61
         LZmeWtlr0t54Z4YGsN3BWS1dSITQMF+WHFQwa93nPhigLc2bCtfb/x2WI9ucdqLp1U
         B5i6PbVoN/4KRwGYSyqMRovfnfB1r51DtSGaQX3WlLTxl3WGaB7TRnjX7BV/mjNbW9
         yZfKDOjXT31WnKK+pClJ7EyZ5UQl3OLMT+zrjoP8ezH69gGKV6ZkQNVnxSMBkTib50
         yiqal+G+ZgRUMElxk7H4OIgiQRVhJ+3aM5xWMByWOxKHgfA7+ww8tCBmhjl7vnNLS3
         z0Cw3YTBsIRjA==
Date:   Thu, 10 Nov 2022 19:22:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
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
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
Message-ID: <Y20zQ2XQL6QJfAke@unreal>
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal>
 <20221109122641.781b30d9@kernel.org>
 <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
 <Y2zASloeKjMMCgyw@unreal>
 <CAMZ6RqJ8P=WUCQQSZ=A_g0brdwDazqCDMUhU+_NN5NWajLFZng@mail.gmail.com>
 <Y2zn0YVlMaHNEOLR@unreal>
 <CAMZ6RqKq_azrLSwXWgnjgKg_z9aczt-p1wuL5c2LD324FRNC2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKq_azrLSwXWgnjgKg_z9aczt-p1wuL5c2LD324FRNC2A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 12:53:16AM +0900, Vincent MAILHOL wrote:
> On Thu. 10 Nov. 2022 at 21:00, Leon Romanovsky <leon@kernel.org> wrote:
> > On Thu, Nov 10, 2022 at 08:43:25PM +0900, Vincent MAILHOL wrote:
> > > On Thu. 10 Nov. 2022 at 18:11, Leon Romanovsky <leon@kernel.org> wrote:
> > > > On Thu, Nov 10, 2022 at 05:34:55PM +0900, Vincent MAILHOL wrote:
> > > > > On Thu. 10 nov. 2022 at 05:26, Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > > On Wed, 9 Nov 2022 19:52:13 +0200 Leon Romanovsky wrote:
> > > > > > > On Tue, Nov 08, 2022 at 12:57:54PM +0900, Vincent Mailhol wrote:
> > > > > > > > If ethtool_ops::get_drvinfo() callback isn't set,
> > > > > > > > ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> > > > > > > > ethtool_drvinfo::bus_info fields.
> > > > > > > >
> > > > > > > > However, if the driver provides the callback function, those two
> > > > > > > > fields are not touched. This means that the driver has to fill these
> > > > > > > > itself.
> > > > > > >
> > > > > > > Can you please point to such drivers?
> > > > > >
> > > > > > What you mean by "such drivers" is not clear from the quoted context,
> > > > > > at least to me.
> > > > >
> > > > > An example:
> > > > > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/broadcom/bnx2.c#L7041
> > > > >
> > > > > This driver wants to set fw_version but needs to also fill the driver
> > > > > name and bus_info. My patch will enable *such drivers* to only fill
> > > > > the fw_version and delegate the rest to the core.
> > > >
> > > > Sorry for being misleading, It looks like I typed only part of the sentence
> > > > which I had in my mind. I wanted to see if any driver exists which prints
> > > > drv_name and bus_info different from default.
> > > >
> > > > >
> > > > > > > One can argue that they don't need to touch these fields in a first
> > > > > > > place and ethtool_drvinfo should always overwrite them.
> > > > > >
> > > > > > Quite likely most driver prints to .driver and .bus_info can be dropped
> > > > > > with this patch in place. Then again, I'm suspecting it's a bit of a
> > > > > > chicken and an egg problem with people adding new drivers not having
> > > > > > an incentive to add the print in the core and people who want to add
> > > > > > the print in the core not having any driver that would benefit.
> > > > > > Therefore I'd lean towards accepting Vincent's patch as is even if
> > > > > > the submission can likely be more thorough and strict.
> > > > >
> > > > > If we can agree that no drivers should ever print .driver and
> > > > > .bus_info, then I am fine to send a clean-up patch to remove all this
> > > > > after this one gets accepted. However, I am not willing to invest time
> > > > > for nothing. So would one of you be ready to sign-off such a  clean-up
> > > > > patch?
> > > >
> > > > I will be happy to see such patch and will review it, but can't add sign-off
> > > > as I'm not netdev maintainer.
> > >
> > > Well, if you want to review, just have a look at:
> > >   $ git grep -W "get_drvinfo(struct"
> >
> > BTW, in some of the callbacks, if driver doesn't exists, they print "N/A",
> > while in your patch it will be empty string.
> 
> Indeed and this is inconsistent. For example, no one sets
> .erom_version to "N/A". So you will have some of the fields set to
> "N/A" and some others set to an empty string. The "N/A" thing was a
> mistake to begin with. I will not change my patch.

I don't see anyone asking you to change your patch drastically. This
discussion is more about next steps.

Thanks

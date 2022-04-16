Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C175034B2
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 09:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiDPHpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 03:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiDPHpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 03:45:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CA5F94E1
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 00:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 099A4B80B71
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 07:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FD7C385A3;
        Sat, 16 Apr 2022 07:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650094976;
        bh=6kmUbohDIeWp8rDGPS/PeHwqWt84oYbaM7zkQoJ8xgA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SNQI9Z0iEUoevRFsqGJi11KVwhuYBdsys9hOU8Qa7veQFywEybTXJ8oYVvMD9K/VU
         N3ssUUH5P8F33R+iNZ4wcnYfhqoDeBXVmgwKkpMf61zGTMU4/cG0NVgxwyUwOgg6rg
         GYBjPK/ZRTeLamMQu9wtwMo00ILsNeLDYEPXEDJISF23g995N/Lx+OUEa7BLcwAgpP
         xRSRo7lE0Y5OdNqjiItMC+O5RkHRpFreeWdryYKl+ugUGTDgdN2UDtDZvV0FgUxua3
         RPKkJ+ISXnkwZAD+yOw9PBqFYczvSzJ3TL+qpt7ScTuOlGt+/aYxlo4kBTH3cSgRLS
         grqC0kHgwzdnA==
Date:   Sat, 16 Apr 2022 09:42:46 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
Subject: Re: [RFCv5 PATCH net-next 02/20] net: introduce operation helpers
 for netdev features
Message-ID: <20220416094246.43b34dd6@kernel.org>
In-Reply-To: <752c07fc-2417-1685-5950-8d8770b9f048@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-3-shenjian15@huawei.com>
        <20220324180931.7e6e5188@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <752c07fc-2417-1685-5950-8d8770b9f048@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Apr 2022 11:33:58 +0800 shenjian (K) wrote:
> =E5=9C=A8 2022/3/25 9:09, Jakub Kicinski =E5=86=99=E9=81=93:
> > On Thu, 24 Mar 2022 23:49:14 +0800 Jian Shen wrote: =20
> >> Introduce a set of bitmap operation helpers for netdev features,
> >> then we can use them to replace the logical operation with them.
> >> As the nic driversare not supposed to modify netdev_features
> >> directly, it also introduces wrappers helpers to this.
> >>
> >> The implementation of these helpers are based on the old prototype
> >> of netdev_features_t is still u64. I will rewrite them on the last
> >> patch, when the prototype changes.
> >>
> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> ---
> >>   include/linux/netdevice.h | 597 ++++++++++++++++++++++++++++++++++++=
++ =20
> > Please move these helpers to a new header file which won't be included
> > by netdevice.h and include it at users appropriately. =20
> I introduced a new header file "netdev_features_helper",=C2=A0 and moved=
=20
> thses helpers
> to it.=C2=A0 Some helpers need to include struct=C2=A0 net_device which d=
efined in=20
> netdevice.h,
> but there are also some inline functions in netdevice.h need to use=20
> these netdev_features
> helpers. It's conflicted.
>=20
> So far I thought 3 ways to solved it, but all of them are not satisfactor=
y.
> 1) Split netdevice.h, move the definition of struct net_device and its=20
> relative definitions to
> a new header file A( haven't got a reasonable name).=C2=A0 Both the=20
> netdev_features_helper.h
> and the netdevice include A.
>=20
> 2) Split netdevice.h, move the inline functions to a new header file B.=20
> The netdev_features_helper.h
> inlucde netdevice.h=EF=BC=8C and B include netdev_features_helper.h and=20
> netdevice.h. All the source files
> which using these ininline functions should include B.
>=20
> 3) Split netdevice.h, move the inline functions to to=20
> netdev_featurer_helper.h. The netdev_features_helper.h
> inlucde netdevice.h, All the source files which using these ininline=20
> functions should include netde_features_helper.h.
>=20
> I'd like to get more advice to this.

Larger surgery is probably too much. What does netdevice.h need? Looks
like it mostly needs the type and the helper for testing if feature is
set. So maybe we can put those in netdevice.h and the rest in a new
header?
More advanced helpers like netdev_get_wanted_features() can move to the
new header as well.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238EC6B3675
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 07:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjCJGQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 01:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCJGQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 01:16:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02E17F033;
        Thu,  9 Mar 2023 22:16:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93A3060CBB;
        Fri, 10 Mar 2023 06:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DD6C433EF;
        Fri, 10 Mar 2023 06:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678429008;
        bh=Yj5n5rY4adpCj1Us38HcVXl5bM17zDSDEQBK1+i7K1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T9wfVqFJMY6lJnnkUajTHrfj+kPZxCy8vScVwpzzZH36aBjD/RxGBclcB6dSq6w7q
         rMpobfDn58blN5qcJK7GvkOBeYZtJiqMi1GzRggWCxHpPAGT4+b+kIqrM14HlDqYkj
         SmuKXxTRFK2lG/spfc+lp9T5I/tMmp3s8+FLjueMD6hSPipTGQVAkGdRkuRyuvRP7P
         aW28uiZWycijvLev1MNGvH0ZybSZFXgutv33Tw3jqFsPjOOvnWtF3Jl4xcc7pULoYZ
         jOSLYpi9S1sIYvdQEo5hSqF6ZjqsNMtC29lZeHp816hQ6ZNE0lt8kVVzAtdzXBBFG1
         l4+9oN81mf0Pw==
Date:   Thu, 9 Mar 2023 22:16:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 net 2/2] net: asix: init mdiobus from one function
Message-ID: <20230309221646.75f97f21@kernel.org>
In-Reply-To: <CANEJEGurX3Kr30Dv5_LzxN+shYuWXxxbEJG1MOgOOhpAq1WzLA@mail.gmail.com>
References: <20230308202159.2419227-1-grundler@chromium.org>
        <20230308202159.2419227-2-grundler@chromium.org>
        <ZAnBCQsv7tTBIUP1@nanopsycho>
        <CANEJEGuK-=tTBXG6FpC4aBb7KbsNZng2-Rmi0k6BJJ7An=Pyxw@mail.gmail.com>
        <07dd1c76-68a1-4c2f-98fe-7c25118eaff9@lunn.ch>
        <CANEJEGurX3Kr30Dv5_LzxN+shYuWXxxbEJG1MOgOOhpAq1WzLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 11:53:54 -0800 Grant Grundler wrote:
> On Thu, Mar 9, 2023 at 11:30=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrot=
e:
> > > I hope the maintainers can apply both to net-next and only apply the
> > > first to net branch. =20
> >
> > Hi Grant
> >
> > Please take a look at
> > https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> >
> > Please submit the first patch to net. Then wait a week for net to be
> > merged into net-next, and submit the second patch to net-next. =20
>=20
> Thanks Andrew!
> I read maintainer-netdev.html when Jakub pointed me at it a few days
> ago. He also instructed me to use "net" but didn't specify for the
> second patch - so I assumed both patches.

I did:

  Keep patch 2 locally for about a week (we merge fixes and cleanup
  branches once a week around Thu, and the two patches depend on each
  other).

https://lore.kernel.org/all/20230307164736.37ecb2f9@kernel.org/

But the process is a bit confusing. I'll take patch 1 in now, please
repost patch with net-next on/after Friday March 17th.

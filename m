Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24BC6DC359
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 07:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDJFqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 01:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDJFqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 01:46:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E703AA1;
        Sun,  9 Apr 2023 22:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED95161783;
        Mon, 10 Apr 2023 05:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849AEC433D2;
        Mon, 10 Apr 2023 05:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681105571;
        bh=I7ycCihJCH4JEfJlZ78JliEzlaBRQzptj+BNXcPlOP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dY0+HKiAo1T3X9jWM2850XOuuZuGX8kPGtDqsnrlb/Dx4Qs/YBeUJ3CEzFpDFNZoz
         Jf6YH+EnSt5iJ9u3LWA69QzEPwHwjQoRWS2JfG8crg5qHPTR1O2c4XtAPE7C8/EVWx
         8a4+tXhhRS7e0Cfs+EbQjX9/XrKVQQdWSowC5rg5MNCIszDd3fsX5upHA9haRrZZym
         Z4PU+kKfH1MW7ZiCdJSVqBX13NAMLc1x38RDL0EDJRCSULsbZ/CJ+qQTFMd90dd6e5
         Y1Q+QFgNSLoZa8GnZHfl0rMYNQYByOWzSWtcS3Wu3WjfsOKHkk3YSb8EtIuJLfd4F8
         7XN/6YMjxnRBg==
Date:   Mon, 10 Apr 2023 08:46:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230410054605.GL182481@unreal>
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130>
 <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
 <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 07:50:34PM -0400, Paul Moore wrote:
> On Sun, Apr 9, 2023 at 4:48 AM Linux regression tracking (Thorsten
> Leemhuis) <regressions@leemhuis.info> wrote:
> > On 30.03.23 03:27, Paul Moore wrote:
> > > On Wed, Mar 29, 2023 at 6:20 PM Saeed Mahameed <saeed@kernel.org> wrote:
> > >> On 28 Mar 19:08, Paul Moore wrote:
> > >>>
> > >>> Starting with the v6.3-rcX kernel releases I noticed that my
> > >>> InfiniBand devices were no longer present under /sys/class/infiniband,
> > >>> causing some of my automated testing to fail.  It took me a while to
> > >>> find the time to bisect the issue, but I eventually identified the
> > >>> problematic commit:
> > >>>
> > >>>  commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
> > >>>  Author: Shay Drory <shayd@nvidia.com>
> > >>>  Date:   Wed Jun 29 11:38:21 2022 +0300
> > >>>
> > >>>   net/mlx5: Enable management PF initialization
> > >>>
> > >>>   Enable initialization of DPU Management PF, which is a new loopback PF
> > >>>   designed for communication with BMC.
> > >>>   For now Management PF doesn't support nor require most upper layer
> > >>>   protocols so avoid them.
> > >>>
> > >>>   Signed-off-by: Shay Drory <shayd@nvidia.com>
> > >>>   Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
> > >>>   Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> > >>>   Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > >>>
> > >>> I'm not a mlx5 driver expert so I can't really offer much in the way
> > >>> of a fix, but as a quick test I did remove the
> > >>> 'mlx5_core_is_management_pf(...)' calls in mlx5/core/dev.c and
> > >>> everything seemed to work okay on my test system (or rather the tests
> > >>> ran without problem).
> > >>>
> > >>> If you need any additional information, or would like me to test a
> > >>> patch, please let me know.
> > >>
> > >> Our team is looking into this, the current theory is that you have an old
> > >> FW that doesn't have the correct capabilities set.
> > >
> > > That's very possible; I installed this card many years ago and haven't
> > > updated the FW once.
> > >
> > >  I'm happy to update the FW (do you have a
> > > pointer/how-to?), but it might be good to identify a fix first as I'm
> > > guessing there will be others like me ...
> >
> > Nothing happened here for about ten days afaics (or was there progress
> > and I just missed it?). That made me wonder: how sound is Paul's guess
> > that there will be others that might run into this? If that's likely it
> > afaics would be good to get this regression fixed before the release,
> > which is just two or three weeks away.
> >
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > --
> > Everything you wanna know about Linux kernel regression tracking:
> > https://linux-regtracking.leemhuis.info/about/#tldr
> > If I did something stupid, please tell me, as explained on that page.
> >
> > #regzbot poke
> 
> I haven't seen any updates from the mlx5 driver folks, although I may
> not have been CC'd?

We are extremely slow these days due to combination of holidays
(Easter, Passover, Ramadan, spring break e.t.c).

Thanks

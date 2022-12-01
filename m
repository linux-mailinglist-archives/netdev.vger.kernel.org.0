Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE2663E8E8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 05:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLAElQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 23:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLAElO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 23:41:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD96528A0;
        Wed, 30 Nov 2022 20:41:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6D6660F97;
        Thu,  1 Dec 2022 04:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CF8C433D6;
        Thu,  1 Dec 2022 04:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669869673;
        bh=e9HBJM9S7MI0S93i5urpVzAQ17BPPVCn42w9xMKJHbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gEI9ozPM4ONciFPi4+0sPhRKjsaHBbqZJNW+g42j34oVV3r9LSu5CSOi2Hv0Gn11P
         9HzN3A+3aF1ofTvrmmnAvwVQ8ZK4JLJ4HxHC2oHm3yooWWQOaBfTQtBSv1udDZT5hH
         6uerdF4xkHJ01HJkoeyJz04Q3NakSNgb94wytxt9GCcRjIvPDWhfcpmTVrJsu3ALcM
         fU1Vt4nYmXfajfpGPV1zyNPN1vovU9pigeEpAfx2utHusFjMUBwJXsxAZx/AT//9w1
         dwZw7QrOzpyxpJVru+J0Nfl9/ixZwU/MUJwsmlx0BWXJIqFrZc0iPNF9JM9bjvMiKi
         Gap238ofnvqwQ==
Date:   Wed, 30 Nov 2022 20:41:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arnd Bergmann" <arnd@arndb.de>
Cc:     "Richard Cochran" <richardcochran@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency
 for BCMGENET under ARCH_BCM2835
Message-ID: <20221130204111.2287b2c9@kernel.org>
In-Reply-To: <10c264a3-019e-4473-9c20-9bb0c9af97c3@app.fastmail.com>
References: <20221125115003.30308-1-yuehaibing@huawei.com>
        <20221128191828.169197be@kernel.org>
        <92671929-46fb-4ea8-9e98-1a01f8d6375e@app.fastmail.com>
        <10c264a3-019e-4473-9c20-9bb0c9af97c3@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 12:58:23 +0100 Arnd Bergmann wrote:
> > The original report was for a different bug that resulted in the
> > BROADCOM_PHY driver not being selectable at all.
> >
> > The remaining problem here is this configuration:
> >
> > CONFIG_ARM=y
> > CONFIG_BCM2835=y
> > CONFIG_BCMGENET=y
> > CONFIG_PTP_1588_CLOCK=m
> > CONFIG_PTP_1588_CLOCK_OPTIONAL=m
> > CONFIG_BROADCOM_PHY=m
> >
> > In this case, BCMGENET should 'select BROADCOM_PHY' to make the
> > driver work correctly, but fails to do this because of the
> > dependency. During early boot, this means it cannot access the
> > PHY because that is in a loadable module, despite commit
> > 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> > trying to ensure that it could.
> >
> > Note that many other ethernet drivers don't have this
> > particular 'select' statement and just rely on the .config
> > to contain a sensible set of drivers. In particular that
> > is true when running 64-bit kernels on the same chip,
> > which is now the normal configuration.
> >
> > The alternative to YueHaibing's fix would be to just revert
> > 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> > and instead change the defconfig file to include the phy driver,
> > as we do elsewhere.

Ah, got it now, I think. Alternatively we could flip the 'select' to 
'depends on' and make the user do the legwork? Enough brain cycles
spend on this simple fix tho, so applying, thanks! :)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5FB5F1CA2
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 16:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiJAOSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 10:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJAOSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 10:18:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270DD3D59B;
        Sat,  1 Oct 2022 07:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01402CE01D0;
        Sat,  1 Oct 2022 14:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940EFC433D6;
        Sat,  1 Oct 2022 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664633909;
        bh=CKkGHr+sdWpXHrqOxQ/cqxBF9+kksWpN2DsUF+exBS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gDiEogvtf5TTgvs8BmlxSclEAjVqM9fTiq+o5fcwKxVdeFAQ6Pfkui85Ed3eaqiQe
         RzMUCQ5iBSLhnk/g2ffGL/WO1kg4sLz0xBOmhAagicxCbn2dqjj1NHlkRyfPWPkvRi
         NsaR7jK6405n2TAWqYTy/isr6oyCzqdljbJTkR+DMO55hjncaznzXa7ryXaAoJKoN7
         0JJz5a2bB5ByK1YE/LAPq4i6LpVNhSq1VJrhsQcHioZ/GWeMgJd4DFLA+FQ668GuRM
         Ww+iyYMmfJpONDVLmFHkqj3Eyo5eWxl5GkzmNgFCmhwTdpkFe5OneWzYYQvEdMZg7G
         dzPcAgXkK14Ag==
Date:   Sat, 1 Oct 2022 07:18:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Gal Pressman <gal@nvidia.com>
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Message-ID: <20221001071827.202fe4c1@kernel.org>
In-Reply-To: <YzfUbKtWlxuq+FzI@nanopsycho>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
        <YzWESUXPwcCo67LP@nanopsycho>
        <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
        <Yzap9cfSXvSLA+5y@nanopsycho>
        <20220930073312.23685d5d@kernel.org>
        <YzfUbKtWlxuq+FzI@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Oct 2022 07:47:24 +0200 Jiri Pirko wrote:
> >> Sure, but more hw does not mean you can't use sysfs. Take netdev as an
> >> example. The sysfs exposed for it is implemented net/core/net-sysfs.c
> >> and is exposed for all netdev instances, no matter what the
> >> driver/hardware is.  
> >
> >Wait, *you* are suggesting someone uses sysfs instead of netlink?
> >
> >Could you say more because I feel like that's kicking the absolute.  
> 
> I don't understand why that would be a problem. 

Why did you do devlink over netlink then?
The bus device is already there in sysfs.

> What I'm trying to say
> is, perhaps sysfs is a better API for this purpose. The API looks very
> neat and there is no probabilito of huge grow.

"this API is nice and small" said everyone about every new API ever,
APIs grow.

> Also, with sysfs, you
> don't need userspace app to do basic work with the api. In this case, I
> don't see why the app is needed.

Yes, with the YAML specs you don't need a per-family APP.
A generic app can support any family, just JSON in JSON out.
DPLL-nl will come with a YAML spec.

> These are 2 biggest arguments for sysfs in this case as I see it.

2 biggest arguments? Is "this API is small" one of the _biggest_
arguments you see? I don't think it's an argument at all. The OCP PTP
driver started small and now its not small. And the files don't even
follow sysfs rules. Trust me, we have some experience here :/

As I said to you in private I feel like there may be some political
games being played here, so I'd like to urge you to focus on real
issues.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D3F645F87
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiLGRAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiLGQ74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 11:59:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05DB6931C;
        Wed,  7 Dec 2022 08:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A99D61ACE;
        Wed,  7 Dec 2022 16:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496CBC433C1;
        Wed,  7 Dec 2022 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670432382;
        bh=UOTMAATjpNxXnTsgAzUbM8B4waAQT2pl6BE2XR4t/K4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XhC0mmciJkcpwLG7sYOOaGKrWKwIVpdwqR/Dn9xSR635jBTpIfxxIFXzwfXPYVpEz
         vGBuzGWW7ET8W+aDFMjo/7nqquvc5C14fBzF2ICGG5AHL3B1tPic0PhuElEjw5MePz
         dSGQz57sc87bI7czj63nZHx4zLOn8UmGQMh3IEmE76m18pKx/b9m2mltqiwwyA8t38
         xX3r6WcL8IFg/Fft1OPCDBrsOr6TrDx7KzneN2T6feczbHYDqLBBpf/qgF4i0lOQLA
         sakSWPZtM/QutnbGlBUiCypq4x/a3Vcl3DdQl7k+tGNM2RgJ9kEkzJKqhnG29KJC6B
         RuZyGWjftleCw==
Date:   Wed, 7 Dec 2022 08:59:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <20221207085941.3b56bc8c@kernel.org>
In-Reply-To: <Y5CQ0qddxuUQg8R8@nanopsycho>
References: <Y4eGxb2i7uwdkh1T@nanopsycho>
        <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4nyBwNPjuJFB5Km@nanopsycho>
        <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4okm5TrBj+JAJrV@nanopsycho>
        <20221202212206.3619bd5f@kernel.org>
        <Y43IpIQ3C0vGzHQW@nanopsycho>
        <20221205161933.663ea611@kernel.org>
        <Y48CS98KYCMJS9uM@nanopsycho>
        <20221206092705.108ded86@kernel.org>
        <Y5CQ0qddxuUQg8R8@nanopsycho>
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

On Wed, 7 Dec 2022 14:10:42 +0100 Jiri Pirko wrote:
> >> Why do we need this association at all?  
> >
> >Someone someday may want netns delegation and if we don't have the
> >support from the start we may break backward compat introducing it.  
> 
> Hmm. Can you imagine a usecase?

Running DPLL control in a namespace / container.

I mean - I generally think netns is overused, but yes, it's what
containers use, so I think someone may want to develop their
timer controller SW in as a container?

> Link to devlink instance btw might be a problem. In case of mlx5, one
> dpll instance is going to be created for 2 (or more) PFs. 1 per ConnectX
> ASIC as there is only 1 clock there. And PF devlinks can come and go,
> does not make sense to link it to any of them.

If only we stuck to the "one devlink instance per ASIC", huh? :)

> Thinking about it a bit more, DPLL itself has no network notion. The
> special case is SyncE pin, which is linked to netdevice. Just a small
> part of dpll device. And the netdevice already has notion of netns.
> Isn't that enough?

So we can't use devlink or netdev. Hm. So what do we do?
Make DPLLs only visible in init_net? And require init_net admin?
And when someone comes asking we add an explicit "move to netns"
command to DPLL?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD89648672
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 17:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIQTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 11:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIQTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 11:19:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E108801F6;
        Fri,  9 Dec 2022 08:19:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A81860EB0;
        Fri,  9 Dec 2022 16:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B2CC433EF;
        Fri,  9 Dec 2022 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670602783;
        bh=VI1X+KqV+1YF/g9QdSwb46QdBvoGHfAFDaTzgHqOkEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FGPFRjDqWBd9QbGMjxlLRfV0Q8l8aOR1AQE0EJ4jc1wWQ7banrCk9+fMzcPjnhH6V
         0SmmbZt9y4Jpm9NoDFnqUNrWNHYR5p10xApoabNuBDhOUqUC1V+ZS0Q6w7jmpYLXtm
         rzOE8Ow/8qeYCgxX/jV5zgJanYWyBp1njWLBVbucQqXNichzpEkX8PlaGr6kdvGvjN
         SxxTeKMFsqy8xzQcM8k+Rquq0+U7+Kb/7EqpwUixUUpuPGnM9/hgudSH7EcI860cxh
         lDsvcYpsGokgVbyOjoa/7Gv9PPn7XSkMfx40CxIfIcZumF9i3Rm4ub2mDSfwMGaJDm
         GPhAyE77MzAXw==
Date:   Fri, 9 Dec 2022 08:19:42 -0800
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
Message-ID: <20221209081942.565bc422@kernel.org>
In-Reply-To: <Y5MAEQ74trsNFQQc@nanopsycho>
References: <Y43IpIQ3C0vGzHQW@nanopsycho>
        <20221205161933.663ea611@kernel.org>
        <Y48CS98KYCMJS9uM@nanopsycho>
        <20221206092705.108ded86@kernel.org>
        <Y5CQ0qddxuUQg8R8@nanopsycho>
        <20221207085941.3b56bc8c@kernel.org>
        <Y5Gc6E+mpWeVSBL7@nanopsycho>
        <20221208081955.335ca36c@kernel.org>
        <Y5IR2MzXfqgFXGHW@nanopsycho>
        <20221208090517.643277e8@kernel.org>
        <Y5MAEQ74trsNFQQc@nanopsycho>
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

On Fri, 9 Dec 2022 10:29:53 +0100 Jiri Pirko wrote:
> Thu, Dec 08, 2022 at 06:05:17PM CET, kuba@kernel.org wrote:
> >On Thu, 8 Dec 2022 17:33:28 +0100 Jiri Pirko wrote:  
> >> For any synce pin manipulation over dpll netlink, we can use the netns
> >> check of the linked netdev. This is the netns aware leg of the dpll,
> >> it should be checked for.  
> >
> >The OCP card is an atomic clock, it does not have any networking.  
> 
> Sure, so why it has to be netns aware if it has nothing to do with
> networking?

That's a larger question, IDK if broadening the scope of the discussion
will help us reach a conclusion. 

The patchset as is uses network namespaces for permissions:

+		.flags	= GENL_UNS_ADMIN_PERM,

so that's what I'm commenting on - aligning visibility of objects with
already used permissions.

> >> I can't imagine practically havind the whole dpll instance netns aware.
> >> Omitting the fact that it really has no meaning for non-synce pins, what
> >> would be the behaviour when for example pin 1 is in netns a, pin 2 in
> >> netns b and dpll itself in netns c?  
> >
> >To be clear I don't think it's a bad idea in general, I've done 
> >the same thing for my WIP PSP patches. But we already have one
> >device without netdevs, hence I thought maybe devlink. So maybe
> >we do the same thing with devlink? I mean - allow multiple devlink
> >instances to be linked and require caps on any of them?  
> 
> I read this 5 times, I'm lost, don't understand what you mean :/

Sorry I was replying to both paragraphs here, sorry.
What I thought you suggested is we scope the DPLL to whatever the
linked netdevs are scoped to? If netns has any of the netdevs attached
to the DPLL then it can see the DPLL and control it as well.

What I was saying is some DPLL have no netdevs. So we can do the same
thing with devlinks. Let the driver link the DPLL to one or more
devlink instances, and if any of the devlink instances is in current
netns then you can see the DPLL.

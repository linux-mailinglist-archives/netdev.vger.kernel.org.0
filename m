Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9BD645234
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLGCrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLGCrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C557643;
        Tue,  6 Dec 2022 18:47:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6E1615A4;
        Wed,  7 Dec 2022 02:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E494BC433D6;
        Wed,  7 Dec 2022 02:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670381261;
        bh=f6n0R/pD7YmCGlqVCvNqDTuIud85Veqm6XJERvXQ7/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sSxW8fTPyiIMOwMROs5Z+PxtQ57sRHq34ag7uyrnQIli4wfxqyVHyb3elghqqRaAb
         +XNwd1eTx2YiO1bR6KIwW+E8chZPxZYVvqZVLK2egErXJZ6Hdvcc4QcdLRnBIKdWEZ
         NQaspygRceSqYekDwyxWEqpOWpVeL9DBEPs9YoK/A1pCQBdDzegyApuXfAaKC+w63I
         BwOe74QavrmKRtSkc8A9oI7Oa8c0mAXMJMS9XsSP0HjduIhVIY5L5TwImGKtKieua3
         7GxYcbQdj3TiLfvf7d7OfRg4RC38RcY9Xm5zEFoL2ege1N13Xkh5YuSKfYIOQlZ4+F
         rcBhXvUqDp13Q==
Date:   Tue, 6 Dec 2022 18:47:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20221206184740.28cb7627@kernel.org>
In-Reply-To: <Y4oj1q3VtcQdzeb3@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
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

On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:
> >But this is only doable with assumption, that the board is internally capable
> >of such internal board level communication, which in case of separated
> >firmwares handling multiple dplls might not be the case, or it would require
> >to have some other sw component feel that gap.  
> 
> Yep, you have the knowledge of sharing inside the driver, so you should
> do it there. For multiple instances, use in-driver notifier for example.

No, complexity in the drivers is not a good idea. The core should cover
the complexity and let the drivers be simple.

> >For complex boards with multiple dplls/sync channels, multiple ports,
> >multiple firmware instances, it seems to be complicated to share a pin if
> >each driver would have own copy and should notify all the other about changes.
> >
> >To summarize, that is certainly true, shared pins idea complicates stuff
> >inside of dpll subsystem.
> >But at the same time it removes complexity from all the drivers which would use  
> 
> There are currently 3 drivers for dpll I know of. This in ptp_ocp and
> mlx5 there is no concept of sharing pins. You you are talking about a
> single driver.
> 
> What I'm trying to say is, looking at the code, the pin sharing,
> references and locking makes things uncomfortably complex. You are so
> far the only driver to need this, do it internally. If in the future
> other driver appears, this code would be eventually pushed into dpll
> core. No impact on UAPI from what I see. Please keep things as simple as
> possible.

But the pin is shared for one driver. Who cares if it's not shared in
another. The user space must be able to reason about the constraints.

You are suggesting drivers to magically flip state in core objects
because of some hidden dependencies?!

> >it and is easier for the userspace due to common identification of pins.  
> 
> By identification, you mean "description" right? I see no problem of 2
> instances have the same pin "description"/label.
>
> >This solution scales up without any additional complexity in the driver,
> >and without any need for internal per-board communication channels.
> >
> >Not sure if this is good or bad, but with current version, both approaches are
> >possible, so it pretty much depending on the driver to initialize dplls with
> >separated pin objects as you have suggested (and take its complexity into
> >driver) or just share them.
> >  
> >>
> >>3) I don't like the concept of muxed pins and hierarchies of pins. Why
> >>   does user care? If pin is muxed, the rest of the pins related to this
> >>   one should be in state disabled/disconnected. The user only cares
> >>   about to see which pins are related to each other. It can be easily
> >>   exposed by "muxid" like this:
> >>   pin 1
> >>   pin 2
> >>   pin 3 muxid 100
> >>   pin 4 muxid 100
> >>   pin 5 muxid 101
> >>   pin 6 muxid 101
> >>   In this example pins 3,4 and 5,6 are muxed, therefore the user knows
> >>   if he connects one, the other one gets disconnected (or will have to
> >>   disconnect the first one explicitly first).
> >
> >Currently DPLLA_PIN_PARENT_IDX is doing the same thing as you described, it
> >groups MUXed pins, the parent pin index here was most straightforward to me,  
> 
> There is a big difference if we model flat list of pins with a set of
> attributes for each, comparing to a tree of pins, some acting as leaf,
> node and root. Do we really need such complexicity? What value does it
> bring to the user to expose this?

The fact that you can't auto select from devices behind muxes.
The HW topology is of material importance to user space.
How many times does Arkadiusz have to explain this :|

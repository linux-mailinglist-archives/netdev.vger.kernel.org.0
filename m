Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68AE4FE4CD
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357043AbiDLPhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiDLPhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:37:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4176819C22
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C64616CA
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C726BC385A5;
        Tue, 12 Apr 2022 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649777696;
        bh=FOYyctYAyWDiBvkkqgua5DgB3lHS9Kd0XFWN1WsoFIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YeVK5Ik9Mzw177qhSIHAvjFVq8E+ikRtr/1AVzV5GorNop/lI/KlcJTlHe5trL3qC
         /G/4FBxn2S8ecdU7arFYduMtiSuQyovkZ2fKQZVCI5vM6iEvz9F1eIsFko3RPnFrA+
         hnugWiIYR8MZR8bjif0/5nKcf3gw01kqehD9qRlde5zMoeMU5kneZ3Wevb1XWB9mr2
         aoIdkHeDrdm1Al0HI6fyElQ99HQB9GNLTCWDPIPfzJjYFRpIMc+70vQelVIk4TXo8g
         Up8E3xsZ0vFNiFCMLzl8GqRT4qeufTY3U/h5wuZ8fyUIr7+xgkxH9ZbQPUupzB6n7D
         Te51qZfWwmkHw==
Date:   Tue, 12 Apr 2022 08:34:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
        jiri@nvidia.com, ariela@nvidia.com, maorg@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <20220412083454.7b2a545d@kernel.org>
In-Reply-To: <YlU1Wrn0zPbYN6pE@nanopsycho>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
        <20220407201638.46e109d1@kernel.org>
        <YlQDmWEzhOyfhWev@nanopsycho>
        <20220411110157.7fcecc4b@kernel.org>
        <YlU1Wrn0zPbYN6pE@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 10:16:26 +0200 Jiri Pirko wrote:
> Mon, Apr 11, 2022 at 08:01:57PM CEST, kuba@kernel.org wrote:
> >> Wait, does all stats have to be well-defined? I mean, look at the
> >> ethtool stats. They are free-form strings too. Do you mean that in
> >> devlink, we can only have well-defines enum-based stats?  
> >
> >That's my strong preference, yes.
> >
> >First, and obvious argument is that it make lazy coding less likely
> >(see devlink params).
> >
> >More importantly, tho, if your stats are not well defined - users don't
> >need to seem them. Really! If I can't draw a line between a statistic
> >and device behavior then keep that stat in the register dump, debugfs   
> 
> During the DaveM's-only era, there was quite strict policy against any
> debugfs usage. As far as I remember the claim was, find of define the
> proper api or do your debug things out-of-tree.
> 
> Does that changed? I just want to make sure that we are now free to use
> debugfs for exposuse of debugging info as "odd vendor stats".
> Personally, I think it is good idea. I think that the rest of the kernel
> actually uses debugfs like that.

I think the policy is "it's fine as long as it's read-only".
Which could be a problem if you want to parametrize the counters.
But then again based on this RFC IDK if you do.

> >or /dev/null.
> >
> >That's why it's important that we talk about _what_ you're trying to
> >expose.  
> 
> Basically a mixture of quite generic things and very obscure device
> specific items.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF7F4FC3C0
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbiDKSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 14:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343859AbiDKSEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 14:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823ABBF4B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5F1960FC4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF052C385A4;
        Mon, 11 Apr 2022 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649700119;
        bh=Bb5W0KFfwztlE33QFIRX6reTZEp0c0W9g4aZNAC7lzg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tESevgEklWxA9fA/2FVIeK4q9W2VmJ7J+9IhssT9cYYO8Y2YhZVEfXQ9CcTTdIHA4
         bUeNYForyRfWwjSkr/cqS6CM1jmfQO89d33LdULjIJgLBoVRm1OhHt7XFS2Q2DKahW
         Jch7JlLv4ZiyyL12toC9/9IFvAhFEpChGzu7UGzRHCswyiGQeY5P0uIdyKpZoSYhsT
         bslOmVXtUy1ythy6S14bvXyc2mTW1ILNzjJvBNcNcyeTcB57Wly7LoF3eCpAlpIBFn
         lBLLdjaFq68r87Omgrg92/AY9nOi5SRB++3N/2YU94I4lur6H9GG5z5MMhrqJuSy8g
         C7nzy9N45H/mQ==
Date:   Mon, 11 Apr 2022 11:01:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
        jiri@nvidia.com, ariela@nvidia.com, maorg@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <20220411110157.7fcecc4b@kernel.org>
In-Reply-To: <YlQDmWEzhOyfhWev@nanopsycho>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
        <20220407201638.46e109d1@kernel.org>
        <YlQDmWEzhOyfhWev@nanopsycho>
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

On Mon, 11 Apr 2022 12:31:53 +0200 Jiri Pirko wrote:
> Fri, Apr 08, 2022 at 05:16:38AM CEST, kuba@kernel.org wrote:
> >On Thu, 7 Apr 2022 11:40:48 +0300 Michael Guralnik wrote:  
> >> This patch set adds port statistics to the devlink port object.
> >> It allows device drivers to dynamically attach and detach counters from a
> >> devlink port object.  
> >
> >The challenge in defining APIs for stats is not in how to wrap a free
> >form string in a netlink message but how do define values that have
> >clear semantics and are of value to the user.  
> 
> Wait, does all stats have to be well-defined? I mean, look at the
> ethtool stats. They are free-form strings too. Do you mean that in
> devlink, we can only have well-defines enum-based stats?

That's my strong preference, yes.

First, and obvious argument is that it make lazy coding less likely
(see devlink params).

More importantly, tho, if your stats are not well defined - users don't
need to seem them. Really! If I can't draw a line between a statistic
and device behavior then keep that stat in the register dump, debugfs 
or /dev/null.

That's why it's important that we talk about _what_ you're trying to
expose.

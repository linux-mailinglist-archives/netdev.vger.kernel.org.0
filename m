Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254A94D7AE1
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 07:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiCNGkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 02:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiCNGkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 02:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E9F3CFFD;
        Sun, 13 Mar 2022 23:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE6261053;
        Mon, 14 Mar 2022 06:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5857CC340E9;
        Mon, 14 Mar 2022 06:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647239933;
        bh=TJyckrVdD9vt3Cl2Da1dKFQHLsxRPeDuQgCN8VeoLxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ORFnekYJeIX98ILOhTdLOHeV0m56Me2lvHtCbPyF4RIgcCA7GIST+1JQukh7VWv0
         oxUbOFT+jDj3oypjYN8Wk3f2pDmb0M2R23R1DwTxSHaQOlQkHNtKOkcmtvr8w2Ll6p
         oTV8tKaWrbtpyjHxB2GKCo34r31vgIBmCjcjB+Sc=
Date:   Mon, 14 Mar 2022 07:38:50 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Daniel Suchy <danny@danysek.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rafael.richter@gin.de" <rafael.richter@gin.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Message-ID: <Yi7i+pebGu0NoIsF@kroah.com>
References: <ccf51795-5821-203d-348e-295aabbdc735@danysek.cz>
 <20220313141030.ztwhuhfwxjfzi5nb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313141030.ztwhuhfwxjfzi5nb@skbuf>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 02:10:31PM +0000, Vladimir Oltean wrote:
> Hi Daniel,
> 
> On Sun, Mar 13, 2022 at 03:03:07PM +0100, Daniel Suchy wrote:
> > Hello,
> > 
> > I noticed boot problems on my Turris Omnia (with Marvell 88E6176 switch
> > chip) after "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
> > removing VLAN" commit https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=2566a89b9e163b2fcd104d6005e0149f197b8a48
> > 
> > Within logs I catched hung kernel tasks (see below), at least first is
> > related to DSA subsystem.
> > 
> > When I revert this patch, everything works as expected and without any
> > issues.
> > 
> > In my setup, I have few vlans on affected switch (i'm using ifupdown2 v3.0
> > with iproute2 5.16 for configuration).
> > 
> > It seems your this patch introduces some new problem (at least for 5.15
> > kernels). I suggest revert this patch.
> > 
> > - Daniel
> 
> Oh wow, I'm terribly sorry. Yes, this patch shouldn't have been
> backported to kernel 5.15 and below, but I guess I missed the
> backport notification email and forgot to tell Greg about this.
> Patch "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
> removing VLAN" needs to be immediately reverted from these trees.
> 
> Greg, to avoid this from happening in the future, would something like
> this work? Is this parsed in some way?
> 
> Depends-on: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work") # which first appeared in v5.16

The "Fixes:" tag will solve this, please just use that in the future.

I'll go revert this, thanks.

greg k-h

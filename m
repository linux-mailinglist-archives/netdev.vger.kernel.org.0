Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD596E17B1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDMWvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDMWvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156D510E5;
        Thu, 13 Apr 2023 15:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E536420C;
        Thu, 13 Apr 2023 22:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BADC4339B;
        Thu, 13 Apr 2023 22:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681426300;
        bh=jfw28FI7IIECARC7fKA24DkKOaJpQuN5hoQfgD0HMyE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DJiYUKg5EunHLmIBAOYacQOzAZXPBG+Lguj/AMdjIl+MxoZTAvboLkZDI8GeiNP6/
         GtWlyJGYzCXaibY44dcLvbzdN6X3kXV9AhL+vYKrM6yRsmddyQKYuOTBSJNMkRSIid
         CfFBoyOWNwzLxNTLkpgvZ1G9oomtRlO+lisLjxilATqUcLHnxV1la3XE60pasGd7vf
         hui2U8hXsH41fLw17m+lPRr0pZdX9lpnMclDpaiC/y9VhAypn0WK7qSiB9jM3yO7AW
         cc1VLQb6uvQm8mdStPglLMNP+JTM5JkaZSu6Z/mDSzfzx7igad16A+TZ7YM/J1p3NN
         ggs/5XxW3yXcg==
Date:   Thu, 13 Apr 2023 15:51:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230413155139.22d3b2f4@kernel.org>
In-Reply-To: <ZDiDbQL5ksMwaMeB@x130>
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
        <ZCS5oxM/m9LuidL/@x130>
        <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
        <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
        <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
        <20230410054605.GL182481@unreal>
        <20230413075421.044d7046@kernel.org>
        <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
        <ZDhwUYpMFvCRf1EC@x130>
        <20230413152150.4b54d6f4@kernel.org>
        <ZDiDbQL5ksMwaMeB@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 15:34:21 -0700 Saeed Mahameed wrote:
> >On a closer read I don't like what this patch is doing at all.
> >I'm not sure we have precedent for "management connection" functions.
> >This requires a larger discussion. And after looking up the patch set  
> 
> But this management connection function has the same architecture as other
> "Normal" mlx5 functions, from the driver pov. The same way mlx5 
> doesn't care if the underlaying function is CX4/5/6 we don't care if it was
> a "management function".

Yes, and that's why every single IPU implementation thinks that it's 
a great idea. Because it's easy to implement. But what is it for
architecturally? Running what is effectively FW commands over TCP?

> We are currently working on enabling a subset of netdev functionality using
> the same mlx5 constructs and current mlx5e code to load up a mlx5e netdev
> on it.. 
> 
> >it went in, it seems to have been one of the hastily merged ones.
> >I'm sending a revert.  
> 
> But let's discuss what's wrong with it, and what are your thoughts ? 
> the fact that it breaks a 6 years OLD FW, doesn't make it so horrible.

Right, the breakage is a separate topic.

You say 6 years old but the part is EOL, right? The part is old and
stable, AFAIU the breakage stems from development work for parts which
are 3 or so generations newer.

The question is who's supposed to be paying the price of mlx5 being
used for old and new parts? What is fair to expect from the user
when the FW Paul has presumably works just fine for him?

> The patchset is a bug fix where previous mlx5 load on such function failed 
> with some nasty kernel log messages, so the patchset only provides a fix to
> make mlx5 load on such function go smooth and avoid loading any interface
> on that function until we provide the patches for that which is a WIP right
> now.

Ah, that's probably why I wasn't screaming at it when it was
posted. I must have understood it then. The commit title is quite
confusing by iteself - "_Enable_ management PF initialization". 

Why is it hard to exclude anything older than CX6 from this condition?
That part I'm still not understanding.. can you add more color?

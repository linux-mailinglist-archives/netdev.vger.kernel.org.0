Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E22262EC62
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiKRDgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRDgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:36:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7847562070
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:36:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 126EE6229D
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7352AC433C1;
        Fri, 18 Nov 2022 03:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668742580;
        bh=K5aDIe2SlBtdw1FEkWSbLjXw0euK3i24cnforADV39A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAaps6knSbkcdj6Nyouj1Mz46EOtiuVFbb0GTuc3XTJvS3EFQeW6rcVG/xgUlS6UI
         kMz4nYDnGFhsfeQkzBmPHaYr/T01bY8/1MkLZzBYmNShJghgJcL2mMbRceGpkvxrRW
         ZIHZnsYOk7D0d2TVinkhZqfHM4EZHm6MAskCeNEHfHR0QYuRQqWWr5Mf8Z3sfM46Vx
         I7FuvR61SoikI5SMrBG1RvotdL6cTSZvuazjiPj7u1Sys1uVC5BKgr/D9Vnhv7AXbG
         wc5xZyDjeRNh9kNf5+pdLdgFXkfi2xAsJXVpyxeinzXC7jeJhqXQ5dEfmtM55/aGxL
         sgE5+osQjF+Tw==
Date:   Thu, 17 Nov 2022 19:36:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jiri@nvidia.com, anthony.l.nguyen@intel.com,
        alexandr.lobakin@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <20221117193618.2cd47268@kernel.org>
In-Reply-To: <Y3ZxqAq3bR7jYc3H@unreal>
References: <Y3OCHLiCzOUKLlHa@unreal>
        <Y3OcAJBfzgggVll9@localhost.localdomain>
        <Y3PS9e9MJEZo++z5@unreal>
        <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
        <Y3R9iAMtkk8zGyaC@unreal>
        <Y3TR1At4In5Q98OG@localhost.localdomain>
        <Y3UlD499Yxj77vh3@unreal>
        <Y3YWkT/lMmYU5T+3@localhost.localdomain>
        <Y3Ye4kwmtPrl33VW@unreal>
        <Y3Y5phsWzatdnwok@localhost.localdomain>
        <Y3ZxqAq3bR7jYc3H@unreal>
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

On Thu, 17 Nov 2022 19:38:48 +0200 Leon Romanovsky wrote:
> I don't think that management of PCI specific parameters in devlink is
> right idea. PCI has his own subsystem with rules and assumptions, netdev
> shouldn't mangle them.

Not netdev, devlink, which covers netdev, RDMA and others.

> In MSI-X case, this even more troublesome as users
> sees these values through lspci without driver attached to it.

I'm no PCI expert either but FWIW to me the patch set seems reasonable.
Whether management FW policies are configured via core PCI sysfs or
subsystem-specific-ish APIs is a toss up. Adding Bjorn and please CC him
on the next rev.

Link to the series:
https://lore.kernel.org/all/20221114125755.13659-1-michal.swiatkowski@linux.intel.com/

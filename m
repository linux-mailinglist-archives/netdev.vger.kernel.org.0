Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76A864A72D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiLLSfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiLLSe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:34:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D514B12D32
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D7A0B80DE9
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F6EC433EF;
        Mon, 12 Dec 2022 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670870092;
        bh=RbSjH8PK8W6qZua0gZUAUy7LTs7WGvW3GZVaIEq78XM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bcd5zhU2fm1dw/zZdegjkrRW9mP2lrD4db57nwVRVgOCoBVs59+0ivFG2hfBIIlBD
         0EOQntpo9D7YmA889Px6UVluCeIHvn0JTcfzun2GBPZ7CK6eWiBPCO5vIol4joJyrI
         8Vwgt0oWA9Ev6Dm0c63AWk7Iqn2L96XAxF5HV9UtZRTdPzuO8G77p2T4TQhCP883Sa
         g5L9RPMJR/K+c83futBOD+mx+Np7Js0fsOcYioA2MuTDC7+t/Nwx45Yqv9x/weTYxj
         pNxi9R8EPMOBSjo/KsdgEFTJZ5zbOXtcZ/8Wl4DBOennBZOIE0aSseY/PAPKsKcBiX
         YUhCni/MNBV0A==
Date:   Mon, 12 Dec 2022 10:34:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <20221212103450.6a747114@kernel.org>
In-Reply-To: <b5fb8890-2df8-fe21-0615-a2d3fa9a6a86@intel.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
        <20221205172627.44943-2-shannon.nelson@amd.com>
        <20221206174136.19af0e7e@kernel.org>
        <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
        <20221207163651.37ff316a@kernel.org>
        <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
        <d194be5e-886b-d69b-7d8d-3894354abe7f@intel.com>
        <20221208172422.37423144@kernel.org>
        <b5fb8890-2df8-fe21-0615-a2d3fa9a6a86@intel.com>
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

On Mon, 12 Dec 2022 10:04:37 -0800 Jacob Keller wrote:
> >    DEVLINK_ATTR_INFO_VERSION_STORED	[nest]
> >      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
> >      DEVLINK_ATTR_INFO_VERSION_VALUE     [str]
> >      DEVLINK_ATTR_INFO_VERSION_BANK	[u32] // << optional
> >   
> 
> 
> Yea this is what I was thinking. With this change we have:
> 
> old kernel, old devlink - behaves as today
> old kernel, new devlink - prints "unknown bank"

Ah, unintentionally I put bank in all nests.
For existing single-image devices I think we can continue to skip 
the bank attr. So old kernel new devlink should behave the same as
old/old.

> new kernel, old devlink - old devlink should ignore the attribute
> new kernel, new devlink - prints bank info along with version
> 
> So I don't see any issue with adding these attributes getting confused 
> when working with old or new userspace.
> 
> >> I think we could also add a new attribute to both reload and flash which
> >> specify which bank to use. For flash, this would be which bank to
> >> program, and for update this would be which bank to load the firmware
> >> from when doing a "fw_activate".  
> > 
> > SG!
> >   
> >> Is that reasonable? Do you still need a permanent "use this bank by
> >> default" parameter as well?  
> > 
> > I hope we cover all cases, so no param needed?  
> 
> The only reason one might want a parameter is if we want to change some 
> default. For example I think I saw some devices load firmware during 
> resets or initialization.

Any reset/activation should happen from the active bank, right?
We should have a way to set the active bank but I reckon that's
more of a normal command than a param thing?

> But I think that is something we can cross if the extra attributes for 
> reload and flash are not sufficient. We can always add a parameter 
> later. We can't easily take them away once added.
